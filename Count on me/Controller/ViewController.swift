//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UIView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var textLabel: UILabel!
    @IBAction func acButton(_ sender: UIButton) {
    }
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if calculator.expressionHaveResult {
            textLabel.text = ""
            calculator.textScreen = ""
        }
        textLabel.text!.append(numberText)
        calculator.textScreen.append(numberText)
        print(calculator.textScreen)
    }
    // Addition Button
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if calculator.canAddOperator {
            textLabel.text!.append(" + ")
            calculator.textScreen.append(" + ")
        } else {
            operatorAlreadyPresent()
        }
    }
    // Substract Button
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if calculator.canAddOperator {
            textLabel.text!.append(" - ")
        } else {
            operatorAlreadyPresent()
        }
    }
    // Multiplication Button
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if calculator.canAddOperator {
            textLabel.text!.append(" x ")
        } else {
            operatorAlreadyPresent()
        }
    }
    // Division button
    @IBAction func tappedDivisionButton(_ sender: UIButton) {if calculator.canAddOperator {
        textLabel.text!.append(" / ")
    } else {
        operatorAlreadyPresent()
        }
    }
    //Result Button
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard calculator.expressionIsCorrect else {
            let alertVC = UIAlertController(title: "Error!", message: "Enter a correct expression!", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        guard calculator.expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Error!", message: "Start a new calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
        let resultOperationdone = calculator.startOperation()
        print("la variable resultOperation est lancée")
        print(resultOperationdone)
        textLabel.text!.append(resultOperationdone)
        print("le text est ajouté au label")
    }
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func operatorAlreadyPresent() {
        let alertVC = UIAlertController(title: "Error!", message: "Un operateur est déja mis !", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    var calculator = Calculator()
}
