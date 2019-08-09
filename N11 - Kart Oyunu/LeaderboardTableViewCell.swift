//
//  LeaderboardTableViewCell.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 25.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     //   pictureView = imgRounder(imgView: pictureView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
