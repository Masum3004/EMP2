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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bottomConstraints.constant = 15.0

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSaveMember(_ sender: Any) {
          _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
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
