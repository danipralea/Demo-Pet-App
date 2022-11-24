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

struct DetailsViewModel {
    
    struct Inputs {
        let bag: DisposeBag
    }
    
    struct Outputs {
        let name: Observable<String?>
        let breed: Observable<String?>
        let size: Observable<String?>
        let gender: Observable<String?>
        let status: Observable<String?>
        let distance: Observable<String?>
    }
    
    private let pet: Pet
    
    let outputs: Outputs
    
    init(pet: Pet, inputs: Inputs) {
        self.pet = pet
        
        let locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        let status = locationManager.authorizationStatus
        if status != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        let location = locationManager.rx.location.compactMap({$0})
        let petLocation = (pet.contact?.address?.fullAddress ?? "").getCoordinate
        let locationToPet : Observable<String?> = Observable
            .combineLatest(location, petLocation)
            .map { $0.0.distance(from: $0.1) }
            .map { distance -> String? in
                let km = distance / 1000.0
                let justKm = Int(km)
                return String(justKm) + " km"
            }
        
        outputs = Outputs(
            name: Observable.just(pet.name),
            breed: Observable.just(pet.breeds?.primary),
            size: Observable.just(pet.size),
            gender: Observable.just(pet.gender),
            status: Observable.just("N/A"),
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
