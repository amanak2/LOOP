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
	var team: String!
	
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
		if (UserDefaults.standard.object(forKey: "Team") == nil) {
			prevTeam.updateValue(teamMembers, forKey: team)
			save(prevTeam: prevTeam, forKey: "Data")
			dismiss(animated: true, completion: nil)
		} else {
			let savedDictionary = retrieveDictionary(withKey: "Data")
			prevTeam = savedDictionary!
			prevTeam.updateValue(teamMembers, forKey: team)
			save(prevTeam: prevTeam, forKey: "Data")
			dismiss(animated: true, completion: nil)
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
		
		let cell = tableView.cellForRow(at: indexPath) as! AddMembersCell
		
		if cell.isSelected {
			teamMembers.updateValue(cell.personNameLbl.text!, forKey: cell.personEmailLbl.text!)
		}
		
	}
	
	func save(prevTeam: [String: [String: String]], forKey key: String) {
		let archiver = NSKeyedArchiver.archivedData(withRootObject: prevTeam)
		UserDefaults.standard.set(archiver, forKey: "Team")
	}
	
	func retrieveDictionary(withKey key: String) -> [String: [String: String]]? {
		
		// Check if data exists
		guard let data = UserDefaults.standard.object(forKey: "Team") else {
			return nil
		}
		
		// Check if retrieved data has correct type
		guard let retrievedData = data as? Data else {
			return nil
		}
		
		// Unarchive data
		let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: retrievedData)
		return unarchivedObject as? [String: [String: String]]
	}
}
