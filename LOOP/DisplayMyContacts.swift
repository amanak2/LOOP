//
//  DisplayMyContacts.swift
//  LOOP
//
//  Created by Aman Chawla on 05/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class DisplayMyContacts: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	var myContactsModel: MyContactsModel!
	var myContacts = [MyContactsModel]()
	var filteredMyContacts = [MyContactsModel]()
	var inSearchMode = false
	
	var email: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
		searchBar.returnKeyType = UIReturnKeyType.done
		
		downloadMyContactsData()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DisplayMyContacts.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
    }

	//MARK - Util
	
	override func viewDidAppear(_ animated: Bool) {
		emptyContacts()
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func emptyContacts() {
		if myContacts.isEmpty == true {
			let alert = UIAlertController(title: "No Friends", message: "Please invite friends from contacts", preferredStyle: .alert)
			
			let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in
				self.dismiss(animated: true, completion: nil)
			}
			
			alert.addAction(okBtn)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "MyContactsInfoVC" {
			if let destination = segue.destination as? MyContactsInfoVC {
				destination.email = self.email
			}
		}
	}
	
	//Download myContacts from API 
	func downloadMyContactsData() {
		Alamofire.request("\(baseURL)frnd_req.php?my_email=\(myEmail)", method: .get).responseJSON { response in
			
			if let dict = response.result.value as? [[String:Any]] {
				for obj in dict {
					let myContact = MyContactsModel(getData: obj)
					self.myContacts.append(myContact)
				}
			}
			self.tableView.reloadData()
		}
	}
	
	@IBAction func backBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	//MARK - SearchBar
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		view.endEditing(true)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		if searchBar.text == nil || searchBar.text == "" {
			
			inSearchMode = false
			tableView.reloadData()
			view.endEditing(true)
		} else {
			
			inSearchMode = true
			
			let lower = searchBar.text?.lowercased()
			//let upper = searchBar.text?.uppercased()
			
			filteredMyContacts = myContacts.filter({$0.user.range(of: lower!) != nil})
			tableView.reloadData()
		}
	}
	
	//MARK - TableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if inSearchMode {
			return filteredMyContacts.count
		}
		return myContacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "MyContactsCell", for: indexPath) as? MyContactsCell {
			
			if inSearchMode {
				let myContact = self.filteredMyContacts[indexPath.row]
				cell.updateUI(myContact: myContact)
			} else {
				let myContact = self.myContacts[indexPath.row]
				cell.updateUI(myContact: myContact)
			}
			
			return cell
		} else {
			return MyContactsCell()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! MyContactsCell
		
		if cell.isSelected {
			email = cell.personEmailLbl.text
			performSegue(withIdentifier: "MyContactsInfoVC", sender: self)
		}
	}
	
}
