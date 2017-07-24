//
//  AudioCallVC.swift
//  LOOP
//
//  Created by Aman Chawla on 21/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import Foundation

class AudioCallVC: UIViewController, SKYLINKConnectionLifeCycleDelegate, SKYLINKConnectionMediaDelegate, SKYLINKConnectionRemotePeerDelegate {

	@IBOutlet weak var muteBtn: UIButton!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var projectTitleLbl: UILabel!
	@IBOutlet weak var projectImgLbl: UIImageView!
	
	var projectTitle: String!
	var ROOM_NAME: String!
	
	var skylinkConnection: SKYLINKConnection!
	var remotePeerArray = [String: Any]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		ROOM_NAME = projectTitle
		
		//Creating configuration
		let config: SKYLINKConnectionConfig = SKYLINKConnectionConfig()
		config.video = false
		config.audio = true
		//Creating SKYLINKConnection
		self.skylinkConnection = SKYLINKConnection(config: config, appKey: SkylinkAppKey as String)
		self.skylinkConnection.lifeCycleDelegate = self
		self.skylinkConnection.mediaDelegate = self
		self.skylinkConnection.remotePeerDelegate = self
		
		// Connecting to a room
		SKYLINKConnection.setVerbose(true)
		let credInfos: Dictionary = ["startTime": Date(), "duration": NSNumber(value: 24.0 as Float)] as [String : Any]
		NSLog("This is credInfos \(credInfos.description)")
		//let credential = SKYLINKConnection.calculateCredentials(ROOM_NAME, duration: credInfos["duration"] as! String, startTime: credInfos["startTime"] as! NSDate, secret: self.skylinkApiSecret)
		let durationString = credInfos["duration"] as! NSNumber
		NSLog("This is Credential \(durationString)")
		let credential = SKYLINKConnection.calculateCredentials(ROOM_NAME, duration: durationString, startTime: credInfos["startTime"] as! Date, secret: SkylinkSecret)
		skylinkConnection.connectToRoom(withCredentials: ["credential": credential!, "startTime": credInfos["startTime"]!, "duration": credInfos["duration"]!], roomName: ROOM_NAME, userInfo: "Audio call user #\(arc4random() % 1000) - iOS \(UIDevice.current.systemVersion)")
    }
	
	// MARK: - SKYLINKConnectionLifeCycleDelegate
	
	func connection(_ connection: SKYLINKConnection!, didConnectWithMessage errorMessage: String!, success isSuccess: Bool) {
		if isSuccess {
			NSLog("Inside %s", #function)
		} else {
			let alert: UIAlertController = UIAlertController(title: "Connection failed", message: errorMessage, preferredStyle: .alert)
			let cancelAction = UIAlertAction(title: "OK", style: .cancel){action->Void in}
			alert.addAction(cancelAction)
			self.present(alert, animated: true, completion: nil)
		}
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.muteBtn.isEnabled = true
		}
	}
	
	func connection(_ connection: SKYLINKConnection!, didDisconnectWithMessage errorMessage: String!) {
		let alert: UIAlertController = UIAlertController(title: "Disconnected", message: errorMessage, preferredStyle: .alert)
		let cancelAction=UIAlertAction(title: "OK", style: .cancel){action->Void in}
		alert.addAction(cancelAction)
		self.present(alert, animated: true, completion: {
			self.disconnect()
		})
	}
	
	// MARK: - SKYLINKConnectionRemotePeerDelegate
	
	func connection(_ connection: SKYLINKConnection!, didJoinPeer userInfo: Any!, mediaProperties pmProperties: SKYLINKPeerMediaProperties!, peerId: String!) {
		NSLog("Peer with id %@ joigned the room.", peerId)
		//self.remotePeerArray.updateValue(peerId, forKey: "id")
		//self.remotePeerArray.updateValue(pmProperties.isAudioMuted, forKey: "sAudioMuted")
		//self.remotePeerArray.updateValue(userInfo is String ? userInfo: "", forKey: "nickname")
	}
	
	func connection(_ connection: SKYLINKConnection!, didLeavePeerWithMessage errorMessage: String!, peerId: String!) {
		NSLog("Peer with id %@ left the room with message: %@", peerId, errorMessage)
	}
	
	@IBAction func muteBtnPressed(_ sender: Any) {
		//mute audio
		self.skylinkConnection.muteAudio(!self.skylinkConnection.isAudioMuted())
	}
	
	func disconnect(){
		if self.skylinkConnection != nil {
			self.skylinkConnection.disconnect({
				self.dismiss(animated: true, completion: nil)
			})
		}
	}
	
	@IBAction func cancelCallBtnPressed(_ sender: Any) {
		disconnect()
	}

}
