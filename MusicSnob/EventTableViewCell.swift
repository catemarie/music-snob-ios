//
//  EventTableViewCell.swift
//  MusicSnob
//
//  Created by Cate Miller on 4/10/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
