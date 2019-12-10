//
//  CustomCell.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/11/08.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import UIKit
import RealmSwift

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var memoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
