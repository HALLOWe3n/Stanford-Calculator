//
//  ViewController.swift
//  Stanford Calculator
//
//  Created by Roman Synovets on 12/25/17.
//  Copyright © 2017 Roman Synovets. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Controller
    
    @IBOutlet weak var display: UILabel!        // Expand display at once to not put a sign (!) After display
    var userIsInTheMiddleTyping = false         // Хранимое свойство
    
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
            if newValue.truncatingRemainder(dividingBy: 1.0) == 0 {
                self.display.text = String(Int(newValue))         // Записываем новое значение
            } else {
                self.display.text = String(newValue)
            }
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
        
        if let mathemaicalSymbol = sender.currentTitle {    // Проверка на nil
            self.modelBrain.performOperation(mathemaicalSymbol)  // передача математического символа к функции performOperation (MODEL)
        }
        
        if let result = modelBrain.result {                 // Optional binding
            self.displayValue = result
        }
    }
    
    @IBAction func clearOperation(_ sender: UIButton) {
        self.display.text = "0"
        self.displayValue = 0
        self.userIsInTheMiddleTyping = false
    }
}
