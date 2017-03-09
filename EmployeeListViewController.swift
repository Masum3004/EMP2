//
//  EmployeeListViewController.swift
//  EMP
//
//  Created by webmyne on 07/03/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

import UIKit

class EmployeeListViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet var lblNoMember : UILabel!
  
    var snackbar: MJSnackBar!

    var memberArr = NSMutableArray()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        snackbar = MJSnackBar(onView: self.view)
        
        let emp_id = UserDefaults.standard.value(forKey: "parentId") as! String
        fetchMemberDataFromDatabase(parentID: emp_id)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        let emp_id = UserDefaults.standard.value(forKey: "parentId") as! String
        fetchMemberDataFromDatabase(parentID: emp_id)
        
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    @IBAction func btnBack(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddMemeber(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EMPLOYEE_DETAIL") as! EmployeeDetailViewController
        
        viewController.isEditable = false
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return memberArr.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell") as! EmployeeTableViewCell;
        
        
        let dict = memberArr.object(at: indexPath.row) as! NSDictionary

        cell.lblDepartment.text = dict.value(forKey: "department_name") as! String?
        cell.lblMemberName.text = dict.value(forKey: "name") as! String?
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94;
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //1
        
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
       
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "EMPLOYEE_DETAIL") as! EmployeeDetailViewController
            
            viewController.isEditable = true
            viewController.memberDict = self.memberArr.object(at: indexPath.row) as! NSDictionary
            self.navigationController?.pushViewController(viewController, animated: true)
        })
        editAction.backgroundColor = UIColor.brown
        
                // 5
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
           
        })
        deleteAction.backgroundColor = UIColor.red
       
        
        // 7
        return [deleteAction, editAction]
    }


    //MARK: UITextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func fetchMemberDataFromDatabase(parentID : String) {
        
        let sharedInstance = ModelManager.getInstance()
        
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Member where parent_id ='\(parentID)'", withArgumentsIn: nil)
        
         memberArr = NSMutableArray()
        
        
        if (resultSet != nil) {
            
            while resultSet.next() {
                
                
                
                let memberDict : NSMutableDictionary = NSMutableDictionary()
                
                memberDict.setValue(resultSet.string(forColumn: "member_id"), forKey: "member_id")
                memberDict.setValue(resultSet.string(forColumn: "name"), forKey: "name")
                memberDict.setValue(resultSet.string(forColumn: "mobile_no"), forKey: "mobile_no")
                memberDict.setValue(resultSet.string(forColumn: "department_name"), forKey: "department_name")
                
                
                memberArr.add(memberDict)
            }
            
            print("------>>\(memberArr)")
            if (memberArr.count > 0) {
                
                tableView.reloadData()
                
                lblNoMember.isHidden = true
                 tableView.isHidden = false
            }
            else {
                let data = MJSnackBarData(message: "No members are added")
                
                snackbar.show(data: data, onView: self.view)
                 lblNoMember.isHidden = false
                 tableView.isHidden = true
            }
            
        }
        else {
            
            let data = MJSnackBarData(message: "Please check record")
            
            snackbar.show(data: data, onView: self.view)
            
        }
        sharedInstance.database!.close()
        
    }

    
}
