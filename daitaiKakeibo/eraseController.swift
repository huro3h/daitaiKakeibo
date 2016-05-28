//  eraseController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData

class eraseController: UIViewController {

	var dataArray: [String] = []
	var catchFromDate: String = ""
	var catchUntilDate: String = ""
	let now = NSDate()
	let df = NSDateFormatter()
	
	@IBOutlet weak var fromDatePicker: UIDatePicker!
	@IBOutlet weak var untilDatePicker: UIDatePicker!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		read()
		
		// DatePicker設定
		fromDatePicker.datePickerMode = UIDatePickerMode.Date
		untilDatePicker.datePickerMode = UIDatePickerMode.Date
		
		df.dateFormat = "yyyy/MM/dd"
		fromDatePicker.date = df.dateFromString("2016/04/01")!
		fromDatePicker.minimumDate = df.dateFromString("2000/01/01")
		fromDatePicker.maximumDate = df.dateFromString("2045/12/31")
		untilDatePicker.date = df.dateFromString("2016/04/01")!
		untilDatePicker.minimumDate = df.dateFromString("2000/01/01")
		untilDatePicker.maximumDate = df.dateFromString("2045/12/31")
		
		// 今日の日付取得
		fromDatePicker.date = now
		untilDatePicker.date = now
	}
	
	// 期間選択
	@IBAction func changeFromPicker(sender: UIDatePicker) {
		let selectedFromDate: NSString = df.stringFromDate(sender.date)
		catchFromDate = selectedFromDate as String
		print(catchFromDate)
	}
	
	@IBAction func changeUntilPicker(sender: UIDatePicker) {
		let selectedUntilDate: NSString = df.stringFromDate(sender.date)
		catchUntilDate = selectedUntilDate as String
		print(catchUntilDate)
	}
	
	
	override func viewWillAppear(animated: Bool) {
		print("erase画面表示")
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
					//let fixDate = dateString(accountBook.inputDate!)
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
	
	func deletePartData (){
		// CoreData期間削除
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		if let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext {
			let entityDiscription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			fetchRequest.entity = entityDiscription
			
			// 以下の2行で期間指定
			let predicate = NSPredicate(format: "%K = %@", "title", "hogehoge")
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
