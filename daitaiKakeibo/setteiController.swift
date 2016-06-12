//  setteiController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import GoogleMobileAds
import FontAwesomeKit

class setteiController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate{

	@IBOutlet weak var myTableView: UITableView!
	var selectedIndex = -1
	var menuList = ["How To Use","メールで送信","アプリについて","データの削除"]
	var selectedName:String = ""
	
	let AdMobID = "ca-app-pub-3530000000000000/0123456789"
	let TEST_DEVICE_ID = "61b0154xxxxxxxxxxxxxxxxxxxxxxxe0"
	let AdMobTest:Bool = true
	let SimulatorTest:Bool = true
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		insertAdMob()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuList.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		let cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
		// cell.textLabel!.text = "\(indexPath.row)行目"
		cell.accessoryType = .DisclosureIndicator
		cell.textLabel!.text = "\(menuList[indexPath.row])"
		return cell
	}
		
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let screenHeight = Int(UIScreen.mainScreen().bounds.size.height)
		//print(screenHeight)
		// 画面サイズで機種判定
		if screenHeight == 480 {
			switch indexPath.row {
			case 0:
				performSegueWithIdentifier("howToUseSegue", sender: nil)
			case 1:
				performSegueWithIdentifier("sendMailSegue4S", sender: nil)
			case 2:
				performSegueWithIdentifier("aboutAppSegue", sender: nil)
			case 3:
				performSegueWithIdentifier("eraseSegue4S", sender: nil)
			default:
				break
			}
		}else{
			switch indexPath.row {
			case 0:
				performSegueWithIdentifier("howToUseSegue", sender: nil)
			case 1:
				performSegueWithIdentifier("sendMailSegue", sender: nil)
			case 2:
				performSegueWithIdentifier("aboutAppSegue", sender: nil)
			case 3:
				performSegueWithIdentifier("eraseSegue", sender: nil)
			default:
				break
			}
		}
	}
	
	func insertAdMob(){
		// 以下参考サイトからのコピぺ
		var admobView: GADBannerView = GADBannerView()
		admobView = GADBannerView(adSize:kGADAdSizeBanner)
		
		// 広告の位置を指定している(下に設置)
		admobView.frame.origin = CGPointMake(0, self.view.frame.size.height - admobView.frame.height)
		
		// ↓上に設置の場合
		// admobView.frame.origin = CGPointMake(0, 20)
		// 広告のサイズを指定している
		admobView.frame.size = CGSizeMake(self.view.frame.width, admobView.frame.height)
		admobView.adUnitID = AdMobID
		admobView.delegate = self
		admobView.rootViewController = self
		
		let admobRequest:GADRequest = GADRequest()
		
		if AdMobTest {
			if SimulatorTest {
				admobRequest.testDevices = [kGADSimulatorID]
			} else {
				admobRequest.testDevices = [TEST_DEVICE_ID]
			}
		}
		admobView.loadRequest(admobRequest)
		self.view.addSubview(admobView)
	}
	
//	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//		if (segue.identifier == "howToUseSegue") {
//			let twoVC: setteiController = (segue.setteiViewController as? howToUseController)!
//
//		}
//	}
	

	

	
	
	
	

	
	
	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
	

}
