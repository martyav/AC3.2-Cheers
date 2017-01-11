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
    func cellTapped(cell: UITableViewCell)
}

class BasicCheersTableViewCell: UITableViewCell {

    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var pricing: UILabel!
    @IBOutlet weak var popularTimes: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var faveIt: FaveButton!
    @IBInspectable public var normalColor: UIColor = .gray
    @IBInspectable public var selectedColor: UIColor = .red
    
    var delegate: FaveButtonDelegate?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.faveIt?.isSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteIt(_ sender: UIButton) {
        if let unwrapDelegate = delegate {
            unwrapDelegate.cellTapped(cell: self)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("reused")
        
        // Reset the cell for new row's data
        self.faveIt.isSelected = false
        print("\(self.faveIt?.isSelected)")
        self.venueName?.text = ""
        self.popularTimes?.text = ""
        self.distance?.text = ""
        self.pricing?.text = ""
    }
}
