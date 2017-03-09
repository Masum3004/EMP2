//
//  LoginViewController.swift
//  EMP
//
//  Created by webmyne on 06/03/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageBackgrounf: UIImageView!
    
    @IBOutlet weak var btnRegisterNow: UIButton!
    
    @IBOutlet weak var txtUsername: UITextField!
   
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       imageWithGradient()
        
        btnRegisterNow.layer.borderWidth = 0.5;
        btnRegisterNow.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func imageWithGradient(){
        
        let view = UIView(frame: imageBackgrounf.frame)
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.frame
        
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        gradient.locations = [0.0, 1.0]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        imageBackgrounf.addSubview(view)
        
        imageBackgrounf.bringSubview(toFront: view)
    }

    @IBAction func btnRegistration(_ sender: Any) {
        
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "REGISTRATION")
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
