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

class whiteColorText: UITextView {
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!;
		textColor = UIColor.whiteColor()
	}
}

class calcController: UIViewController {
	
	// 画面サイズによって可変させるview
	@IBOutlet weak var flexView: UIView!
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
	
	@IBOutlet weak var foodTextView: UITextView!
	@IBOutlet weak var lifeTextView: UITextView!
	@IBOutlet weak var zappiTextView: UITextView!
	@IBOutlet weak var hokaTextView: UITextView!
	
	@IBOutlet weak var foodFont: UIImageView!
	
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
	
	var allTotal: Int = 0
	
	var panLocation: CGPoint = CGPoint()
	// 起動画面サイズの取得
	let myBoundSize:CGSize = UIScreen.mainScreen().bounds.size
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// 画像のタッチ操作を有効にする
		displayLabel.userInteractionEnabled = true
		
		let trash = FAKFontAwesome.trashIconWithSize(30)
		// 下記でアイコンの色も変えられます
		// trash.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
		let trashImage = trash.imageWithSize(CGSizeMake(30, 30))
		
		foodFont.image = trashImage
		
	}
	
	override func viewWillAppear(animated: Bool) {
		
		foodTextView.text = "食費:\(foodArray)"
		lifeTextView.text = "生活費:\(lifeArray)"
		zappiTextView.text = "雑費:\(zappiArray)"
		hokaTextView.text = "他:\(hokaArray)"
		
		foodTextView.textColor = UIColor.whiteColor()
		zappiLabel.textColor = UIColor.whiteColor()
		
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
				
			} else if (myDefault.arrayForKey("fourTotal") == nil) {
				
				foodArray = []
				foodTotal = 0
				foodLabel.text! = "0"
				lifeArray = []
				lifeTotal = 0
				lifeLabel.text! = "0"
				zappiArray = []
				zappiTotal = 0
				zappiLabel.text! = "0"
				hokaArray = []
				hokaTotal = 0
				hokaLabel.text! = "0"
				
				display.text = "0"
				displayLabel.text! = display.text!
			}
	}
	
	// Labelタッチ判定テスト ここから↓↓ (5.22-)
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touch: UITouch = touches.first! as UITouch
		startPoint = touch.locationInView(self.view) // タッチの開始座標を取得
		imageBeHereNowPoint = displayLabel.frame.origin // 開始時の画像の座標を取得
		
		// 画面の大きさによって可変させるViewから高さを取得
		let myFlexViewSize:CGSize = self.flexView.bounds.size
		
		// タップしたビューがUILabelか判断する。
		// if touch.view!.isKindOfClass(UILabel) {
		if touch.view!.tag == 10 {
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
			
			// 画面の大きさによって可変させるViewから高さを取得
			let myFlexViewSize:CGSize = self.flexView.bounds.size
			
			// 移動量を計算
			let deltaX: CGFloat = CGFloat(location.x - startPoint!.x)
			let deltaY: CGFloat = CGFloat(location.y - startPoint!.y)
			
			// Labelを半透過にする
			displayLabel.layer.opacity = 0.5
			// displayLabel.transform = CGAffineTransformMakeScale(0.7, 0.7)
			
			// Labelを移動
			self.displayLabel.frame.origin.x = imageBeHereNowPoint!.x + deltaX
			self.displayLabel.frame.origin.y = imageBeHereNowPoint!.y + deltaY
			
			
		} else {
			// Do nothing
		}
	}
	
	// MARK:label効果
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		// 画面の大きさによって可変させるViewから高さを取得
		let myFlexViewSize:CGSize = self.flexView.bounds.size
		// 指を離したタイミングでLabelの透過解除
		displayLabel.layer.opacity = 1.0
		// displayLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)


		// タッチした位置の座標を取得
		for touch: AnyObject in touches {
			let point = touch.locationInView(self.view)
			//座標獲得
			let pointXY = (point.x,point.y)
			print(pointXY)
			// let myBoundSize:CGSize = UIScreen.mainScreen().bounds.size
			
			// オートレイアウトに対応
			// 変数に画面の左半分と右半分の値を代入
			let widthLeft = myBoundSize.width*0.4999 // 159.9
			let widthRight = myBoundSize.width*0.50  // 160.0
			
			let heightMiddleUp = myFlexViewSize.height*0.25198413 + 64   // 191.9
			let heightMiddleDown = myFlexViewSize.height*0.25198414 + 64 // 192.0
			let heightEnd = myFlexViewSize.height*0.50396825 + 64  // 319.0
				//条件分岐
				switch pointXY {
				
				// case (0.0...159.9, 64.0...192.0):
				case (0.0...widthLeft, 64.0...heightMiddleUp):
					print("foodFieldにラベルがきました！")
					let foodInt: Int = Int(displayLabel.text!)!
					foodArray.append(foodInt)
					print(foodArray)
					foodTotal = foodArray.reduce(0) { (num1, num2) -> Int in
						num1 + num2
					}
					let foodString : String = String(foodTotal)
					foodLabel.text? = foodString
					foodTextView.text = "食費:\(foodArray)"
					doing0()
					
				case (widthRight...myBoundSize.width, 64.0...heightMiddleUp):
					print("lifeFieldにラベルがきました！")
					let lifeInt: Int = Int(displayLabel.text!)!
					lifeArray.append(lifeInt)
					print(lifeArray)
					lifeTotal = lifeArray.reduce(0) { (num1, num2) -> Int in
						num1 + num2
					}
					let lifeString : String = String(lifeTotal)
					lifeLabel.text! = lifeString
					lifeTextView.text = "生活費:\(lifeArray)"
					doing0()
					
				case (0.0...widthLeft, heightMiddleDown...heightEnd):
					print("zappiFieldにラベルがきました！")
					let zappiInt: Int = Int(displayLabel.text!)!
					zappiArray.append(zappiInt)
					print(zappiArray)
					zappiTotal = zappiArray.reduce(0) { (num1, num2) -> Int in
						num1 + num2
					}
					let zappiString : String = String(zappiTotal)
					zappiLabel.text! = zappiString
					zappiTextView.text = "雑費:\(zappiArray)"
					doing0()
					
				case (widthRight...myBoundSize.width, heightMiddleDown...heightEnd):
					print("hokaFieldにラベルがきました！")
					let hokaInt: Int = Int(displayLabel.text!)!
					hokaArray.append(hokaInt)
					print(hokaArray)
					hokaTotal = hokaArray.reduce(0) { (num1, num2) -> Int in
						num1 + num2
					}
					let hokaString : String = String(hokaTotal)
					hokaLabel.text! = hokaString
					hokaTextView.text = "他:\(hokaArray)"
					doing0()
					
				default:
					break
				}
		}
	}
	// Labelタッチ判定テスト ここまで↑↑(5.22-)
	
	
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
		foodTextView.text = "食費:\(foodArray)"
		doing0()
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
		lifeTextView.text = "生活費:\(lifeArray)"
		doing0()
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
		zappiTextView.text = "雑費:\(zappiArray)"
		doing0()
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
		hokaTextView.text = "他:\(hokaArray)"
		doing0()
	}
	
	// 画面長押しで項目の値 全削除　ここから↓(6.1-)
	@IBAction func longPressFoodField(sender: UILongPressGestureRecognizer) {
		foodArray = []
		foodLabel.text! = "0"
		foodTotal = 0
		print("foodをリセット!\(foodArray)")
		foodTextView.text = "食費:\(foodArray)"
		userDefaultMemory()
	}
	
	@IBAction func longPressLifeField(sender: UILongPressGestureRecognizer) {
		lifeArray = []
		lifeLabel.text! = "0"
		lifeTotal = 0
		print("lifeをリセット!\(lifeArray)")
		lifeTextView.text = "生活費:\(lifeArray)"
		userDefaultMemory()
	}
	
	@IBAction func longPressZappiField(sender: UILongPressGestureRecognizer) {
		zappiArray = []
		zappiLabel.text! = "0"
		zappiTotal = 0
		print("zappiをリセット!\(zappiArray)")
		zappiTextView.text = "雑費:\(zappiArray)"
		userDefaultMemory()
	}
	
	@IBAction func longPressHokaField(sender: UILongPressGestureRecognizer) {
		hokaArray = []
		hokaLabel.text! = "0"
		hokaTotal = 0
		print("hokaをリセット!\(hokaArray)")
		hokaTextView.text = "他:\(hokaArray)"
		userDefaultMemory()
	}
	
	// 画面外側にスワイプしたら、配列の最後の値を削除(擬似Undo機能)
	@IBAction func swipeFoodField(sender: UISwipeGestureRecognizer) {
		if(foodArray != []) {
			foodArray.removeLast()
			foodLabel.text! = String(foodArray.reduce(0, combine: { $0 + $1 }))
			foodTotal = foodArray.reduce(0, combine: { $0 + $1 })
			print ("foodUndo:\(foodArray)")
			foodTextView.text = "食費:\(foodArray)"
			userDefaultMemory()
		} else {
			// 配列が空だったら何もしない
		}
	}
	
	@IBAction func swipeLifeField(sender: UISwipeGestureRecognizer) {
		if(lifeArray != []) {
			lifeArray.removeLast()
			lifeLabel.text! = String(lifeArray.reduce(0, combine: { $0 + $1 }))
			lifeTotal = lifeArray.reduce(0, combine: { $0 + $1 })
			print ("lifeUndo:\(lifeArray)")
			lifeTextView.text = "生活費:\(lifeArray)"
			userDefaultMemory()
		} else {
			// 配列が空だったら何もしない
		}
	}
	
	@IBAction func swipeZappiField(sender: UISwipeGestureRecognizer) {
		if(zappiArray != []) {
			zappiArray.removeLast()
			zappiLabel.text! = String(zappiArray.reduce(0, combine: { $0 + $1 }))
			zappiTotal = zappiArray.reduce(0, combine: { $0 + $1 })
			print ("zappiUndo:\(zappiArray)")
			zappiTextView.text = "雑費:\(zappiArray)"
			userDefaultMemory()
		} else {
			// 配列が空だったら何もしない
		}
	}
	
	@IBAction func swipeHokaField(sender: UISwipeGestureRecognizer) {
		if(hokaArray != []) {
			hokaArray.removeLast()
			hokaLabel.text! = String(hokaArray.reduce(0, combine: { $0 + $1 }))
			hokaTotal = hokaArray.reduce(0, combine: { $0 + $1 })
			print ("hokaUndo:\(hokaArray)")
			hokaTextView.text = "他:\(hokaArray)"
			userDefaultMemory()
		} else {
			// 配列が空だったら何もしない
		}
	}
	
	
		var isTypingNumber = false  // 数字をタイプ中か
		var bufferNumber : Int = 0  // 計算中の数値
		var nextOperation : String?   // 次に演算する操作　+, -
	
		// 数字キーが押されたとき
		@IBAction func digit(sender: UIButton) {
			// ログに表示
			print("pushed \(sender.currentTitle)")
			
			if isTypingNumber {
				
				if(display.text == "0"){
					let digit: Int = Int(sender.currentTitle!)!
					display.text = String(Int(display.text!)! + digit)
				} else {
					let digit = sender.currentTitle!
					display.text = display.text! + digit
				}
				
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
				
				foodTotal = 0
				lifeTotal = 0
				zappiTotal = 0
				hokaTotal = 0
				allTotal = 0
				
				foodTextView.text = "食費:\(foodArray)"
				lifeTextView.text = "生活費:\(lifeArray)"
				zappiTextView.text = "雑費:\(zappiArray)"
				hokaTextView.text = "他:\(hokaArray)"
				
				let myDefault = NSUserDefaults.standardUserDefaults()
				myDefault.removeObjectForKey("fourTotal")
				
				userDefaultMemory()

			}
			
			
			// MARK:★
			if sender.currentTitle == "★" {
				
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
					
					foodTotal = 0
					lifeTotal = 0
					zappiTotal = 0
					hokaTotal = 0
					allTotal = 0
					
					let myDefault = NSBundle.mainBundle().bundleIdentifier
					NSUserDefaults.standardUserDefaults().removePersistentDomainForName(myDefault!)
					bufferNumber = 0
					nextOperation = nil
					
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
					
					foodTextView.text = "食費:\(foodArray)"
					lifeTextView.text = "生活:\(lifeArray)"
					zappiTextView.text = "雑費:\(zappiArray)"
					hokaTextView.text = "他:\(hokaArray)"
					foodTextView.textColor = UIColor.whiteColor()
				}
				
			}
			
//			if sender.currentTitle == "D" {
//				let myDefault = NSUserDefaults.standardUserDefaults()
//				 //一時的に用意したユーザーデフォルト消すボタン
//				myDefault.removeObjectForKey("fourTotal")
//				userDefaultMemory()
//			}
			
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
	
		// 値が入る時や何らかの動きがあった時にuserDefaultに保存
		func userDefaultMemory() {
			let myDefault = NSUserDefaults.standardUserDefaults()
			// データを書き込んで("fourTotal"箱の名前)
			myDefault.setObject([foodTotal,lifeTotal,zappiTotal,hokaTotal], forKey: "fourTotal")
			// 即反映させる(きちんと保存して使用時すぐ出せるように)
			allTotal = foodTotal+lifeTotal+zappiTotal+hokaTotal
			myDefault.synchronize()
			foodTextView.textColor = UIColor.whiteColor()
		}
	
		// userDefault保存後、計算機の値を0に戻す動き
		func doing0(){
			userDefaultMemory()
			display.text! = "0"
			displayLabel.text! = display.text!
		}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}

