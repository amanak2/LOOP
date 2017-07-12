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
}

class ProjectsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MyCellDelegate{

	@IBOutlet weak var tableView: UITableView!
	
	var projectName: String!
	var gId: String!
	
	var notificationModel: NotificationModel!
	var notifications = [NotificationModel]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		downloadNotificationData()
    }
	
	//Download Notifications
	func downloadNotificationData() {
		Alamofire.request("\(baseURL)notification.php?my_email=\(myEmail!)", method: .get).responseJSON { response in
			
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
		if segue.identifier == "ProjectDescriptionVC" {
			if let destination = segue.destination as? ProjectDesciptionVC {
				destination.gId = self.gId
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
			
			let notifications = self.notifications[indexPath.row]
			cell.updateUI(notifications: notifications)
			
			cell.cellDelegate = self
			cell.tag = indexPath.row
			
			return cell
		} else {
			return ProjectCell()
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
			"email" : "\(myEmail!)",
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
