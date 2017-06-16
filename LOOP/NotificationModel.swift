//
//  MeetingModel.swift
//  LOOP
//
//  Created by Aman Chawla on 13/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import Foundation

class NotificationModel {
	
	private var _g_id: String!
	private var _topic: String!
	private var _message: String!
	private var _type: String!
	private var _adminEmail: String!
	private var _adminName: String!
	private var _date: String!
	private var _time: String!
	private var _users = [String: String]()
	
	var user: Dictionary<String, String> {
		if _users.isEmpty {
			print(Error.self)
		}
		return _users
	}
	
	var g_id: String {
		if _g_id == nil {
			_g_id = "Err"
		}
		return _g_id
	}
	
	var topic: String {
		if _topic == nil {
			_topic = "Err"
		}
		return _topic
	}
	
	var message: String {
		if _message == nil {
			_message = "Err"
		}
		return _message
	}
	
	var type: String {
		if _type == nil {
			_type = "Err"
		}
		return _type
	}
	
	var adminEmail: String {
		if _adminEmail == nil {
			_adminEmail = "Err"
		}
		return _adminEmail
	}
	
	var adminName: String {
		if _adminName == nil {
			_adminName = "Err"
		}
		return _adminName
	}
	
	var date: String {
		if _date == nil {
			_date = "Err"
		}
		return _date
	}
	
	var time: String {
		if _time == nil {
			_time = "Err"
		}
		return _time
	}
	
	init(getData: [String: Any]) {
		
		if let id = getData["g_id"] as? String {
			self._g_id = id
		}
		
		if let topic = getData["topic"] as? String {
			self._topic = topic
		}
		
		if let msg = getData["message"] as? String {
			self._message = msg
		}
		
		if let type = getData["type"] as? String {
			self._type = type
		}
		
		if let email = getData["adminemail"] as? String {
			self._adminEmail = email
		}
		
		if let name = getData["adminname"] as? String {
			self._adminName = name
		}
		
		if let scheduledate = getData["scheduledate"] as? String {
			self._date = scheduledate
		}
		
		if let scheduletime = getData["scheduletime"] as? String {
			self._time = scheduletime
		}
		
		if let user = getData["users"] as? [Dictionary<String, AnyObject>] {
		
			let userEmail = user[0]["email"] as? String
			let userCat = user[0]["category"] as? String
		
			self._users.updateValue(userCat!, forKey: userEmail!)
		}

	}
}
			
