//  ViewController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/13.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit

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
	
	@IBOutlet var myGes: UIPanGestureRecognizer!
	@IBAction func myGesAction(sender: UIPanGestureRecognizer) {
		let move = sender.translationInView(view)
		self.displayLabel.center.x = self.displayLabel.center.x + move.x
		self.displayLabel.center.y = self.displayLabel.center.y + move.y
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

	}
	override func viewDidLoad() {
		super.viewDidLoad()
	}
		
		var isTypingNumber = false  // 数字をタイプ中か
		var bufferNumber : Int = 0  // 計算中の数値
		var nextOperation : String?   // 次に演算する操作　+, -
	
		
		
		// 数字キーが押されたとき
		@IBAction func digit(sender: UIButton) {
			
			// ログに表示
			print("pushed \(sender.currentTitle)")
			
			if isTypingNumber {
				let digit = sender.currentTitle!
				display.text = display.text! + digit
			} else {
				display.text = sender.currentTitle!
				isTypingNumber = true
			}
			displayLabel.text! = display.text!
			
		}
		
		// 操作キー（+-=C）が押されたとき
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
				let maxLength: Int = 13
				let str = display.text
				
				if str!.characters.count > maxLength {
					let myalert = UIAlertController(
						title: "桁数",
						message: "オーバーです",
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
			
			
		}
		
		
		// ディスプレイ表示を取得しIntに変換して返す
		func getDisplayInt() -> Int {
			if let displayText = display.text {
				return Int(displayText) ?? 0
			} else {
				return 0
			}
		}
	


	
	
	
	
	
	
	
	
//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//	}

	
}

