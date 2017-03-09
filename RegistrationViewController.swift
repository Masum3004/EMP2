//
//  RegistrationViewController.swift
//  EMP
//
//  Created by webmyne on 07/03/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtName: UITextField!

    @IBOutlet weak var txtMobileNo: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
     var snackbar: MJSnackBar!
    
    var isChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bottomConstraints.constant = 15.0
        
        snackbar = MJSnackBar(onView: self.view)
       
        //txtUserName.addTarget(self, action:Selector(("usernameChangedEvent:")), for: UIControlEvents.editingChanged);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @IBAction func usernameChangedEvent(sender : AnyObject) {
    
        isChecked = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func btnBack(_ sender: Any) {
        
       _ = self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func btnSignUp(_ sender: Any) {
    
        if (txtUserName.text == "" || txtName.text == "" || txtPassword.text == "" || txtMobileNo.text == "" || txtConfirmPassword.text == "" ) {
            
            let data = MJSnackBarData(message: "Please enter all details")
            
            snackbar.show(data: data, onView: self.view)
        }
        else if(txtPassword.text != txtConfirmPassword.text) {
            
            let data = MJSnackBarData(message: "Password doesn't match")
            
            snackbar.show(data: data, onView: self.view)
        }
        else {
            insertData()
        }
    }
    
    func insertData()  {
        
        let sharedInstance = ModelManager.getInstance()
        
        
        if sharedInstance.database != nil {
            
            sharedInstance.database!.open()
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Parent (username, name, mobile_no, password) VALUES (?, ?, ?, ?)", withArgumentsIn: [txtUserName.text!, txtName.text!, txtMobileNo.text!, txtPassword.text!])
            sharedInstance.database!.close()
            
            if isInserted {
                
                successfulInsertion()
            }
            else {
                
                let data = MJSnackBarData(message: "Not Inserted")
                
                snackbar.show(data: data, onView: self.view)

            }
            
        }

    }
    
    //MARK: UITextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var maxLength = 15
        
        if textField == txtMobileNo {
             maxLength = 10
        }

        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    //MARK: UIKeyboard
    
    func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    //MARK: SUCCESS MESSAGE
    
    func successfulInsertion() {
        
        let alert=UIAlertController(title: "EMP", message: "Data Inserted Successfully", preferredStyle: UIAlertControllerStyle.alert);
        //default input textField (no configuration...)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SIGNIN")
            self.navigationController?.pushViewController(viewController, animated: true)
        }));
        present(alert, animated: true, completion: nil);
    }
    
    
    @IBAction func btnCheckAvailability(_ sender: Any) {
        
        isChecked = getParentId(username: txtUserName.text!)
        
        if isChecked {
           
            let data = MJSnackBarData(message: "User name already exists")
            
            snackbar.show(data: data, onView: self.view)
        }
        else {
            let data = MJSnackBarData(message: "you can use this")
            
            snackbar.show(data: data, onView: self.view)
        }
    }
    
    func getParentId(username : String) ->Bool {
        
        var isExist = false
        
        let sharedInstance = ModelManager.getInstance()
        
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Parent where username ='\(username)'", withArgumentsIn: nil)
        
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
            
            if (parentArr.count > 0) {
                
                isExist = true
            }
        }
        else {
            isExist =  false
        }
        sharedInstance.database!.close()
        
        return isExist
    }


}
