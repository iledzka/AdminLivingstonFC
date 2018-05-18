//
//  LoginViewController.swift
//  AdminForLivingstonFC
//
//  Created by Iza Ledzka on 12/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  Login view controller
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        passwordTextField.layer.cornerRadius = 10
        usernameTextField.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 80.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 80.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    var alert: UIAlertController? {
        didSet{
            self.present(alert!, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if (username == "" || password == "") {
            return
        }
        
        doLogin(username: username!, password: password!)
    }
    
    private func doLogin(username: String, password: String){
        var params = [String:String]()
        params["username"] = username
        params["password"] = password
        LivingstonFCAPIManager.sharedInstance.loginAdmin(params: params, onSuccess: { accessToken in
            DispatchQueue.main.async {
                UserDefaultsManager.addAccessToken(accessToken)
                Switcher.updateRootVC()
            }
        }, onFailure: { [weak self] error in
            DispatchQueue.main.async {
                var errorMsg = error.localizedDescription
                if let error = error as? ErrorResponse {
                    switch error {
                    case .internalServerError:
                        errorMsg = "There is something wrong on our side. Please try again later."
                    case .unauthorized:
                        errorMsg = "The username/email address or password is invalid."
                    case .unprocessableEntity:
                        errorMsg = "Could not process your request."
                    case .connectionFailed:
                        errorMsg = "It appears you are offline. Connect to internet to log in."
                    case .invalidRequest:
                        errorMsg = "Invalid Request"
                    }
                }
                
                self?.alert = CustomAlert.unsuccessfulLogin(errorMsg)
            }
        })
    }
   
   
    //MARK: Texfield Delegate method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }

}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
