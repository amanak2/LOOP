//
//  MeetingsVC.swift
//  LOOP
//
//  Created by Aman Chawla on 02/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

protocol ButtonDelegate: class {
	func JoinBtnPressed(_ tag: Int)
}

class MeetingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ButtonDelegate {
	
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
	var type: String!
	var users = [NotificationUsers]()
	var searchBarShowing = true
	var inSearchMode = false
	
	var objDate: NSDate!
	var currentDate: NSDate!
	
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
		
//		if notifications.isEmpty {
//			tableView.isHidden = true
//		} else {
//			tableView.isHidden = false
//		}
	}
	
	//MARK - Util
	
	func convertDate() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
		
		let obj: String = "\(date) \(time)"
		let data = dateFormatter.date(from: obj)
		objDate = data! as NSDate
	}
	
	func getCurrentDate() {
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MM-yyyy hh:mm"
		let result = formatter.string(from: date)
		
		let data = formatter.date(from: result)
		currentDate = data! as NSDate
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "MeetingDescriptionVC" {
			if let destination = segue.destination as? MeetingDescriptionVC {
				destination.meetingTit = self.meetingTit
				destination.date = self.date
				destination.time = self.time
				destination.users = self.users
				destination.adminEmail = self.adminEmail
				destination.type = self.type
			}
		}
	}
	
	//MARK - Download Notification
	
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
	
	
	//MARK - SearchBar
	
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
	
	//MARK - TableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MeetingCell", for: indexPath) as? MeetingCell
		
		if inSearchMode {
			let notificationModel = filteredNotification[indexPath.row]
			cell?.updateUI(notification: notificationModel)
			
			cell?.buttonDelegate = self
			cell?.tag = indexPath.row
		} else {
			let notificationModel = notifications[indexPath.row]
			cell?.updateUI(notification: notificationModel)
			
			cell?.buttonDelegate = self
			cell?.tag = indexPath.row
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
		
		if cell.isSelected && cell.type == "OpenMeeting" {
			meetingTit = cell.meetingTit
			time = cell.time
			date = cell.date
			users = cell.users
			adminEmail = cell.adminEmail
			type = cell.type
			
			performSegue(withIdentifier: "MeetingDescriptionVC", sender: self)
		}
	}
	
	//Join Meeting
	func JoinBtnPressed(_ tag: Int) {
		
		if objDate.isLessThanDate(dateToCompare: currentDate) {
			let alert = UIAlertController(title: "Join Meeting", message: "Its not time yet, you cant join a meeting before it starts", preferredStyle: .alert)
			
			let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in }
			
			alert.addAction(okBtn)
			self.present(alert, animated: true, completion: nil)
			
		} else {
			let notification = self.notifications[tag]
			
			let parameters: Parameters = [
				"g_id" : notification.g_id,
				"email" : "\(myEmail)",
				"type" : notification.type
			]
			
			Alamofire.request("\(baseURL)chat_notification_accept.php", method: .post, parameters: parameters).responseJSON { response in
				
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
}

extension NSDate {
	
	func isLessThanDate(dateToCompare: NSDate) -> Bool {
		//Declare Variables
		var isLess = false
		
		//Compare Values
		if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
			isLess = true
		}
		
		//Return Result
		return isLess
	}
	
	func addDays(daysToAdd: Int) -> NSDate {
		let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
		let dateWithDaysAdded: NSDate = self.addingTimeInterval(secondsInDays)
		
		//Return Result
		return dateWithDaysAdded
	}
	
	func addHours(hoursToAdd: Int) -> NSDate {
		let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
		let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)
		
		//Return Result
		return dateWithHoursAdded
	}
}
