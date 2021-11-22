//
//  IMCViewController.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 18/11/21.
//

import UIKit

class IMCViewController: UIViewController, Coordinating {
    
    var coordinator: Coordinator?
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 2)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemTeal
        scrollView.frame = self.view.bounds
        scrollView.contentSize = contentViewSize
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemTeal
        view.frame.size = contentViewSize
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Calcule seu IMC!"
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var weightTextField: UITextField = {
        let weightTextField = UITextField()
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.backgroundColor = .white
        weightTextField.borderStyle = .roundedRect
        weightTextField.placeholder = "Insira seu peso (Kg)"
        weightTextField.keyboardType = .decimalPad
        return weightTextField
    }()
    
    lazy var heightTextField: UITextField = {
        let heightTextField = UITextField()
        heightTextField.translatesAutoresizingMaskIntoConstraints = false
        heightTextField.backgroundColor = .white
        heightTextField.borderStyle = .roundedRect
        heightTextField.placeholder = "Insira sua altura (m)"
        heightTextField.keyboardType = .decimalPad
        return heightTextField
    }()
    
    lazy var calculateButton: UIButton = {
        let calculateButton = UIButton()
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        calculateButton.backgroundColor = .systemGreen
        calculateButton.setTitle("Calcular", for: .normal)
        calculateButton.layer.cornerRadius = 10
        calculateButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        return calculateButton
    }()
    
    lazy var announcementLabel: UILabel = {
        let announcementLabel = UILabel()
        announcementLabel.translatesAutoresizingMaskIntoConstraints = false
        announcementLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        announcementLabel.text = "Seu IMC é..."
        announcementLabel.textColor = .black
        announcementLabel.numberOfLines = 1
        announcementLabel.textAlignment = .center
        announcementLabel.isHidden = true
        return announcementLabel
    }()
    
    lazy var resultLabel: UILabel = {
        let resultLabel = UILabel()
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        resultLabel.textColor = .black
        resultLabel.numberOfLines = 1
        resultLabel.textAlignment = .center
        resultLabel.isHidden = true
        return resultLabel
    }()
    
    lazy var imcImage: UIImageView = {
        let imcImage = UIImageView()
        imcImage.translatesAutoresizingMaskIntoConstraints = false
        imcImage.contentMode = .scaleAspectFit
        imcImage.isHidden = true
        return imcImage
    }()
    
    lazy var resetButton: UIButton = {
        let resetButton = UIButton()
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.backgroundColor = .systemGreen
        resetButton.setTitle("Refazer", for: .normal)
        resetButton.layer.cornerRadius = 10
        resetButton.isHidden = true
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return resetButton
    }()
    
    var imc: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        
        weightTextField.delegate = self
        heightTextField.delegate = self
        
        configureViewHierarchy()
        setupConstraints()
        setNavigationBar()
        
    }

    func setNavigationBar() {
        navigationItem.title = "Calcular IMC"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Conversor", style: .plain, target: self, action: #selector(goToConverter))
    }
    
    func configureViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(weightTextField)
        contentView.addSubview(heightTextField)
        contentView.addSubview(calculateButton)
        contentView.addSubview(announcementLabel)
        contentView.addSubview(resultLabel)
        contentView.addSubview(imcImage)
        contentView.addSubview(resetButton)

    }
    
    func setupConstraints() {
        let bottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint.priority = .required
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomConstraint,
            
//            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 85),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            
            weightTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weightTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 85),
            weightTextField.heightAnchor.constraint(equalToConstant: 50),
            weightTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            
            heightTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heightTextField.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 30),
            heightTextField.heightAnchor.constraint(equalToConstant: 50),
            heightTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            
            calculateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            calculateButton.topAnchor.constraint(equalTo: heightTextField.bottomAnchor, constant: 30),
            calculateButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            calculateButton.heightAnchor.constraint(equalToConstant: 60),
            
            announcementLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            announcementLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height + 70),

            resultLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resultLabel.topAnchor.constraint(equalTo: announcementLabel.bottomAnchor, constant: 20),
            
            imcImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imcImage.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            imcImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/4),
            imcImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),

            resetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: imcImage.bottomAnchor, constant: 20),
            resetButton.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            resetButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    @objc func calculate() {
        if let weight = Double(weightTextField.text!), let height = Double(heightTextField.text!) {
            imc = weight / pow(height, 2)
        }
        showResults()
        
        let frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    @objc func reset() {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.scrollRectToVisible(frame, animated: true)
        
        weightTextField.text = ""
        heightTextField.text = ""
    }
    
    @objc func goToConverter() {
        coordinator?.goToConverter()
    }
    
    func showResults() {
        var result: String = ""
        var image: String = ""
        
        switch imc {
            case 0..<16:
                result = "Magreza"
                image = "magreza"
            case 16..<18.5:
                result = "Abaixo do peso"
                image = "abaixo"
            case 18.5..<25:
                result = "Peso ideal"
                image = "ideal"
            case 25..<30:
                result = "Sobrepeso"
                image = "sobre"
            default:
                result = "Obesidade"
                image = "obesidade"
        }
        
        resultLabel.text = "\(Int(imc)): \(result)"
        imcImage.image = UIImage(named: image)
        resultLabel.isHidden = false
        announcementLabel.isHidden = false
        imcImage.isHidden = false
        resetButton.isHidden = false
        
        view.endEditing(true)
    }
}

extension IMCViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
