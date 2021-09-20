//
//  CellView.swift
//  MiopsBarcodeManager
//
//  Created by Furkan Kara on 29.12.2020.
//

import UIKit

class CellView: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var cihazImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var printBarcodeButton: UIButton!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    
}
