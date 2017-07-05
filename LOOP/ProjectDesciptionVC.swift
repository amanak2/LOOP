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

	@IBOutlet weak var projectDescriptionLbl: UILabel!
	@IBOutlet weak var projectTitleLbl: UILabel!
	var gId: String!
	
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
				let project = dict["project"] as? String
				let description = dict["description"] as? String
				
				self.projectTitleLbl.text = project
				self.projectDescriptionLbl.text = description
			}
		}
	}
	
}
