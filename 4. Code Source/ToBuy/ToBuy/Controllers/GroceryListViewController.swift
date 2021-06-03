//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la page de liste de courses.

import UIKit
import MBProgressHUD
import FirebaseAuth

class GroceryListViewController: UIViewController {

    @IBOutlet weak var tablev: UITableView!
    
    private var items = [ShoppingList]()
    private var selectedItem: ShoppingList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup(){
        self.tablev.delegate = self
        self.tablev.dataSource = self
        self.tablev.tableFooterView = UIView()
        self.tablev.reloadData()
        self.getData()
    }
    
    private func getData(){
        self.tablev.setEmptyMessage("Chargement")
        Networking.shared.getShoppingList(uid: Public.user.uid) { (error, items) in
            self.tablev.restore()
            if let error = error{
                self.showAlert(title: "Erreur", message: error) { (_) in }
            }else if let items = items{
                self.items = items
                Public.groceryList = items
                self.tablev.reloadData()
            }else{
                self.tablev.setEmptyMessage("Produit pas valide")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            let vc = segue.destination as! EditGroceriesViewController
            vc.item = self.selectedItem
        }
    }

    @IBAction func logout(_ sender: Any) {
        let alert = UIAlertController(title: "Déconnexion", message: "Voulez-vous déconnecter ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (_) in
            do{
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "login")
                UIApplication.shared.windows.first?.rootViewController = vc
            }catch{
                self.showAlert(title: "Impossible de se déconnecter", message: error.localizedDescription) { (_) in }
            }
        }))
        alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension GroceryListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
        cell.name.text = self.items[indexPath.row].name
        cell.category.text = "Categorie: \(self.items[indexPath.row].category)"
        cell.qty.text = "Quantité: \(self.items[indexPath.row].quantity)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedItem = self.items[indexPath.row]
        self.performSegue(withIdentifier: "edit", sender: nil)
    }
    
}
