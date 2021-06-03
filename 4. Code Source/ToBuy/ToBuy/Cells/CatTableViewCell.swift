//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script est utilisé pour les cellules des catégorie et location.

import UIKit
 
class CatTableViewCell: UITableViewCell {

    @IBOutlet weak var cat: UILabel!
    @IBOutlet weak var loc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
