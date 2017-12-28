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
**/

public struct CalculatorBrainModel {

    // MARK: Module (Public API)
    
    private var accumulator: Double?    // Свойство - накопитель
    
    private enum Operation {
        case constant(Double)           // Ассоциированное значение
        case unaryOperation
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation,  // SQRT
        "cos": Operation.unaryOperation // COS
    ]
    
    public mutating func performOperation(_ symbol: String) {       // функция по работе с символами
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let associatedConstantValue):
                self.accumulator = associatedConstantValue
                break
            case .unaryOperation:
                break
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
