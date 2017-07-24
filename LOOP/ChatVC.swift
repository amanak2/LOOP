//
//  ChatVC.swift
//  LOOP
//
//  Created by Aman Chawla on 02/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, YourCellDelegate, UISearchBarDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	var notificationModel: NotificationModel!
	var notifications = [NotificationModel]()
	var filteredNotification = [NotificationModel]()
	var searchBarShowing = true
	var inSearchMode = false
	
	@IBOutlet weak var searchBarWidth: NSLayoutConstraint!
	
	var projectType: String!
	var projectTitle: String!
	var projectGid: String!
	var projectUsers = [NotificationUsers]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
		searchBar.returnKeyType = UIReturnKeyType.done
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		self.notifications.removeAll()
		self.downloadNotificationData()
		self.tableView.reloadData()
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
			
			filteredNotification = notifications.filter({$0.project.range(of: lower!) != nil})
			tableView.reloadData()
		}
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
		if inSearchMode {
			return filteredNotification.count
		}
		
		return notifications.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell {
			
			if inSearchMode {
				let data = self.filteredNotification[indexPath.row]
				cell.updateUI(update: data)
			} else {
				let data = self.notifications[indexPath.row]
				cell.updateUI(update: data)
			}
			
			return cell
		} else {
			return ChatCell()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? ChatCell {
			if cell.isSelected && cell.projectType == "OpenProject" {
				projectTitle = cell.projectTitle
				projectType = cell.projectType
				projectUsers = cell.projectUsers
				projectGid = cell.projectGid
				performSegue(withIdentifier: "ChatViewVC", sender: self)
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ChatViewVC" {
			let destination = segue.destination as! ChatViewVC
			destination.projectTitle = self.projectTitle
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
	
	@IBAction func searchBtnPressed(_ sender: Any) {
		if searchBarShowing {
			searchBarWidth.constant = 310
			UISearchBar.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
		} else {
			searchBarWidth.constant = -310
			UISearchBar.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
		}
		
		searchBarShowing = !searchBarShowing
	}
	
}

