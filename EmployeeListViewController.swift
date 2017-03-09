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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let viewController = storyboard.instantiateViewController(withIdentifier: "EMPLOYEE_DETAIL")
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell") as! EmployeeTableViewCell;
        
       cell.lblDepartment.text = "Departmet Name"
        cell.lblMemberName.text = "Member Name"
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94;
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //1
        
        
        let moreAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "More" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
       
        })
        moreAction.backgroundColor = UIColor.brown
        
                // 5
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
           
        })
        deleteAction.backgroundColor = UIColor.red
        deleteAction.backgroundColor = UIColor(patternImage: UIImage(named: "phone-call.png")!)
        
        // 7
        return [deleteAction, moreAction]
    }


    //MARK: UITextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
}
