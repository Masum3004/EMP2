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
    
    var snackbar: MJSnackBar!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageWithGradient()
        
        snackbar = MJSnackBar(onView: self.view)
        
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
        
        if (txtUsername.text == "" || txtPassword.text == ""  ) {
            
            let data = MJSnackBarData(message: "Please enter all details")
            
            snackbar.show(data: data, onView: self.view)
        }
        else {
        
          let isExist = getParentId(username: txtUsername.text!, password: txtPassword.text!)
            
            if isExist {
           
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "EMPLOYEE_LIST")
                navigationController?.pushViewController(viewController, animated: true)

            }
            else {
                let data = MJSnackBarData(message: "Username/Password is wrong")
                
                snackbar.show(data: data, onView: self.view)
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func getParentId(username : String, password : String) ->Bool {
        
        var isExist = false
        
        let sharedInstance = ModelManager.getInstance()
       
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Parent where username ='\(username)' AND password = '\(password)'", withArgumentsIn: nil)
        print("-----\(resultSet)")
        let parentArr : NSMutableArray = NSMutableArray()
       

        if (resultSet != nil) {
            
            while resultSet.next() {
                

            let parentDict : NSMutableDictionary = NSMutableDictionary()
                
                parentDict.setValue(resultSet.string(forColumn: "emp_id"), forKey: "emp_id")
                parentDict.setValue(resultSet.string(forColumn: "username")
                    , forKey: "username")
                parentDict.setValue(resultSet.string(forColumn: "name")
                    , forKey: "name")
                parentDict.setValue(resultSet.string(forColumn: "mobile_no")
                    , forKey: "mobile_no")
                parentDict.setValue(resultSet.string(forColumn: "password")
                    , forKey: "password")

                parentArr.add(parentDict)
            }
            
            print("------>>\(parentArr)")
            if (parentArr.count > 0) {
               
                isExist = true
                
                var dict = NSDictionary()
                
                dict = parentArr.object(at: 0) as! NSDictionary
                
                let emp_id = dict.value(forKey: "emp_id")
                
                
                let emp_name = dict.value(forKey: "username")

                print(emp_id as Any)
                
                UserDefaults.standard.set(emp_id, forKey: "parentId")
                UserDefaults.standard.set(emp_name, forKey: "parentName")
                UserDefaults.standard.synchronize()
            }
            
        }
        else {
            let data = MJSnackBarData(message: "Please check record")
            
            snackbar.show(data: data, onView: self.view)
            isExist =  false
        }
        sharedInstance.database!.close()
        
        return isExist
    }
}
