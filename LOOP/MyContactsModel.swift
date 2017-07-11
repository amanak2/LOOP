//
//  MyContacts.swift
//  LOOP
//
//  Created by Aman Chawla on 05/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import Foundation

class MyContactsModel {
	private var _user: String!
	private var _email: String!
	private var _num: String!
	private var _phone: String!
	private var _designation: String!
	private var _zone: String!
	private var _profile: String!
	
	var user: String {
		if _user == nil {
			_user = ""
		}
		return _user
	}
	
	var profile: String {
		if _profile == nil {
			_profile = ""
		}
		return _profile
	}
	
	var email: String {
		if _email == nil {
			_email = ""
		}
		return _email
	}
	
	var num: String {
		if _num == nil {
			_num = ""
		}
		return _num
	}
	
	var phone: String {
		if _phone == nil {
			_phone = ""
		}
		return _phone
	}
	
	var designation: String {
		if _designation == nil {
			_designation = ""
		}
		return _designation
	}
	
	var zone: String {
		if _zone == nil {
			_zone = ""
		}
		return _zone
	}
	
	init(getData: [String: Any]) {
		
		if let user = getData["user_name"] as? String {
			self._user = user
		}
		
		if let email = getData["user_email"] as? String {
			self._email = email
		}
		
		if let num = getData["office_num"] as? String {
			self._num = num
		}
		
		if let phone = getData["phone"] as? String {
			self._phone = phone
		}
		
		if let designation = getData["designation"] as? String {
			self._designation = designation
		}
		
		if let zone = getData["timezone"] as? String {
			self._zone = zone
		}
		
		if let profile = getData["profile"] as? String {
			self._profile = profile
		}
	}
}
