//
//  ChatViewVC.swift
//  LOOP
//
//  Created by Aman Chawla on 14/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class ChatViewVC: UIViewController {

	@IBOutlet weak var messageTextField: UITextField!
	@IBOutlet weak var projectImg: UIImageView!
	@IBOutlet weak var projectUsersLbl: UILabel!
	@IBOutlet weak var projectTitleLbl: UILabel!
	
	var projectTitle: String!
	var projectImage: String!
	var projectUsers = [NotificationUsers]()
	var users = ""
	var email = ""
	var userNames = [String]()
	var userEmail = [String]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		projectImg.layer.cornerRadius = projectImg.frame.size.width / 2
		projectImg.clipsToBounds = true
		
		//tap anywhere to disapear keyboard with message textField
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		//tap anywhere to disapear keyboard
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
    }
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		projectTitleLbl.text = self.projectTitle
		projectImg.sd_setImage(with: URL(string: projectImage as String), placeholderImage: UIImage(named: "Mr.Nobody"))
		
		for key in projectUsers {
			users = String(format: "%@", arguments: [key.userName])
			userNames.append(users)
		}
		
		for key in projectUsers {
			email = String(format: "{\"email\":\"%@\"}", arguments: [key.userEmail])
			userEmail.append(email)
		}
		
		projectUsersLbl.text = "\(userNames.joined(separator: ","))"
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
		
		let parameters: Parameters = [
			"type" : "audio",
			"vid" : projectTitle!,
			"users" : "[\(userEmail.joined(separator: ","))]"
		]
		
		Alamofire.request("\(baseURL)audio_video.php?sender_email=\(myEmail)", method: .post, parameters: parameters,encoding: JSONEncoding.default).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let msg = dict["message"] as? String
				let status = dict["status"] as? String
				
				if status == "200" {
					self.performSegue(withIdentifier: "AudioCallVC", sender: self)
				} else {
					let alert = UIAlertController(title: "Audio Call", message: msg, preferredStyle: .alert)
					
					let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in }
					
					alert.addAction(okBtn)
					self.present(alert, animated: true, completion: nil)
				}
			}
		}
	}
	
	@IBAction func videoCallBtnPressed(_ sender: Any) {
		
		let parameters: Parameters = [
			"type" : "video",
			"vid" : projectTitle!,
			"users" : "[\(userEmail.joined(separator: ","))]"
		]
		
		Alamofire.request("\(baseURL)audio_video.php?sender_email=\(myEmail)", method: .post, parameters: parameters,encoding: JSONEncoding.default).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let msg = dict["message"] as? String
				let status = dict["status"] as? String
				
				
				if status == "200" {
					self.performSegue(withIdentifier: "VideoCallVC", sender: self)
				} else {
					let alert = UIAlertController(title: "Video Call", message: msg, preferredStyle: .alert)
					
					let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in }
					
					alert.addAction(okBtn)
					self.present(alert, animated: true, completion: nil)
				}
			}
		}
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
			destination.ProjectTitle = self.projectTitle
		}
	}
	
}
