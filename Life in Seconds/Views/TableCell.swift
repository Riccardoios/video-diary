//
//  TableCell.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 11/01/22.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var videoImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
