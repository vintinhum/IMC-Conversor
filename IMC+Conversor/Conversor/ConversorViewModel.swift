//
//  ConversorViewModel.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 24/11/21.
//

import UIKit

protocol ConversorViewModelProtocol: AnyObject {
    func convert(weight: Float, unit: Unit, rounded: Bool) -> String
}

class ConversorViewModel: ConversorViewModelProtocol {
    
    
    func convert(weight: Float, unit: Unit, rounded: Bool) -> String {
        switch unit {
            case .kilo:
                if rounded {
                    return String("\(Int(weight * 2.20))" + " " + "Lb")
                } else {
                    return String("\(weight * 2.20)" + " " + "Lb")
                }
            case .pound:
                if rounded {
                    return String("\(Int(weight / 2.20))" + " " + "Kg")
                } else {
                    return String("\(weight / 2.20)" + " " + "Kg")
                }
        }
        
    }
}
