//
//  PersonCell.swift
//  LOOP
//
//  Created by Aman Chawla on 05/06/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Contacts
import Alamofire

class PersonCell: UITableViewCell {

	@IBOutlet weak var personNameLbl: UILabel!
	@IBOutlet weak var personEmailLbl: UILabel!
	@IBOutlet weak var personImg: UIImageView!
	@IBOutlet weak var inviteBtn: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateUI(contact:CNContact) {
		personNameLbl.text = "\(contact.givenName) \(contact.familyName)"
		personEmailLbl.text = contact.emailAddresses.first?.value as String?
		//  personImg.image = contact.imageData
	}
	
	
	
	@IBAction func inviteBtnPressed(_ sender: Any) {
		
		let parameters: Parameters = [
			"email": personEmailLbl.text as Any
		]

		
		Alamofire.request("\(baseURL)/frndsSystem.php?action=send&my_email=\(myEmail as Any)", method: .post, parameters: parameters).responseJSON { response in
			
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				if let Status = dict["status"] as? Int {
					if Status == 200 {
						self.inviteBtn.setTitle("Invited", for: .normal)
					} else if Status == 409 {
						self.inviteBtn.setTitle("Error", for: .normal)
					}
				}
			}
		}

	}
	
	
	
}
