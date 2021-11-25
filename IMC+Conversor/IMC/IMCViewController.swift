//
//  IMCViewController.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 18/11/21.
//

import UIKit

protocol IMCViewControllerDelegate: AnyObject {
    func showConverter(title: String)
}

class IMCViewController: UIViewController {
        
    // MARK: - UI
    
    private lazy var imcView: IMCView = {
        let view = IMCView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: IMCViewControllerDelegate?
    public var viewModel = IMCViewModel()
    
    // MARK: - LIFE CYCLE
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
        dismissKeyboard()
        configureViewHierarchy()
        configureConstraints()
    }
    
    // MARK: - SETUP

    private func configureNavigationBar() {
        navigationItem.title = "Calcular IMC"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Conversor", style: .plain, target: self, action: #selector(showConverter))
    }
    
    private func configureView() {
        view.backgroundColor = .systemTeal
    }
    
    private func configureViewHierarchy() {
        view.addSubview(imcView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imcView.topAnchor.constraint(equalTo: view.topAnchor),
            imcView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imcView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imcView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - ACTIONS
    
    @objc private func showConverter() {
        guard let title = navigationItem.rightBarButtonItem?.title else { return }
        delegate?.showConverter(title: title)
    }
}

extension IMCViewController: IMCViewDelegate {

    func calculate(weight: Double, height: Double) {
        let imc = viewModel.calculate(weight: weight, height: height)
        let result = viewModel.showResults(imc: imc)
        imcView.updateInterface(imc: imc, result: result.result, imageName: result.imageName)
    }
}


