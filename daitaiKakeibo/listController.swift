//  listController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import CoreData

class listController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// CoreDataから読み込み
		read()
    }
	
	override func viewWillAppear(animated: Bool) {
		print("List画面表示")
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 30 // 入れたい行数(10行)
	}
	
	// 2.行に表示する内容をリセット
	// returnで入る物、int型(引数) -> 戻り値のデータ型
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("myCell")! as UITableViewCell
		
		let label1 = cell.viewWithTag(1) as! UILabel
		label1.text = "\(indexPath.section)"
		
		let label2 = cell.viewWithTag(2) as! UILabel
		label2.text = "\(indexPath.row)"
		
		let label3 = cell.viewWithTag(3) as! UILabel
		label3.text = "\(indexPath.row)"
		return cell
	}
	
	@objc func tableView(tableView: UITableView, heightForRowAtIndexPath IndexPath: NSIndexPath) -> CGFloat{
		return 20.0
	}
	// 3.選択された時に行う処理(Delegate処理)
	// 似た名前がたくさんあるので間違えないように注意！
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("\(indexPath.row)行目を選択")
	}
	
	// すでに存在するデータの読み込み処理
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
				
				//　a7.保存した件数をprint表示
//				print(results.count)
				
				for managedObject in results {
					let accountBook = managedObject as! AccountBook
					
					print("日時:\(accountBook.inputDate), 食費:\(accountBook.foodFee), 生活費:\(accountBook.lifeFee), 雑費:\(accountBook.zappiFee), 他:\(accountBook.hokaFee), 合計:\(accountBook.totalFee)")
				}
				
			}catch let error1 as NSError{
				error = error1
			}
			
		}
	}

	
	

	
	
	
	
	
	
	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }

}
