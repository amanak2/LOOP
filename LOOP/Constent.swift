//
//  constent.swift
//  LOOP
//
//  Created by Aman Chawla on 01/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import Foundation

let baseURL = "http://35.154.30.238/smokeApi/code/"
let myEmail = UserDefaults.standard.string(forKey: "email")!
let firstname = UserDefaults.standard.string(forKey: "firstname")!
let lastname = UserDefaults.standard.string(forKey: "lastname")!
let mobile = UserDefaults.standard.string(forKey: "mobile")!
let office = UserDefaults.standard.string(forKey: "office")!
let designation = UserDefaults.standard.string(forKey: "designation")!
let myName = "\(firstname) \(lastname)"

let SkylinkAppKey: String = "31bcce92-26d8-4ac7-ae0c-327f90f2d221"
let SkylinkSecret: String  = "ey6wbd6kpp7m0"

typealias downloadComplete = () -> ()

protocol PassSelectedMembers {
	func passingMembers(members: [String: String])
}

protocol PassMyContacts {
	func passingContacts(selects: [MyContactsModel])
}

protocol PassingSelectedTeamMembers  {
	func passingTeamMembers(members: [String: String])
}

protocol YourCellDelegate: class {
	func didPressButton(_ tag: Int)
}
