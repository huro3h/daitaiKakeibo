//  eraseController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData

class eraseController: UIViewController {

	var dataArray: [String] = []
	var catchStartDate: String = ""
	var catchEndDate: String = ""
	let now = NSDate()
	let df = NSDateFormatter()
	
	@IBOutlet weak var startDatePicker: UIDatePicker!
	@IBOutlet weak var endDatePicker: UIDatePicker!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		read()
		
		// DatePicker設定
		startDatePicker.datePickerMode = UIDatePickerMode.Date
		endDatePicker.datePickerMode = UIDatePickerMode.Date
		
		df.dateFormat = "yyyy-MM-dd"
		startDatePicker.date = df.dateFromString("2016/04/01")!
		startDatePicker.minimumDate = df.dateFromString("2000/01/01")
		startDatePicker.maximumDate = df.dateFromString("2045/12/31")
		endDatePicker.date = df.dateFromString("2016/04/01")!
		endDatePicker.minimumDate = df.dateFromString("2000/01/01")
		endDatePicker.maximumDate = df.dateFromString("2045/12/31")
		
		// 今日の日付取得
		startDatePicker.date = now
		endDatePicker.date = now
	}
	
	override func viewWillAppear(animated: Bool) {
		print("erase画面表示")
	}

	
	// 期間選択
	@IBAction func changeFromPicker(sender: UIDatePicker) {
		let selectedStartDate: NSString = df.stringFromDate(sender.date)
		catchStartDate = selectedStartDate as String
		print(catchStartDate)
	}
	
	@IBAction func changeUntilPicker(sender: UIDatePicker) {
		let selectedEndDate: NSString = df.stringFromDate(sender.date)
		catchEndDate = selectedEndDate as String
		print(catchEndDate)
	}
	

	@IBAction func tapBtnLimited(sender: UIButton) {
		let alertController = UIAlertController(title: "データの消去", message: "指定された期間のデータを消去します", preferredStyle: .Alert)
		
		alertController.addAction(UIAlertAction(
			title: "消去",
			style: UIAlertActionStyle.Destructive,
			handler: { action in self.deletePartData()}))
		
		alertController.addAction(UIAlertAction(
			title: "Cancel",
			style: .Cancel,
			handler: { action in self.myCancel()}))
		
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	@IBAction func tapBtn(sender: UIButton) {
		let alertController = UIAlertController(title: "データの消去", message: "全期間のデータを消去しますか？", preferredStyle: .Alert)
		
		alertController.addAction(UIAlertAction(
			title: "消去",
			style: UIAlertActionStyle.Destructive,
			handler: { action in self.deleteAllData()}))
		
		alertController.addAction(UIAlertAction(
			title: "Cancel",
			style: .Cancel,
			handler: { action in self.myCancel()}))
		
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	// Coredata読込
	func read(){
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		if let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext{
			let entityDescription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			fetchRequest.entity = entityDescription
			var error:NSError? = nil
			
			do{
				let results = try managedObjectContext.executeFetchRequest(fetchRequest)
				
				for managedObject in results {
					let accountBook = managedObject as! AccountBook
					print("日時:\(accountBook.inputDate), 食費:\(accountBook.foodFee)")
					
					// 用意した変数に各項目を配列の形で代入
					let fixDate = dateString(accountBook.inputDate!)
					//let myFoods = String(accountBook.foodFee!)
					//let myLifes = String(accountBook.lifeFee!)
					//let myZappies = String(accountBook.zappiFee!)
					//let myHokas = String(accountBook.hokaFee!)
					//let myTotals = String(accountBook.totalFee!)
					
					//dataArray.append("\(fixDate)\(myFoods)\(myLifes)\(myZappies)\(myHokas)\(myTotals)")
					
				}
			} catch let error1 as NSError {
				error = error1
			}
		}
	}
	
	// CoreDataから日付を検索するやり方 ?
//	CoreDataのNSPredicateで日付を検索する方法を教えて下さい
//	
//	例えばCoreDataで"Data"というエンティティを作成したとして、
//	その中にType：DateのAttribute、"day"を作成したとします。
//	そして特定の日付(時間は無視します)のdayを引っ張ろうと試みた時に、次のようなコードとなりました。

//	let predicate = NSPredicate(format: "%K = ?????", "day", ?????)

//	 let calendar :NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
//	 let targetedDay :NSDate! = calendar.dateWithEra(1, year: 2015, month: 5, day: 12, hour: 0, minute: 0, second: 0, nanosecond: 0)
//	 let predicate = NSPredicate(format: "SELF.day BETWEEN {%@ , %@}", targetedDay, NSDate(timeInterval: 24*60*60-1, sinceDate: targetedDay))
	
//	例えば、特定のNSDateを作って、そこからの24時間-1秒をBETWEENで取るという手があります。
//	dayのattributeには、SELF.dayを使います。
//	ミリ秒までデータがあるならば、SELF.day >= %@ AND SELF.day < %@で厳密に期間判定をした方が良いです。
	
	func deletePartData (){
	
		// 目的の日時と比較させる日付作成(2016年5月1日から今日が何日目かをカウントさせる)
		let calendar :NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
		let targetedDay :NSDate! = calendar.dateWithEra(1, year: 2016, month: 5, day: 29, hour: 0, minute: 0, second: 0, nanosecond: 0)
		
		// CoreData期間削除
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		if let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext {
			let entityDiscription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			fetchRequest.entity = entityDiscription
			
			// 以下の2行でデータ削除期間の指定
//			 let predicate = NSPredicate(format: "%K = ?????", "inputDate", "2016-05-29")
			let predicate = NSPredicate(format: "SELF.day BETWEEN {%@ , %@}", targetedDay, NSDate(timeInterval: 24*60*60-1, sinceDate: targetedDay))
			print(predicate)
			fetchRequest.predicate = predicate
			var error: NSError? = nil
			
			do {
				let results = try managedObjectContext.executeFetchRequest(fetchRequest)
				print(results.count)
				
				for managedObject in results{
					let accountBook = managedObject as! AccountBook
					
					managedObjectContext.deleteObject(managedObject as! NSManagedObject)
					
					appDelegate.saveContext()
				}
			} catch let error1 as NSError {
				error = error1
			}
		}
	}
	
	func deleteAllData (){
		// CoreData全削除
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		if let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext {
			let entityDiscription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			fetchRequest.entity = entityDiscription
			var error: NSError? = nil
			
			do {
				let results = try managedObjectContext.executeFetchRequest(fetchRequest)
				print(results.count)
				
				for managedObject in results{
					let accountBook = managedObject as! AccountBook
					
					managedObjectContext.deleteObject(managedObject as! NSManagedObject)
					
					appDelegate.saveContext()
				}
			} catch let error1 as NSError {
				error = error1
			}
		}
	}
	
	// NSDate->String型に変換
	func dateString (date: NSDate) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
		// dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
		dateFormatter.dateFormat = "M/dd"
		let dateString: String = dateFormatter.stringFromDate(date)
		return dateString
	}
	
	func myCancel() {
		print("キャンセル")
	}
	
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	

}
