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

func changeSign(operation: Double) -> Double {              // Глобальная функция (принимает значение и возв. со знаком)
    return -operation
}

public struct CalculatorBrainModel {

    // MARK: Module (Public API)
    
    private var accumulator: Double?    // Свойство - накопитель
    
    private enum Operation {
        case constant(Double)                           // Ассоциированное значение
        case unaryOperation((Double) -> Double)         // Функция так-же может быть ассоциированным значением
    }
    
    private var operations: Dictionary<String, Operation> = [       // словарь - операций
        "π": Operation.constant(Double.pi),               // PI - 3.1415926...
        "e": Operation.constant(M_E),                     // e = 2.71...
        "√": Operation.unaryOperation(sqrt),              // SQRT
        "cos": Operation.unaryOperation(cos),             // COS
        "±": Operation.unaryOperation(changeSign)         // ± (плюс и минус)
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
            }
        }
    }
    
    public mutating func setOperand(_ operand: Double) { // функция которая устанавливает операнд   (mutating - слово, которое способствует изменению структуры)
        
        self.accumulator = operand      // Получаем и записываем операнд в свойство accumulator
    }
    
    var result: Double? {        // результирущая переменная (Optional)
        get {
            return self.accumulator!
        }
    }
}
