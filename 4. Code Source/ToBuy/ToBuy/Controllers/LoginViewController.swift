//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Code généré semi-automatiquement, autre partie du code de Killermy, ce gère le login de l'application.

import UIKit
import MBProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: DesignableUITextField!
    @IBOutlet weak var password: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        if let email = self.email.text, let password = self.password.text{
            if email == ""{
                self.showAlert(title: "Erreur", message: "Entrer l'email") { (_) in }
                return
            }
            if password == ""{
                self.showAlert(title: "Erreur", message: "Entre un mot de passe") { (_) in }
                return
            }
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Networking.shared.signIn(email: email, password: password){ (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error{
                    self.showAlert(title: "Erreur", message: error) { (_) in }
                }else{
                    self.performSegue(withIdentifier: "toHome", sender: nil)
                }
            }
        }
    }

}
