//  listController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData
import FontAwesomeKit

class listController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

	
	@IBOutlet weak var listTableView: UITableView!
	
	var myTimes: [String] = []
	var myFoods: [NSNumber] = []
	var myLifes: [NSNumber] = []
	var myZappies: [NSNumber] = []
	var myHokas: [NSNumber] = []
	var myTotals: [NSNumber] = []
	
	// リスト最下部に表示させる変数
	var foodFeeCount: Int = 0
	var lifeFeeCount: Int = 0
	var zappiFeeCount: Int = 0
	var hokaFeeCount: Int = 0
	var totalFeeCount: Int = 0
	
	@IBOutlet weak var foodFeeLabel: UILabel!
	@IBOutlet weak var lifeFeeLabel: UILabel!
	@IBOutlet weak var zappiFeeLabel: UILabel!
	@IBOutlet weak var hokaFeeLabel: UILabel!
	@IBOutlet weak var totalFeeLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		// CoreDataから読み込み
		read()
		// 別でcellファイルを作った時に
		listTableView.registerNib(UINib(nibName: "feeList", bundle: nil), forCellReuseIdentifier: "feeList")
    }
	
	override func viewWillAppear(animated: Bool) {
		print("List画面表示")
		foodFeeLabel.text = String(foodFeeCount)
		lifeFeeLabel.text = String(lifeFeeCount)
		zappiFeeLabel.text = String(zappiFeeCount)
		hokaFeeLabel.text = String(hokaFeeCount)
		totalFeeLabel.text = String(totalFeeCount)
		listTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
	
	override func setEditing(editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		listTableView.setEditing(editing, animated: animated)
	}
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myTimes.count // 行数をデータの数でカウント
	}
	
	// 2.行に表示する内容をリセット
	// returnで入る物、int型(引数) -> 戻り値のデータ型
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("feeList")! as! FeeTableViewCell
		
		cell.dayLabel.text = "\(myTimes[indexPath.row])"
		cell.foodFareLabel.text = "\(myFoods[indexPath.row])"
		cell.lifeFareLabel.text = "\(myLifes[indexPath.row])"
		cell.zappiFareLabel.text  = "\(myZappies[indexPath.row])"
		cell.hokaFareLabel.text  = "\(myHokas[indexPath.row])"
		cell.totalFareLabel.text  = "\(myTotals[indexPath.row])"
		return cell
//		let label1 = cell.viewWithTag(1) as! UILabel
//		label1.text = "\(myTimes[indexPath.row])"
//		let label2 = cell.viewWithTag(2) as! UILabel
//		label2.text = "\(myFoods[indexPath.row])"
//		let label3 = cell.viewWithTag(3) as! UILabel
//		label3.text = "\(myLifes[indexPath.row])"
//		let label4 = cell.viewWithTag(4) as! UILabel
//		label4.text = "\(myZappies[indexPath.row])"
//		let label5 = cell.viewWithTag(5) as! UILabel
//		label5.text = "\(myHokas[indexPath.row])"
//		let label6 = cell.viewWithTag(6) as! UILabel
//		label6.text = "\(myTotals[indexPath.row])"
//		return cell
	}
	
	// 3.選択された時に行う処理(Delegate処理)
	//	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	//		print("\(indexPath.row)行目を選択")
	//	}
	
	func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			// myTimes.removeAtIndex(indexPath.row)
			// tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
			
			let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
			
			if let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext {
				let entityDiscription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
				
				let fetchRequest = NSFetchRequest(entityName: "AccountBook")
				fetchRequest.entity = entityDiscription
				
				var error: NSError? = nil
				
				do {
					let results = try managedObjectContext.executeFetchRequest(fetchRequest)
					print(results.count)
					
					var num: Int = 0
					
					for managedObject in results {
						
						if(num == indexPath.row) {
							let accountBook = managedObject as! AccountBook
							
							managedObjectContext.deleteObject(managedObject as! NSManagedObject)
							
							appDelegate.saveContext()
							read()
							listTableView.reloadData()
							
							foodFeeLabel.text = String(foodFeeCount)
							lifeFeeLabel.text = String(lifeFeeCount)
							zappiFeeLabel.text = String(zappiFeeCount)
							hokaFeeLabel.text = String(hokaFeeCount)
							totalFeeLabel.text = String(totalFeeCount)
						}
						num++
					}
				} catch let error1 as NSError {
					error = error1
				}
			}
		}
	}

	// 以下自作関数置き場
	
	// CoreDataから値読み込み
	func read(){
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		if let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext{

			let entityDescription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			fetchRequest.entity = entityDescription
			
			var error:NSError? = nil

			do{
				
				foodFeeCount = 0
				lifeFeeCount = 0
				zappiFeeCount = 0
				hokaFeeCount = 0
				totalFeeCount = 0
				
				myTimes = []
				myFoods = []
				myLifes = []
				myZappies = []
				myHokas = []
				myTotals = []
				
				let results = try managedObjectContext.executeFetchRequest(fetchRequest)
				print(results.count)
				for managedObject in results {
					let accountBook = managedObject as! AccountBook
					
					// 用意した変数に各項目を配列の形で代入
					let fixDate = dateString(accountBook.inputDate!)
					myTimes.append(fixDate)
					myFoods.append(accountBook.foodFee!)
					myLifes.append(accountBook.lifeFee!)
					myZappies.append(accountBook.zappiFee!)
					myHokas.append(accountBook.hokaFee!)
					myTotals.append(accountBook.totalFee!)
					
					// リストに各項目の合計値を入れる為、Int型にダウンキャストして合計させる
					foodFeeCount += (accountBook.foodFee! as Int)
					lifeFeeCount += (accountBook.lifeFee! as Int)
					zappiFeeCount += (accountBook.zappiFee! as Int)
					hokaFeeCount += (accountBook.hokaFee! as Int)
					totalFeeCount += (accountBook.totalFee! as Int)
				}
				
			}catch let error1 as NSError{
				error = error1
			}
		}
	}
	
	
	// NSDate->String型に変換
	func dateString(date: NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
		// dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
		dateFormatter.dateFormat = "M/d"
		let dateString: String = dateFormatter.stringFromDate(date)
		return dateString
	}
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
