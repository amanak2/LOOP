//
//  ProjectsVC.swift
//  LOOP
//
//  Created by Aman Chawla on 02/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

protocol MyCellDelegate: class {
	func didJoinPressButton(_ tag: Int)
	func didRejectPressButton(_ tag: Int)
}

class ProjectsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MyCellDelegate, UISearchBarDelegate{

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var searchBarWidth: NSLayoutConstraint!
	
	var projectName: String!
	var gId: String!
	var searchBarShowing = true
	var inSearchMode = false
	
	var notificationModel: NotificationModel!
	var notifications = [NotificationModel]()
	var filteredNotification = [NotificationModel]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
		searchBar.returnKeyType = UIReturnKeyType.done
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DisplayMyContacts.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		self.notifications.removeAll()
		self.downloadNotificationData()
		self.tableView.reloadData()
	}
	
	//MARK - Util 
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ProjectDescriptionVC" {
			if let destination = segue.destination as? ProjectDesciptionVC {
				destination.gId = self.gId
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
			
			filteredNotification = notifications.filter({$0.project.range(of: lower!) != nil})
			tableView.reloadData()
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
	
	
	//Download Notifications
	func downloadNotificationData() {
		Alamofire.request("\(baseURL)notification.php?my_email=\(myEmail)", method: .get).responseJSON { response in
			
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
	
	//Create New Project
	@IBAction func createProjectBtnPressed(_ sender: Any) {
		performSegue(withIdentifier: "AddProjectVC", sender: self)
	}
	
	
	//TableView Functions
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectCell {
			
			if inSearchMode {
				let notifications = self.filteredNotification[indexPath.row]
				cell.updateUI(notifications: notifications)
			} else {
				let notifications = self.notifications[indexPath.row]
				cell.updateUI(notifications: notifications)
			}
			
			cell.cellDelegate = self
			cell.tag = indexPath.row
			
			return cell
		} else {
			return ProjectCell()
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if inSearchMode {
			return filteredNotification.count
		}
		
		return notifications.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! ProjectCell
		
		if cell.isSelected && cell.type == "OpenProject" {
			self.gId = cell.gId
			performSegue(withIdentifier: "ProjectDescriptionVC", sender: self)
		}
	}
	
	//Join Project
	func didJoinPressButton(_ tag: Int) {
		let notification = self.notifications[tag]
		
		let parameters: Parameters = [
			"g_id" : notification.g_id,
			"email" : "\(myEmail)",
			"type" : notification.type
		]
		
		Alamofire.request("\(baseURL)chat_notification_accept.php", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let status = dict["status"] as? String
				let msg = dict["msg"] as? String
				
				if status == "200" {
					self.notifications.removeAll()
					self.downloadNotificationData()
				} else {
					let alert = UIAlertController(title: "Project", message: msg, preferredStyle: .alert)
					
					let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in }
					
					alert.addAction(okBtn)
					self.present(alert, animated: true, completion: nil)
				}
			}

		}
	}
	
	//Reject Project Button
	func didRejectPressButton(_ tag: Int) {
		let notification = self.notifications[tag]
		
		let parameters: Parameters = [
			"g_id" : notification.g_id,
			"email" : "\(myEmail)",
		]
		
		Alamofire.request("\(baseURL)reject_user_group", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let status = dict["status"] as? String
				let msg = dict["msg"] as? String
				
				if status == "200" {
					self.notifications.removeAll()
					self.downloadNotificationData()
				} else {
					let alert = UIAlertController(title: "Project", message: msg, preferredStyle: .alert)
					
					let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in }
					
					alert.addAction(okBtn)
					self.present(alert, animated: true, completion: nil)
				}
			}
			
		}
	}
	
	//CoreData Saving Functions
	func saveData(topic: String, g_id: String) {
		let context = self.getContext()
		
		//retrieve the entity that we just created
		let entity =  NSEntityDescription.entity(forEntityName: "Project", in: context)
		
		let transc = NSManagedObject(entity: entity!, insertInto: context)
		
		//set the entity values
		transc.setValue(topic, forKey: "project")
		transc.setValue(g_id, forKey: "g_id")
		
		//save the object
		do {
			try context.save()
			print("saved!")
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
		} catch {
			
		}
	}
	
	func getContext () -> NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}
	
	
}
