//
//  ConversorViewController.swift
//  IMC+Conversor
//
//  Created by Vitor Barrios Luis De Albuquerque  on 18/11/21.
//

import UIKit

class ConversorViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    deinit {
        print("was dealocated from memory")
    }
    
    var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.backgroundColor = .white
        inputTextField.borderStyle = .roundedRect
        inputTextField.placeholder = "Insira o valor"
        inputTextField.keyboardType = .decimalPad
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return inputTextField
    }()
    
    var unitPicker: UIPickerView = {
        let unitPicker = UIPickerView()
        unitPicker.translatesAutoresizingMaskIntoConstraints = false
        return unitPicker
    }()
    
    var valueSlider: UISlider = {
        let valueSlider = UISlider()
        valueSlider.translatesAutoresizingMaskIntoConstraints = false
        valueSlider.minimumValue = 0
        valueSlider.maximumValue = 9999
        valueSlider.addTarget(self, action: #selector(changeValue(_:)), for: .allTouchEvents)
        valueSlider.addTarget(self, action: #selector(convert), for: .allTouchEvents)
        return valueSlider
    }()
    
    var roundValueSwitch: UISwitch = {
        let roundSwitch = UISwitch()
        roundSwitch.translatesAutoresizingMaskIntoConstraints = false
        roundSwitch.addTarget(self, action: #selector(roundValue(_:)), for: .touchUpInside)
        return roundSwitch
    }()
    
    var switchLabel: UILabel = {
        let switchLabel = UILabel()
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.text = "Arredondar valor"
        switchLabel.font = UIFont.systemFont(ofSize: 22)
        switchLabel.textColor = .black
        switchLabel.numberOfLines = 0
        switchLabel.textAlignment = .center
        return switchLabel
    }()
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Conversor de valores"
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    var convertedValueLabel: UILabel = {
        let convertedValueLabel = UILabel()
        convertedValueLabel.translatesAutoresizingMaskIntoConstraints = false
        convertedValueLabel.text = "0 Lb"
        convertedValueLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        convertedValueLabel.textColor = .black
        convertedValueLabel.numberOfLines = 0
        convertedValueLabel.textAlignment = .center
        return convertedValueLabel
    }()
    
    let units: [String] = ["Kg", "Lb"]
    var chosenUnit: Unit = .kilo
    var isRounded: Bool = false
    var convertedValue: Float = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        unitPicker.delegate = self
        unitPicker.dataSource = self
        
        view.backgroundColor = .systemTeal
        configureViewHierarchy()
        setupConstraints()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        navigationItem.title = "Conversor"
        navigationItem.backButtonTitle = "Calcular IMC"
    }
    
    func configureViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(inputTextField)
        view.addSubview(unitPicker)
        view.addSubview(valueSlider)
        view.addSubview(roundValueSwitch)
        view.addSubview(switchLabel)
        view.addSubview(convertedValueLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            
            inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 70),
            inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: self.view.frame.width / 5 / 2),
            inputTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5),
            
            unitPicker.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor),
            unitPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(self.view.frame.width / 5 / 2)),
            unitPicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5),
            unitPicker.heightAnchor.constraint(equalToConstant: 100),
            
            valueSlider.centerXAnchor.constraint(equalTo: inputTextField.centerXAnchor),
            valueSlider.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20),
            valueSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5),
            
            switchLabel.centerXAnchor.constraint(equalTo: valueSlider.centerXAnchor),
            switchLabel.topAnchor.constraint(equalTo: valueSlider.bottomAnchor, constant: 20),
            switchLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5),
            
            roundValueSwitch.centerXAnchor.constraint(equalTo: unitPicker.centerXAnchor),
            roundValueSwitch.centerYAnchor.constraint(equalTo: switchLabel.centerYAnchor),
            
            convertedValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            convertedValueLabel.topAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: 30),
            convertedValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    @objc func convert() {
        guard let weight = Float(inputTextField.text!) else { return }
        if chosenUnit == .kilo {
            if isRounded {
                convertedValueLabel.text = String("\(Int(weight * 2.20))" + " " + "Lb")
            } else {
                convertedValueLabel.text = String("\(weight * 2.20)" + " " + "Lb")
            }
        } else {
            if isRounded {
                convertedValueLabel.text = String("\(Int(weight / 2.20))" + " " + "Kg")
            } else {
                convertedValueLabel.text = String("\(weight / 2.20)" + " " + "Kg")
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        convert()
    }
    
    @objc func changeValue(_ sender: UISlider) {
        if isRounded {
            let value = Int(round(sender.value))
            inputTextField.text = "\(value)"
        } else {
            let value = Float((sender.value))
            inputTextField.text = "\(value)"
        }
    }
    
    @objc func roundValue(_ sender: UISwitch) {
        if sender.isOn {
            isRounded = true
            convert()
        } else {
            isRounded = false
            convert()
        }
    }
}

extension ConversorViewController {
    enum Unit {
        case kilo, pound
    }
}

extension ConversorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        convert()
        return true
    }
}

extension ConversorViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
