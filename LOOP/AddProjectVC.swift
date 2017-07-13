//
//  AddProjectVC.swift
//  LOOP
//
//  Created by Aman Chawla on 05/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class AddProjectVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PassSelectedMembers, PassMyContacts {
	
	var selectedMembers = [String: String]()
	var smembers = [String]()
	var selected = ""
	
	var myContactsModel: MyContactsModel!
	var members = [MyContactsModel]()
	
	@IBOutlet weak var addParticipantsBtn: UIButton!
	@IBOutlet weak var participantsCountLbl: UILabel!
	@IBOutlet weak var projectImg: UIImageView!
	@IBOutlet weak var projectNameTextField: UITextField!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var projectDescriptionTextView: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddProjectVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
		collectionView.delegate = self
		collectionView.dataSource = self
    }
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		updatePage()
		collectionView.reloadData()
	}
	
	func updatePage() {
		
		if selectedMembers.isEmpty == false {
			addParticipantsBtn.isHidden = true
		}
		
		participantsCountLbl.text = "(\(selectedMembers.count))"
	}
	
	func getSmembers() {
		if selectedMembers.isEmpty == false {
			for (key, value) in selectedMembers {
				//selected = ["useremail": key, "catagory": value]
				selected = String(format: "{\"category\":\"%@\",\"email\":\"%@\"}", arguments: [key,value])
				smembers.append(selected)
			}
		}
	}
	
	func passingMembers(members: [String: String]) {
		self.selectedMembers = members
		getSmembers()
	}
	
	func passingContacts(selects: [MyContactsModel]) {
		self.members = selects
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? AddParticipantsVC {
			destination.delegate = self
			destination.del = self
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return members.count
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantsCell", for: indexPath) as? ParticipantsCell {
			
			let members = self.members[indexPath.row]
			cell.updateUI(member: members)
			
			return cell
		} else {
			return ParticipantsCell()
		}
	}
	
	@IBAction func backBtnPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func createProjectBtnPressed(_ sender: Any) {
		let parameters: Parameters = [
			"Project" : projectNameTextField.text!,
			"adminemail" : "\(firstname)",
			"type" : "group",
			"users" : "[\(smembers.joined(separator: ","))]",
			"adminemail" : "\(myEmail)",
			"description": projectDescriptionTextView.text!,
			"ext" : "",
			"g_profile" : ""
		]
		print(parameters)
		
		Alamofire.request("\(baseURL)user_group.php", method: .post, parameters: parameters).responseJSON { response in
//			if let dict = response.result.value as? Dictionary<String, AnyObject> {
//				let topic = dict["project"] as? String
//				let g_id = dict["g_id"] as? String
//				let description = dict["description"] as? String
//				
//				self.saveData(topic: topic!, g_id: g_id!, desription: description!)
//			}
			
		}
	}
	
	@IBAction func addParticipantsBtnPressed(_ sender: Any) {
		performSegue(withIdentifier: "AddParticipantsVC", sender: self)
	}
	
	//CoreData Saving Functions
	func saveData(topic: String, g_id: String, desription: String) {
		let context = self.getContext()
		
		//retrieve the entity that we just created
		let entity =  NSEntityDescription.entity(forEntityName: "Project", in: context)
		
		let transc = NSManagedObject(entity: entity!, insertInto: context)
		
		//set the entity values
		transc.setValue(topic, forKey: "project")
		transc.setValue(topic, forKey: "description")
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
	
	@IBAction func uploadImagePressed(_ sender: Any) {
		//Add Picture for project
		
	}
}
