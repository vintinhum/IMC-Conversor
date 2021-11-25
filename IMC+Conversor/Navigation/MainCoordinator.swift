//
//  MainCoordinator.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 19/11/21.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let rootVC = IMCViewController()
        let rootViewModel = IMCViewModel()
        rootVC.delegate = self
        rootVC.viewModel = rootViewModel
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    func presentConverter(title: String) {
        let converterVC = ConversorViewController()
        navigationController?.pushViewController(converterVC, animated: true)
    }
}

extension MainCoordinator: IMCViewControllerDelegate {
    func showConverter(title: String) {
        presentConverter(title: title)
    }
}
