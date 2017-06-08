//
//  AddTeamMembersVC.swift
//  LOOP
//
//  Created by Aman Chawla on 07/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class AddTeamMembersVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	
	var myContacts = [[String: Any]]()

	var teamMembers = [String: String]()
	
	var prevTeam = [String: [String: String]]()
	
	var teamName: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		dowloadMyContacts()
    }
	
	func dowloadMyContacts() {
		Alamofire.request("\(baseURL)frnd_req.php?my_email=rishabh9393@gmail.com", method: .get).responseJSON { response in
			
			if let dict = response.result.value as? [[String:Any]]{
				self.myContacts=dict
				self.tableView.reloadData()
			}
		}
	}

	@IBAction func backBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func doneBtn(_ sender: Any) {
		if (UserDefaults.standard.object(forKey: "Team") != nil) {
			prevTeam = UserDefaults.standard.object(forKey: "Team") as! [String : [String : String]]
			prevTeam.updateValue(teamMembers, forKey: teamName)
			UserDefaults.standard.set(prevTeam, forKey: "Team")
		} else {
			prevTeam.updateValue(teamMembers, forKey: teamName)
			UserDefaults.standard.set(prevTeam, forKey: "Team")
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myContacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AddMembersCell", for: indexPath) as? AddMembersCell
		let myContacts = self.myContacts[indexPath.row]
		cell?.updateUI(Contacts: myContacts)
		return cell!
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let cell = tableView.cellForRow(at: indexPath) {
			
			if cell.accessoryType == .checkmark {
				cell.accessoryType = .none
				teamMembers.removeValue(forKey: (cell.textLabel?.text)!)
			} else {
				cell.accessoryType = .checkmark
				if teamMembers.isEmpty {
					teamMembers = [(cell.textLabel?.text)!: (cell.detailTextLabel?.text)!]
				} else {
					teamMembers.updateValue((cell.detailTextLabel?.text)!, forKey: (cell.detailTextLabel?.text)!)
				}
			}
		}
	}
}
