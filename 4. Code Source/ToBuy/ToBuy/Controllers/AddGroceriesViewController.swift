//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la page d'ajout de produit.

import UIKit
import MBProgressHUD
import DropDown

class AddGroceriesViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var category: DesignableUITextField!
    @IBOutlet weak var quantity: DesignableUITextField!
    @IBOutlet weak var catBtn: UIButton!
    
    private var dropDown = DropDown()
    
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
    
    @IBAction func openDropdown(_ sender: Any) {
        self.dropDown.show()
    }
    
    @IBAction func add(_ sender: Any) {
        if let name = self.name.text, let quantity = self.quantity.text, let category = self.category.text{
            if name == ""{
                self.showAlert(title: "Erreur", message: "Entrer un nom de produit") { (_) in }
                return
            }
            if Int(quantity) == nil{
                self.showAlert(title: "Erreur", message: "Quantité invalide") { (_) in }
                return
            }
             if Int(quantity) == 0{
                self.showAlert(title: "Erreur", message: "La quantité ne peut pas être de 0") { (_) in }
                return
            }
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let shoppingItem = ShoppingList(name: name, dateAdded: Date(), quantity: Int(quantity)!, category: category, uid: Public.user.uid)
            Networking.shared.addShoppingItem(shoppingItem: shoppingItem) { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error{
                    self.showAlert(title: "Erreur", message: error) { (_) in }
                }else{
                    self.showAlert(title: "Succès", message: "Produit ajouté") { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    

}
