//
//  ViewController.swift
//  CountOnMe
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var calculator = Calculator()
    // Outlets
    @IBOutlet weak var textView: UIView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var textLabel: UITextView!
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {return}
        calculator.addingNumber(number: numberText)
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
    @IBAction func tappedDotButton(_ sender: UIButton) {
        calculator.addDot()
    }
    @IBAction func acButton(_ sender: UIButton) {
        calculator.clear()
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
        receivingNotification(name: "errorDivideByZero")
    }
    // function for receiving notification
    private func receivingNotification(name: String) {
        let notificationName = Notification.Name(rawValue: name)
        let selector = Selector((name))
        NotificationCenter.default.addObserver(self, selector: selector, name: notificationName, object: nil)
    }
    // function that update the Screen
    @objc func updateScreen() {
        textLabel.text = calculator.textScreen
    }
    // Alert when there's not enought element for making a operation
    @objc func alertNotEnoughtElement () {
        guard calculator.expressionHaveEnoughElement else {
            let alertVC = UIAlertController(title: "Error!", message: "Start a new calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
        }
    }
    // Alert when the operation does not finish by number
    @objc func alertNotFinishingByNumber() {
            let alertVC = UIAlertController(title: "Error!",
                                            message: "Enter a correct expression!",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return self.present(alertVC, animated: true, completion: nil)
    }
    // Alert when the user try to divide a number by zero 
    @objc func errorDivideByZero() {
        let alertVC = UIAlertController(title: "Error: Cannot divide by zero !",
                                        message: "Not possible to divide a number with zero. Start a new Operation.",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}

