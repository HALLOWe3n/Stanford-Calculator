//
//  ViewController.swift
//  Stanford Calculator
//
//  Created by Roman Synovets on 12/25/17.
//  Copyright © 2017 Roman Synovets. All rights reserved.
//

import UIKit

// MARK: Controller
class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!             // Expand display at once to not put a sign (!) After display
    @IBOutlet weak var displayDescription: UILabel!  // Хранимое свойство (Содержит в себе описание)
    var userIsInTheMiddleTyping = false              // Хранимое свойство
    
    @IBAction func touchDigit(_ sender: UIButton) {  // @IBAction -> пометка Xcode (Сообщает что метод привязан к кнопке)
        let digit = sender.currentTitle!
        let dotSymbol = "."
        
        if userIsInTheMiddleTyping {
            let textCurrentlyInDisplay = display.text!   // Считываем значение из label
            
            if !(textCurrentlyInDisplay.contains(dotSymbol) && digit.contains(dotSymbol)) {     // Проверка на содержание точки в textCurrentlyInDisplay
                self.display.text = textCurrentlyInDisplay + digit
            }
            
        } else if !digit.contains(dotSymbol) {      // Проверка на присутствие точки в самом начале
            self.display.text = digit
            userIsInTheMiddleTyping = true
        }
    }
    
    // MARK: property for label
    var displayValue: Double {                       // Вычесляемое свойство
        get {
            return Double(display.text!)!          // Разворачиваем и возвращаем значение
        }
        set {
                print(newValue)
            if newValue.truncatingRemainder(dividingBy: 1.0) == 0 && newValue < Double(Int.max) {
                self.display.text = String(Int(newValue))         // Записываем новое значение
            } else {
                self.display.text = String(newValue)
            }
        }
    }
    
    var operationValue: String? {       // Вычесляемое свойство (для передачи операций над числами)
        get { return nil }
        set {
            self.displayDescription.text = newValue
        }
    }
    
    // MARK: Include Model for (MVC)
    private var modelBrain = CalculatorBrainModel()    // Подключаем Model (логику)
    
    // MARK: operation button
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleTyping {
            modelBrain.setOperand(self.displayValue)
            userIsInTheMiddleTyping = false
        }
        
        if let mathemaicalSymbol = sender.currentTitle {          // Проверка на nil
            self.modelBrain.performOperation(mathemaicalSymbol)  // передача математического символа к функции performOperation (MODEL)
        }
        
        if let result = modelBrain.result {                     // Optional binding
            self.displayValue = result
        }
        
        if let resultOperation = modelBrain.resultOperation {
            self.operationValue = resultOperation
        }
    }
}
