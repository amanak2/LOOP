//
//  ChooseMembersFromTeam.swift
//  LOOP
//
//  Created by Aman Chawla on 14/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class SelectTeamVC: UIViewController, UITableViewDelegate, UITableViewDataSource, PassSelectedMembers {

	@IBOutlet weak var tableView: UITableView!
	
	var team = [String: [String: String]]()
	var names = [String]()
	var send = [String: String]()
	var delegate: PassingSelectedTeamMembers?
	
	var selectedMembers = [String: String]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		if UserDefaults.standard.object(forKey: "Team") != nil {
			let savedDictionary = retrieveDictionary(withKey: "Data")
			team = savedDictionary!
			names = Array(team.keys)
		}
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTeamCell", for: indexPath)
		cell.textLabel?.text = names[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return names.count
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		for (key, value) in team {
			if cell?.textLabel?.text == key {
				send = value
				performSegue(withIdentifier: "ChooseTeamMemberVC", sender: self)
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ChooseTeamMemberVC" {
			let destination = segue.destination as! ChooseTeamMemberVC
			destination.teamMembers = send
		}
		
		if let destination = segue.destination as? ChooseTeamMemberVC {
			destination.delegate = self
		}
	}
	
	func passingMembers(members: [String: String]) {
		self.selectedMembers = members
		dismiss(animated: false) {
			self.delegate?.passingTeamMembers(members: self.selectedMembers)
		}
	}

}
