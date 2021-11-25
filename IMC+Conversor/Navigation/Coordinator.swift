//
//  Coordinator.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 19/11/21.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    
    func start()
}

