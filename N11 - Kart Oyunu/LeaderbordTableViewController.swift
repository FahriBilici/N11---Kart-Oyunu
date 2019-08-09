//
//  LeaderbordTableViewController.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 25.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit

class LeaderbordTableViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var userList : [Player] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.shared.getLeaderbord { (userList) in
            self.userList = userList
            self.tableView.reloadData()
        }
        tableView.allowsSelection = false
        activityIndicator.startAnimating()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardTableViewCell
        cell.pictureView.image = UIImage()
        cell.nameLabel.text = userList[indexPath.row].username
        cell.scoreLabel.text = "Score: \(userList[indexPath.row].highscore)"
        cell.statusLabel.text = "\(indexPath.row + 1) -"
        DispatchQueue.main.async {
            let image = Service.shared.downloadImgFromUrl(url: self.userList[indexPath.row].profile_pic)
            cell.pictureView.image = UIImage(data: image as Data)
            self.activityIndicator.stopAnimating()
        }
        return cell
    }
}
