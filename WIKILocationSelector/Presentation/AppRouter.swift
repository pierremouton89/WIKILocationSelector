//
//  AppRouter.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 22/06/2023.
//

import UIKit

protocol AppRouter {
    func presentListScreen()
    func presentAlert(with message: String)
    func presentSelected(location: Location)
}

class AppRouterImplementation: AppRouter {
    private weak var navigationController: UINavigationController?
        
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func presentListScreen() {
        let viewModel = LocationsListViewModelImplementation(locationsRepository: Dependencies.shared.locationsRepository, router: self)
        let viewController = LocationsListViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentAlert(with message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController (
                title: "Alert",
                message: message,
                preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .destructive) {(action) in
            }
            alert.addAction(okAction)
            self.navigationController?.present(alert, animated: true)
        }
    }
    
    func presentSelected(location: Location) {
        
        guard
            let base64Data = try? JSONEncoder().encode(location)
        else {
            presentAlert(with: "Could not present location. Something went wrong.")
            return
        }
        let base64EncodedLocation = base64Data.base64EncodedString()
        DispatchQueue.main.async {
            UIApplication.shared.open(URL(string: "wikipedia://places?location=\(base64EncodedLocation)")!)
        }
    }

}
