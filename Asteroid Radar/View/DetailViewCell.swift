//
//  DetailViewCell.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//

import UIKit

class DetailViewCell: UITableViewCell {

    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailContentLabel: UILabel!
    @IBOutlet weak var detailValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

