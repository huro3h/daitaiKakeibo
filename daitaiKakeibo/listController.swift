//  listController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit

class listController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
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

	
	
	
	
	
	
	
	
	
	
	
	
	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }

}
