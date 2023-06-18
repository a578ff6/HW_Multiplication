//
//  ViewController.swift
//  HW_Multiplication
//
//  Created by 曹家瑋 on 2023/6/16.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // 數學問題Label
    @IBOutlet weak var questionLabel: UILabel!
    
    // 目前第幾題Label
    @IBOutlet weak var currentQuestionLabel: UILabel!
    
    // 答對加圈、答錯加叉叉 Label
    @IBOutlet weak var emojiLabel: UILabel!
    
    // 結果分數的評語文字 Label
    @IBOutlet weak var resultLabel: UILabel!
    
    // 三個選項的outlet collections
    @IBOutlet var optionButtons: [UIButton]!
    
    // 開始遊戲View
    @IBOutlet weak var startGameView: UIView!
    
    // 遊戲結束後顯示總分及重玩按鈕
    @IBOutlet weak var endGameView: UIView!
    
    // 顯示最終分數（在endGameView上）
    @IBOutlet weak var scoreLabel: UILabel!
    
    // 儲存圈叉符號的顯示
    var emojiIndex = ""
    
    // 當前題目數，預設為0（會在generateProblem使用）
    var questionCount = 0
    
    // 分數計算（答對加10分）
    var scoreCount = 0
    
    // 創建存放 MathProblem 的變數
    var currentProblem: MathProblem?
    
    // 音效
    let soundPlayer = AVPlayer()
    
    // 起始畫面
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 生成題目
        generateProblem()
        // emojiLabel 用來顯示圈叉
        emojiLabel.text = emojiIndex
        // 隱藏 endGame
        endGameView.isHidden = true
    }
    
    // 三個選項
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        
        // 獲取按鈕的選項文字
        let optionText = sender.titleLabel!.text!
        // 將選項文字轉換成使用者的回答（字串轉數字）
        let userAnswer = Int(optionText)!
        
        // 確認 currentProblem 一定有值
        let problem = currentProblem!
        
        // 使用 AnswerOption 的 checkAnswer 方法來判斷使用者的回答是否正確
        let answer = AnswerOption.checkAnswer(userAnswer: userAnswer, problem: problem)

        // 根據回答的結果執行不同的動作
        switch answer {
        case .correct:
            print("答對了！")
            soundOfCorrect()                         // 答對音效
            updateEmojiLabel(withSymbol: "⭕️")       // 答對就添加一個⭕️
            scoreCount += 10                         // 答對加10分
        case .wrong:
            print("答錯了！")
            soundOfWrong()                            // 答錯音效
            updateEmojiLabel(withSymbol: "❌")        // 答錯就添加一個❌
        }
        
        // 顯示最終分數
        scoreLabel.text = "\(scoreCount)分"
        
        // 生成下一題
        generateProblem()
    }
    
    
    // 再測一次按鈕
    @IBAction func playAgainButtonTapped(_ sender: UIButton) {
        
        // 再玩一次音效
        soundOfAgain()
        
        // 隱藏endGameView
        endGameView.isHidden = true
        
        // 清空 resultLabel
        resultLabel.text = ""
        
        // 清空 emojiIndex、emojiLabel
        emojiLabel.text = ""
        emojiIndex = ""
        
        // 初始化題數、分數
        questionCount = 0
        scoreCount = 0
        
        // 生成新問題
        generateProblem()

        // 啟用選項按鈕
        optionButtons.forEach { button in
            button.isEnabled = true
        }

    }
    
    // 開始遊戲
    @IBAction func startGameButtonTapped(_ sender: UIButton) {
        // 隱藏startGameView
        startGameView.isHidden = true
        // 音效
        soundOfStart()
    }
    

    // 生成題目選項。 參數correctAnswer: 正確的答案。 返回值: 包含正確答案及兩個錯誤答案的整數陣列。（給generateProblem使用）
    func generateOptions(correctAnswer: Int) -> [Int] {
        
        // 把正確答案加入選項
        var options = [correctAnswer]

        // 生成另外兩個選項
        while options.count < 3 {
            
            // 隨機生成一個介於 1 到 81 之間的數字
            let randomProduct = Int.random(in: 1...81)
            
            // 如果生成的隨機數字 randomProduct 不在 options 陣列中，表示該選項是唯一的，則將其加入 options 陣列。（確保選項不重複）
            if !options.contains(randomProduct) {
                options.append(randomProduct)
            }
        }
        
        // 打亂選項
        options.shuffle()
        // 返回
        return options
    }
    
    
    // 生成一個新的數學問題並將其顯示在 questionLabel 上（同時更新Label）
    func generateProblem() {
        
        // 呼叫 MathProblem，藉此亂數生成被乘數、乘數
        currentProblem = MathProblem.generate()
        
        //  使用 optional binding 確保 currentProblem 是否有值
        if let problem = currentProblem {
            
            // 將被乘數和乘數轉換成字串，並且指派給 questionLabel 顯示
            questionLabel.text = "\(problem.multiplicand) x \(problem.multiplier) = ? "
            
            // 透過 generateOptions() 生成一個正確答案選項、兩個錯誤選項
            let options = generateOptions(correctAnswer: problem.product)
            
            
            // 為每個按鈕設置選項文字，並根據 options 陣列中的順序分配正確的選項給相應的按鈕
            for (index, button) in optionButtons.enumerated() {
                
                // 使用 index 來獲取 options 陣列中相應位置的答案選項，並將其設置為按鈕的標題，以便在 UI 上顯示相應的選項文字
                button.setTitle("\(options[index])", for: .normal)
            }
            
        }
        
        // 生成新的題目時，同時將 questionCount 增加 1，以確保計數的準確性。
        questionCount += 1
        currentQuestionLabel.text = "第 \(questionCount) 題"
        
        // 設置只能答10題
        if questionCount >= 11 {
            // 停止選項按鈕的運作
            optionButtons.forEach { button in
                button.isEnabled = false
            }
            
            // 當答完所有題目時，將當前第幾題改為「作答結束」。將題目清空。顯示分數結果
            currentQuestionLabel.text = "作答結束"
            questionLabel.text = ""
            resultLabel.text = updateScoreResult(score: scoreCount)
                    
            // 顯示 endGame
            endGameView.isHidden = false
        }
        
    }

    
    // 答對音效
    func soundOfCorrect() {
        let soundUrl = Bundle.main.url(forResource: "correct answer", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: soundUrl)
        soundPlayer.replaceCurrentItem(with: playerItem)
        soundPlayer.rate = 1.5
        soundPlayer.play()
    }
    
    // 答錯音效
    func soundOfWrong() {
        let soundUrl = Bundle.main.url(forResource: "wrong answer", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: soundUrl)
        soundPlayer.replaceCurrentItem(with: playerItem)
        soundPlayer.rate = 1.5
        soundPlayer.play()
    }
    
    // 再玩一次音效
    func soundOfAgain() {
        let soundUrl = Bundle.main.url(forResource: "SwipeSound", withExtension: "mp3")!
        let playeritem = AVPlayerItem(url: soundUrl)
        soundPlayer.replaceCurrentItem(with: playeritem)
        soundPlayer.rate = 1.5
        soundPlayer.play()
    }
    
    // 開始遊戲
    func soundOfStart() {
        let soundUrl = Bundle.main.url(forResource: "gameStart", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: soundUrl)
        soundPlayer.replaceCurrentItem(with: playerItem)
        soundPlayer.rate = 1.5
        soundPlayer.play()
    }
    
    // 答題的結果圈叉符號添加到 emojiLabel
    func updateEmojiLabel(withSymbol symbol: String) {
        
        // 將 symbol 添加到 emojiIndex 中
        emojiIndex += symbol
        
        // 在第 5 個 emoji 後插入換行符號
        if emojiIndex.count == 5 {
            emojiIndex += "\n"
        }
        // 將 emojiIndex 的內容設定為 emojiLabel 的文字內容。
        emojiLabel.text = emojiIndex
    }
    
    // 分數返回字串
    func updateScoreResult(score: Int) -> String {
                    
        switch score {
        case 0:
            return "你考了\(score)分！\n亂猜都會中一題吧！"
        case 10:
            return "你考了\(score)分！\n請不要亂猜！"
        case 20:
            return "你考了\(score)分！\n不要氣餒！"
        case 30:
            return "你考了\(score)分！\n一步一腳印，不要急！"
        case 40, 50:
            return "你考了\(score)分！\n再加把勁就快及格了！"
        case 60:
            return "你考了\(score)分！\n剛好及格邊緣！"
        case 70, 80:
            return "你考了\(score)分！\n挺厲害的！"
        case 90:
            return "你考了\(score)分！\n差一題滿分！讚！"
        default:
            return "你考了\(score)分！\n你考滿分啊！！"
        }
    }
    
}

              // for 迴圈寫法
//            for button in optionButtons {
//                // 在這裡對每個按鈕進行操作
//                button.isEnabled = false
//            }
