//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la page d'ajout de catégorie des magasins.

import UIKit
import DropDown
import MBProgressHUD

class AddShopCategoryViewController: UIViewController {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var category: DesignableUITextField!
    @IBOutlet weak var catBtn: UIButton!
    
    private var dropDown = DropDown()
    
    var shop: Shop!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup(){
        self.dropDown.anchorView = self.catBtn
        self.dropDown.dataSource = ["Jeux", "Légumes", "Boissons", "Viande", "Produit laitier", "Produit surgelé"]
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.category.text = item
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openDropDown(_ sender: Any) {
        self.dropDown.show()
    }

    @IBAction func add(_ sender: Any) {
        if let location = self.location.text, let category = self.category.text{
            if location == ""{
                self.showAlert(title: "Erreur", message: "Entrer la location de la catégorie") { (_) in }
                return
            }
            self.shop.categoryLocation[category] = location
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Networking.shared.editShop(shop: self.shop) { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error{
                    self.showAlert(title: "Erreur", message: error) { (_) in }
                }else{
                    self.showAlert(title: "Succès", message: "Catégorie ajoutée") { (_) in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
