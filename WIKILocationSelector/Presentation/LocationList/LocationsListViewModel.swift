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
    
    var nameInput: Box<String?> {get}
    
    var latitudeInput: Box<String> {get}
    func updateLatitude(with: InputTextStateChanges)
    
    var longitudeInput: Box<String> {get}
    func updateLongitude(with: InputTextStateChanges)
    
    func loadContent() async
    func selectLocation(at index: Int)
}

class LocationsListViewModelImplementation: LocationsListViewModel {
    
    static let TITLE = "Locations"
    private let locationsRepository: LocationsRepository
    private(set) var title = Box<String>(TITLE)
    private(set) var displayModels  = Box<[LocationDisplayModel]>([])
    
    private(set) var nameInput = Box<String?>(nil)
    private(set) var latitudeInput = Box<String>("")
    private(set) var longitudeInput = Box<String>("")
    private let router: AppRouter
        
    init(locationsRepository: LocationsRepository, router: AppRouter){
        self.locationsRepository = locationsRepository
        self.router = router
    }
    
    func updateLatitude(with change: InputTextStateChanges) {
        let inputField = self.latitudeInput
        let originalValue = inputField.value
        switch (change) {
        case .changed(let value):
            if value != originalValue, let value = value {
                inputField.value = String.santise(decimalValue: value)
            }
        case .endEditing:
            inputField.value = originalValue.trimmingCharacters(in: CharacterSet(charactersIn: String.decimalSeparator))
        }
    }
    
    func updateLongitude(with change: InputTextStateChanges) {
        let inputField = self.longitudeInput
        let originalValue = inputField.value
        switch (change) {
        case .changed(let value):
            if value != originalValue, let value = value {
                inputField.value = String.santise(decimalValue: value)
            }
        case .endEditing:
            inputField.value = originalValue.trimmingCharacters(in: CharacterSet(charactersIn: String.decimalSeparator))
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


private extension String {
   static let decimalSeparator: String = {
       return Locale.autoupdatingCurrent.decimalSeparator ?? "."
    }()
    static func santise(decimalValue: String) -> String {
        guard decimalValue.contains(decimalSeparator) else {
            return decimalValue
        }
        let decimalOnly = decimalValue.filter("-0123456789\(decimalSeparator)".contains)
        let numbers = decimalOnly.components(separatedBy: String.decimalSeparator)
        let firstNumber = numbers.first ?? "0"
        let sanitesedFirstNumber = firstNumber.isEmpty ? "0" : firstNumber
        return "\(sanitesedFirstNumber)\(decimalSeparator)\(numbers.suffix(from: 1).joined(separator:""))"
    }
}
