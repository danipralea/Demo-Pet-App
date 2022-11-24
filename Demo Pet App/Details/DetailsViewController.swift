//
//  DetailsViewController.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 21.11.2022.
//

import Foundation
import UIKit
import RxSwift

class DetailsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var viewModelFactory: (DetailsViewModel.Inputs) -> DetailsViewModel = { _ in fatalError("Must provide factory function first.") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    private func setupRx() {
        let inputs = DetailsViewModel.Inputs(bag: disposeBag)
        
        let viewModel = viewModelFactory(inputs)
        let outputs = viewModel.outputs
        outputs.name.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        outputs.breed.bind(to: breedLabel.rx.text).disposed(by: disposeBag)
        outputs.size.bind(to: sizeLabel.rx.text).disposed(by: disposeBag)
        outputs.gender.bind(to: genderLabel.rx.text).disposed(by: disposeBag)
        outputs.status.bind(to: statusLabel.rx.text).disposed(by: disposeBag)
        outputs.distance.bind(to: distanceLabel.rx.text).disposed(by: disposeBag)
    }
}
