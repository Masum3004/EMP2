//
//  EmployeeDetailViewController.swift
//  EMP
//
//  Created by webmyne on 07/03/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

import UIKit

class EmployeeDetailViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtDepartment: UITextField!
    
    @IBOutlet weak var txtMobileno: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    @IBOutlet var btnUpdateMember: UIButton!
    

    
    var snackbar: MJSnackBar!

    var isEditable : Bool!
    
    var memberDict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomConstraints.constant = 15.0
        
        snackbar = MJSnackBar(onView: self.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    
        
        if isEditable == true {
            
            txtMobileno.text = memberDict.value(forKey: "mobile_no") as! String?
            txtDepartment.text = memberDict.value(forKey: "department_name") as! String?
            txtName.text = memberDict.value(forKey: "name") as! String?
            
            btnUpdateMember.setTitle("UPDATE MEMBER", for: UIControlState.normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSaveMember(_ sender: Any) {
      
        
        if isEditable == true {
           
            if (txtDepartment.text == "" || txtName.text == "" || txtMobileno.text == "" ) {
                
                let data = MJSnackBarData(message: "Please enter all details")
                
                snackbar.show(data: data, onView: self.view)
            }
            else {
                
                updateData()
            }

            
        }
        else {
            
            
            if (txtDepartment.text == "" || txtName.text == "" || txtMobileno.text == "" ) {
                
                let data = MJSnackBarData(message: "Please enter all details")
                
                snackbar.show(data: data, onView: self.view)
            }
            else {
                
                insertData()
            }

        }
        
    }
    func insertData()  {
        
        let sharedInstance = ModelManager.getInstance()
        
        
        if sharedInstance.database != nil {
            
            sharedInstance.database!.open()
            
            let parentID = UserDefaults.standard.value(forKey: "parentId") as! String
            
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Member (name, department_name, mobile_no, parent_id) VALUES (?, ?, ?, ?)", withArgumentsIn: [txtName.text!, txtDepartment.text!, txtMobileno.text!, parentID])
            sharedInstance.database!.close()
            
            if isInserted {
                
                _ = self.navigationController?.popViewController(animated: true)
            }
            else {
                
                let data = MJSnackBarData(message: "Data is not inserted. Please try again.")
                
                snackbar.show(data: data, onView: self.view)
                
            }
            
        }
        
    }
    
    func updateData()  {
      
        let sharedInstance = ModelManager.getInstance()
       
        
        sharedInstance.database!.open()
       
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Member SET Name=?, department_name=?, mobile_no=? WHERE member_id=?", withArgumentsIn: [txtName.text!, txtDepartment.text!, txtMobileno.text!, memberDict.value(forKey: "member_id")!])
        
        sharedInstance.database!.close()
        
        if isUpdated {
            
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            
            let data = MJSnackBarData(message: "Data is not Updated. Please try again.")
            
            snackbar.show(data: data, onView: self.view)
            
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
        
        if textField == txtMobileno {
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
    
    
}
