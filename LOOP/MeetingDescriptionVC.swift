//
//  MeetingDescriptionVC.swift
//  LOOP
//
//  Created by Aman Chawla on 11/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Alamofire

class MeetingDescriptionVC: UIViewController {

	@IBOutlet weak var participantsCountLbl: UILabel!
	@IBOutlet weak var mediaCountLbl: UIButton!
	@IBOutlet weak var typeLbl: UILabel!
	@IBOutlet weak var timeLbl: UILabel!
	@IBOutlet weak var dateLbl: UILabel!
	@IBOutlet weak var meetingTitleLbl: UILabel!
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var gid: String!
	var notificationModel: NotificationModel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		downloadNotificationData()
	}
	
	func downloadNotificationData() {
		Alamofire.request("\(baseURL)notification.php?my_email=rishabh9393@gmail.com", method: .get).responseJSON { response in
			
			if let dict = response.result.value as? [[String:Any]] {
				for obj in dict {
					let notification = NotificationModel(getData: obj)
					if notification.g_id == self.gid || notification.type == "OpenMeeting" {
						
						self.meetingTitleLbl.text = notification.topic
						self.dateLbl.text = notification.date
						self.timeLbl.text = notification.time
					}
				}
			}
		}
	}
	
	@IBAction func deleteBtnPressed(_ sender: Any) {
	}
	
	@IBAction func backBtnPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func viewMediaBtnPressed(_ sender: Any) {
	}
}
