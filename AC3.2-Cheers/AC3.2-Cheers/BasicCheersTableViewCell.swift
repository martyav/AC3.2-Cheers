//
//  BasicCheersTableViewCell.swift
//  AC3.2-Cheers
//
//  Created by Marty Avedon on 1/10/17.
//  Copyright © 2017 Marty Hernandez Avedon. All rights reserved.
//

import UIKit
import FaveButton

protocol FaveButtonDelegate {
    func favoriteButtonClicked(at index:IndexPath)
}

class BasicCheersTableViewCell: UITableViewCell {

    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var pricing: UILabel!
    @IBOutlet weak var popularTimes: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var faveIt: FaveButton!
    
    var delegate: FaveButtonDelegate!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func makeFavorite(_ sender: FaveButton) {
//        cell.favorite = !cell.favorite
//    }
    
    @IBAction func faveIt(_ sender: UIButton) {
        self.delegate.favoriteButtonClicked(at: indexPath)
    }
}
