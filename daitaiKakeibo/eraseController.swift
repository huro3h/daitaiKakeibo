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
	
	override func viewWillAppear(animated: Bool) {
		print("erase画面表示")
	}
	
	
//	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//		let managedObject: NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as NSManagedObject
//		managedObjectContext?.deleteObject(managedObject)
//		managedObjectContext?.save(nil)
//	}
	
	@IBAction func tapBtn(sender: UIButton) {

		// AppDelegateをコードで読み込み
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		// Entityの操作を制御するmanagedObjectContextをappDelegateから作成
		if let managedObjectContext: NSManagedObjectContext = appDelegate.managedObjectContext {
			// Entityを指定する設定
			let entityDiscription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			
			fetchRequest.entity = entityDiscription
			
			
			// 全件削除処理をするにはNSPredicate()に何を書けば？
			// 全件削除したい場合は下の条件指定ごとなくすと、無条件で全部取ってくるようになる！
//			let predicate = NSPredicate(format: whereString, argumentArray: nil)
//			fetchRequest.predicate = predicate
			
			var error: NSError? = nil
			
			// フェッチリクエストの実行
			do {
				let results = try managedObjectContext.executeFetchRequest(fetchRequest)
				print(results.count)
				
				for managedObject in results{
					let accountBook = managedObject as! AccountBook
					print("日時:\(accountBook.inputDate), 食費:\(accountBook.foodFee), 生活費:\(accountBook.lifeFee), 雑費:\(accountBook.zappiFee), 他:\(accountBook.hokaFee), 合計:\(accountBook.totalFee)")
					// 削除処理の本体
					managedObjectContext.deleteObject(managedObject as! NSManagedObject)
					// 削除したことも忘れず保存！（でないと反映されない）
					appDelegate.saveContext()
				}
			} catch let error1 as NSError {
				error = error1
			}
		}
	}

	func read(){
		
		// a1.AppDelegateをコードで読み込む
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		
		// a2.Entityの操作を制御する(managedObjectContext)を(appDelegate)から作成
		if let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext{
			
			// a3.Entityを指定する設定
			let entityDescription = NSEntityDescription.entityForName("AccountBook", inManagedObjectContext: managedObjectContext)
			
			// a4.フェッチに必要なオブジェクトを準備
			let fetchRequest = NSFetchRequest(entityName: "AccountBook")
			
			fetchRequest.entity = entityDescription
			
			// a5.エラーが発生した際にキャッチするための変数
			var error:NSError? = nil
			
			// a6.フェッチリクエスト(データの検索と取得処理)の実行
			// 最初は短く書いて、後からスペースを入れることによってインデントが綺麗に治る
			// do{}catch let error1 as NSError{ error = error1 }
			// php であった try! catch と同じ役目
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
	
	
	
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	

}
