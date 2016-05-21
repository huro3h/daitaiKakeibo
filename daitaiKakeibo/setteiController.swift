//  setteiController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit

class setteiController: UIViewController, UITableViewDataSource, UITableViewDelegate{

	@IBOutlet weak var myTableView: UITableView!
	var selectedIndex = -1
	var menuList = ["How To Use","メールで送信","アプリについて","データの削除"]
	var selectedName:String = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuList.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
		var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell")
		// cell.textLabel!.text = "\(indexPath.row)行目"
		cell.accessoryType = .DisclosureIndicator
		cell.textLabel!.text = "\(menuList[indexPath.row])"
		return cell
	}
		
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		switch indexPath.row {
		case 0:
			self.navigationController?.pushViewController(howToUseController(), animated: true)
		case 1:
			self.navigationController?.pushViewController(sendMailController(), animated: true)
		case 2:
			self.navigationController?.pushViewController(aboutAppController(), animated: true)
		case 3:
			self.navigationController?.pushViewController(eraseController(), animated: true)
		default:
			break
		}
	}
	
//	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//		if (segue.identifier == "howToUseSegue") {
//			let subVC: SubViewController = (segue.destinationViewController as? howToUseController)!
//
//		}
//	}
	

	
	
	
	

	
	
	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
	

}
