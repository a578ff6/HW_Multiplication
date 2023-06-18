//
//  MathProblem.swift
//  HW_Multiplication
//
//  Created by 曹家瑋 on 2023/6/16.
//

import Foundation

// 題目
struct MathProblem {
    // 被乘數
    let multiplicand: Int
    // 乘數
    let multiplier: Int
    // 積數
    var product: Int {
        return multiplicand * multiplier
    }
    
    // 生成數學題目
    static func generate() -> MathProblem {
        
        let randomMultiplicand = Int.random(in: 1...9)
        let randomMultiplier = Int.random(in: 1...9)
        
        return MathProblem(multiplicand: randomMultiplicand, multiplier: randomMultiplier)
    }
}
