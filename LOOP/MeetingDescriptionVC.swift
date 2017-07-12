//
//  MeetingDescriptionVC.swift
//  LOOP
//
//  Created by Aman Chawla on 11/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class MeetingDescriptionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet weak var meetingType: UILabel!
	@IBOutlet weak var participantsCountLbl: UILabel!
	@IBOutlet weak var mediaCountLbl: UIButton!
	@IBOutlet weak var typeLbl: UILabel!
	@IBOutlet weak var timeLbl: UILabel!
	@IBOutlet weak var dateLbl: UILabel!
	@IBOutlet weak var meetingTitleLbl: UILabel!
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var meetingTit: String!
	var date: String!
	var time: String!
	var users = [NotificationUsers]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.delegate = self
		collectionView.dataSource = self
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		
		meetingTitleLbl.text = meetingTit
		dateLbl.text = date
		timeLbl.text = time
		collectionView.reloadData()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return users.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingDescriptionCell", for: indexPath) as? MeetingDescriptionCell {
			
			let user = self.users[indexPath.row]
			cell.updateUI(user: user)
			
			return cell
		} else {
			return MeetingDescriptionCell()
		}
	}
	
	@IBAction func deleteBtnPressed(_ sender: Any){
		//delete project
	
	}
	
	@IBAction func backBtnPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func viewMediaBtnPressed(_ sender: Any) {
		//View Media in Group
	}
}
