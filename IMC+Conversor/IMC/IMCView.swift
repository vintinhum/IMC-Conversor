//
//  IMCView.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 24/11/21.
//

import UIKit

protocol IMCViewDelegate: AnyObject {
    func calculate(weight: Double, height: Double)
}

class IMCView: UIView {
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Calcule seu IMC!"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var weightTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Insira seu peso (Kg)"
        textField.keyboardType = .decimalPad
        textField.delegate = self
        return textField
    }()
    
    private lazy var heightTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Insira sua altura (m)"
        textField.keyboardType = .decimalPad
        textField.delegate = self
        return textField
    }()
    
    private lazy var calculateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("Calcular", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var announcementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.text = "Seu IMC é..."
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var imcImage: UIImageView = {
        let uiimage = UIImageView()
        uiimage.translatesAutoresizingMaskIntoConstraints = false
        uiimage.contentMode = .scaleAspectFit
        uiimage.isHidden = true
        return uiimage
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitle("Refazer", for: .normal)
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return button
    }()
    
    // MARK: - PUBLIC PROPERTIES
    weak var delegate: IMCViewDelegate?
            
    // MARK: - LIFE CYCLE
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
        addViewHierarchy()
        setupConstraints()
        
    }
    
    // MARK: - SETUP
    
    private func configureView() {
        backgroundColor = .systemTeal
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addViewHierarchy() {
        addSubview(scrollView)
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            
            weightTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weightTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            weightTextField.heightAnchor.constraint(equalToConstant: 48),
            weightTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            
            heightTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heightTextField.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 32),
            heightTextField.heightAnchor.constraint(equalToConstant: 48),
            heightTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            
            calculateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            calculateButton.topAnchor.constraint(equalTo: heightTextField.bottomAnchor, constant: 32),
            calculateButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            calculateButton.heightAnchor.constraint(equalToConstant: 48),
            
            announcementLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            announcementLabel.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 32),

            resultLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resultLabel.topAnchor.constraint(equalTo: announcementLabel.bottomAnchor, constant: 16),
            
            imcImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imcImage.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 24),
            imcImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            imcImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            resetButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: imcImage.bottomAnchor, constant: 24),
            resetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            resetButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            resetButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func updateInterface(imc: Double, result: String, imageName: String) {
        resultLabel.text = "\(Int(imc)): \(result)"
        imcImage.image = UIImage(named: imageName)
        resultLabel.isHidden = false
        announcementLabel.isHidden = false
        imcImage.isHidden = false
        resetButton.isHidden = false
    }
    
    // MARK: - ACTIONS
    
    @objc private func reset() {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scrollView.scrollRectToVisible(frame, animated: true)
        
        weightTextField.text = ""
        heightTextField.text = ""
        
        calculateButton.isEnabled = false
    }
    
    @objc private func calculate() {
        let weight = Double(weightTextField.text ?? "")!
        let height = Double(heightTextField.text ?? "")!
        delegate?.calculate(weight: weight, height: height)
    }
}

extension IMCView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let height = heightTextField.text, let weight = weightTextField.text, height.isEmpty || weight.isEmpty {
            calculateButton.isEnabled = false
        } else {
            calculateButton.isEnabled = true
        }
    }
}
