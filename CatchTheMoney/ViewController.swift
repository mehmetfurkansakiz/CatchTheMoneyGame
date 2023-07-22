//
//  ViewController.swift
//  CatchTheMoney
//
//  Created by furkan sakız on 15.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // Variables
    var score = 0
    var timer = Timer()
    var remainingTime = 30
    var topMargin: CGFloat = 100 // 100 pixel from top
    
    // Views
    @IBOutlet var gameView: UIView!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
//    @IBOutlet weak var money1: UIImageView!
//    @IBOutlet weak var money2: UIImageView!
//    @IBOutlet weak var money3: UIImageView!
//    @IBOutlet weak var money4: UIImageView!
//    @IBOutlet weak var money5: UIImageView!
//    @IBOutlet weak var money6: UIImageView!
//    @IBOutlet weak var money7: UIImageView!
//    @IBOutlet weak var money8: UIImageView!
//    @IBOutlet weak var money9: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Score
        scoreLabel.text = "Score: \(score)"
        
        // Images
//        money1.isUserInteractionEnabled = true
//        money2.isUserInteractionEnabled = true
//        money3.isUserInteractionEnabled = true
//        money4.isUserInteractionEnabled = true
//        money5.isUserInteractionEnabled = true
//        money6.isUserInteractionEnabled = true
//        money7.isUserInteractionEnabled = true
//        money8.isUserInteractionEnabled = true
//        money9.isUserInteractionEnabled = true
        
//        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
//        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
//        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
//        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
//        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
//        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
//        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
//        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
//        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        
//        money1.addGestureRecognizer(recognizer1)
//        money2.addGestureRecognizer(recognizer2)
//        money3.addGestureRecognizer(recognizer3)
//        money4.addGestureRecognizer(recognizer4)
//        money5.addGestureRecognizer(recognizer5)
//        money6.addGestureRecognizer(recognizer6)
//        money7.addGestureRecognizer(recognizer7)
//        money8.addGestureRecognizer(recognizer8)
//        money9.addGestureRecognizer(recognizer9)
        
        // Remaining Time Timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(remainingTimeFunction), userInfo: nil, repeats: true)
        
        // Money Spawn Timer
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(spawnMoney), userInfo: nil, repeats: true)
    }
    
    // Increase Score Function
//    @objc func increaseScore() {
//        score += 1
//        scoreLabel.text = "Score: \(score)"
//    }
    //
    @objc func remainingTimeFunction() {
        
        remainingTime -= 1
        timeLabel.text = "\(remainingTime)"
        
        if remainingTime == 0 {
            timer.invalidate()
            let alert = UIAlertController(title: "Time's Up", message: "Score: \(score)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let replayAction = UIAlertAction(title: "Try Again!", style: .default) { UIAlertAction in
                //replay function
            }
            
            alert.addAction(okAction)
            alert.addAction(replayAction)
            self.present(alert, animated: true)
        }
    }
    
    @objc func spawnMoney() {
        //
        let moneySize = CGSize(width: 75, height: 75)
        let randomX = CGFloat.random(in: 0...(gameView.frame.width - moneySize.width))
        let randomY = CGFloat.random(in: topMargin...(gameView.frame.height - topMargin - moneySize.height))
        let moneyFrame = CGRect(x: randomX, y: randomY, width: moneySize.width, height: moneySize.height)
        
        // Money imeage creation
        let moneyImage = UIImage(named: "moneyPic") // Money karakterinin resminin adı
        let moneyImageView = UIImageView(frame: moneyFrame)
        moneyImageView.image = moneyImage
        moneyImageView.isUserInteractionEnabled = true
        gameView.addSubview(moneyImageView)
        
        // Remove money image from imageView after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            moneyImageView.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Detect if the user touches the money image and remove it
        if let touch = touches.first {
            let touchLocation = touch.location(in: gameView)
            if let touchedView = gameView.hitTest(touchLocation, with: event), touchedView is UIImageView {
                touchedView.removeFromSuperview()
                score += 1
                updateScoreLabel()
            }
        }
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }


}

