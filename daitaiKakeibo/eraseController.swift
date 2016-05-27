//  eraseController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData

class eraseController: UIViewController {

	var dataArray: [String] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		read()

	}
	
	@IBOutlet weak var fromPicker: UIPickerView!
	@IBOutlet weak var untilPicker: UIPickerView!
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return dataArray.count
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return dataArray[row]
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let i = row+1
		print("選択されたのは\(i)行目の\(dataArray[row])です")
	}
	
	
	override func viewWillAppear(animated: Bool) {
		print("erase画面表示")
	}

	@IBAction func tapBtnLimited(sender: UIButton) {
		let alertController = UIAlertController(title: "データの消去", message: "指定された期間のデータを消去します", preferredStyle: .Alert)
		
		alertController.addAction(UIAlertAction(
			title: "消去",
			style: UIAlertActionStyle.Destructive,
			handler: { action in self.deleteData()}))
		
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
			handler: { action in self.deleteData()}))
		
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
					let myFoods = String(accountBook.foodFee!)
					let myLifes = String(accountBook.lifeFee!)
					let myZappies = String(accountBook.zappiFee!)
					let myHokas = String(accountBook.hokaFee!)
					let myTotals = String(accountBook.totalFee!)
					
					dataArray.append("\(fixDate)\(myFoods)\(myLifes)\(myZappies)\(myHokas)\(myTotals)")
					
				}
			} catch let error1 as NSError {
				error = error1
			}
		}
	}
	
	func deleteData (){
		// CoreData削除
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
