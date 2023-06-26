//
//  LocationsListViewModel.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

enum InputTextStateChanges {
    case changed(String?)
    case endEditing
}


protocol LocationsListViewModel {
    
    var title: Box<String> { get }
    var displayModels: Box<[LocationDisplayModel]> {get}
    
    var nameDescription: Box<String> {get}
    var nameInput: Box<String> {get}
    func updateName(with: InputTextStateChanges)
    
    var latitudeDescription: Box<String> {get}
    var latitudeInput: Box<String> {get}
    func updateLatitude(with: InputTextStateChanges)
    
    var longitudeDescription: Box<String> {get}
    var longitudeInput: Box<String> {get}
    func updateLongitude(with: InputTextStateChanges)
    
    func loadContent() async
    func selectLocation(at index: Int)
}

class LocationsListViewModelImplementation: LocationsListViewModel {
    
    static let TITLE = "Locations"
    static let NAME_DESCRIPTION = "Name"
    static let LATITUDE_DESCRIPTION = "Latitude"
    static let LONGITUDE_DESCRIPTION = "Longitude"
    private let locationsRepository: LocationsRepository
    private(set) var title = Box<String>(TITLE)
    private(set) var displayModels  = Box<[LocationDisplayModel]>([])
    
    private(set) var nameDescription = Box<String>(NAME_DESCRIPTION)
    private(set) var nameInput = Box<String>("")
    
    private(set) var latitudeDescription = Box<String>(LATITUDE_DESCRIPTION)
    private(set) var latitudeInput = Box<String>("")
    private(set) var longitudeDescription = Box<String>(LONGITUDE_DESCRIPTION)
    private(set) var longitudeInput = Box<String>("")
    private let router: AppRouter
    private let decimalInputFormatter: DecimalInputStringFormatter
        
    init(locationsRepository: LocationsRepository, router: AppRouter, decimalInputFormatter: DecimalInputStringFormatter = .init()){
        self.locationsRepository = locationsRepository
        self.router = router
        self.decimalInputFormatter = decimalInputFormatter
    }
    
    func updateName(with change: InputTextStateChanges) {
        let inputField = self.nameInput
        let originalValue = inputField.value
        switch (change) {
        case .changed(let value):
            if value != originalValue, let value = value {
                inputField.value = value
            }
        case .endEditing:
            break
        }
    }
    
    func updateLatitude(with change: InputTextStateChanges) {
        let inputField = self.latitudeInput
        let originalValue = inputField.value
        switch (change) {
        case .changed(let value):
            if value != originalValue, let value = value {
                inputField.value = decimalInputFormatter.whileEditing(format: value)
            }
        case .endEditing:
            inputField.value = decimalInputFormatter.whenDoneEditing(format: originalValue)
        }
    }
    
    func updateLongitude(with change: InputTextStateChanges) {
        let inputField = self.longitudeInput
        let originalValue = inputField.value
        switch (change) {
        case .changed(let value):
            if value != originalValue, let value = value {
                inputField.value = decimalInputFormatter.whileEditing(format: value)
            }
        case .endEditing:
            inputField.value = decimalInputFormatter.whenDoneEditing(format: originalValue)
        }
    }
        
        
    func loadContent() async {
        do {
            let locations =  try await self.locationsRepository.retrieveLocations()
            self.displayModels.value = locations.map{ .init(location: $0) }
        } catch {
            self.router.presentAlert(with: error.localizedDescription)
        }
    }
    
    func selectLocation(at index: Int) {
        if index < self.displayModels.value.count && index >= 0 {
            self.router.presentSelected(location: self.displayModels.value[index].location)
        }
    }

}
extension String {
    static let decimalSeparator: Self = {
        return Locale.autoupdatingCurrent.decimalSeparator ?? "."
    }()
}
