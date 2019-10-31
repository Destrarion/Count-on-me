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
    @IBOutlet weak var textLabel: UITextView!
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if calculator.expressionHaveResult {
            textLabel.text = ""
            calculator.textScreen = ""
            calculator.textResult = ""
        }
        textLabel.text?.append(numberText)
        calculator.textScreen.append(numberText)
    }
    // Addition Button
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        calculator.addingAddition()
    }
    // Substract Button
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        calculator.addingSubstraction()
    }
    // Multiplication Button
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        calculator.addingMultiplication()
    }
    // Division button
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        calculator.addingDivision()
    }
    @IBAction func acButton(_ sender: UIButton) {
        calculator.textScreen = ""
        updateScreen()
    }
    //Result Button
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.startOperation()
    }
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        receivingNotification(name: "updateScreen")
        receivingNotification(name: "alertNotFinishingByNumber")
        receivingNotification(name: "alertNotEnoughtElement")
    }
    var calculator = Calculator()
    private func receivingNotification(name: String) {
        let notificationName = Notification.Name(rawValue: name)
        let selector = Selector((name))
        NotificationCenter.default.addObserver(self, selector: selector, name: notificationName, object: nil)
    }

    @objc func updateScreen() {
        textLabel.text = calculator.textScreen
    }
    @objc func alertNotEnoughtElement () {
        guard calculator.expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Error!", message: "Start a new calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
    }
    @objc func alertNotFinishingByNumber() {
            let alertVC = UIAlertController(title: "Error!",
                                            message: "Enter a correct expression!",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
    }
}
