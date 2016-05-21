//  aboutAppController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit

class aboutAppController: UIViewController {

	@IBOutlet weak var myAbouttext: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewWillAppear(animated: Bool) {
		print("aboutApp画面表示")
		myAbouttext.text="だいたい家計簿 Ver1.01\n\nCopyright © 2016 Satoshiii inc.\nAll Rights Reserved.\n\n（仮）"
	}
	
	
	
	
	
	
	

	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }


}
