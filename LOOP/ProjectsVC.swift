//
//  ProjectsVC.swift
//  LOOP
//
//  Created by Aman Chawla on 02/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class ProjectsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MyCellDelegate{

	@IBOutlet weak var tableView: UITableView!
	
	var projectName: String!
	var selectedMembers = [String: String]()
	
	var notificationModel: NotificationModel!
	var notifications = [NotificationModel]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		downloadNotificationData()
    }
	
	func downloadNotificationData() {
		Alamofire.request("\(baseURL)notification.php?my_email=rishabh9393@gmail.com", method: .get).responseJSON { response in
			
			if let dict = response.result.value as? [[String:Any]] {
				for obj in dict {
					let notification = NotificationModel(getData: obj)
					if notification.type == "OpenProject" || notification.type == "group" {
						self.notifications.append(notification)
					}
				}
				self.tableView.reloadData()
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SelectStateVC" {
			let destination = segue.destination as! ChooseMembersFromMyContactsVC
			destination.projectName = self.projectName
			
			let destination2 = segue.destination as! ChooseTeamMemberVC
			destination2.projectName = self.projectName
		}
	}
	
	@IBAction func createProjectBtnPressed(_ sender: Any) {
		let alert = UIAlertController(title: "Create Project", message: "Enter Title of New Project", preferredStyle: .alert)
		
		alert.addTextField { (textField) in
			textField.placeholder = "Enter Project Title"
		}
		
		
		let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
			UIAlertAction in
			let textField = alert.textFields![0]
			self.projectName = textField.text
			self.performSegue(withIdentifier: "SelectStateVC", sender: self)
		}
		
		let cancelBtn = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
			UIAlertAction in
			self.dismiss(animated: true, completion: nil)
		}
		
		alert.addAction(okBtn)
		alert.addAction(cancelBtn)
		
		self.present(alert, animated: true, completion: nil)
	}
	
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectCell {
			
			let notifications = self.notifications[indexPath.row]
			cell.updateUI(notifications: notifications)
			return cell
		} else {
			return ProjectCell()
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notifications.count
	}
	
	func didJoinPressButton(_ tag: Int) {
		let notification = self.notifications[tag]
		
		let parameters: Parameters = [
			"g_id" : notification.g_id,
			"email" : "Email",
			"type" : notification.type
		]
		
		Alamofire.request("\(baseURL)/chat_notification_accept.php", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let status = dict["status"] as? String
				
				if status == "200" {
					// hide join button
				}
				
			}
		}
	}
}

protocol MyCellDelegate: class {
	func didJoinPressButton(_ tag: Int)
}
