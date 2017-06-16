//
//  ViewTeamMembersVC.swift
//  LOOP
//
//  Created by Aman Chawla on 13/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ViewTeamMembersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	
	var teamMembers = [String: String]()
	
	struct objects {
		var userEmail: String!
		var userName: String!
	}
	
	var objArray = [objects]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		for (key, value) in teamMembers {
			objArray.append(objects(userEmail: key, userName: value))
		}

    }
	
	@IBAction func backBtnPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTeamMembersCell", for: indexPath) as? ViewTeamMembersCell
		let objArray = self.objArray[indexPath.row]
		cell?.updateUI(objArray: objArray)
		return cell!
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return teamMembers.count
	}
}
