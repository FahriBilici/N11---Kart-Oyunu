//
//  FinishPopUpViewController.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 23.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit

class FinishPopUpViewController: UIViewController {
    @IBOutlet weak var finishImage: UIImageView!
    @IBOutlet weak var finishText: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var highScoreText: UILabel!
    var success : Bool?
    @IBOutlet weak var finishView: UIView!
    var score : Int = 0
    var highScore : Int = 0
    @IBOutlet weak var blueEffect: UIImageView!
    @IBAction func Return(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        finishView.layer.cornerRadius = 50
        if success == true
        {
            finishImage.image = UIImage(named: "OK")
            finishText.text = "Congrats!! You Finished Game"
            scoreText.text = "Your Score : \(score)"
            highScoreText.text = "Your Highest Score : \(String(highScore))"
        }
        else
        {
            finishImage.image = UIImage(named: "Fail")
            finishText.text = "You Lose"
            scoreText.text = "Your Score : \(score)"
        }
    }
}
