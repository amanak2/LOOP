//
//  Constent.swift
//  LOOP
//
//  Created by Aman Chawla on 01/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import Foundation

//MARK - Constents

let baseURL = "http://35.154.30.238/smokeApi/code/"
let myEmail = UserDefaults.standard.string(forKey: "email")!
let profile = UserDefaults.standard.string(forKey: "profile")!
let firstname = UserDefaults.standard.string(forKey: "firstname")!
let lastname = UserDefaults.standard.string(forKey: "lastname")!
let mobile = UserDefaults.standard.string(forKey: "mobile")!
let office = UserDefaults.standard.string(forKey: "office")!
let designation = UserDefaults.standard.string(forKey: "designation")!
let DeviceToken = "" //UserDefaults.standard.string(forKey: "DeviceToken")!    Activate push Notification to ge this!!
let myName = "\(firstname) \(lastname)"

//MARK - Needs to be same with Andriod

let SkylinkAppKey: String = "737c213c-5a2e-4454-9581-080d02e0e3cb"
let SkylinkSecret: String  = "9njf7aygkldnp"

//Not sure if this is needed for Alamofire
typealias downloadComplete = () -> ()

//MARK - Protocols

protocol PassSelectedMembers {
	func passingMembers(members: [String: String])
}

protocol PassMyContacts {
	func passingContacts(selects: [MyContactsModel])
}

protocol PassingSelectedTeamMembers  {
	func passingTeamMembers(members: [String: String])
}
