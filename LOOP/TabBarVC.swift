//
//  TabBarVC.swift
//  LOOP
//
//  Created by Aman Chawla on 04/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		//dummyData()
		
		tabBar.barTintColor = UIColor.black
    }
	
	override func viewDidAppear(_ animated: Bool) {
		ifLoggedIn()
	}

	
	func ifLoggedIn() {
		if UserDefaults.standard.bool(forKey: "ifLoggedIn") != true {
			DispatchQueue.main.async() {
				[unowned self] in
				self.performSegue(withIdentifier: "MainVC", sender: self)
			}
		} else if UserDefaults.standard.bool(forKey: "otpSent") == true {
			DispatchQueue.main.async() {
				[unowned self] in
				self.performSegue(withIdentifier: "OtpNotSubmitted", sender: self)
			}
		}
	}
	
	func dummyData() {
		UserDefaults.standard.set("", forKey: "email")
		UserDefaults.standard.set("", forKey: "firstname")
		UserDefaults.standard.set("", forKey: "lastname")
		UserDefaults.standard.set("" , forKey: "modile")
		UserDefaults.standard.set("" , forKey: "office")
		UserDefaults.standard.set("" , forKey: "designation")
		UserDefaults.standard.set("", forKey: "profile")
		UserDefaults.standard.synchronize()
	}
}
