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

class DisplayContactsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,YourCellDelegate {

	@IBOutlet weak var tableView: UITableView!
	var email: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
    }
	
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
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell
	
		let contacts = self.contacts[indexPath.row]
		cell?.updateUI(contact: contacts)
		
		cell?.cellDelegate = self
		cell?.tag = indexPath.row
		
		return cell!
	}
	
	@IBAction func backBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	func didPressButton(_ tag: Int) {
		let contact = self.contacts[tag]
		
		let parameters: Parameters = [
			"email": contact.emailAddresses.first?.value as String!
		]
		
		Alamofire.request("\(baseURL)frndsSystem.php?action=send&my_email=\(myEmail!)", method: .post, parameters: parameters).responseJSON { response in
		
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				let msg = dict["msg"] as? String
				
				if let Status = dict["status"] as? Int {
					if Status == 200 {
						// request sent
						let alert = UIAlertController(title: "Invite", message: "Invite sent", preferredStyle: .alert)
						
						let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in }
						
						alert.addAction(okBtn)
						self.present(alert, animated: true, completion: nil)
						
					} else {
						// Failed
						let alert = UIAlertController(title: "Invite", message: msg, preferredStyle: .alert)
						
						let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in }
						
						alert.addAction(okBtn)
						self.present(alert, animated: true, completion: nil)
					}
				}
			}
		}
	}
	
}
