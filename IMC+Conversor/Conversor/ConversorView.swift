//
//  ConversorView.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 24/11/21.
//

import UIKit

protocol ConversorViewDelegate: AnyObject {
    func convert(weight: Float, unit: Unit, rounded: Bool)
}

enum Unit {
    case kilo, pound
}

class ConversorView: UIView {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let units: [String] = ["Kg", "Lb"]
    private var chosenUnit: Unit = .kilo
    private var isRounded: Bool = false
    private var convertedValue: Float = 0
    
    // MARK: - UI
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Insira o valor"
        textField.keyboardType = .decimalPad
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var unitPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var valueSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 9999
        slider.addTarget(self, action: #selector(changeValue(_:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var roundValueSwitch: UISwitch = {
        let uiswitch = UISwitch()
        uiswitch.translatesAutoresizingMaskIntoConstraints = false
        uiswitch.addTarget(self, action: #selector(roundValue(_:)), for: .touchUpInside)
        return uiswitch
    }()
    
    private lazy var switchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Arredondar valor"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Conversor de valores"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var convertedValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 Lb"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: ConversorViewDelegate?
    
    // MARK: - LIFE CYCLE
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(){
        super.init(frame: .zero)
        
        configureView()
        configureViewHierarchy()
        configureConstraints()
    }
    
    // MARK: - SETUP
    
    private func configureView() {
        backgroundColor = .systemTeal
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureViewHierarchy() {
        addSubview(titleLabel)
        addSubview(inputTextField)
        addSubview(unitPicker)
        addSubview(valueSlider)
        addSubview(roundValueSwitch)
        addSubview(switchLabel)
        addSubview(convertedValueLabel)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3/4),
            
            inputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            inputTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            inputTextField.trailingAnchor.constraint(equalTo: unitPicker.leadingAnchor, constant: -16),
            
            unitPicker.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor),
            unitPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            unitPicker.widthAnchor.constraint(equalToConstant: 96),
            unitPicker.heightAnchor.constraint(equalToConstant: 96),
            
            valueSlider.centerXAnchor.constraint(equalTo: inputTextField.centerXAnchor),
            valueSlider.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 24),
            valueSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            valueSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -160),
            
            switchLabel.centerXAnchor.constraint(equalTo: valueSlider.centerXAnchor),
            switchLabel.topAnchor.constraint(equalTo: valueSlider.bottomAnchor, constant: 24),
            switchLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 3/5),
            
            roundValueSwitch.centerXAnchor.constraint(equalTo: unitPicker.centerXAnchor),
            roundValueSwitch.centerYAnchor.constraint(equalTo: switchLabel.centerYAnchor),
            
            convertedValueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            convertedValueLabel.topAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: 24),
        ])
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func updateInterface(with label: String) {
        convertedValueLabel.text = label
    }
    
    // MARK: - ACTIONS
    
    @objc private func convert() {
        guard let weight = Float(inputTextField.text!) else { return }
        delegate?.convert(weight: weight, unit: chosenUnit, rounded: isRounded)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        convert()
    }
    
    @objc private func changeValue(_ sender: UISlider) {
        convert()
        if isRounded {
            let value = Int(round(sender.value))
            inputTextField.text = "\(value)"
        } else {
            let value = Float((sender.value))
            inputTextField.text = "\(value)"
        }
    }
    
    @objc private func roundValue(_ sender: UISwitch) {
        if sender.isOn {
            isRounded = true
            convert()
        } else {
            isRounded = false
            convert()
        }
    }
}

// MARK: - TEXTFIELD DELEGATE

extension ConversorView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        convert()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
}

// MARK: - PICKER DELEGATE & DATASOURCE

extension ConversorView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            chosenUnit = .kilo
            convert()
        } else {
            chosenUnit = .pound
            convert()
        }
    }
}
