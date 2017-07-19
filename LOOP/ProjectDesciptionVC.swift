//
//  ProjectDesciptionVC.swift
//  LOOP
//
//  Created by Aman Chawla on 04/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class ProjectDesciptionVC: UIViewController {

	@IBOutlet weak var deleteProjectBtn: UIButton!
	@IBOutlet weak var projectDescriptionLbl: UILabel!
	@IBOutlet weak var projectTitleLbl: UILabel!
	
	var gId: String!
	var adminEmail: String!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		getData()
    }
	
	@IBAction func backBtnPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func deleteProjectPressed(_ sender: Any) {
	}
	
	
	func getData() {
		let parameters: Parameters = [
			"g_id": gId
		]
		
		Alamofire.request("\(baseURL)group_detail.php", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				if let project = dict["project"] as? String {
					self.projectTitleLbl.text = project
				}
				
				if let description = dict["description"] as? String {
					self.projectDescriptionLbl.text = description
				}
				
				if let adminEmail = dict["adminemail"] as? String {
					self.adminEmail = adminEmail
					
					if adminEmail == myEmail {
						self.deleteProjectBtn.isHidden = true
					} else {
						self.deleteProjectBtn.isHidden = false
					}
				}
			}
		}
	}
	
}
