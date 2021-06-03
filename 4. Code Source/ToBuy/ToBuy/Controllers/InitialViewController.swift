//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la première vue active, si connecté ou non.

import UIKit
import FirebaseAuth
import MBProgressHUD

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser == nil{
            self.performSegue(withIdentifier: "login", sender: nil)
        }else{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Networking.shared.fetchUser(uid: Auth.auth().currentUser!.uid) { (error, user) in
                if let error = error{
                    self.showAlert(title: "Erreur", message: error) { (_) in
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }
                }else if let user = user{
                    Public.user = user
                    self.performSegue(withIdentifier: "toHome", sender: nil)
                }else{
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
            }
        }
    }

}
