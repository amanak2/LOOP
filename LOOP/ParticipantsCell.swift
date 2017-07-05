//
//  ParticipantCell.swift
//  LOOP
//
//  Created by Aman Chawla on 05/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit

class ParticipantsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension ParticipantsCell:UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		
	}
	
	
}
