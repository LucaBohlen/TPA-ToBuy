//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la page de modification de produit.

import UIKit
import DropDown
import MBProgressHUD

class EditGroceriesViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var category: DesignableUITextField!
    @IBOutlet weak var quantity: DesignableUITextField!
    @IBOutlet weak var catBtn: UIButton!
    
    private var dropDown = DropDown()
    
    var item: ShoppingList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.fillUI()
    }
    
    private func setup(){
        self.dropDown.anchorView = self.catBtn
        self.dropDown.dataSource = ["Jeux", "Légumes", "Boissons", "Viande", "Produit laitier", "Produit surgelé"]
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.category.text = item
        }
    }
    
    private func fillUI(){
        self.name.text = self.item.name
        self.category.text = self.item.category
        self.quantity.text = "\(self.item.quantity)"
    }
    
    @IBAction func openDropDown(_ sender: Any) {
        self.dropDown.show()
    }
    
    @IBAction func edit(_ sender: Any) {
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
            var shoppingItem = ShoppingList(name: name, dateAdded: self.item.dateAdded, quantity: Int(quantity)!, category: category, uid: Public.user.uid)
            shoppingItem.id = self.item.id
            Networking.shared.editShoppingItem(shoppingItem: shoppingItem) { (error) in
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
    
    @IBAction func del(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Grocery Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Networking.shared.deleteShoppingListItem(id: self.item.id) { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error{
                    self.showAlert(title: "Error", message: error) { (_) in }
                }else{
                    self.showAlert(title: "Success", message: "Item deleted from grocery list") { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
