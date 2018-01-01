//
//  CalculatorBrainModel.swift
//  Stanford Calculator
//
//  Created by Roman Synovets on 12/27/17.
//  Copyright © 2017 Roman Synovets. All rights reserved.
//

import Foundation

/**
    struct - структура (тип)
        1) struct - передается путем копирования (класс живет в куче)
        2) struct - получает автоматический инициализотор
        3) struct - не имеет наследования
 
    func - функция (нормальный тип)
        1) func - такой же тип как и Double, String, Int...
        2) Может быть типом ассоциированного значения
**/

/*  Global Function */
func factorial(number: Double) -> Double {
    if  number > 1 {
        return number * factorial(number: number - 1)
    } else {
        return number
    }
}

public struct CalculatorBrainModel {

    // MARK: Module (Public API)
    
    private var accumulator: Double?                     // Свойство - накопитель
    
    private enum Operation {
        case constant(Double)                            // Ассоциированное значение
        case unaryOperation((Double) -> Double)          // Функция так-же может быть ассоциированным значением (унарная операция)
        case binaryOperation((Double, Double) -> Double) // Бинарная операция
        case equals
        
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {             // структура для запоминаия бинарных операций (Cтруктура​,которая “удерживает” две вещи)
        
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var operations: Dictionary<String, Operation> = [        // словарь - операций
        "π": Operation.constant(Double.pi),                          // PI - 3.1415926...
        "e": Operation.constant(M_E),                                // e = 2.71...
        "√": Operation.unaryOperation(sqrt),                         // SQRT
        "x!": Operation.unaryOperation(factorial),                   // factorial (p!)
        "x2": Operation.unaryOperation({ $0 * $0 }),                 // x2
        "cos": Operation.unaryOperation(cos),                        // COS
        "sin": Operation.unaryOperation(sin),                        // SIN
        "tg": Operation.unaryOperation(tan),                         // TAN
        "±": Operation.unaryOperation({ -$0 }),                      // ± (плюс и минус)
        "×": Operation.binaryOperation({ $0 * $1 }),                 // × (умножение) (Замыкание)
        "÷": Operation.binaryOperation({ $0 / $1 }),                 // ÷ (деление) (Замыкание)
        "+": Operation.binaryOperation({ $0 + $1 }),                 // + (сложение) (Замыкание)
        "-": Operation.binaryOperation({ $0 - $1 }),                 // - (вычитание) (Замыкание)
        "=": Operation.equals,                                       // = (равно)
    ]
    
    public mutating func performOperation(_ symbol: String) {       // функция по работе с символами
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):                  // извлекаем значение
                self.accumulator = value
            case .unaryOperation(let function):         // извлекаем значение
                if accumulator != nil {
                    self.accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    self.pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    self.accumulator = nil              // Перевожу "Первый операнд в состояние non-set" чтобы значение не записалось в display (Controller)
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            self.accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            self.pendingBinaryOperation = nil                   // убираю значение левого и правого операндов для следующей операции
        }
    }
    
    public mutating func setOperand(_ operand: Double) { // функция которая устанавливает операнд   (mutating - слово, которое способствует изменению структуры)
        self.accumulator = operand      // Получаем и записываем операнд в свойство accumulator
    }
    
    var result: Double? {        // результирущая переменная (Optional)
        get {
            return self.accumulator
        }
    }
}
