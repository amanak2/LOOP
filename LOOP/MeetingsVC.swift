//
//  MeetingsVC.swift
//  LOOP
//
//  Created by Aman Chawla on 02/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class MeetingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	
	var notificationModel: NotificationModel?
	var notifications = [NotificationModel]()
	
	var gid: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.notifications.removeAll()
		self.downloadNotificationData()
		self.tableView.reloadData()
	}
	
	func downloadNotificationData() {
		Alamofire.request("\(baseURL)notification.php?my_email=rishabh9393@gmail.com", method: .get).responseJSON { response in
			
			if let dict = response.result.value as? [[String:Any]] {
				for obj in dict {
					let notification = NotificationModel(getData: obj)
					if notification.type == "meeting" || notification.type == "OpenMeeting" {
						self.notifications.append(notification)
					}
				}
				self.tableView.reloadData()
			}
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell", for: indexPath) as? MeetingCell
			
			let notificationModel = notifications[indexPath.row]
			cell?.updateUI(notification: notificationModel)
			return cell!
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notifications.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! MeetingCell
		
		if cell.isSelected {
			gid = cell.gid
			performSegue(withIdentifier: "MeetingDescriptionVC", sender: self)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "MeetingDescriptionVC" {
			if let destination = segue.destination as? MeetingDescriptionVC {
				destination.gid = self.gid
			}
		}
	}

}
