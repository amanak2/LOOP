//
//  ChooseMembersVC.swift
//  LOOP
//
//  Created by Aman Chawla on 09/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class ChooseMembersFromMyContactsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	var myContactsModel: MyContactsModel!
	var myContacts = [MyContactsModel]()
	
	var selected = [MyContactsModel]()
	
	var selectedMembers = [String: String]()
	var projectName: String!
	var delegate: PassSelectedMembers?
	var del: PassMyContacts?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		downloadMyContactsData()
    }
	
	func downloadMyContactsData() {
		Alamofire.request("\(baseURL)frnd_req.php?my_email=\(myEmail)", method: .get).responseJSON { response in
			
			if let dict = response.result.value as? [[String:Any]] {
				for obj in dict {
					let myContact = MyContactsModel(getData: obj)
					self.myContacts.append(myContact)
				}
			}
			self.tableView.reloadData()
		}
	}
	
	@IBAction func doneBtnPressed(_ sender: Any) {
		dismiss(animated: true) {
			self.delegate?.passingMembers(members: self.selectedMembers)
			self.del?.passingContacts(selects: self.selected)
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myContacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseMemberCell", for: indexPath) as? ChooseMemberCell
		
		let myContacts = self.myContacts[indexPath.row]
		cell?.updateUI(Contacts: myContacts)
		
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let cell = tableView.cellForRow(at: indexPath) as! ChooseMemberCell
		
		if cell.isSelected {
			let cat = cell.catagoryLbl.text
			let email = cell.personEmailLbl.text
			selectedMembers.updateValue(cat!, forKey: email!)
			selected.append(myContacts[indexPath.row])
		}
		
	}
	
	@IBAction func backBtnPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}	
	
}
