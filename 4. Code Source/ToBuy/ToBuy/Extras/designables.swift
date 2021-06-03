//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Code généré automatiquement, ce script crée ici le code de chaque objet crée.

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {

    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.height))
            self.leftView = paddingView
            self.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.borderColor = self.borderColor.cgColor
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
    
}

@IBDesignable
class DesignableUIButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.black{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.borderColor = self.borderColor.cgColor
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var circular: Bool = false{
        didSet{
            self.applyCornerRadius()
        }
    }
    
    func applyCornerRadius()
    {
        if(self.circular) {
            self.layer.cornerRadius = self.bounds.size.height/2
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = CGFloat(self.borderWidth)
        }else {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = CGFloat(self.borderWidth)
        }
    }
    
}

@IBDesignable
class RoundableImageView: UIImageView {

    @IBInspectable var cornerRadius : CGFloat = 0.0{
        didSet{
            self.applyCornerRadius()
        }
    }

    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            self.applyCornerRadius()
        }
    }

    @IBInspectable var borderWidth : Double = 0{
        didSet{
            self.applyCornerRadius()
        }
    }

    @IBInspectable var circular : Bool = false{
        didSet{
            self.applyCornerRadius()
        }
    }

    func applyCornerRadius()
    {
        if(self.circular) {
            self.layer.cornerRadius = self.bounds.size.height/2
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = CGFloat(self.borderWidth)
        }else {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = CGFloat(self.borderWidth)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyCornerRadius()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadius()
    }

}

@IBDesignable
class DesignableUITextView: UITextView {

    @IBInspectable var placeholder: String = "" {
         didSet{
             updatePlaceHolder()
        }
    }

    @IBInspectable var placeholderColor: UIColor = UIColor.gray {
        didSet {
            updatePlaceHolder()
        }
    }

    private var originalTextColor = UIColor.darkText
    private var originalText: String = ""

    private func updatePlaceHolder() {

        if self.text == "" || self.text == placeholder  {

            self.text = placeholder
            self.textColor = placeholderColor
            if let color = self.textColor {

                self.originalTextColor = color
            }
            self.originalText = ""
        } else {
            self.textColor = self.originalTextColor
            self.originalText = self.text
        }

    }

    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.text = self.originalText
        self.textColor = self.originalTextColor
        return result
    }
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updatePlaceHolder()

        return result
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}

@IBDesignable class customView:UIView {
    
    @IBInspectable var cornerRadius : CGFloat = 0.0{
        didSet{
            self.applyCornerRadius()
        }
    }

    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            self.applyCornerRadius()
        }
    }

    @IBInspectable var borderWidth : Double = 0{
        didSet{
            self.applyCornerRadius()
        }
    }
    
    @IBInspectable var circular: Bool = false{
        didSet{
            self.applyCornerRadius()
        }
    }
    
    func applyCornerRadius(){
        if(self.circular) {
            self.layer.cornerRadius = self.bounds.size.height/2
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = CGFloat(self.borderWidth)
        }else {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = CGFloat(self.borderWidth)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyCornerRadius()
    }
    
}

@IBDesignable extension UINavigationBar {

    @IBInspectable var titleColor: UIColor? {
        set {
            guard let color = newValue else { return }
            if #available(iOS 13.0, *) {
                self.standardAppearance.titleTextAttributes = [.foregroundColor: color]
                self.standardAppearance.backgroundColor = UIColor(red: 22/255, green: 126/255, blue: 185/255, alpha: 1.0)
            } else {
                self.titleTextAttributes = [.foregroundColor: color]
            }
        }
        get {
            self.titleTextAttributes?[NSAttributedString.Key(rawValue: "NSForegroundColorAttributeName")] as? UIColor
        }
    }
}

@IBDesignable
class designableSearchBar: UISearchBar{
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.height))
            self.searchTextField.leftView = paddingView
            self.searchTextField.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.searchTextField.backgroundColor = .white
        self.setImage(UIImage(named: "x"), for: .clear, state: .normal)
        self.searchTextField.font = UIFont(name: "Ubuntu-Regular", size: 16.0)
        self.setImage(UIImage(), for: .search, state: .normal)
    }
    
}

