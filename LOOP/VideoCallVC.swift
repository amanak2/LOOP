//
//  VideoCallVC.swift
//  LOOP
//
//  Created by Aman Chawla on 24/07/17.
//  Copyright © 2017 SoftkiwiTech. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCallVC: UIViewController, SKYLINKConnectionLifeCycleDelegate, SKYLINKConnectionMediaDelegate, SKYLINKConnectionRemotePeerDelegate {
	
	var skylinkConnection: SKYLINKConnection!
	var peerIds = [String]()
	var peersInfos = [String: [String: Any]]()

	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var videoAspectSegmentControl: UISegmentedControl!
	@IBOutlet weak var muteBtn: UIButton!
	@IBOutlet weak var flipCamBtn: UIButton!
	@IBOutlet weak var ThirdPeerLbl: UILabel!
	@IBOutlet weak var SecondPeerLbl: UILabel!
	@IBOutlet weak var FirstPeerLbl: UILabel!
	@IBOutlet weak var ThirdPeerVideoContainer: UIView!
	@IBOutlet weak var SecondPeerVideoContainer: UIView!
	@IBOutlet weak var LocalVideoContainer: UIView!
	@IBOutlet weak var FirstPeerVideoContainer: UIView!

	
	var ROOM_NAME: String!
	var ProjectName: String!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		NSLog("imat_viewDidLoad")
		NSLog("SKYLINKConnection version = %@", SKYLINKConnection.getSkylinkVersion())
		
		self.peersInfos = [:]
		ROOM_NAME = ProjectName
		
		// Creating configuration
		let config:SKYLINKConnectionConfig = SKYLINKConnectionConfig()
		config.video = true
		config.audio = true
		
		// Creating SKYLINKConnection
		self.skylinkConnection = SKYLINKConnection(config: config, appKey: SkylinkAppKey as String)
		self.skylinkConnection.lifeCycleDelegate = self
		self.skylinkConnection.mediaDelegate = self
		self.skylinkConnection.remotePeerDelegate = self
		
		// Connecting to a room
		SKYLINKConnection.setVerbose(true)
		
		self.skylinkConnection.connectToRoom(withSecret: SkylinkSecret as String, roomName: ROOM_NAME, userInfo: nil)
	
		//Disable Button
		flipCamBtn.isEnabled = false
		muteBtn.isEnabled = false
		//btnCameraTap.isEnabled = false
		//lockButton.isEnabled = false

	}
	
	func disConnect() {
		NSLog("imat_disConnect")
		self.activityIndicator.startAnimating()
		if (self.skylinkConnection != nil) {
			self.skylinkConnection.disconnect({() -> Void in
				self.activityIndicator.stopAnimating()
				self.dismiss(animated: true, completion: nil)
			})
		}
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.updatePeersVideosFrames()
	}
	
	func AlertMessage(_ msg_title: String, msg:String) {
		let alertController = UIAlertController(title: msg_title , message: msg, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
		alertController.addAction(OKAction)
		self.present(alertController, animated: true) {
		}
	}
	
	//MARK: Utils
	
	func containerViewForVideoView(_ videoView: UIView) -> UIView {
		
		var correspondingContainerView: UIView!
		
		if videoView.isDescendant(of: self.LocalVideoContainer) {
			correspondingContainerView = self.LocalVideoContainer
		}
		else if videoView.isDescendant(of: self.FirstPeerVideoContainer) {
			correspondingContainerView = self.FirstPeerVideoContainer
		}
		else if videoView.isDescendant(of: self.SecondPeerVideoContainer) {
			correspondingContainerView = self.SecondPeerVideoContainer
		}
		else if videoView.isDescendant(of: self.ThirdPeerVideoContainer) {
			correspondingContainerView = self.ThirdPeerVideoContainer
		}
		return correspondingContainerView
	}
	
	func aspectFillRectForSize(_ insideSize: CGSize, containedInRect containerRect: CGRect) -> CGRect {
		let maxFloat: CGFloat = max(containerRect.size.height, containerRect.size.width)
		let aspectRatio: CGFloat = insideSize.width / insideSize.height
		var frame: CGRect = CGRect(x: 0, y: 0, width: containerRect.size.width, height: containerRect.size.height)
		if insideSize.width < insideSize.height {
			frame.size.width = maxFloat
			frame.size.height = frame.size.width / aspectRatio
		}
		else {
			frame.size.height = maxFloat;
			frame.size.width = frame.size.height * aspectRatio;
		}
		frame.origin.x = (containerRect.size.width - frame.size.width) / 2;
		frame.origin.y = (containerRect.size.height - frame.size.height) / 2;
		return frame
	}
	
	func addRenderedVideo(_ videoView: UIView, insideContainer containerView: UIView, mirror shouldMirror: Bool) {
		NSLog("I_addRenderedVideo")
		videoView.frame = containerView.bounds
		if shouldMirror {
			videoView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		}
		
		for subview: UIView in containerView.subviews {
			subview.removeFromSuperview()
		}
		
		containerView.insertSubview(videoView, at: 0)
	}
	
	func indexForContainerView(_ v: UIView) -> Int {
		return [self.FirstPeerVideoContainer, self.SecondPeerVideoContainer, self.ThirdPeerVideoContainer].index(of: v)!
	}
	
	func refreshPeerViews() {
		
		let peerContainerViews = [self.FirstPeerVideoContainer, self.SecondPeerVideoContainer, self.ThirdPeerVideoContainer]
		var peerLabels = [self.FirstPeerLbl, self.SecondPeerLbl, self.ThirdPeerLbl]
		
		
		for viewToClean in peerContainerViews {
			for aSubview in (viewToClean?.subviews)! {
				aSubview.removeFromSuperview()
			}
		}
		
		for i in 0 ..< peersInfos.count  {
			let index: Int = self.peerIds.index(of: peerIds[i])!
			
			let videoView = (self.peersInfos[peerIds[i]]?["videoView"])! as AnyObject
			if (index < peerContainerViews.count) {
				if videoView is NSNull {
					self.AlertMessage("Warning",msg: "Cannot render the video view. Camera not found")
				}
				else {
					self.addRenderedVideo(videoView as! UIView, insideContainer: peerContainerViews[index]!, mirror: false)
				}
			}
			// refresh the label
			let audioMuted = (self.peersInfos[peerIds[i]]?["isAudioMuted"])!
			
			let videoMuted = (self.peersInfos[peerIds[i]]?["isVideoMuted"])!
			
			var mutedInfos: String = ""
			if (audioMuted is NSNumber) && CBool(audioMuted as! NSNumber) {
				mutedInfos = "Audio muted"
			}
			if (videoMuted is NSNumber) && CBool(videoMuted as! NSNumber) {
				mutedInfos = mutedInfos.characters.count != 0 ? "Video & " + mutedInfos : "Video muted"
			}
			if (index < peerLabels.count) {
				peerLabels[index]?.text = mutedInfos
			}
			if (index < peerLabels.count) {
				peerLabels[index]?.isHidden = !(mutedInfos.characters.count != 0)
			}
		}
		
		for i in self.peerIds.count ..< peerLabels.count {
			((peerLabels[i]!)).isHidden = true
		}
		self.updatePeersVideosFrames()
	}
	
	func updatePeersVideosFrames() {
		var pvView: AnyObject?
		var pvSize: AnyObject?
		
		for i in 0..<self.peerIds.count {
			pvView = (self.peersInfos[self.peerIds[i]]?["videoView"])! as AnyObject
			pvSize = (self.peersInfos[self.peerIds[i]]?["videoSize"])! as AnyObject
			
			if (pvView is UIView && pvSize is NSValue) {
				((pvView as! UIView)).frame = (self.videoAspectSegmentControl.selectedSegmentIndex == 0) ? self.aspectFillRectForSize((pvSize as! NSValue).cgSizeValue, containedInRect:(self.containerViewForVideoView(pvView as! UIView).frame)): AVMakeRect(aspectRatio: ((pvSize as! NSValue)).cgSizeValue, insideRect: self.containerViewForVideoView(pvView as! UIView).bounds)
			}
		}
	}

	
	// MARK: SKYLINKConnectionMediaDelegate
	
	func connection(_ connection: SKYLINKConnection!, didChangeVideoSize videoSize: CGSize, videoView: UIView!) {
		if videoSize.height > 0 && videoSize.width > 0 {
			let correspondingContainerView: UIView = self.containerViewForVideoView(videoView)
			if !correspondingContainerView.isEqual(self.LocalVideoContainer) {
				let i: Int = self.indexForContainerView(correspondingContainerView)
				
				let videoView = (self.peersInfos[peerIds[i]])!
				let videoSize = NSValue(cgSize: videoSize)
				let isAudioMuted = (self.peersInfos[peerIds[i]]?["isAudioMuted"])!
				let isVideoMuted = (self.peersInfos[peerIds[i]]?["isVideoMuted"])!
				
				if i != NSNotFound {
					self.peersInfos[peerIds[i]] = [
						"videoView" : videoView,
						"videoSize" : videoSize,
						"isAudioMuted" : isAudioMuted,
						"isVideoMuted" : isVideoMuted]
				}
			}
			
			videoView.frame =
				(self.videoAspectSegmentControl.selectedSegmentIndex == 0 || correspondingContainerView.isEqual(self.LocalVideoContainer)) ? self.aspectFillRectForSize(videoSize, containedInRect: correspondingContainerView.frame): AVMakeRect(aspectRatio: videoSize, insideRect: correspondingContainerView.bounds)
		}
		self.updatePeersVideosFrames()
	}
	
	func connection(_ connection: SKYLINKConnection!, didToggleAudio isMuted: Bool, peerId: String!) {
		let bool = self.peersInfos.keys.contains(where: {(peerId) -> Bool in
			return true
		})
		if (bool) {
			let videoView = (self.peersInfos[peerId]?["videoView"])
			let videoSize = (self.peersInfos[peerId]?["videoSize"])!
			let isAudioMuted = isMuted
			let isVideoMuted = (self.peersInfos[peerId]?["isVideoMuted"])!
			self.peersInfos[peerId] = [
				"videoView" : videoView!,
				"videoSize" : videoSize,
				"isAudioMuted" : isAudioMuted,
				"isVideoMuted" : isVideoMuted]
		}
		self.refreshPeerViews()
	}
	
	func connection(_ connection: SKYLINKConnection!, didToggleVideo isMuted: Bool, peerId: String!) {
		NSLog("imat_didToggleVideo")
		let bool = self.peersInfos.keys.contains(where: {(peerId) -> Bool in
			return true
		})
		
		if (bool) {
			let videoView = (self.peersInfos[peerId]?["videoView"])!
			let videoSize = (self.peersInfos[peerId]?["videoSize"])!
			let isAudioMuted = (self.peersInfos[peerId]?["isAudioMuted"])!
			let isVideoMuted = isMuted
			self.peersInfos[peerId] = [
				"videoView" : videoView,
				"videoSize" : videoSize,
				"isAudioMuted" : isAudioMuted,
				"isVideoMuted" : isVideoMuted]
		}
		self.refreshPeerViews()
	}
	
	// MARK: SKYLINKConnectionLifeCycleDelegate
	
	func connection(_ connection: SKYLINKConnection!, didConnectWithMessage errorMessage: String!, success isSuccess: Bool) {
		if isSuccess {
			NSLog("Inside %@", #function)
			DispatchQueue.main.async(execute: {() -> Void in
				self.LocalVideoContainer.alpha = 1
			})
		}
		else {
			let msgTitle: String = "Connection failed"
			let msg: String = errorMessage
			AlertMessage(msgTitle, msg:msg)
			self.navigationController!.popViewController(animated: true)
		}
		DispatchQueue.main.async(execute: {() -> Void in
			self.activityIndicator.stopAnimating()
			//Enabled Btn
			self.flipCamBtn.isEnabled = true
			self.muteBtn.isEnabled = true
			//self.btnCameraTap.isEnabled = true
			//self.lockButton.isEnabled = true
		})
	}
	
	func connection(_ connection: SKYLINKConnection!, didDisconnectWithMessage errorMessage: String!) {
		let msgTitle: String = "Disconnected"
		let alertController = UIAlertController(title: msgTitle , message: errorMessage, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
		alertController.addAction(OKAction)
		self.present(alertController, animated: true, completion: {
			self.disConnect()
		})
	}
	
	func connection(_ connection: SKYLINKConnection!, didRenderUserVideo userVideoView: UIView!) {
		self.addRenderedVideo(userVideoView, insideContainer: self.LocalVideoContainer, mirror: true)
	}
	
	// MARK: SKYLINKConnectionRemotePeerDelegate

	func connection(_ connection: SKYLINKConnection!, didJoinPeer userInfo: Any!, mediaProperties pmProperties: SKYLINKPeerMediaProperties!, peerId: String!) {
		if !(self.peerIds.contains(peerId)) {
			self.peerIds.append(peerId)
		}
		
//		if self.peerIds.count >= 4 {
//			self.lockRoom(shouldLock: true)
//		}
		
		var bool = false
		for i in self.peersInfos.keys {
			if (i as AnyObject).isEqual(to: peerId) {
				bool = true
			}
		}
		
		if !(bool) {
			self.peersInfos[peerId] = ["videoView": NSNull(), "videoSize": NSNull(), "isAudioMuted": NSNull(), "isVideoMuted": NSNull()]
		}
		
		let videoView = (self.peersInfos[peerId]?["videoView"])!
		let size = CGSize(width: pmProperties.videoWidth, height: pmProperties.videoHeight)
		let videoSize = NSValue(cgSize: size)
		let isAudioMuted = NSNumber(value: pmProperties.isAudioMuted as Bool)
		let isVideoMuted = NSNumber(value: pmProperties.isVideoMuted as Bool)
		self.peersInfos[peerId] = [
			"videoView" : videoView,
			"videoSize" : videoSize,
			"isAudioMuted" : isAudioMuted,
			"isVideoMuted" : isVideoMuted]
		self.refreshPeerViews()
	}
	
	func connection(_ connection: SKYLINKConnection!, didLeavePeerWithMessage errorMessage: String!, peerId: String!) {
		NSLog("Peer with id %@ left the room with message: %@", peerId, errorMessage);
		if(self.peerIds.count != 0) {
			self.peerIds.remove(at: peerIds.index(of: peerId)!)
			self.peersInfos.removeValue(forKey: peerId)
		}
		//self.lockRoom(shouldLock: false)
		self.refreshPeerViews()
	}
	
	func connection(_ connection: SKYLINKConnection!, didRenderPeerVideo peerVideoView: UIView!, peerId: String!) {
		
		if !self.peerIds.contains(peerId) {
			self.peerIds.append(peerId)
		}
		var bool = false
		for i in self.peersInfos.keys {
			if (i as AnyObject).isEqual(to: peerId) {
				bool = true
			}
		}
		
		if !(bool) {
			self.peersInfos[peerId] = ["videoView": NSNull(), "videoSize": NSNull(), "isAudioMuted": NSNull(), "isVideoMuted": NSNull()]
		}
		
		let videoSize = (self.peersInfos[peerId]?["videoView"])!
		let isAudioMuted = (self.peersInfos[peerId]?["isAudioMuted"])!
		let isVideoMuted = (self.peersInfos[peerId]?["isVideoMuted"])!
		
		self.peersInfos[peerId] = [
			"videoView" : peerVideoView,
			"videoSize" : videoSize,
			"isAudioMuted" : isAudioMuted,
			"isVideoMuted" : isVideoMuted]
		self.refreshPeerViews()
	}
	
	@IBAction func cancelCallBtnPressed(_ sender: Any) {
		disConnect()
	}
	
	@IBAction func muteBtnPressed(_ sender: Any) {
		self.skylinkConnection.muteAudio(!self.skylinkConnection.isAudioMuted())
	}
	
	@IBAction func flipCamBtnPressed(_ sender: Any) {
		self.skylinkConnection.switchCamera()
	}
}
