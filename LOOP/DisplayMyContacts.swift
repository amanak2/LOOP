//
//  DisplayMyContacts.swift
//  LOOP
//
//  Created by Aman Chawla on 05/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class DisplayMyContacts: UIViewController, UITableViewDelegate, UITableViewDataSource  {

	@IBOutlet weak var tableView: UITableView!
	
	var myContactsModel: MyContactsModel!
	var myContacts = [MyContactsModel]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		downloadMyContactsData()
    }

	@IBAction func backBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	func downloadMyContactsData() {
		Alamofire.request("\(baseURL)frnd_req.php?my_email=rishabh9393@gmail.com", method: .get).responseJSON { response in
			
			if let dict = response.result.value as? [[String:Any]] {
				for obj in dict {
					let myContact = MyContactsModel(getData: obj)
					self.myContacts.append(myContact)
				}
			}
			self.tableView.reloadData()
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myContacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "MyContactsCell", for: indexPath) as? MyContactsCell {
			
			let myContact = self.myContacts[indexPath.row]
			cell.updateUI(myContact: myContact)
			
			return cell
		} else {
			return MyContactsCell()
		}
		
	}
	
}
