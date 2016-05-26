//  eraseController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData

class eraseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		read()
	}
	
	@IBOutlet weak var fromPicker: UIPickerView!
	@IBOutlet weak var untilPicker: UIPickerView!
	
	override func viewWillAppear(animated: Bool) {
		print("erase画面表示")
	}

	@IBAction func tapBtn(sender: UIButton) {
		let alertController = UIAlertController(title: "注意", message: "全期間のデータを削除しますか？", preferredStyle: .Alert)
		
		alertController.addAction(UIAlertAction(
			title: "削除",
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
					
					print("日時:\(accountBook.inputDate), 食費:\(accountBook.foodFee), 生活費:\(accountBook.lifeFee), 雑費:\(accountBook.zappiFee), 他:\(accountBook.hokaFee), 合計:\(accountBook.totalFee)")
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
					print("日時:\(accountBook.inputDate), 食費:\(accountBook.foodFee), 生活費:\(accountBook.lifeFee), 雑費:\(accountBook.zappiFee), 他:\(accountBook.hokaFee), 合計:\(accountBook.totalFee)")
					managedObjectContext.deleteObject(managedObject as! NSManagedObject)
					
					appDelegate.saveContext()
				}
			} catch let error1 as NSError {
				error = error1
			}
		}
	}
	
	func myCancel() {
		print("キャンセル")
	}
	
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	

}
