//
//  DisplayContactsVC.swift
//  LOOP
//
//  Created by Aman Chawla on 05/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Contacts
import Alamofire

protocol YourCellDelegate: class {
	func didPressButton(_ tag: Int)
}

class DisplayContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,YourCellDelegate, UISearchBarDelegate {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	var email: String!
	var filteredContacts = [CNContact]()
	var inSearchMode = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
		searchBar.returnKeyType = UIReturnKeyType.done
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DisplayContactsVC.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
    }
	
	//MARK - Util
	func dismissKeyboard() {
		view.endEditing(true)
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
			
			let text = searchBar.text
			
			filteredContacts = contacts.filter({$0.givenName.range(of: text!) != nil})
			tableView.reloadData()
		}
	}
	
	//MARK - Get Contacts from Phone
	lazy var contacts: [CNContact] = {
		let contactStore = CNContactStore()
		let keysToFetch = [
			CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
			CNContactEmailAddressesKey,
			CNContactImageDataAvailableKey
			] as [Any]
		
		// Get all the containers
		var allContainers: [CNContainer] = []
		do {
			allContainers = try contactStore.containers(matching: nil)
		} catch {
			print("Error fetching containers")
		}
		
		var results: [CNContact] = []
		
		// Iterate all containers and append their contacts to our results array
		for container in allContainers {
			let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
			
			do {
				let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
				results.append(contentsOf: containerResults)
			} catch {
				print("Error fetching results for container")
			}
		}
		
		return results
	}()
	
	//MARK - TableView
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if inSearchMode {
			return filteredContacts.count
		}
		
		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell
	
		if inSearchMode {
			let contacts = self.filteredContacts[indexPath.row]
			cell?.updateUI(contact: contacts)
			
			cell?.cellDelegate = self
			cell?.tag = indexPath.row
		} else {
			let contacts = self.contacts[indexPath.row]
			cell?.updateUI(contact: contacts)
			
			cell?.cellDelegate = self
			cell?.tag = indexPath.row
		}
		
		return cell!
	}
	
	// MARK - Protocol Invoked button to invite Friends 
	
	func didPressButton(_ tag: Int) {
		let contact = self.contacts[tag]
		
		let parameters: Parameters = [
			"email": contact.emailAddresses.first?.value as String!
		]
		
		Alamofire.request("\(baseURL)frndsSystem.php?action=send&my_email=\(myEmail)", method: .post, parameters: parameters).responseJSON { response in
		
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				//let msg = dict["msg"] as? String
				
				let Status = dict["status"] as? String
				
				if Status == "200" {
					// request sent
					self.inviteSent()
					
				} else {
					// Failed
					self.inviteFailed()
				}
				
			}
		}
	}
	
	//MARK - Add by email 
	
	@IBAction func addByEmailBtn(_ sender: Any) {
		let alert = UIAlertController(title: "Add Contact", message: "Enter valid email to send invitation", preferredStyle: .alert)
		
		let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in }
		let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in

			let textField = alert.textFields![0] as UITextField
			
			let parameters: Parameters = [
				"email": textField.text!
			]
			
			Alamofire.request("\(baseURL)frndsSystem.php?action=send&my_email=\(myEmail)", method: .post, parameters: parameters).responseJSON { response in
				
				if let dict = response.result.value as? Dictionary<String, AnyObject> {
					
					//let msg = dict["msg"] as? String
					
					let Status = dict["status"] as? String
					
					if Status == "200" {
						// request sent
						self.inviteSent()
					} else {
						// Failed
						self.inviteFailed()
					}
					
				}
			}
		
		}
		
		alert.addTextField { (textField : UITextField!) -> Void in
			textField.placeholder = "Enter Email Address"
		}
		
		alert.addAction(okBtn)
		alert.addAction(cancelBtn)
		self.present(alert, animated: true, completion: nil)
	}
	
	func inviteSent() {
		let alert = UIAlertController(title: "Invite", message: "Invite sent", preferredStyle: .alert)
		
		let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in }
		
		alert.addAction(ok)
		self.present(alert, animated: true, completion: nil)
	}
	
	func inviteFailed() {
		let alert = UIAlertController(title: "Invite", message: "Something Went Wrong", preferredStyle: .alert)
		
		let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in }
		
		alert.addAction(ok)
		self.present(alert, animated: true, completion: nil)
	}
	
}
