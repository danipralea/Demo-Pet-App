//
//  DetailsViewModel.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 21.11.2022.
//

import Foundation
import RxSwift
import CoreLocation
import RxCoreLocation
import RxCocoa

struct DetailsViewModel {
    
    struct Outputs {
        let name: Driver<String?>
        let breed: Driver<String?>
        let size: Driver<String?>
        let gender: Driver<String?>
        let status: Driver<String?>
        let distance: Driver<String?>
    }
    
    let pet: Pet
    let outputs: Outputs
    
    init(pet: Pet) {
        self.pet = pet
        
        let locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        let status = locationManager.authorizationStatus
        if status != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        let location = locationManager.rx
            .location
            .compactMap({$0})
        let petFullAddress = pet.contact?.address?.fullAddress ?? ""
        let petLocation = petFullAddress
                .getCoordinate
        
        let locationToPet : Driver<String?> = Observable
            .combineLatest(location, petLocation)
            .map { $0.0.distance(from: $0.1) }
            .map { distance -> String? in
                let km = distance / 1000.0
                let justKm = Int(km)
                return String(justKm) + " km"
            }
            .asDriver(onErrorJustReturn: "N/A")
        
        outputs = Outputs(
            name: Driver.just(pet.name),
            breed: Driver.just(pet.breeds?.primary),
            size: Driver.just(pet.size),
            gender: Driver.just(pet.gender),
            status: Driver.just("N/A"),
            distance: locationToPet
        )
        
    }
}

extension String {
    var getCoordinate: Observable<CLLocation>  {
        return Observable.create { observer -> Disposable in
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(self) { (placemarks, error) in
                if error == nil, let placemark = placemarks?.first, let location = placemark.location {
                    observer.onNext(location)
                    observer.onCompleted()
                }
                if let error = error {
                    observer.onError(error)
                } else {
                    let error = NSError(domain: "location", code: NSNotFound)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
}
