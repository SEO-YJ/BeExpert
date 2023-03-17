//
//  TimeTableViewCell.swift
//  BeExpert
//
//  Created by 서유준 on 2023/03/06.
//

import UIKit

class TimeTableViewCell: UITableViewCell {
    static let cell_id = "cell_id_time"
        
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    override func prepareForReuse() {
            super.prepareForReuse()
        timeLabel.text = ""
        currentTimeLabel.text = ""
        }
}
