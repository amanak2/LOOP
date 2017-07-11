//
//  ChooseTeamMemeberVC.swift
//  LOOP
//
//  Created by Aman Chawla on 14/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ChooseTeamMemberVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	
	var teamMembers = [String: String]()
	var projectName: String!
	var delegate: PassSelectedMembers?
	
	struct objects {
		var userEmail: String!
		var userName: String!
	}
	
	var objArray = [objects]()
	var selectedMembers = [String: String]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self

		for (key, value) in teamMembers {
			objArray.append(objects(userEmail: key, userName: value))
		}
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return teamMembers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseTeamMemberCell", for: indexPath) as? ChooseTeamMemberCell
		let objArray = self.objArray[indexPath.row]
		cell?.updateUI(objArray: objArray)
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! ChooseTeamMemberCell
		
		if cell.isSelected {
			let cat = cell.catagoryLbl.text
			let email = cell.personEmailLbl.text
			selectedMembers.updateValue(cat!, forKey: email!)
		}
		
		selectedMembers.updateValue(cell.catagoryLbl.text!, forKey: cell.personEmailLbl.text!)
		
	}
	
	@IBAction func doneBtnPressed(_ sender: Any) {
		dismiss(animated: true) {
			self.delegate?.passingMembers(members: self.selectedMembers)
		}
	}
	
	@IBAction func backBtnPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	

}
