//
//  GameScreenViewController.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 23.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit

class GameScreenViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCard", for: indexPath) as! GameCardCollectionViewCell
        cell.cardPicture.image = UIImage(named: "Default Card")
        return cell
    }
}
