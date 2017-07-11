//
//  MyContactsInfoVC.swift
//  LOOP
//
//  Created by Aman Chawla on 11/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class MyContactsInfoVC: UIViewController {

	@IBOutlet weak var timeZoneLbl: UILabel!
	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var userNameLbl: UILabel!
	@IBOutlet weak var UserEmailLbl: UILabel!
	@IBOutlet weak var mobileLbl: UILabel!
	@IBOutlet weak var officeLbl: UILabel!
	@IBOutlet weak var designationLbl: UILabel!
	
	var email: String!
	
	var myContactsModel: MyContactsModel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		downloadMyContactsData()
		
		userImg.layer.cornerRadius = userImg.frame.size.width / 2
		userImg.clipsToBounds = true
	}
	
	func downloadMyContactsData() {
		Alamofire.request("\(baseURL)frnd_req.php?my_email=rishabh9393@gmail.com", method: .get).responseJSON { response in
			
			if let dict = response.result.value as? [[String:Any]] {
				for obj in dict {
					let myContact = MyContactsModel(getData: obj)
					if myContact.email == self.email {
						self.userNameLbl.text = myContact.user
						self.UserEmailLbl.text = myContact.email
						self.mobileLbl.text = myContact.phone
						self.officeLbl.text = myContact.num
						self.designationLbl.text = myContact.designation
						self.userImg.sd_setImage(with: URL(string: myContact.profile as String), placeholderImage: UIImage(named: "Mr.Nobody"))
					}
				}
			}
		}
	}

	@IBAction func backBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	
}
