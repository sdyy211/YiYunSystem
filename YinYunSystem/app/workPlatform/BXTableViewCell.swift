//
//  BXTableViewCell.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/3/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class BXTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
