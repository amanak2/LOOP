//
//  AddMeetingVC.swift
//  LOOP
//
//  Created by Aman Chawla on 09/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class AddMeetingVC: UIViewController {
	
	@IBOutlet weak var selectedTimeLbl: UILabel!
	@IBOutlet weak var dataPickerView: UIDatePicker!
	@IBOutlet weak var setDataBtn: UIButton!
	@IBOutlet weak var topicTextField: UITextField!
	@IBOutlet weak var agendaTextField: UITextField!
	
	var members = [String : String]()
	
	var currentDate: String!
	var currentTime: String!
	var setDate: String!
	var setTime: String!
	
	var selectedMembers = [String: String]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		dataPickerView.setValue(UIColor.white, forKey: "textColor")
		dataPickerView.isHidden = true
		
		getCurrentDate()
		getCurrentTime()
		
		printUsers()
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
	
	func printUsers() {
		for (key, value) in selectedMembers {
			let printThis =  ["email": key, "catagory": value]
			print("\(printThis)")
		}
	}
	

	@IBAction func doneBtnPressed(_ sender: Any) {
		
		let parameters: Parameters = [
			"topic" : topicTextField.text!,
			"setdate" : currentDate ,
			"scheduledate" : setDate,
			"settime" : currentTime ,
			"scheduletime" : setTime,
			"agenda" : agendaTextField.text!,
   
			"adminname" : "junaid",
			"type" : "meeting",
			"users" : [
				[
				printUsers()
				]
			],
			"adminemail" : "pmajok@gmail.com"

		]
		
		Alamofire.request("\(baseURL)/meeting_shedule.php", method: .post, parameters: parameters).responseJSON { response in
			
			
			
		}
		
	}

}
