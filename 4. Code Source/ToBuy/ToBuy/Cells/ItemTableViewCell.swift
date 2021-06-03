//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script est utilisé pour les cellules des produits.

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
