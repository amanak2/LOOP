//
//  ChatViewVC.swift
//  LOOP
//
//  Created by Aman Chawla on 14/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ChatViewVC: UIViewController {

	@IBOutlet weak var messageTextField: UITextField!
	@IBOutlet weak var projectImg: UIImageView!
	@IBOutlet weak var projectUsersLbl: UILabel!
	@IBOutlet weak var projectTitleLbl: UILabel!
	
	var projectTitle: String!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
    }
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		projectTitleLbl.text = self.projectTitle
	}
	
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view
				.frame.origin.y == 0{
				self.view.frame.origin.y -= keyboardSize.height
			}
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y += keyboardSize.height
			}
		}
	}
	
	@IBAction func backBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func sendPhotoBtnPressed(_ sender: Any) {
		//Send Image in Chat
	}
	
	@IBAction func audioCallBtnPressed(_ sender: Any) {
		performSegue(withIdentifier: "AudioCallVC", sender: self)
	}
	
	@IBAction func videoCallBtnPressed(_ sender: Any) {
		performSegue(withIdentifier: "VideoCallVC", sender: self)
	}
	
	@IBAction func sendLocationBtnPressed(_ sender: Any) {
		//Send your location in group
	}
	
	@IBAction func textFieldTouched(_ sender: Any) {
		//start writting message
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AudioCallVC" {
			let destination = segue.destination as! AudioCallVC
			destination.projectTitle = self.projectTitle
		}
		
		if segue.identifier == "VideoCallVC" {
			let destination = segue.destination as! VideoCallVC
			destination.ProjectName = self.projectTitle
		}
	}
	
}
