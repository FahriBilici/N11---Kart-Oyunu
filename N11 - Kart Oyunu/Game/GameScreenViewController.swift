//
//  GameScreenViewController.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 23.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit
class GameScreenViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var          collectionView: UICollectionView!
    
    let cardList : [String] = ["a1","a2","a3","a4","a5","a6","a7","a8"]
    var levelCardList : [String] = []
    var level = 1
    var gameTimer = Timer()
    var timeRemain = 180
    var selectedPicture : [String] = []
    var selectedPictureLocation : [IndexPath] = []
    var locationOfHiddenPictures : [IndexPath] = []
    var score = 0
    var cardRemain = Int()
    var isGameFinished : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designLevel(level: level)
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isGameFinished == true
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelCardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCard", for: indexPath) as! GameCardCollectionViewCell
        cell.frontOfTheCard.image = UIImage(named: "DefaultCard")
        cell.backOfTheCard.image = UIImage(named: levelCardList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if level != 1
        {
            return CGSize(width: 75, height: 50)
        }
        else
        {
            return CGSize(width: 100, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedPictureLocation.count == 0 || selectedPictureLocation[0] != indexPath
        {
            let cell = collectionView.cellForItem(at: indexPath) as! GameCardCollectionViewCell
            selectedPicture.append(levelCardList[indexPath.row])
            selectedPictureLocation.append(indexPath)
            locationOfHiddenPictures.append(indexPath)
            cell.flip()
            if selectedPicture.count == 2
            {
                if isCardsMatched(selectedCards: selectedPicture) == true
                {
                    ifTheyMatched()
                }
                else
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.ifTheyNotMatched()
                    })
                }
            }
            
        }
        
    }
    func ifTheyMatched()
    {
        self.view.isUserInteractionEnabled = false
        for item in selectedPictureLocation
        {
            let hiddenCell = collectionView.cellForItem(at: item) as? GameCardCollectionViewCell
            hiddenCell?.destroy()
            if cardRemain != 1
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    hiddenCell?.isHidden = true
                    self.view.isUserInteractionEnabled = true
                })
            }
            else
            {
                hiddenCell?.isHidden = true
                self.view.isUserInteractionEnabled = true
            }
            
        }
        updateScore(level: level)
        cardRemain -= 1
        selectedPictureLocation.removeAll()
        if cardRemain == 0
        {
            ifLevelFinished()
            collectionView.reloadData()
        }
    }
    func ifTheyNotMatched()
    {
        for item in selectedPictureLocation
        {
            let hiddenCell = collectionView.cellForItem(at: item) as? GameCardCollectionViewCell
            hiddenCell?.flipBack()
        }
        selectedPictureLocation.removeAll()
    }
    
    func designLevel(level : Int)
    {
        if level == 1
        {
            levelCardList = makeCardsForLevel(cardnumber: 3)
        }
        else if level == 2
        {
            levelCardList = makeCardsForLevel(cardnumber: 4)
        }
        else if level == 3
        {
            levelCardList = makeCardsForLevel(cardnumber: 6)
        }
        else
        {
            levelCardList = makeCardsForLevel(cardnumber: 8)
        }
    }
    func makeCardsForLevel(cardnumber: Int) -> [String]
    {
        var cardForLevel = cardList
        cardRemain = cardnumber
        cardForLevel.shuffle()
        if cardnumber != 8
        {
        cardForLevel.removeLast(8-cardnumber)
        }
        cardForLevel += cardForLevel
        cardForLevel.shuffle()
        return cardForLevel
    }
    func startTimer()
    {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime()
    {
        timeLabel.text = "Time : \(formatTime(time: timeRemain))"
        
        if timeRemain != 0
        {
            timeRemain -= 1
        }
        else
        {
            endTimer()
            finishGame(result: false)
        }
    }
    func endTimer() {
        gameTimer.invalidate()
    }
    func formatTime(time: Int) -> String
    {
        let seconds = Int(time % 60)
        let minutes = Int((time / 60) % 60)
        
        return String(format: "%02d:%02d", minutes,seconds)
    }
    func isCardsMatched(selectedCards:[String]) -> Bool
    {
        if selectedPicture[0] == selectedPicture[1]
        {
            selectedPicture.removeAll()
            return true
        }
        else
        {
            selectedPicture.removeAll()
            return false
        }
    }
    func ifLevelFinished()
    {
        if level < 1
        {
        level += 1
        for item in locationOfHiddenPictures
        {
            let hiddenCell = collectionView.cellForItem(at: item) as? GameCardCollectionViewCell
            hiddenCell?.isHidden = false
            hiddenCell?.flipBack()
        }
        designLevel(level: level)
        }
        else
        {
            finishGame(result: true)
            endTimer()
        }
    }
    func updateScore(level: Int)
    {
        score += (10*level)
        scoreLabel.text = "Score : \(score)"
    }
    func finishGame(result : Bool)
    {
        isGameFinished = true
        score = score + (timeRemain * 3)
        saveScore(score: score)
        openFinishGamePopUp(result: result)
    }
    func openFinishGamePopUp(result : Bool)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Finish") as! FinishPopUpViewController
        vc.success = result
        vc.score = score
        vc.highScore = UserDefaults.standard.value(forKey: "highscore") as! Int
        self.present(vc, animated: true, completion: nil)
    }
    func saveScore(score: Int)
    {
        if let highScore = UserDefaults.standard.value(forKey: "highscore")
        {
            if score > highScore as! Int
            {
               UserDefaults.standard.set(score, forKey: "highscore")
            updateScoreToDB(score: score)
            }
        }
        else
        {
            UserDefaults.standard.set(Int(score), forKey: "highscore")
        }
    }
    func updateScoreToDB(score: Int)
    {
        if let userID = UserDefaults.standard.value(forKey: "userID") as? String
        {
        let scoreAsString = String(score)
        Service.shared.saveScore(userID: userID, highScore: scoreAsString, success: {
        print("Score yüklendi")
        })
        }
    }
}
