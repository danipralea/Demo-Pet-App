//
//  ListViewController.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 21.11.2022.
//

import UIKit
import RxDataSources
import RxSwift
import PKHUD

class ListViewController: UIViewController {
    
    private let viewModel = ListViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pets"
        setupViews()
        setupRx()
    }
    
    private func setupViews() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.addSubview(refreshControl)
    }
    
    private func setupRx() {
        HUD.show(.progress, onView: view)
        // bind data to tableview
        viewModel.output.pets
            .do(onNext: { _ in HUD.hide() })
            .drive(tableView.rx.items(cellIdentifier: ListTableViewCell.ClassName, cellType: ListTableViewCell.self)) { (row, pet, cell) in
                cell.update(with: pet)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .do(onNext: { _ in HUD.hide() })
            .drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                self.showError(errorMessage)
            })
            .disposed(by: disposeBag)
        
        viewModel.input.reload.accept(())
        
        tableView.rx
            .modelSelected(Pet.self)
            .asDriver()
            .map({ [weak self] pet -> UIViewController? in
                guard let self = self else { return nil }
                guard let controller = self.storyboard?.instantiateViewController(identifier: DetailsViewController.ClassName) as? DetailsViewController else { return nil }
                let viewModelFactory = {
                    return DetailsViewModel(pet: pet)
                }
                controller.viewModelFactory = viewModelFactory
                return controller
            })
            .compactMap { $0 }
            .drive(onNext: { [weak self] controller in
                guard let self = self else { return }
                if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                }
                self.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        refreshControl
            .rx.controlEvent(.valueChanged)
            .do(onNext: { [weak self] _ in
                self?.viewModel.input.reload.accept(())
            })
            .subscribe(onNext: { [weak self] in
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI
    
    private func showError(_ errorMessage: String) {
        // display error ?
        let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}
