//
//  CreateTeamVC.swift
//  LOOP
//
//  Created by Aman Chawla on 06/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class CreateTeamVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	
	var teamName: String!
	var team = [String: [String: String]]()
	var names = [String]()
	var send = [String: String]()
	
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

	@IBAction func backBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func createTeambtnPressed(_ sender: Any) {
		
		let alert = UIAlertController(title: "Create Team", message: "Enter Name of New Team", preferredStyle: .alert)
		
		alert.addTextField { (textField) in
			textField.placeholder = "Enter Team Name"
			}

		
		let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
			UIAlertAction in
			let textField = alert.textFields![0]
			self.teamName = textField.text
			self.performSegue(withIdentifier: "AddTeamMembersVC", sender: self)
		}
		
		let cancelBtn = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
			UIAlertAction in
			self.dismiss(animated: true, completion: nil)
		}
		
		alert.addAction(okBtn)
		alert.addAction(cancelBtn)
		
		self.present(alert, animated: true, completion: nil)
	
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddTeamMembersVC" {
			let destination = segue.destination as! AddTeamMembersVC
			destination.team = teamName
		}
		
		if segue.identifier == "ViewTeamMembersVC" {
			let destination = segue.destination as! ViewTeamMembersVC
			destination.teamMembers = send
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return names.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
		cell.textLabel?.text = names[indexPath.row]
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
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
				performSegue(withIdentifier: "ViewTeamMembersVC", sender: self)
			}
		}
	}
	
}
