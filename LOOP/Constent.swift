//
//  constent.swift
//  LOOP
//
//  Created by Aman Chawla on 01/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import Foundation

let baseURL = "http://35.154.30.238/smokeApi/code/"
let myEmail = UserDefaults.standard.object(forKey: "email") as! String

typealias downloadComplete = () -> ()
