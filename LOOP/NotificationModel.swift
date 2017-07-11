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
	private var _description: String!
	private var _timeStamp: String!
	private var _project: String!
	private var _from_email: String!
	
	var user: Dictionary<String, String> {
		if _users.isEmpty {
			print(Error.self)
		}
		return _users
	}
	
	var g_id: String {
		if _g_id == nil {
			_g_id = ""
		}
		return _g_id
	}
	
	var topic: String {
		if _topic == nil {
			_topic = ""
		}
		return _topic
	}
	
	var message: String {
		if _message == nil {
			_message = ""
		}
		return _message
	}
	
	var type: String {
		if _type == nil {
			_type = ""
		}
		return _type
	}
	
	var adminEmail: String {
		if _adminEmail == nil {
			_adminEmail = ""
		}
		return _adminEmail
	}
	
	var adminName: String {
		if _adminName == nil {
			_adminName = ""
		}
		return _adminName
	}
	
	var date: String {
		if _date == nil {
			_date = ""
		}
		return _date
	}
	
	var time: String {
		if _time == nil {
			_time = ""
		}
		return _time
	}
	
	var description: String {
		if _description == nil {
			_description = ""
		}
		return _description
	}
	
	var timeStamp: String {
		if _timeStamp == nil {
			_timeStamp = ""
		}
		return _timeStamp
	}
	
	var project: String {
		if _project == nil {
			_project = ""
		}
		return _project
	}
	
	var from_email: String {
		if _from_email == nil {
			_from_email = ""
		}
		return _from_email
	}
	
	init(getData: [String: Any]) {
		
		if let id = getData["g_id"] as? String {
			self._g_id = id
		}
		
		if let topic = getData["topic"] as? String {
			self._topic = topic
		}
		
		if let project = getData["project"] as? String {
			self._project = project
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
		
		if let description = getData["description"] as? String {
			self._description = description
		}
		
		if let timeStamp = getData["timestamp"] as? String {
			self._timeStamp = timeStamp
		}
		
		if let from_email = getData["_from_email"] as? String {
			self._from_email = from_email
		}
		
		if let user = getData["users"] as? [Dictionary<String, AnyObject>] {
		
			let userEmail = user[0]["email"] as? String
			let userCat = user[0]["category"] as? String
		
			self._users.updateValue(userCat!, forKey: userEmail!)
		}

	}
}
			
