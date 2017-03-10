//
//  EmployeeTableViewCell.swift
//  EMP
//
//  Created by webmyne on 07/03/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDepartment: UILabel!
    @IBOutlet weak var lblMemberName: UILabel!
    
    @IBOutlet var lblMobileNo: UILabel!
    
    @IBOutlet var btnCall: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
