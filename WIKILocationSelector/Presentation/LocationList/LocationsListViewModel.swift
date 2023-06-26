//
//  LocationsListViewModel.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

protocol LocationsListViewModel {
    
    var title: Box<String> { get }
    var displayModels: Box<[LocationDisplayModel]> {get}
    
    func loadContent() async
    func selectLocation(at index: Int)
}

class LocationsListViewModelImplementation: LocationsListViewModel {
    
    static let TITLE = "Locations"
    private let locationsRepository: LocationsRepository
    private(set) var title = Box<String>(TITLE)
    private(set) var displayModels  = Box<[LocationDisplayModel]>([])
    private let router: AppRouter
        
    init(locationsRepository: LocationsRepository, router: AppRouter){
        self.locationsRepository = locationsRepository
        self.router = router
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
