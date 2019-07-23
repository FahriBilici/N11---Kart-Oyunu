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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cardList : [String] = ["a1","a2","a3","a4","a5","a6","a7","a8"]
    var levelCardList : [String] = []
    var level = 1
    var gameTimer = Timer()
    var timeRemain = 180
    var selectedPicture : [String] = []
    var selectedPictureLocation : [IndexPath] = []
    var locationOfHiddenPictures : [IndexPath] = []
    var score = 0
    var cardRemain = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        levelDesigner(level: level)
        startTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelCardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCard", for: indexPath) as! GameCardCollectionViewCell
        cell.cardPicture.image = UIImage(named: "Default Card")
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
        let cell = collectionView.cellForItem(at: indexPath) as! GameCardCollectionViewCell
        selectedPicture.append(levelCardList[indexPath.row])
        selectedPictureLocation.append(indexPath)
        locationOfHiddenPictures.append(indexPath)
        cell.cardPicture.image = UIImage(named: levelCardList[indexPath.row])
        if selectedPicture.count == 2
        {
            if selectionControl(selectedCards: selectedPicture) == true
            {
                    for item in selectedPictureLocation
                    {
                        let hiddenCell = collectionView.cellForItem(at: item)
                        hiddenCell?.isHidden = true
                    }
                    scoreCalculator(level: level)
                cardRemain -= 1
                selectedPictureLocation.removeAll()
                if cardRemain == 0
                {
                    levelUp()
                    collectionView.reloadData()
                }
            }
            else
            {
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: selectedPictureLocation)
                }, completion: nil)
                selectedPictureLocation.removeAll()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
    
    func levelDesigner(level : Int)
    {
        if level == 1
        {
            cardCreator(cardnumber: 3)
        }
        else if level == 2
        {
            cardCreator(cardnumber: 4)
        }
        else if level == 3
        {
            cardCreator(cardnumber: 6)
        }
        else
        {
            cardCreator(cardnumber: 8)
        }
    }
    func cardCreator(cardnumber: Int)
    {
        cardRemain = cardnumber
        levelCardList = cardList
        levelCardList.shuffle()
        levelCardList.removeLast(8-cardnumber)
        levelCardList += levelCardList
        levelCardList.shuffle()
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
    func selectionControl(selectedCards:[String]) -> Bool
    {
        if selectedPicture[0] == selectedPicture[1]
        {
            print(selectedPicture)
            //levelCardList.removeAll (where : {$0 == selectedPicture[0] })
            selectedPicture.removeAll()
            return true
        }
        else
        {
            selectedPicture.removeAll()
            return false
        }
    }
    func levelUp()
    {
        if level != 5
        {
        level += 1
        for item in locationOfHiddenPictures
        {
            let hiddenCell = collectionView.cellForItem(at: item)
            hiddenCell?.isHidden = false
        }
        levelDesigner(level: level)
        }
        else
        {
            endTimer()
            print("level bitti")
            score = score + (timeRemain * 3)
        }
    }
    func scoreCalculator(level: Int)
    {
        score += (10*level)
        scoreLabel.text = "Score : \(score)"
    }
}
