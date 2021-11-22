//
//  MainCoordinator.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 19/11/21.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    func start() {
        var imcVC: UIViewController & Coordinating = IMCViewController()
        imcVC.coordinator = self
        navigationController?.setViewControllers([imcVC], animated: false)
    }
    
    func goToConverter() {
        var converterVC: UIViewController & Coordinating = ConversorViewController()
        converterVC.coordinator = self
        navigationController?.pushViewController(converterVC, animated: true)
    }
    
    
}
