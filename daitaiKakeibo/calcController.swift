//  ViewController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/13.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import QuartzCore
import CoreData

class BorderButton: UIButton {
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!;
		layer.cornerRadius = 0;  // ボタンの角の半径
		layer.borderWidth = 0.5;  // ボタンの枠線の太さ
		layer.borderColor = UIColor.darkGrayColor().CGColor;
	}
}

class calcController: UIViewController {

	// 結果を表示するテキストフィールド
	@IBOutlet weak var display: UITextField!
	// 実際に数字を確認するテキストラベル
	@IBOutlet weak var displayLabel: UILabel!
	
	@IBOutlet weak var foodLabel: UILabel!
	@IBOutlet weak var foodField: UIView!
	@IBOutlet weak var lifeLabel: UILabel!
	@IBOutlet weak var lifeField: UIView!
	@IBOutlet weak var zappiLabel: UILabel!
	@IBOutlet weak var zappiField: UIView!
	@IBOutlet weak var hokaLabel: UILabel!
	@IBOutlet weak var hokaField: UIView!
	
	var startPoint: CGPoint?
	var imageBeHereNowPoint: CGPoint?
	var isImageInside: Bool?
	
	var foodArray:[Int] = []
	var foodTotal = 0
	var lifeArray:[Int] = []
	var lifeTotal = 0
	var zappiArray:[Int] = []
	var zappiTotal = 0
	var hokaArray:[Int] = []
	var hokaTotal = 0
	
	var allTotal = 0
	
//	@IBAction func myGesAction(sender: UIPanGestureRecognizer) {
//		let move = sender.translationInView(view)
//		self.displayLabel.center.x = self.displayLabel.center.x + move.x
//		self.displayLabel.center.y = self.displayLabel.center.y + move.y
	
		
//		sender.view!.center = CGPoint(x: sender.view!.center.x + move.x*0.05, y: sender.view!.center.y + move.y*0.02)
		// displayLabel.center = move
		
		
//		@IBAction func panYellowView(sender: UIPanGestureRecognizer) {
//			
//			let translation = sender.translationInView(self.view)
//			
//			sender.displayLabel.center = CGPoint(x: sender.displayLabel.center.x + move.x, y: sender.displayLabel.center.y + move.y)
//			
//			sender.setTranslation(CGPointZero, inView: self.view)
//			
//		}

//	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// 画像のタッチ操作を有効にする
		displayLabel.userInteractionEnabled = true
	}
	
	override func viewWillAppear(animated: Bool) {
		let myDefault = NSUserDefaults.standardUserDefaults()
			if (myDefault.arrayForKey("fourTotal") != nil){
				
				var fourTotal: Array? = myDefault.arrayForKey("fourTotal")!
		
				if (fourTotal!.count == 4){
					
					foodTotal = fourTotal![0] as! Int
					lifeTotal = fourTotal![1] as! Int
					zappiTotal = fourTotal![2] as! Int
					hokaTotal = fourTotal![3] as! Int
					
					allTotal = foodTotal+lifeTotal+zappiTotal+hokaTotal
					print(allTotal)
				
				let foodString : String = String(foodTotal)
					foodLabel.text = foodString
				let lifeString : String = String(lifeTotal)
					lifeLabel.text = lifeString
				let zappiString : String = String(zappiTotal)
					zappiLabel.text = zappiString
				let hokaString : String = String(hokaTotal)
					hokaLabel.text = hokaString
				
				}else{
				 // 上の処理を無視！ \( 'ω')/
				}
			}
	}
	
	@IBAction func tapFoodField(sender: UITapGestureRecognizer) {
		// print("foodFieldたっぷ！")
		
		// 配列にInt型の値が入るように変更
		let foodInt: Int = Int(displayLabel.text!)!
		foodArray.append(foodInt)
		print(foodArray)
		foodTotal = foodArray.reduce(0) { (num1, num2) -> Int in
			num1 + num2
		}
		let foodString : String = String(foodTotal)
		foodLabel.text? = foodString
		userDefaultMemory()
//		bufferNumber = 0
//		nextOperation = nil
		display.text! = "0"
		displayLabel.text! = display.text!
//		getDisplayInt()
		
	}
	
	@IBAction func tapLifeField(sender: UITapGestureRecognizer) {
		
		let lifeInt: Int = Int(displayLabel.text!)!
		lifeArray.append(lifeInt)
		print(lifeArray)
		lifeTotal = lifeArray.reduce(0) { (num1, num2) -> Int in
			num1 + num2
		}
		let lifeString : String = String(lifeTotal)
		lifeLabel.text! = lifeString
		userDefaultMemory()
	}
	
	@IBAction func tapZappiField(sender: UITapGestureRecognizer) {
		
		let zappiInt: Int = Int(displayLabel.text!)!
		zappiArray.append(zappiInt)
		print(zappiArray)
		zappiTotal = zappiArray.reduce(0) { (num1, num2) -> Int in
			num1 + num2
		}
		let zappiString : String = String(zappiTotal)
		zappiLabel.text! = zappiString
		userDefaultMemory()
	}
	
	@IBAction func tapHokaField(sender: UITapGestureRecognizer) {
		
		let hokaInt: Int = Int(displayLabel.text!)!
		hokaArray.append(hokaInt)
		print(hokaArray)
		hokaTotal = hokaArray.reduce(0) { (num1, num2) -> Int in
			num1 + num2
		}
		let hokaString : String = String(hokaTotal)
		hokaLabel.text! = hokaString
		userDefaultMemory()
		
	}
	
	
	// Labelタッチ判定テスト ここから↓↓ (5.22-)
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch: UITouch = touches.first! as UITouch
		
		startPoint = touch.locationInView(self.view) // タッチの開始座標を取得
		imageBeHereNowPoint = displayLabel.frame.origin // 開始時の画像の座標を取得
		
		// タップしたビューがUILabelか判断する。
		if touch.view!.isKindOfClass(UILabel) {
			isImageInside = true
		} else {
			isImageInside = false
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if isImageInside! {
			// タッチ中のLabelの座標を取得
			let touch = touches.first! as UITouch
			let location = touch.locationInView(self.view)
			
			// 移動量を計算
			let deltaX: CGFloat = CGFloat(location.x - startPoint!.x)
			let deltaY: CGFloat = CGFloat(location.y - startPoint!.y)
			
			// Labelを半透過にする
			displayLabel.layer.opacity = 0.6
			
			// Labelを移動
			self.displayLabel.frame.origin.x = imageBeHereNowPoint!.x + deltaX
			self.displayLabel.frame.origin.y = imageBeHereNowPoint!.y + deltaY
			
		} else {
			// Do nothing
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		// タッチ終了時の画像の座標と目標Areaの座標の距離を求める
//		let distanceXFromDestination = fabs(imageBeHereNow.frame.origin.x - imageDestinationArea.frame.origin.x)
//		let distanceYFromDestination = fabs(imageBeHereNow.frame.origin.y - imageDestinationArea.frame.origin.y)
//		
//		let threshold: CGFloat = 100
//		
//		if distanceXFromDestination < threshold && distanceYFromDestination < threshold {
//			// アニメーションで目標Areaに吸着させる
//			print("perform animation to imageDestinationArea")
		
		// 指を離したタイミングでLabelの透過解除
		displayLabel.layer.opacity = 1.0
		
		
			
//			let fromPoint: CGPoint = imageBeHereNow.center
//			let toPoint: CGPoint = imageDestinationArea.center
//			positonAnimationFromPoint(fromPoint, toPoint: toPoint)
//			
//			imageBeHereNow.center = imageDestinationArea.center         // イメージを移動
		
	}
	// Labelタッチ判定テスト ここまで↑↑(5.22-)
	
		var isTypingNumber = false  // 数字をタイプ中か
		var bufferNumber : Int = 0  // 計算中の数値
		var nextOperation : String?   // 次に演算する操作　+, -
	
		// 数字キーが押されたとき
		@IBAction func digit(sender: UIButton) {
			// ログに表示
			print("pushed \(sender.currentTitle)")
			
			if isTypingNumber {
				let digit: Int = Int(sender.currentTitle!)!
				display.text = String(Int(display.text!)! + digit)
			} else {
				display.text = sender.currentTitle!
				isTypingNumber = true
			}
			
			displayLabel.text! = display.text!
		}
		
		// 操作キー（+-×÷=C★!D）が押されたとき
		@IBAction func operation(sender: UIButton) {
			// ログに表示
			print("pushed \(sender.currentTitle)")
			
			if sender.currentTitle == "C" {
				bufferNumber = 0
				nextOperation = nil
				
			} else {
				if nextOperation == nil {
					//はじめて演算キーを押したとき
					bufferNumber = getDisplayInt()
				} else if nextOperation == "+" {
					//前回+を押したとき
					bufferNumber = bufferNumber + getDisplayInt()
				} else if nextOperation == "-" {
					//前回-を押したとき
					bufferNumber = bufferNumber - getDisplayInt()
				} else if nextOperation == "×" {
					//前回×を押したとき
					bufferNumber = bufferNumber * getDisplayInt()
				} else if nextOperation == "÷" {
					//前回÷を押したとき
					bufferNumber = bufferNumber / getDisplayInt()
				}
				// 実際の計算は次のキーを押した時なので、演算の種類をとっておく
				if (sender.currentTitle == "+" || sender.currentTitle == "-" || sender.currentTitle == "×" || sender.currentTitle == "÷") {
					nextOperation = sender.currentTitle
				}
			}
			
			display.text = "\(bufferNumber)"
			displayLabel.text! = display.text!
			isTypingNumber = false
			
			// =は計算いったん完了
			if (sender.currentTitle == "=") {
				displayLabel.text! = display.text!
				// 文字数最大を決める
				let maxLength: Int = 17
				let str = display.text
				
				if str!.characters.count > maxLength {
					let myalert = UIAlertController(
						title: "桁数オーバーです",
						message: "17桁(1京円)以内で入力してください",
						preferredStyle: .Alert)
					
					myalert.addAction(UIAlertAction(
						title: "OK",
						style: .Default,
						handler: { action in print("OK") }))
					presentViewController(myalert, animated: true, completion: nil)
					display.text = "error"
					display.text = "0"
					displayLabel.text! = display.text!
				}
				
				bufferNumber = 0
				nextOperation = nil
			}
			
			// !ボタンが押された場合、各項目Labelの値をリセット
			if sender.currentTitle == "!" {
				foodArray = []
				foodLabel.text! = "0"
				lifeArray = []
				lifeLabel.text! = "0"
				zappiArray = []
				zappiLabel.text! = "0"
				hokaArray = []
				hokaLabel.text! = "0"
				display.text = "0"
				displayLabel.text! = display.text!
				
				userDefaultMemory()
			}
			
			// MARK:★
			if sender.currentTitle == "★" {
				userDefaultMemory()
				
				// 1.AppDelegateをコードで読み込む
				let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
				
				// 2.Entityの操作を制御する(managedObjectContext)を(appDelegate)から作成
				if let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext{
					
					// 3.新しくデータを追加する為のEntityを作成する
					let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("AccountBook", inManagedObjectContext: managedObjectContext)
					
					// 4.Todo EntityからObjectを生成し、Attributesに接続して値を代入
					// (Entityにあわせたクラスを作ってから)
					let accountBook = managedObject as! AccountBook
					
					accountBook.foodFee = foodTotal
					accountBook.lifeFee = lifeTotal
					accountBook.zappiFee = zappiTotal
					accountBook.hokaFee = hokaTotal
					accountBook.totalFee = allTotal
					accountBook.inputDate = NSDate() // NSDate() 現在の日付を返す
					
					appDelegate.saveContext()
				}
				
			}
			
			if sender.currentTitle == "D" {
				let myDefault = NSUserDefaults.standardUserDefaults()
				 //一時的に用意したユーザーデフォルト消すボタン
				myDefault.removeObjectForKey("fourTotal")
				
				userDefaultMemory()
			}
			
			
		}
		
		// MARK:自作関数置き場
		// ディスプレイ表示を取得しIntに変換して返す
		func getDisplayInt() -> Int {
			if let displayText = display.text {
				return Int(displayText) ?? 0
			} else {
				return 0
			}
		}
	
		func userDefaultMemory() {
			let myDefault = NSUserDefaults.standardUserDefaults()
			// データを書き込んで("fourTotal"箱の名前)
			myDefault.setObject([foodTotal,lifeTotal,zappiTotal,hokaTotal], forKey: "fourTotal")
			// 即反映させる(きちんと保存して使用時すぐ出せるように)
			myDefault.synchronize()
		}


	
	
	
	
	
	
	
	
//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//	}

	
}

