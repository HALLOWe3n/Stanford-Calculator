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
    
    @IBOutlet weak var display: UILabel!        // Разворачиваем display сразу чтобы не ставить знак (!) после display
    var userIsInTheMiddleTyping = false         // Хранимое свойство
    
    @IBAction func touchDigit(_ sender: UIButton) {  // @IBAction -> пометка Xcode (Сообщает что метод привязан к кнопке)
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleTyping {
            
            let textCurrentlyInDisplay = display.text!   // Считываем значение из label
            display.text = textCurrentlyInDisplay + digit
           
        } else  {
            display.text = digit
            userIsInTheMiddleTyping = true
        }
    }
    
    // MARK: property for label
    var displayValue: Double {                       // Вычесляемое свойство
        get {
            return Double(display.text!)!           // Разворачиваем и возвращаем значение
        }
        set {
            display.text = String(newValue)         // Записываем новое значение
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
}
