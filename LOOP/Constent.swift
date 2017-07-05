//
//  constent.swift
//  LOOP
//
//  Created by Aman Chawla on 01/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import Foundation

let baseURL = "http://35.154.30.238/smokeApi/code/"
let myEmail = UserDefaults.standard.object(forKey: "email") as? String
let firstname = UserDefaults.standard.object(forKey: "firstname") as? String
let lastname = UserDefaults.standard.object(forKey: "lastname") as? String
let adminName = "\(firstname!) \(lastname!)"

typealias downloadComplete = () -> ()

protocol PassSelectedMembers {
	func passingMembers(members: [String: String])
}

protocol PassingSelectedTeamMembers  {
	func passingTeamMembers(members: [String: String])
}
