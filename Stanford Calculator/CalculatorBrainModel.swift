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
func factorial(number: Double) -> Double {                                                         // Факториал числа (p!) - рекурсия
    if  number > 1 && number < 21 {
        return number * factorial(number: number - 1)
    } else {
        return number
    }
}

public struct CalculatorBrainModel {

    // MARK: Module (Public API)
    
    private var accumulator: Double?                                                               // Свойство - накопитель
    private var resultIsPending: Bool = false                                                      // Свойство для контроля отложенной операции
    private var description: String?                                                               // Свойство описания
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private enum Operation {
        case constant(Double)                                                                      // Ассоциированное значение
        case unaryOperation((Double) -> Double)                                                    // Функция так-же может быть ассоциированным значением (унарная операция)
        case binaryOperation((Double, Double) -> Double)                                           // Бинарная операция
        case equals                                                                                 // Равно
        case clear                                                                                  // Очистка
    }
    
    private struct PendingBinaryOperation {                                                        // структура для запоминаия бинарных операций (Cтруктура​,которая “удерживает” две вещи)
        
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private var operations: Dictionary<String, Operation> = [                                  // словарь - операций
        "π": Operation.constant(Double.pi),                                                    // PI - 3.1415926...
        "e": Operation.constant(M_E),                                                          // e = 2.71...
        "√": Operation.unaryOperation(sqrt),                                                   // SQRT
        "x!": Operation.unaryOperation(factorial),                                             // factorial (p!)
        "x2": Operation.unaryOperation({ $0 * $0 }),                                           // x2
        "cos": Operation.unaryOperation(cos),                                                  // COS
        "sin": Operation.unaryOperation(sin),                                                  // SIN
        "±": Operation.unaryOperation({ -$0 }),                                                // ± (плюс и минус)
        "×": Operation.binaryOperation({ $0 * $1 }),                                           // × (умножение) (Замыкание)
        "÷": Operation.binaryOperation({ $0 / $1 }),                                           // ÷ (деление) (Замыкание)
        "+": Operation.binaryOperation({ $0 + $1 }),                                           // + (сложение) (Замыкание)
        "-": Operation.binaryOperation({ $0 - $1 }),                                           // - (вычитание) (Замыкание)
        "=": Operation.equals,                                                                 // = (равно)
        "C": Operation.clear                                                                   // C (Clear) Очистка
    ]
    
    public mutating func performOperation(_ symbol: String) {                                 // функция по работе с символами
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):                                                        // извлекаем значение
                self.accumulator = value
                if !self.resultIsPending {
                    self.description = symbol + " " + String(describing: self.accumulator!)                // Последовательность операции
                }
            case .unaryOperation(let function):                                                        // извлекаем значение
                if accumulator != nil {
                    self.description = symbol + " (" + String(describing: self.accumulator!) + ")"    // Последовательность операции
                    self.accumulator = function(accumulator!)
                    
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    self.resultIsPending = true             // Указываю что операция отложена
                    self.pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    self.description = "(" + String(describing: self.accumulator!) + " " + symbol + " "
                    
                    self.accumulator = nil                                                    // Перевожу "Первый операнд в состояние non-set" чтобы значение не записалось в display (Controller)
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                self.pendingBinaryOperation = nil                                             // Очистка бинарных операций
                self.accumulator = 0                                                          // Очистка содержимого на дисплее и в переменной
                self.description = "Operations"                                               // Очистка содержимого описания
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            self.resultIsPending = false                                                      // Указываю что операция не являеться отложенной
            self.description! += String(describing: self.accumulator!) + ")"
            self.accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            self.pendingBinaryOperation = nil                                                 // убираю значение левого и правого операндов для следующей операции
        }
    }
    
    public mutating func setOperand(_ operand: Double) {                                      // функция которая устанавливает операнд   (mutating - слово, которое способствует изменению структуры)
        self.accumulator = operand                                                            // Получаем и записываем операнд в свойство accumulator
    }
    
    var result: Double? {                                                                     // результирущая переменная (Optional)
        get {
            return self.accumulator
        }
    }
    var resultOperation: String? {                                                            // Переменная возвращающая описание операций
        get {
            return self.description
        }
    }
}
