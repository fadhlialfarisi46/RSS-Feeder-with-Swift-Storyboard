//
//  FeedItemTableViewCell.swift
//  RSS Feeder
//
//  Created by muhammad.alfarisi on 14/05/23.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell {

    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
