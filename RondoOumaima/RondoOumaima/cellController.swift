//
//  cellController.swift
//  RondoOumaima
//
//  Created by ESPRIT on 08/01/17.
//  Copyright © 2017 ESPRIT. All rights reserved.
//

import UIKit

class cellController: UITableViewCell {
    @IBOutlet weak var titre: UILabel!

    @IBOutlet weak var DES: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
