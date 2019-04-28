//
//  SantaCell.swift
//  IOS-SecretSantaApp
//
//  Created by Andrew Fallin on 4/28/19.
//  Copyright © 2019 Andrew Fallin. All rights reserved.
//

import Foundation
import UIKit

class SantaCell: UITableViewCell{
    
    @IBOutlet weak var promptLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
