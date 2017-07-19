//
//  MeetingsVC.swift
//  LOOP
//
//  Created by Aman Chawla on 02/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class MeetingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var searchBarWidth: NSLayoutConstraint!
	
	var notificationModel: NotificationModel?
	var notifications = [NotificationModel]()
	var filteredNotification = [NotificationModel]()
	
	var meetingTit: String!
	var time: String!
	var date: String!
	var adminEmail: String!
	var users = [NotificationUsers]()
	var searchBarShowing = true
	var inSearchMode = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MeetingsVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.notifications.removeAll()
		self.downloadNotificationData()
		self.tableView.reloadData()
		
		if notifications.isEmpty {
			tableView.isHidden = true
		} else {
			tableView.isHidden = false
		}
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		view.endEditing(true)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		if searchBar.text == nil || searchBar.text == "" {
			
			inSearchMode = false
			tableView.reloadData()
			view.endEditing(true)
		} else {
			
			inSearchMode = true
			
			let lower = searchBar.text?.lowercased()
			//let upper = searchBar.text?.uppercased()
			
			filteredNotification = notifications.filter({$0.topic.range(of: lower!) != nil})
			tableView.reloadData()
		}
	}
	
	@IBAction func searchBarBtnPressed(_ sender: Any) {
		if searchBarShowing {
			searchBarWidth.constant = 310
			UISearchBar.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
		} else {
			searchBarWidth.constant = -310
			UISearchBar.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
		}
		
		searchBarShowing = !searchBarShowing
		
	}
	
	
	func downloadNotificationData() {
		Alamofire.request("\(baseURL)notification.php?my_email=\(myEmail)", method: .get).responseJSON { response in
			
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
		
		if inSearchMode {
			let notificationModel = filteredNotification[indexPath.row]
			cell?.updateUI(notification: notificationModel)
		} else {
			let notificationModel = notifications[indexPath.row]
			cell?.updateUI(notification: notificationModel)
		}
			return cell!
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if inSearchMode {
			return filteredNotification.count
		}
		
		return notifications.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! MeetingCell
		
		if cell.isSelected {
			meetingTit = cell.meetingTit
			time = cell.time
			date = cell.date
			users = cell.users
			adminEmail = cell.adminEmail
			
			performSegue(withIdentifier: "MeetingDescriptionVC", sender: self)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "MeetingDescriptionVC" {
			if let destination = segue.destination as? MeetingDescriptionVC {
				destination.meetingTit = self.meetingTit
				destination.date = self.date
				destination.time = self.time
				destination.users = self.users
				destination.adminEmail = self.adminEmail
			}
		}
	}

}
