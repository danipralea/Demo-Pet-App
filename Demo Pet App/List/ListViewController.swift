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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pets"
        
        HUD.show(.progress, onView: view)
        ApiManager.rx
            .getToken()
            .flatMapLatest({ _ in
                return ApiManager.rx.getPets()
            })
            .do(onCompleted: {
                DispatchQueue.main.async {                    
                    HUD.hide()
                }
            })
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { index, model, cell in
                guard let cell = cell as? ListTableViewCell else { return }
                cell.update(with: model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Pet.self)
            .asDriver()
            .map({ [weak self] pet -> UIViewController? in
                guard let self = self else { return nil }
                guard let controller = self.storyboard?.instantiateViewController(identifier: DetailsViewController.ClassName) as? DetailsViewController else { return nil }
                let viewModelFactory = { inputs -> DetailsViewModel in
                    return DetailsViewModel(pet: pet, inputs: inputs)
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
    }
}
