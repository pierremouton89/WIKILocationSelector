//
//  AppRouter.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 22/06/2023.
//

import UIKit

protocol AppRouter {
    func presentListScreen()
}

class AppRouterImplementation: AppRouter {
    private weak var navigationController: UINavigationController?
        
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func presentListScreen()  {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        viewController.title = "Locations"
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
