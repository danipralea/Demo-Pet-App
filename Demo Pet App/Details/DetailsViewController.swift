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
    
    var viewModelFactory: () -> DetailsViewModel = { fatalError("Must provide factory function first.") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    private func setupRx() {
        let viewModel = viewModelFactory()
        let outputs = viewModel.outputs
        outputs.name.drive(nameLabel.rx.text).disposed(by: disposeBag)
        outputs.breed.drive(breedLabel.rx.text).disposed(by: disposeBag)
        outputs.size.drive(sizeLabel.rx.text).disposed(by: disposeBag)
        outputs.gender.drive(genderLabel.rx.text).disposed(by: disposeBag)
        outputs.status.drive(statusLabel.rx.text).disposed(by: disposeBag)
        outputs.distance.drive(distanceLabel.rx.text).disposed(by: disposeBag)
    }
}
