//
//  NewsViewCell.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//

import UIKit

class NewsViewCell: UITableViewCell {
    
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
