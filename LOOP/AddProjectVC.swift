//
//  AddProjectVC.swift
//  LOOP
//
//  Created by Aman Chawla on 05/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class AddProjectVC: UIViewController, UITableViewDataSource {
	
	var selectedMember = [String: String]()
	var selected = [String]()

	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if selectedMember.isEmpty == false {
			for key in selectedMember {
				selected.append(key as String)
			}
		}
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ParticipantsCell") as! ParticipantsCell 
		
			return cell
	}

}
