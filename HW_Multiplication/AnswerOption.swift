//
//  AnswerOption.swift
//  HW_Multiplication
//
//  Created by 曹家瑋 on 2023/6/16.
//

import Foundation

// 答案選項
enum AnswerOption {

    // 答對
    case correct
    // 答錯
    case wrong
    
    // 檢查使用者的回答有沒有正確
    static func checkAnswer(userAnswer: Int, problem: MathProblem) -> AnswerOption {
        
        // 如果使用者的回答與題目的答案相同
        if userAnswer == problem.product {
            return .correct
        } else {
            return .wrong
        }
    }
}
