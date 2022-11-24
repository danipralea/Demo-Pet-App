//
//  ListTests.swift
//  Demo Pet AppTests
//
//  Created by Danut Pralea on 24.11.2022.
//

import XCTest
import RxTest
import RxSwift

@testable import Demo_Pet_App

final class ListTests: XCTestCase {
    var viewModel: ListViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        viewModel = ListViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        let expectation = expectation(description: "Get Animals")
        var pets: [Pet]?
        viewModel.output.pets
            .asObservable()
            .subscribe(onNext: { result in
                pets = result
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.input.reload.accept(())
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(pets)
        XCTAssertGreaterThanOrEqual(pets?.count ?? 0, 1)
    }

}
