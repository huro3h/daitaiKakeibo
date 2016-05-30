//  eraseController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData

class eraseController: UIViewController {

	var dataArray: [String] = []
	let now = NSDate()
	let df = NSDateFormatter()
	
	// 以下4行期間指定削除で使う変数
	// datePickerからString型で日付を取得し以下2行の変数に代入
	var catchStartDate: String = "2000-01-01"
	var catchEndDate: String = "2000-01-01"
	
	// 次の2行は先のデータをString型->NSDate型に変更した後に入れておく変数
	var catchStartDate2: NSDate = NSDate()
	var catchEndDate2: NSDate = NSDate()
	
	@IBOutlet weak var startDatePicker: UIDatePicker!
	@IBOutlet weak var endDatePicker: UIDatePicker!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		read()
		
		// DatePicker設定
		startDatePicker.datePickerMode = UIDatePickerMode.Date
		endDatePicker.datePickerMode = UIDatePickerMode.Date
		
		df.dateFormat = "yyyy-MM-dd"
		// 初期表示の日付を設定
		startDatePicker.date = df.dateFromString("2016/01/01")!
		endDatePicker.date = df.dateFromString("2016/01/01")!
		// 選択可能範囲設定
		startDatePicker.minimumDate = df.dateFromString("2000/01/01")
		startDatePicker.maximumDate = df.dateFromString("2045/12/31")
		endDatePicker.minimumDate = df.dateFromString("2000/01/01")
		endDatePicker.maximumDate = df.dateFromString("2045/12/31")
		
		// startDatePicker.date = now
		// endDatePicker.date = now
	}
	
	override func viewWillAppear(animated: Bool) {
		print("erase画面表示")
	}

	
	// 期間選択
	@IBAction func changeFromPicker(sender: UIDatePicker) {
		let selectedStartDate: NSString = df.stringFromDate(sender.date)
		catchStartDate = selectedStartDate as String
	}
	
	@IBAction func changeUntilPicker(sender: UIDatePicker) {
		let selectedEndDate: NSString = df.stringFromDate(sender.date)
		catchEndDate = selectedEndDate as String
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

//	 let calendar :NSCalendar! = NSCalendar(identifier: NSCalendarIdentifierGregorian)
//	 let targetedDay :NSDate! = calendar.dateWithEra(1, year: 2015, month: 5, day: 12, hour: 0, minute: 0, second: 0, nanosecond: 0)
//	 let predicate = NSPredicate(format: "SELF.day BETWEEN {%@ , %@}", targetedDay, NSDate(timeInterval: 24*60*60-1, sinceDate: targetedDay))
//	例えば、特定のNSDateを作って、そこからの24時間-1秒をBETWEENで取るという手があります。
//	dayのattributeには、SELF.dayを使います。
//	ミリ秒までデータがあるならば、SELF.day >= %@ AND SELF.day < %@で厳密に期間判定をした方が良いです。
	
	func deletePartData (){
		
		// CoreData期間削除
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		if let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext {
			let entityDiscription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			fetchRequest.entity = entityDiscription
			
			// データをNSDate型に変換
			catchStartDate2 = df.dateFromString(catchStartDate)!
			catchEndDate2 = df.dateFromString(catchEndDate)!
			// catchEndDate2に 23:59:59 加算
			let catchEndDate2Plus1Day: NSDate = NSDate(timeInterval:24*60*60-1, sinceDate:catchEndDate2)

			let predicate = NSPredicate(format: "(inputDate >= %@)and(inputDate <= %@)", catchStartDate2, catchEndDate2Plus1Day)
			// print(predicate)
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
		dateFormatter.dateFormat = "yyyy-MM-dd"
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
