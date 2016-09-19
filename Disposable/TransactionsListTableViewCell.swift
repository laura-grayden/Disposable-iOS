//
//  TransactionsListTableViewCell.swift
//  Disposable
//
//  Created by Laura Grayden on 8/09/2015.
//  Copyright (c) 2015 Lance Apps. All rights reserved.
//

import UIKit

class TransactionsListTableViewCell: UITableViewCell {
    
    // Properties

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var reoccuranceLabel: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {

        super.setSelected(selected, animated: animated)

    }

}
