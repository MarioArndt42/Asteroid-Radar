//
//  ApproachViewCell.swift
//  Asteroid Radar
//
//  Created by Mario Arndt on 14.09.23.
//

import UIKit

class ApproachViewCell: UITableViewCell {
    
    @IBOutlet weak var approachView: UIView!
    @IBOutlet weak var approachDateContentLabel: UILabel!
    @IBOutlet weak var approachDateValueLabel: UILabel!
    @IBOutlet weak var distanceContentLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var velocityContentLabel: UILabel!
    @IBOutlet weak var velocityValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
