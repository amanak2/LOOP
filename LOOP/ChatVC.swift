//
//  ChatVC.swift
//  LOOP
//
//  Created by Aman Chawla on 02/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, YourCellDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	var notificationModel: NotificationModel!
	var notifications = [NotificationModel]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		downloadNotificationData()
    }
	
	func downloadNotificationData() {
		if UserDefaults.standard.bool(forKey: "ifLoggedIn") == true {
			Alamofire.request("\(baseURL)notification.php?my_email=\(myEmail)", method: .get).responseJSON { response in
				
				if let dict = response.result.value as? [[String:Any]] {
					for obj in dict {
						let notification = NotificationModel(getData: obj)
						if notification.type == "OpenProject" || notification.type == "accept" {
							self.notifications.append(notification)
						}
					}
					self.tableView.reloadData()
				}
			}
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notifications.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell {
			
			let data = self.notifications[indexPath.row]
			cell.updateUI(update: data)
			
			return cell
		} else {
			return ChatCell()
		}
	}
	
	func didPressButton(_ tag: Int) {
		let notification = self.notifications[tag]
		
		let parameters: Parameters = [
			"email": notification.from_email as String
		]
		
		Alamofire.request("\(baseURL)frndsSystem.php?action=accept&my_email=\(myEmail)", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let status = dict["status"] as? String
				
				if status == "200" {
					self.notifications.removeAll()
					self.downloadNotificationData()
				}
			}
		}
		
	}
}

