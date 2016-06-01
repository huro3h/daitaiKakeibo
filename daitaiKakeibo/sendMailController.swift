//  sendMailController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData

class sendMailController: UIViewController {
	
//	var dataArray: [String] = []
	let now = NSDate()
	let df = NSDateFormatter()
	
	var catchStartDate: String = "2000-01-01"
	var catchEndDate: String = "2000-01-01"
	var catchStartDate2: NSDate = NSDate()
	var catchEndDate2: NSDate = NSDate()
	
	var foodFeeCount: Int = 0
	var lifeFeeCount: Int = 0
	var zappiFeeCount: Int = 0
	var hokaFeeCount: Int = 0
	var totalFeeCount: Int = 0
	
	var shareTextArray: [String] = []
	
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
		startDatePicker.date = df.dateFromString("2016/06/01")!
		endDatePicker.date = df.dateFromString("2016/06/19")!
		// 選択可能範囲設定
		startDatePicker.minimumDate = df.dateFromString("2000/01/01")
		startDatePicker.maximumDate = df.dateFromString("2045/12/31")
		endDatePicker.minimumDate = df.dateFromString("2000/01/01")
		endDatePicker.maximumDate = df.dateFromString("2045/12/31")
		
		// startDatePicker.date = now
		// endDatePicker.date = now
	}

	override func viewWillAppear(animated: Bool) {
		print("sendMail画面表示")
	}
	
	@IBAction func changeFromPicker(sender: UIDatePicker) {
		let selectedStartDate: NSString = df.stringFromDate(sender.date)
		catchStartDate = selectedStartDate as String
	}
	
	@IBAction func changeUntilPicker(sender: UIDatePicker) {
		let selectedEndDate: NSString = df.stringFromDate(sender.date)
		catchEndDate = selectedEndDate as String
	}
	
	
	@IBAction func tapBtnLimited(sender: UIButton) {
		shareTextArray.append("日付,食費,生活費,雑費,その他,小計")
		sendPartData()
		// メールの最終行に合計値追加
		shareTextArray.append("合計,\(foodFeeCount),\(lifeFeeCount),\(zappiFeeCount),\(hokaFeeCount),\(totalFeeCount)")
		myActivity()
		// print(shareTextArray)
	}
	
	@IBAction func tapBtnAll(sender: UIButton) {
		shareTextArray.append("日付,食費,生活費,雑費,その他,小計")
		sendAllData()
		// メールの最終行に合計値追加
		shareTextArray.append("合計,\(foodFeeCount),\(lifeFeeCount),\(zappiFeeCount),\(hokaFeeCount),\(totalFeeCount)")
		myActivity()
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
//					print("日時:\(accountBook.inputDate), 食費:\(accountBook.foodFee)")
					
					// 用意した変数に各項目を配列の形で代入
					let fixDate = dateString(accountBook.inputDate!)
//					let myFoods = String(accountBook.foodFee!)
//					let myLifes = String(accountBook.lifeFee!)
//					let myZappies = String(accountBook.zappiFee!)
//					let myHokas = String(accountBook.hokaFee!)
//					let myTotals = String(accountBook.totalFee!)
//					dataArray.append("\(fixDate)\(myFoods)\(myLifes)\(myZappies)\(myHokas)\(myTotals)")
				}
				
			} catch let error1 as NSError {
				error = error1
			}
		}
	}
	
	func sendPartData () {
		// CoreData期間指定
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
			// 並び順を指定 ascending: true - falseで降順-昇順切り替え
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "inputDate", ascending: true)]
			
			let predicate = NSPredicate(format: "(inputDate >= %@)and(inputDate <= %@)", catchStartDate2, catchEndDate2Plus1Day)
			// print(predicate)
			fetchRequest.predicate = predicate
			var error: NSError? = nil
			
			do {
				let results = try managedObjectContext.executeFetchRequest(fetchRequest)
				print(results.count)
				for managedObject in results{
					let accountBook = managedObject as! AccountBook
					// managedObjectContext.deleteObject(managedObject as! NSManagedObject)
					// appDelegate.saveContext()
					print(accountBook.totalFee)
					let myDate = dateString(accountBook.inputDate!)
					let myFoods = accountBook.foodFee!
					let myLifes = accountBook.lifeFee!
					let myZappies = accountBook.zappiFee!
					let myHokas = accountBook.hokaFee!
					let myTotals = accountBook.totalFee!
					shareTextArray.append("\(myDate),\(myFoods),\(myLifes),\(myZappies),\(myHokas),\(myTotals)")
					
					// 選択した範囲の合計値をメールの一番下に追加する為、各値の合計を代入
					foodFeeCount += (accountBook.foodFee! as Int)
					lifeFeeCount += (accountBook.lifeFee! as Int)
					zappiFeeCount += (accountBook.zappiFee! as Int)
					hokaFeeCount += (accountBook.hokaFee! as Int)
					totalFeeCount += (accountBook.totalFee! as Int)
					
					// shareTextArray = ["\(accountBook)"]
				}
				
			} catch let error1 as NSError {
				error = error1
			}
		}
	}
	
	func sendAllData () {
		// CoreData期間指定
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		if let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext {
			let entityDiscription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			fetchRequest.entity = entityDiscription
			
			// 並び順を指定 ascending: true - falseで降順-昇順切り替え
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "inputDate", ascending: true)]
			
			// データをNSDate型に変換
			// catchStartDate2 = df.dateFromString(catchStartDate)!
			// catchEndDate2 = df.dateFromString(catchEndDate)!
			// catchEndDate2に 23:59:59 加算
			// let catchEndDate2Plus1Day: NSDate = NSDate(timeInterval:24*60*60-1, sinceDate:catchEndDate2)
			
			// let predicate = NSPredicate(format: "(inputDate >= %@)and(inputDate <= %@)", catchStartDate2, catchEndDate2Plus1Day)
			// print(predicate)
			// fetchRequest.predicate = predicate
			var error: NSError? = nil
			
			do {
				let results = try managedObjectContext.executeFetchRequest(fetchRequest)
				print(results.count)
				for managedObject in results{
					let accountBook = managedObject as! AccountBook
					//					managedObjectContext.deleteObject(managedObject as! NSManagedObject)
					//					appDelegate.saveContext()
					print(accountBook.totalFee)
					let myDate = dateString(accountBook.inputDate!)
					let myFoods = accountBook.foodFee!
					let myLifes = accountBook.lifeFee!
					let myZappies = accountBook.zappiFee!
					let myHokas = accountBook.hokaFee!
					let myTotals = accountBook.totalFee!
					shareTextArray.append("\(myDate),\(myFoods),\(myLifes),\(myZappies),\(myHokas),\(myTotals)")
					// shareTextArray = ["\(accountBook)"]
					
					// 選択した範囲の合計値をメールの一番下に追加する為、各値の合計を代入
					foodFeeCount += (accountBook.foodFee! as Int)
					lifeFeeCount += (accountBook.lifeFee! as Int)
					zappiFeeCount += (accountBook.zappiFee! as Int)
					hokaFeeCount += (accountBook.hokaFee! as Int)
					totalFeeCount += (accountBook.totalFee! as Int)
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
	
	func myActivity() {
		// 共有したい情報を格納する配列
		let activityItems = shareTextArray
		
		// 初期化処理
		let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		
		// 使用しないアクティビティタイプ(出さないやつをここに書く)
		let excludedActivityTypes = [
			UIActivityTypePostToWeibo,
			UIActivityTypeSaveToCameraRoll,
			UIActivityTypePrint
		]
		activityVC.excludedActivityTypes = excludedActivityTypes
		
		// UIActivityViewControllerを表示
		// 下の一文がないと表示されない
		presentViewController(activityVC, animated: true, completion: nil)
	}
	
	
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
}
