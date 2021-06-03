//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la page de liste de magasin.

import UIKit
import MBProgressHUD

class ShopsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var colv: UICollectionView!
    
    private var items = [Shop]()
    private var selectedShop: Shop!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup(){
        self.colv.delegate = self
        self.colv.dataSource = self
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.colv.addGestureRecognizer(lpgr)
        
        self.getData()
    }
    
    private func getData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Networking.shared.getShops(uid: Public.user.uid) { (error, shops) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error{
                self.showAlert(title: "Erreur", message: error) { (_) in }
            }else if let shops = shops{
                self.items = shops
                self.colv.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add"{
            let vc = segue.destination as! AddShopViewController
            vc.items = self.items
        }else if segue.identifier == "next"{
            let vc = segue.destination as! ShopDetailsViewController
            vc.shop = self.selectedShop
        }
    }

}

extension ShopsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath) as! ShopCollectionViewCell
        cell.name.text = self.items[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let measurement = (self.view.bounds.width/2)-30
        return CGSize(width: measurement, height: measurement)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectedShop = self.items[indexPath.row]
        self.performSegue(withIdentifier: "next", sender: nil)
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != UIGestureRecognizer.State.ended){
            return
        }
        let p = gestureRecognizer.location(in: self.colv)
        if let indexPath = (self.colv.indexPathForItem(at: p)){
            let item = self.items[indexPath.row]
            if ["Migros", "Aldi", "Coop"].contains(item.name){
                self.showAlert(title: "Erreur", message: "Un magasin prédéfini ne peut pas être supprimé") { (_) in }
                return
            }
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Supprimer", style: .destructive, handler: { (_) in
                let alert = UIAlertController(title: "Supprimer un produit", message: "Voulez-vous supprmier votre produit", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (_) in
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    Networking.shared.deleteShop(id: item.id) { (error) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if let error = error{
                            self.showAlert(title: "Erreur", message: error) { (_) in }
                        }else{
                            self.showAlert(title: "Succès", message: "Produit supprimé de la liste") { (_) in
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
