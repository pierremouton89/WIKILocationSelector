//
//  LocationsListViewModel.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

protocol LocationsListViewModel {
    
    var title: Box<String> { get }
    var locations: Box<[Location]> { get }
    
    func loadContent() async
}


class LocationsListViewModelImplementation: LocationsListViewModel {
    
    static let TITLE = "Locations"
    private let locationsRepository: LocationsRepository
    private(set) var title = Box<String>(TITLE)
    private(set) var locations  = Box<[Location]>([])
    private let router: AppRouter
        
    init(locationsRepository: LocationsRepository, router: AppRouter){
        self.locationsRepository = locationsRepository
        self.router = router
    }
        
    func loadContent() async {
        do {
            self.locations.value = try await self.locationsRepository.retrieveLocations()
        } catch {
            self.router.presentAlert(with: error.localizedDescription)
        }
    }
    

}
