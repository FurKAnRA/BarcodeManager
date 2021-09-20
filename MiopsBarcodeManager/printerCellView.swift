//
//  printerCellView.swift
//  MiopsBarcodeManager
//
//  Created by Furkan Kara on 7.02.2021.
//

import UIKit

class printerCellView: UITableViewCell {

 
    @IBOutlet weak var cell: UIView!
    

    @IBOutlet weak var cihazImage: UIImageView!
    
    @IBOutlet weak var cihazName: UILabel!
    
    @IBOutlet weak var connectButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
//        cell.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
