//  listController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData

class listController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

	var myTimes: [NSDate] = []
	var myFoods: [NSNumber] = []
	var myLifes: [NSNumber] = []
	var myZappies: [NSNumber] = []
	var myHokas: [NSNumber] = []
	var myTotals: [NSNumber] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// CoreDataから読み込み
		read()
    }
	
	override func viewWillAppear(animated: Bool) {
		print("List画面表示")
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myTimes.count // 入れたい行数(10行)
	}
	
	// 2.行に表示する内容をリセット
	// returnで入る物、int型(引数) -> 戻り値のデータ型
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("myCell")! as UITableViewCell
		
		let label1 = cell.viewWithTag(1) as! UILabel
		label1.text = "myTimes(indexPath.row)"
		
		let label2 = cell.viewWithTag(2) as! UILabel
		label2.text = "\(indexPath.row)"
		
		let label3 = cell.viewWithTag(3) as! UILabel
		label3.text = "\(indexPath.row)"
		
		let label4 = cell.viewWithTag(4) as! UILabel
		label4.text = "\(indexPath.row)"
		
		let label5 = cell.viewWithTag(5) as! UILabel
		label5.text = "\(indexPath.row)"
		
		let label6 = cell.viewWithTag(6) as! UILabel
		label6.text = "\(indexPath.row)"
		
		return cell
	}
	
	@objc func tableView(tableView: UITableView, heightForRowAtIndexPath IndexPath: NSIndexPath) -> CGFloat{
		return 15
	}
	// 3.選択された時に行う処理(Delegate処理)
	// 似た名前がたくさんあるので間違えないように注意！
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("\(indexPath.row)行目を選択")
	}
	

	func read(){

		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		
		if let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext{
			
			let entityDescription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			fetchRequest.entity = entityDescription
			
			var error:NSError? = nil

			do{
				let results = try managedObjectContext.executeFetchRequest(fetchRequest)
				
				//　a7.保存した件数をprint表示
				print(results.count)
				
				for managedObject in results {
					let accountBook = managedObject as! AccountBook
					
					myTimes.append(accountBook.inputDate!)
					myFoods.append(accountBook.foodFee!)
					myLifes.append(accountBook.lifeFee!)
					myZappies.append(accountBook.zappiFee!)
					myHokas.append(accountBook.hokaFee!)
					myTotals.append(accountBook.totalFee!)

					//print("日時:\(accountBook.inputDate), 食費:\(accountBook.foodFee), 生活費:\(accountBook.lifeFee), 雑費:\(accountBook.zappiFee), 他:\(accountBook.hokaFee), 合計:\(accountBook.totalFee)")
				}
				
			}catch let error1 as NSError{
				error = error1
			}
			
		}
	print(myFoods)
	print(myTimes)
	}

	
	

	
	
	
	
	
	
	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }

}
