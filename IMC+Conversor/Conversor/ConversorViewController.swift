//
//  ConversorViewController.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 18/11/21.
//

import UIKit

class ConversorViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var conversorView: ConversorView = {
        let view = ConversorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - PUBLIC PROPERTIES
    
    public var viewModel = ConversorViewModel()
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewHierarchy()
        dismissKeyboard()
        setupConstraints()
        setNavigationBar()
    }
    
    // MARK: - SETUP
    
    private func configureView() {
        view.backgroundColor = .systemTeal
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setNavigationBar() {
        navigationItem.title = "Conversor"
        navigationItem.backButtonTitle = "Calcular IMC"
    }
    
    private func configureViewHierarchy() {
        view.addSubview(conversorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            conversorView.topAnchor.constraint(equalTo: view.topAnchor),
            conversorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            conversorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            conversorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension ConversorViewController: ConversorViewDelegate {
    func convert(weight: Float, unit: Unit, rounded: Bool) {
        conversorView.updateInterface(with: viewModel.convert(weight: weight, unit: unit, rounded: rounded))
    }
}



