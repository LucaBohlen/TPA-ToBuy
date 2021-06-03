//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la page des détails des magasins.

import UIKit
import MBProgressHUD

class ShopDetailsViewController: UIViewController {
    
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var shop: Shop!
    var items = [(String, String)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.name.text = self.shop.name
        self.location.text = self.shop.shopLocation
        self.getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shop"{
            let vc = segue.destination as! OrderListViewController
            vc.shop = self.shop
        }else if segue.identifier == "add"{
            let vc = segue.destination as! AddShopCategoryViewController
            vc.shop = self.shop
        }
    }
    
    private func setup(){
        self.tablev.delegate = self
        self.tablev.dataSource = self
        self.tablev.tableFooterView = UIView()
        self.items.removeAll()
        for (key, value) in shop.categoryLocation{
            self.items.append((key, value))
        }
        self.items.sort(by: {$0.0 < $1.0})
        self.tablev.reloadData()
    }
    
    private func getData(){
        Networking.shared.getShop(id: self.shop.id) { (error, shop) in
            if let error = error{
                self.showAlert(title: "Erreur", message: error) { (_) in
                    self.navigationController?.popViewController(animated: true)
                }
            }else if let shop = shop{
                self.shop = shop
                self.setup()
            }else{
                self.showAlert(title: "Erreur", message: "Magasin pas trouvé") { (_) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }

}

extension ShopDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell") as! CatTableViewCell
        cell.cat.text = "Catégorie: \(self.items[indexPath.row].0)"
        cell.loc.text = "Quantité: \(self.items[indexPath.row].1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Supprimer une catégorie", message: "Voulez-vous supprimer une catégorie ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (_) in
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.shop.categoryLocation.removeValue(forKey: self.items[indexPath.row].0)
                Networking.shared.editShop(shop: self.shop) { (error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if let error = error{
                        self.showAlert(title: "Erreur", message: error) { (_) in }
                    }else{
                        self.showAlert(title: "Succès", message: "Catégorie supprimé") { (_) in }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
