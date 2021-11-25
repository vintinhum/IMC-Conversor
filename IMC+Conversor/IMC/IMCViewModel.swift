//
//  ViewModels.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 24/11/21.
//

import UIKit

protocol IMCViewModelProtocol: AnyObject {
    func calculate(weight: Double, height: Double) -> Double
    func showResults(imc: Double) -> (result: String, imageName: String)
}

class IMCViewModel: IMCViewModelProtocol {
        
    func calculate(weight: Double, height: Double) -> Double {
        let imc = weight / pow(height, 2)
        return imc
    }
    
    func showResults(imc: Double) -> (result: String, imageName: String) {
        switch imc {
            case 0..<16:
                return (result: "Magreza", imageName: "magreza")
            case 16..<18.5:
                return (result: "Abaixo do peso", imageName: "abaixo")
                
            case 18.5..<25:
                return (result: "Peso ideal", imageName: "ideal")
            case 25..<30:
                return (result: "Sobrepeso", imageName: "sobre")
            default:
                return (result: "Obesidade", imageName: "obesidade")
        }
    }
}

