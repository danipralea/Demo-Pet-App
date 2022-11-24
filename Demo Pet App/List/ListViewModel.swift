//
//  ListViewModel.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 21.11.2022.
//

import Foundation
import RxSwift
import RxCocoa

struct ListViewModel {
    
    let input: Input
    let output: Output
    
    struct Input {
        let reload: PublishRelay<Void>
    }
    
    struct Output {
        let pets: Driver<[Pet]>
        let errorMessage: Driver<String>
    }
    
    init() {
        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()
        
        let pets = reloadRelay
            .flatMapLatest({ ApiManager.rx.getToken() })
            .flatMapLatest { ApiManager.rx.getPets() }
            .asDriver { (error) -> Driver<[Pet]> in
                errorRelay.accept(error.localizedDescription)
                return Driver.just([])
            }
        
        input = Input(reload: reloadRelay)
        output = Output(pets: pets,
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
    }
}
