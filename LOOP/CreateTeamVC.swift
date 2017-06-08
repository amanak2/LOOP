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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		if UserDefaults.standard.object(forKey: "Team") != nil {
			team = UserDefaults.standard.object(forKey: "Team") as! [String : [String : String]]
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
			let otherVC = AddTeamMembersVC()
			otherVC.teamName = self.teamName
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
}
