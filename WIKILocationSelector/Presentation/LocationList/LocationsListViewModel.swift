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
    
    var namePlaceHolder: Box<String> {get}
    var nameDescription: Box<String> {get}
    var nameInput: Box<String> {get}
    func updateName(with: InputTextStateChanges)
    
    var latitudePlaceHolder: Box<String> {get}
    var latitudeDescription: Box<String> {get}
    var latitudeInput: Box<String> {get}
    func updateLatitude(with: InputTextStateChanges)
    
    var longitudePlaceHolder: Box<String> {get}
    var longitudeDescription: Box<String> {get}
    var longitudeInput: Box<String> {get}
    func updateLongitude(with: InputTextStateChanges)
    
    func loadContent() async
    func selectLocation(at index: Int)
    
    var openLocationEnabled: Box<Bool> {get}
    func openLocation()
    
    var addLocationEnabled: Box<Bool> {get}
    func addLocation()
}

class LocationsListViewModelImplementation: LocationsListViewModel {
    
    static let TITLE = "Locations"
    static let NAME_DESCRIPTION = "Name"
    static let NAME_PLACEHOLDER = "Unknown"
    static let LATITUDE_DESCRIPTION = "Latitude"
    static let LATITUDE_PLACEHOLDER = "0.0"
    static let LONGITUDE_DESCRIPTION = "Longitude"
    static let LONGITUDE_PLACEHOLDER = "0.0"
    
    private let locationsRepository: LocationsRepository
    private(set) var title = Box<String>(TITLE)
    private(set) var displayModels  = Box<[LocationDisplayModel]>([])
    
    
    private(set) var namePlaceHolder = Box<String>(NAME_PLACEHOLDER)
    private(set) var nameDescription = Box<String>(NAME_DESCRIPTION)
    private(set) var nameInput = Box<String>("")
    
    private(set) var latitudePlaceHolder = Box<String>(LATITUDE_PLACEHOLDER)
    private(set) var latitudeDescription = Box<String>(LATITUDE_DESCRIPTION)
    private(set) var latitudeInput = Box<String>("")
    
    private(set) var longitudePlaceHolder = Box<String>(LATITUDE_PLACEHOLDER)
    private(set) var longitudeDescription = Box<String>(LONGITUDE_DESCRIPTION)
    private(set) var longitudeInput = Box<String>("")
    private(set) var openLocationEnabled = Box<Bool>(false)
    private(set) var addLocationEnabled = Box<Bool>(false)
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
        checkButtonEnabled()
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
        checkButtonEnabled()
        
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
    
    func openLocation() {
        guard
            let latitude = Decimal(string: latitudeInput.value),
            let longitude = Decimal(string: longitudeInput.value)
        else {
            return self.router.presentAlert(with: "Something went wrong with input")
        }
        self.router.presentSelected(location: .init(
            name: nameInput.value.isEmpty ? nil : nameInput.value,
            latitude: latitude,
            longitude: longitude
        ))
    }
    
    func addLocation() {
        guard
            let latitude = Decimal(string: latitudeInput.value),
            let longitude = Decimal(string: longitudeInput.value)
        else {
            return self.router.presentAlert(with: "Something went wrong with input")
        }
        let location = Location(
            name: nameInput.value.isEmpty ? nil : nameInput.value,
            latitude: latitude,
            longitude: longitude
        )
        self.displayModels.value.append(LocationDisplayModel(location: location))
    }
    
    private func checkButtonEnabled() {
        openLocationEnabled.value = checkEnabled()
        addLocationEnabled.value = checkEnabled()
    }
    
    private func checkEnabled() -> Bool {
        if longitudeInput.value.isEmpty {
            return false
        }
        if latitudeInput.value.isEmpty {
            return false
        }
        return true
    }

}
extension String {
    static let decimalSeparator: Self = {
        return Locale.autoupdatingCurrent.decimalSeparator ?? "."
    }()
}
