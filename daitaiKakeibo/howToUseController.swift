//  howToUseController.swift
//  daitaiKakeibo
//
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit

class howToUseController: UIViewController {
	
	@IBOutlet weak var myTextView: UITextView!
	let twoVC = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		print("howToUse画面表示")
	myTextView.text = "How To Use(仮)\n\n\n1.D&Dで金額入力\n\n2.集計ボタン押す\n\n3.それだけ！"
		
	}
	
	


	
	
	
	

	
	
	
	
	
	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }


}
