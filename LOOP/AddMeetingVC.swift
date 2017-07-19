//
//  AddMeetingVC.swift
//  LOOP
//
//  Created by Aman Chawla on 09/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class AddMeetingVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, PassSelectedMembers, PassingSelectedTeamMembers, PassMyContacts {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBOutlet weak var addParticipantsBtn: UIButton!
	@IBOutlet weak var selectedTimeLbl: UILabel!
	@IBOutlet weak var dataPickerView: UIDatePicker!
	@IBOutlet weak var setDataBtn: UIButton!
	@IBOutlet weak var topicTextField: UITextField!
	@IBOutlet weak var agendaTextField: UITextField!
	
	var members = [String : String]()
	var myContactsModel: MyContactsModel!
	var contacts = [MyContactsModel]()
	
	var currentDate: String!
	var currentTime: String!
	var setDate: String!
	var setTime: String!
	
	var selectedMembers = [String: String]()
	var smembers = [String]()
	var selected = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMeetingVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		getCurrentDate()
		getCurrentTime()
    }
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		
		if contacts.isEmpty {
			addParticipantsBtn.isHidden = false
		} else {
			addParticipantsBtn.isHidden = true
		}
		
		
		
		collectionView.reloadData()
		dataPickerView.isHidden = true
	}
	
	func getSmembers() {
		if selectedMembers.isEmpty == false {
			for (key, value) in selectedMembers {
				//selected = ["email":key, "category":value]
				selected = String(format: "{\"category\":\"%@\",\"email\":\"%@\"}", arguments: [key,value])
				smembers.append(selected)
			}
		}
	}
	
	func getCurrentTime() {
		let date = Date()
		let calendar = Calendar.current
		let hour = calendar.component(.hour, from: date)
		let minutes = calendar.component(.minute, from: date)
		currentTime = "\(hour):\(minutes)"
	}
	
	func getCurrentDate() {
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-mm-yyyy"
		let result = formatter.string(from: date)
		currentDate = result
	}
	
	@IBAction func setDateBtnPressed(_ sender: Any) {
		if dataPickerView.isHidden {
			dataPickerView.isHidden = false
		} else {
			dataPickerView.isHidden = true
		}
		
	}
	
	@IBAction func setDateAction(_ sender: UIDatePicker) {
		pickDate()
	}
	
	func pickDate() {
		let cal = Calendar.current
		let day = cal.component(.day, from: dataPickerView.date)
		let month = cal.component(.month, from: dataPickerView.date)
		let year = cal.component(.year, from: dataPickerView.date)
		let hour = cal.component(.hour, from: dataPickerView.date)
		let min = cal.component(.minute, from: dataPickerView.date)
		setDate = "\(day)-\(month)-\(year)"
		setTime = "\(hour):\(min)"
		selectedTimeLbl.text = "\(day)-\(month)-\(year), \(hour):\(min)" 
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? ChooseMembersFromMyContactsVC {
			destination.delegate = self
			destination.del = self
		}
		
		if let destination2 = segue.destination as? SelectTeamVC {
			destination2.delegate = self
		}
	}
	
	func passingMembers(members: [String: String]) {
		self.selectedMembers = members
		getSmembers()
	}
	
	func passingTeamMembers(members: [String: String]) {
		self.selectedMembers = members
		getSmembers()
	}
	
	func passingContacts(selects: [MyContactsModel]) {
		self.contacts = selects
	}
	
	@IBAction func AddMeetingBtnPressed(_ sender: Any) {
		let alert = UIAlertController(title: "Add Members", message: "Where would you like to select Members From", preferredStyle: .alert)
		
		
		let myContactsBtn = UIAlertAction(title: "My Contacts", style: UIAlertActionStyle.default) {
			UIAlertAction in
			self.performSegue(withIdentifier: "ChooseMembersFromMyContactsVC", sender: self)
		}
		
		let myTeamsBtn = UIAlertAction(title: "My Team", style: UIAlertActionStyle.default) {
			UIAlertAction in
			self.performSegue(withIdentifier: "SelectTeamVC", sender: self)
		}
		
		alert.addAction(myContactsBtn)
		alert.addAction(myTeamsBtn)
		
		self.present(alert, animated: true, completion: nil)
	}
	
	@IBAction func doneBtnPressed(_ sender: Any) {
		
		let parameters: Parameters = [
			"topic":topicTextField.text!,
			"setdate":currentDate as String,
			"scheduledate":setDate as String,
			"settime":currentTime as String,
			"scheduletime":setTime as String,
			"agenda":agendaTextField.text!,
			"adminname":"\(firstname)",
			"type":"meeting",
			"users" : "[\(smembers.joined(separator: ","))]",
			"adminemail":"\(myEmail)"
		]
		
		Alamofire.request("\(baseURL)meeting_shedule.php",method: .post, parameters: parameters,encoding: JSONEncoding.default).responseJSON { response in
			
//			if let dict = response.result.value as? Dictionary<String, AnyObject> {
//				let topic = dict["topic"] as? String
//				let g_id = dict["g_id"] as? String
//				
//				self.storeMeeting(topic: topic!, g_id: g_id!)
//				
//			}
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	
	func storeMeeting (topic: String, g_id: String) {
		let context = self.getContext()
		
		//retrieve the entity that we just created
		let entity =  NSEntityDescription.entity(forEntityName: "Meeting", in: context)
		
		let transc = NSManagedObject(entity: entity!, insertInto: context)
		
		//set the entity values
		transc.setValue(topic, forKey: "topic")
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
	
	@IBAction func backBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return contacts.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MparticipantsCell", for: indexPath) as? MparticipantsCell {
			
			let contacts = self.contacts[indexPath.row]
			cell.updateUI(contact: contacts)
			
			return cell
		} else {
			return MparticipantsCell()
		}
	}
}
