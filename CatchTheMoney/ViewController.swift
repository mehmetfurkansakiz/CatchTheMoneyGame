//
//  ViewController.swift
//  CatchTheMoney
//
//  Created by furkan sakız on 15.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    
    var score = 0
    var remainingTimeTimer = Timer()
    var moneyTimer = Timer()
    var remainingTime = 30
    var highScore = 0
    var topMargin: CGFloat = 100 // 100 pixels from top,
    var gameIsRunning = false
    var timeBonusImageView: UIImageView?
    var moneyImageView: UIImageView?
    
    // MARK: - Views
    
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScoreLabel()
        
        // HighScore
        highScore = UserDefaults.standard.integer(forKey: "HighScore")
        highScoreLabel.text = "High Score: \(highScore)"
    }
    
    // MARK: - Start Button
    
    @IBAction func startButtonTapped(_ sender: Any) {
        score = 0
        updateScoreLabel()
        
        remainingTime = 30
        timeLabel.text = "\(remainingTime)"
        
        startButton.isHidden = true
        gameIsRunning = true
        startGame()
    }
    
    func startGame() {
        // Remaining Time Timer
        remainingTimeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(remainingTimeFunction), userInfo: nil, repeats: true)
        
        // Money Spawn Timer
        moneyTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(spawnMoney), userInfo: nil, repeats: true)
    }
    
    // MARK: - Remaining Time and Alert Actions
    
    @objc func remainingTimeFunction() {
        
        remainingTime -= 1
        timeLabel.text = "\(remainingTime)"
        
        if remainingTime == 0 {
            self.remainingTimeTimer.invalidate()
            self.moneyTimer.invalidate()
            
            // Check if the current score is higher than the stored high score
            if score > highScore {
                highScore = score
                highScoreLabel.text = "Highscore: \(highScore)"
                UserDefaults.standard.set(highScore, forKey: "HighScore")
            }
            
            let alert = UIAlertController(title: "Time's Up", message: "Score: \(score)", preferredStyle: .alert)
            let replayAction = UIAlertAction(title: "Try Again!", style: .default) { UIAlertAction in

                // Restart Game
                self.startButton.isHidden = false
                self.gameIsRunning = false
//                self.startGame()
                
                // Replay function
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.remainingTime = 30
                self.timeLabel.text = "\(self.remainingTime)"
            }
            
            alert.addAction(replayAction)
            self.present(alert, animated: true)
        }
    }
    // MARK: - Time Bonus
    
    @objc func spawnTimeBonus() {
        // Define the size of the time bonus image and set random X and Y coordinates, but limit the Y coordinate to be below the top 200 pixels.
        let timeBonusSize = CGSize(width: 75, height: 75)
        let randomX = CGFloat.random(in: 0...(gameView.frame.width - timeBonusSize.width))
        let randomY = CGFloat.random(in: topMargin...(gameView.frame.height - topMargin - timeBonusSize.height))
        let timeBonusFrame = CGRect(x: randomX, y: randomY, width: timeBonusSize.width, height: timeBonusSize.height)
        
        let timeBonusImage = UIImage(named: "timeBonusPic")
        timeBonusImageView = UIImageView(frame: timeBonusFrame)
        timeBonusImageView?.image = timeBonusImage
        timeBonusImageView?.isUserInteractionEnabled = true
        timeBonusImageView?.tag = 100
        gameView.addSubview(timeBonusImageView!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.timeBonusImageView!.removeFromSuperview()
        }
    }
    
    @objc func checkForTimeBonus() {
        // Check if the score is a multiple of 6
        if score % 6 == 0 {
            spawnTimeBonus()
        }
    }

    
    // MARK: - Spawn Money
    
    @objc func spawnMoney() {
        let moneySize = CGSize(width: 75, height: 75)
        let randomX = CGFloat.random(in: 0...(gameView.frame.width - moneySize.width))
        let randomY = CGFloat.random(in: topMargin...(gameView.frame.height - topMargin - moneySize.height))
        let moneyFrame = CGRect(x: randomX, y: randomY, width: moneySize.width, height: moneySize.height)
        
        // Money imeage creation
        let moneyImage = UIImage(named: "moneyPic")
        moneyImageView = UIImageView(frame: moneyFrame)
        moneyImageView?.image = moneyImage
        moneyImageView?.isUserInteractionEnabled = true
        moneyImageView?.tag = 200
        gameView.addSubview(moneyImageView!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.moneyImageView!.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: gameView)
            if let touchedView = gameView.hitTest(touchLocation, with: event), touchedView is UIImageView {
                
                if touchedView.tag == 100 {
                    // Handle tap on timeBonusImageView
                    if let timeBonusImageView = touchedView as? UIImageView {
                        remainingTime += 5
                        timeLabel.text = "\(remainingTime)"
                        timeBonusImageView.removeFromSuperview()
                    }
                } else if touchedView.tag == 200 {
                    // Handle tap on moneyImageView
                    touchedView.removeFromSuperview()
                    score += 1
                    updateScoreLabel()
                    checkForTimeBonus()
                }
            }
        }
    }


    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }


}

