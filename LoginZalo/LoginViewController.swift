//
//  ViewController.swift
//  LoginZalo
//
//  Created by Anh vũ on 7/3/19.
//  Copyright © 2019 anh vu. All rights reserved.
//


import UIKit
import ZaloSDK

class LoginViewController: UIViewController {
    var loadingIndicator =  UIActivityIndicatorView()
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.alignButtonIconAndTitle()
        checkIsAuthenticated()
        
    }
    
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func LogOutbutton(_ sender: Any) {
            ZaloSDK.sharedInstance().unauthenticate()
    }
    
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        login()
    }
    
    func showMainController() {
        self.performSegue(withIdentifier: "showMainController", sender: self)
    }
}

extension LoginViewController {
    func login() {
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView, parentController: self) { (response) in
            self.onAuthenticateComplete(with: response)
        }
    }
    
    func checkIsAuthenticated() {
        loadingIndicator.startAnimating()
        loginButton.isHidden = true
        
        ZaloSDK.sharedInstance().isAuthenticatedZalo { (response) in
            self.loadingIndicator.stopAnimating()
            if response?.isSucess == true {
                self.showMainController()
            } else {
                self.loginButton.isHidden = false
            }
        }
    }
    
    func onAuthenticateComplete(with response: ZOOauthResponseObject?) {
        loadingIndicator.stopAnimating()
        loginButton.isHidden = false
        
        if response?.isSucess == true {
            showMainController()
        } else if let response = response,
            response.errorCode != -1001 { // not cancel
            showAlert(with: "Error \(response.errorCode)", message: response.errorMessage)
        }
    }
}

extension UIViewController {
    func showAlert(with title: String = "ZaloSDK", message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
}

extension UIButton {
    func alignButtonIconAndTitle() {
        guard let imageView = self.imageView,
            let titleLabel = self.titleLabel else {
                return
        }
        self.contentHorizontalAlignment = .left
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

//        let space = UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets)
//
//        let width = animationRect.width - self.imageEdgeInsets.right - imageView.frame.size.width - titleLabel.frame.size.width
//        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: width/2, bottom: 0, right: 0)
    }
}
