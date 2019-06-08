//  eraseController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData
import FontAwesomeKit

class eraseController: UIViewController {

	var dataArray: [String] = []
	let now = Date()
	let df = DateFormatter()
	
	// 以下4行期間指定削除で使う変数
	// datePickerからString型で日付を取得し以下2行の変数に代入
	var catchStartDate: String = "2000-01-01"
	var catchEndDate: String = "2000-01-01"
	
	// 次の2行は先のデータをString型->NSDate型に変更した後に入れておく変数
	var catchStartDate2: Date = Date()
	var catchEndDate2: Date = Date()

	@IBOutlet weak var spacerView: UIView!
	
	@IBOutlet weak var startDatePicker: UIDatePicker!
	@IBOutlet weak var endDatePicker: UIDatePicker!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		read()
		
		// DatePicker設定
		startDatePicker.datePickerMode = UIDatePickerMode.date
		endDatePicker.datePickerMode = UIDatePickerMode.date
		
		df.dateFormat = "yyyy-MM-dd"
		
		catchStartDate = df.string(from: Date(timeInterval:-31*24*60*60, since:Date()))
		catchEndDate = df.string(from: Date())
		
		// 初期表示の日付を設定
		startDatePicker.date = df.date(from: catchStartDate)!
		endDatePicker.date = df.date(from: catchEndDate)!
		// 選択可能範囲設定
		startDatePicker.minimumDate = df.date(from: "2000/01/01")
		startDatePicker.maximumDate = df.date(from: "2045/12/31")
		endDatePicker.minimumDate = df.date(from: "2000/01/01")
		endDatePicker.maximumDate = df.date(from: "2045/12/31")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		print("erase画面表示")
	}

	
	// 期間選択
	@IBAction func changeFromPicker(_ sender: UIDatePicker) {
		let selectedStartDate: NSString = df.string(from: sender.date) as NSString
		catchStartDate = selectedStartDate as String
	}
	
	@IBAction func changeUntilPicker(_ sender: UIDatePicker) {
		let selectedEndDate: NSString = df.string(from: sender.date) as NSString
		catchEndDate = selectedEndDate as String
	}
	
	@IBAction func tapBtnLimited(_ sender: UIButton) {
		let alertController = UIAlertController(title: "データの消去", message: "指定された期間のデータを消去します", preferredStyle: .alert)
		
		alertController.addAction(UIAlertAction(
			title: "消去",
			style: UIAlertActionStyle.destructive,
			handler: { action in self.deletePartData()}))
		
		alertController.addAction(UIAlertAction(
			title: "Cancel",
			style: .cancel,
			handler: { action in self.myCancel()}))
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	@IBAction func tapBtn(_ sender: UIButton) {
		let alertController = UIAlertController(title: "データの消去", message: "全期間のデータを消去しますか？", preferredStyle: .alert)
		
		alertController.addAction(UIAlertAction(
			title: "消去",
			style: UIAlertActionStyle.destructive,
			handler: { action in self.deleteAllData()}))
		
		alertController.addAction(UIAlertAction(
			title: "Cancel",
			style: .cancel,
			handler: { action in self.myCancel()}))
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	// Coredata読込
	func read(){
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		if let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext{
			let entityDescription = NSEntityDescription.entity(forEntityName: "AccountBook", in: managedObjectContext)
			
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountBook")
			fetchRequest.entity = entityDescription
			var error:NSError? = nil
			
			do{
				let results = try managedObjectContext.fetch(fetchRequest)
				
				for managedObject in results {
					let accountBook = managedObject as! AccountBook
					print("日時:\(accountBook.inputDate), 食費:\(accountBook.foodFee)")
					
					// 用意した変数に各項目を配列の形で代入
					let fixDate = dateString(accountBook.inputDate! as Date)
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
	
	func deletePartData () {
		// CoreData期間削除
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		if let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext {
			let entityDiscription = NSEntityDescription.entity(forEntityName: "AccountBook", in: managedObjectContext)
			
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountBook")
			fetchRequest.entity = entityDiscription
			
			// データをNSDate型に変換
			catchStartDate2 = df.date(from: catchStartDate)!
			catchEndDate2 = df.date(from: catchEndDate)!
			// catchEndDate2に 23:59:59 加算
			let catchEndDate2Plus1Day: Date = Date(timeInterval:24*60*60-1, since:catchEndDate2)

			let predicate = NSPredicate(format: "(inputDate >= %@)and(inputDate <= %@)", catchStartDate2 as CVarArg, catchEndDate2Plus1Day as CVarArg)
			// print(predicate)
			fetchRequest.predicate = predicate
			var error: NSError? = nil
			
			do {
				let results = try managedObjectContext.fetch(fetchRequest)
				print(results.count)
				
				for managedObject in results{
					let accountBook = managedObject as! AccountBook
					
					managedObjectContext.delete(managedObject as! NSManagedObject)
					
					appDelegate.saveContext()
				}
			} catch let error1 as NSError {
				error = error1
			}
		}
	}
	
	func deleteAllData (){
		// CoreData全削除
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		if let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext {
			let entityDiscription = NSEntityDescription.entity(forEntityName: "AccountBook", in: managedObjectContext)
			
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AccountBook")
			fetchRequest.entity = entityDiscription
			var error: NSError? = nil
			
			do {
				let results = try managedObjectContext.fetch(fetchRequest)
				print(results.count)
				
				for managedObject in results{
					let accountBook = managedObject as! AccountBook
					
					managedObjectContext.delete(managedObject as! NSManagedObject)
					
					appDelegate.saveContext()
				}
			} catch let error1 as NSError {
				error = error1
			}
		}
	}
	
	// NSDate->String型に変換
	func dateString (_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ja_JP")
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dateString: String = dateFormatter.string(from: date)
		return dateString
	}
	
	func myCancel() {
		print("キャンセル")
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
