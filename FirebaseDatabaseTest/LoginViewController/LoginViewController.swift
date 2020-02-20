//
//  LoginViewController.swift
//  FirebaseDatabaseTest
//
//  Created by Valeriy Kovalevskiy on 2/20/20.
//  Copyright © 2020 v.kovalevskiy. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var ref: DatabaseReference!
    // MARK: - IBOutlets
    
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        warnLabel.alpha = 0
        addObservers()
        
        Auth.auth().addStateDidChangeListener({ [weak self] (auth, user) in
            if user != nil {
                let storyboard = UIStoryboard(name: "TaskViewController", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
                self?.navigationController!.pushViewController(vc, animated: true)
                return
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: - Private Methods
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func displayWarningLabel(with text: String) {
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
            }) { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
    }
    
    //MARK: - Objc Methods
    
    @objc func keyboardDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + keyboardSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
    
    @objc func keyboardDidHide(){
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    // MARK: - IBActions
    
    @IBAction func didTappedLoginButton(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { displayWarningLabel(with: "error")
            return
        }
        
        guard email != "", password != "" else {
            displayWarningLabel(with: "error")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(with: "error firebase")
                return
            }
            if user != nil {
//                let storyboard = UIStoryboard(name: "TaskViewController", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
//                self?.navigationController!.pushViewController(vc, animated: true)
//                return
                print("logged in")
            }
            
            self?.displayWarningLabel(with: "no user")
        })
    }
    
    @IBAction func didTappedRegisterButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { displayWarningLabel(with: "error")
            return
        }
        
        guard email != "", password != "" else {
            displayWarningLabel(with: "error")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in

            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                return
            }
            
            let userRef = self?.ref.child((user?.user.uid)!) //сложна
            userRef?.setValue(["email": user?.user.email]) //разобраться завтра
        })
    }
    
    
}

