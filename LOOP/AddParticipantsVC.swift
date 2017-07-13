//
//  AddParticipantsVC.swift
//  LOOP
//
//  Created by Aman Chawla on 06/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class AddParticipantsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var myContactsModel: MyContactsModel!
	var myContacts = [MyContactsModel]()
	
	var selected = [MyContactsModel]()
	
	var selectedMembers = [String: String]()
	
	var delegate: PassSelectedMembers?
	var del: PassMyContacts?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		collectionView.delegate = self
		collectionView.dataSource = self

		downloadMyContactsData()
    }
	
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
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myContacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "AddParticipantsCell", for: indexPath) as? AddParticipantsCell {
			
			let myContact = self.myContacts[indexPath.row]
			cell.updateUI(myContact: myContact)
			
			return cell
		} else {
			return AddParticipantsCell()
		}
	}
	
	@IBAction func doneBtnPressed(_ sender: Any) {
		dismiss(animated: true) {
			self.delegate?.passingMembers(members: self.selectedMembers)
			self.del?.passingContacts(selects: self.selected)
		}
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return selected.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedParticipantsCell", for: indexPath) as? AddedParticipantsCell {
			
			let select = self.selected[indexPath.row]
			cell.updateUI(selected: select)
			
			return cell
		} else {
			return AddedParticipantsCell()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! AddParticipantsCell
		
		if cell.isSelected {
			let cat = cell.catagoryLbl.text
			let email = cell.personEmailLbl.text
			selectedMembers.updateValue(cat!, forKey: email!)
			selected.append(myContacts[indexPath.row])
			collectionView.reloadData()
		}
	}
	
}
