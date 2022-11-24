//
//  DetailsTests.swift
//  Demo Pet AppTests
//
//  Created by Danut Pralea on 24.11.2022.
//

import XCTest
import RxTest
import RxSwift
import CoreLocation

@testable import Demo_Pet_App

final class DetailsTests: XCTestCase {
    
    var viewModel: DetailsViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        
        guard let data = Helper.getFile("Pet") else {
            throw TestError.noTestFile
        }
        
        let jsonDecoder = JSONDecoder()
        let pet = try jsonDecoder.decode(Pet.self, from: data)
        viewModel = DetailsViewModel(pet: pet)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testInit() throws {
        XCTAssertNotNil(viewModel)
    }
    
    func testData() throws {
        XCTAssertEqual(viewModel.pet.type, "Dog")
        
        XCTAssertEqual(viewModel.pet.name, "Spot")
        XCTAssertEqual(viewModel.pet.breeds?.primary, "Akita")
        XCTAssertEqual(viewModel.pet.size, "Medium")
        XCTAssertEqual(viewModel.pet.gender, "Male")
    }
    
    func testReverseGeocoding() {
        let expectation = expectation(description: "Reverse Geocoding")
        var expectedLocation : CLLocation?
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("Romania, Bucuresti, Strada Benjamin Franklin 1-3") { (placemarks, error) in
            if error == nil, let placemark = placemarks?.first, let location = placemark.location {
                expectedLocation = location
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(expectedLocation)
    }
    
    func testName() {
        let name = scheduler.createObserver(String?.self)
        
        viewModel.outputs.name
            .drive(name)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(name.events, [.next(0, "Spot"), .completed(0)])
    }
    
    func testDistance() {
        let distance = scheduler.createObserver(String?.self)
        
        viewModel.outputs.distance
            .drive(distance)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(distance.events, [])
    }

}
