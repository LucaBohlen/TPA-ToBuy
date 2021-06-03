//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la page d'ordre des courses.

import UIKit
import MBProgressHUD

class OrderListViewController: UIViewController {
    
    @IBOutlet weak var tablev: UITableView!
    
    var items = [(String, ShoppingList)]()
    var shop: Shop!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup(){
        self.items.removeAll()
        for i in Public.groceryList{
            self.items.append((self.shop.categoryLocation[i.category] ?? "", i))
        }
        self.items.sort(by: {$0.0 < $1.0})
        self.tablev.delegate = self
        self.tablev.dataSource = self
        self.tablev.tableFooterView = UIView()
        self.tablev.reloadData()
    }

    @IBAction func finish(_ sender: Any) {
        if self.items.count == 0{
            self.showAlert(title: "Liste des courses vide", message: "Il n'y a pas de produit dans votre liste") { (_) in }
            return
        }
        var ids = [String]()
        for i in self.items{
            ids.append(i.1.id)
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Networking.shared.deleteShoppingList(ids: ids) { (error) in
            if let error = error{
                self.showAlert(title: "Erreur", message: error) { (_) in }
            }else{
                self.showAlert(title: "Félicitations !", message: "Vous avez terminé vos courses") { (_) in
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-4])!, animated: true)
                }
            }
        }
    }
    
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell
        cell.name.text = self.items[indexPath.row].1.name
        cell.category.text = "Catégorie: \(self.items[indexPath.row].1.category)"
        cell.qty.text = "Quantité: \(self.items[indexPath.row].1.quantity)"
        if let location = self.shop.categoryLocation[self.items[indexPath.row].1.category]{
            cell.location.text = "Location: \(location)"
        }else{
            cell.location.text = "Location: N/A"
        }
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "edit", sender: nil)
    }
    
}
