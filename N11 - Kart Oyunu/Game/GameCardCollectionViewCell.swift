//
//  GameCardCollectionViewCell.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 23.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit

class GameCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backOfTheCard: UIImageView!
    @IBOutlet weak var frontOfTheCard: UIImageView!
    
    func flip()
    {
        UIView.transition(from: frontOfTheCard, to: backOfTheCard, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    func flipBack()
    {
        UIView.transition(from: backOfTheCard, to: frontOfTheCard, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
    }
    func destroy()
    {
        UIView.transition(with: backOfTheCard, duration: 0.5, options: .transitionCurlUp, animations: nil, completion: nil)
    }
    
}
