//  listController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData

class listController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

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
		// var testFoodTotal: Int = (myFoods.reduce(0, combine: { $0 + $1 }))
    }
	
	override func viewWillAppear(animated: Bool) {
		print("List画面表示")
		foodFeeLabel.text = String(foodFeeCount)
		lifeFeeLabel.text = String(lifeFeeCount)
		zappiFeeLabel.text = String(zappiFeeCount)
		hokaFeeLabel.text = String(hokaFeeCount)
		totalFeeLabel.text = String(totalFeeCount)
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myTimes.count // 行数をデータの数でカウント
	}
	
	// 2.行に表示する内容をリセット
	// returnで入る物、int型(引数) -> 戻り値のデータ型
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("myCell")! as UITableViewCell
		
		let label1 = cell.viewWithTag(1) as! UILabel
		label1.text = "\(myTimes[indexPath.row])"
		let label2 = cell.viewWithTag(2) as! UILabel
		label2.text = "\(myFoods[indexPath.row])"
		let label3 = cell.viewWithTag(3) as! UILabel
		label3.text = "\(myLifes[indexPath.row])"
		let label4 = cell.viewWithTag(4) as! UILabel
		label4.text = "\(myZappies[indexPath.row])"
		let label5 = cell.viewWithTag(5) as! UILabel
		label5.text = "\(myHokas[indexPath.row])"
		let label6 = cell.viewWithTag(6) as! UILabel
		label6.text = "\(myTotals[indexPath.row])"
		return cell
	}
	
	@objc func tableView(tableView: UITableView, heightForRowAtIndexPath IndexPath: NSIndexPath) -> CGFloat{
		return 25 // 行の幅
	}
	// 3.選択された時に行う処理(Delegate処理)
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("\(indexPath.row)行目を選択")
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
		dateFormatter.dateFormat = "M/dd"
		let dateString: String = dateFormatter.stringFromDate(date)
		return dateString
	}
	

	
	

	
	
	
	
	
	
	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }

}
