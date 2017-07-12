//
//  NotificationUsers.swift
//  LOOP
//
//  Created by Aman Chawla on 12/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import Foundation

class NotificationUsers {
	
	private var _userEmail: String!
	private var _userCategory: String!
	private var _userProfile: String!
	private var _userName: String!
	
	var userEmail: String {
		if _userEmail == nil {
			_userEmail = ""
		}
		return _userEmail
	}
	
	var userCategory: String {
		if _userCategory == nil {
			_userCategory = ""
		}
		return _userCategory
	}
	
	var userProfile: String {
		if _userProfile == nil {
			_userProfile = ""
		}
		return _userProfile
	}
	
	var userName: String {
		if _userName == nil {
			_userName = ""
		}
		return _userName
	}
	
	init(data: [String: Any]) {
		
		if let email = data["email"] as? String {
			self._userEmail = email
		}
		
		if let category = data["category"] as? String {
			self._userCategory = category
		}
		
		if let name = data["user_name"] as? String {
			self._userName = name
		}
		
		if let profile = data["u_profile"] as? String {
			self._userProfile = profile
		}
	}
}
