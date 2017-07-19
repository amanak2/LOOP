//
//  EditProfileVC.swift
//  LOOP
//
//  Created by Aman Chawla on 11/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var userImg: UIImageView!
	@IBOutlet weak var userNameLbl: UILabel!
	@IBOutlet weak var timeZoneLbl: UILabel!
	@IBOutlet weak var designationTextFeild: UITextField!
	@IBOutlet weak var officeTextFeild: UITextField!
	@IBOutlet weak var emailLbl: UILabel!
	@IBOutlet weak var mobileTextFeild: UITextField!
	
	var imagePicker = UIImagePickerController()
	var strBase64: String!
	var format: String!
	var image: UIImage!
	var gotImage = false
	
	override func viewDidLoad() {
        super.viewDidLoad()
		imagePicker.delegate = self
		userImg.layer.cornerRadius = userImg.frame.size.width / 2
		userImg.clipsToBounds = true
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		if (UserDefaults.standard.string(forKey: "mobile")?.isEmpty == false) {
			mobileTextFeild.text = mobile
		}
		
		if (UserDefaults.standard.string(forKey: "office")?.isEmpty == false) {
			officeTextFeild.text = office
		}
		
		if (UserDefaults.standard.string(forKey: "designation")?.isEmpty == false) {
			designationTextFeild.text = designation
		}
		
		emailLbl.text = myEmail
		userNameLbl.text = firstname
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	@IBAction func editImgBtnPressed(_ sender: Any) {
		//Upload Image
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .photoLibrary
		
		present(imagePicker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			userImg.contentMode = .scaleAspectFit
			userImg.image = pickedImage
			image = pickedImage
			gotImage = true
		}
		
		dismiss(animated: true, completion: nil)
	}
	
	func getString() {
		if gotImage == true {
			let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
			let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
			self.strBase64 = strBase64
			self.format = "png"
		} else {
			self.strBase64 = " "
			self.format = " "
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
		
	@IBAction func saveBtnPressed(_ sender: Any) {
		
		getString()
		let parameters: Parameters = [
			"email" : myEmail,
			"office_num": officeTextFeild.text!,
			"phone": mobileTextFeild.text!,
			"designation": designationTextFeild.text!,
			"time_zone": "",
			"upic": strBase64,
			"ext": format
		]
		
		Alamofire.request("\(baseURL)editProfile.php", method: .post, parameters: parameters).responseJSON { response in
			
			
			print(response)
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let status = dict["status"] as? String
				
				if status == "200" {
					UserDefaults.standard.removeObject(forKey: "mobile")
					UserDefaults.standard.removeObject(forKey: "office")
					UserDefaults.standard.removeObject(forKey: "designation")
					UserDefaults.standard.set(self.mobileTextFeild.text, forKey: "mobile")
					UserDefaults.standard.set(self.officeTextFeild.text, forKey: "office")
					UserDefaults.standard.set(self.designationTextFeild.text, forKey: "designation")
					UserDefaults.standard.synchronize()
					self.dismiss(animated: true, completion: nil)
				}
			}
			
		}
		
	}
	
	@IBAction func backBtnPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
}
