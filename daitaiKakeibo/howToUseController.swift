//  howToUseController.swift
//  daitaiKakeibo
//  Created by satoshiii on 2016/05/21.
//  Copyright © 2016年 satoshiii. All rights reserved.

import UIKit
import GoogleMobileAds
import FontAwesomeKit

class howToUseController: UIViewController, UIScrollViewDelegate , GADBannerViewDelegate {
	
	@IBOutlet weak var myTextView: UITextView!
	
	let AdMobID = "ca-app-pub-8544314931809940/6829362316"
	let TEST_DEVICE_ID = "61b0154xxxxxxxxxxxxxxxxxxxxxxxe0"
	let AdMobTest:Bool = true
	let SimulatorTest:Bool = true
	
	var pictureFlag:Bool = true
	
	let backgroundColor = UIColor(red: 255.0/255.0, green: 214.0/255.0, blue: 234.0/255.0, alpha: 1.0)
	let slides = [
		[ "image": "", "text": "1. 数字を入力\n\n2. 画面タップで入力\n\n3.✏️で記録！"],
		[ "image": "page2.png", "text": "2ページ目"],
		[ "image": "", "text": "4. 画面の外に\nスワイプで取り消し\n\n5.長押しで消去"],
		[ "image": "page4.png", "text": "4ページ目"],
		[ "image": "", "text": "とっても簡単\n\nさあ\n\nはじめましょう"]
	]
	
	let screen: CGRect = UIScreen.mainScreen().bounds
	var scroll: UIScrollView?
	var dots: UIPageControl?

    override func viewDidLoad() {
        super.viewDidLoad()
		insertAdMob()
		
		// ここから下コピー
		
		view.backgroundColor = backgroundColor
		scroll = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: screen.width, height: screen.height * 0.9))
		scroll?.showsHorizontalScrollIndicator = false
		scroll?.showsVerticalScrollIndicator = false
		scroll?.pagingEnabled = true
		
		//scroll?.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
		//rscroll?.pageIndicatorTintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
		

		// 画面サイズで機種判定
		let screenHeight = Int(UIScreen.mainScreen().bounds.size.height)
		print(screenHeight)
		
		// ドットの位置などここで決めている ↓
		view.addSubview(scroll!)
		if (slides.count > 1) {
			dots = UIPageControl(frame: CGRect(x: 0.0, y: screen.height * 0.86, width: screen.width, height: screen.height * 0.05))
			
			if screenHeight == 480 {
				dots = UIPageControl(frame: CGRect(x: 0.0, y: screen.height * 0.845, width: screen.width, height: screen.height * 0.05))
			}
			
			dots?.numberOfPages = slides.count
			view.addSubview(dots!)
		}

		
		for var i = 0; i < slides.count; ++i {
			
			//
			if (slides[i]["image"] as! String! != ""){
				pictureFlag = true
			}else{
				pictureFlag = false
			}
			
			if (pictureFlag == true) {
				
				let image = UIImage(named: slides[i]["image"]!)
				let imageView: UIImageView = UIImageView(frame: getFrame(image!.size.width, iH: image!.size.height, slide: i, offset: screen.height * 0.15))
				imageView.image = image
				scroll?.addSubview(imageView)
				
			} else {
				
				let text = slides[i]["text"]
				let textView = UITextView(frame: CGRect(x: screen.width * 0.05 + CGFloat(i) * screen.width, y: screen.height / 2 - 120, width: screen.width * 0.9, height: 300.0))
				textView.text = text
				textView.editable = false
				textView.selectable = false
				textView.textAlignment = NSTextAlignment.Center
				textView.font = UIFont.systemFontOfSize(28, weight: 0)
				textView.textColor = hexStr("555555", alpha: 1)
				textView.backgroundColor = UIColor.clearColor()
				scroll?.addSubview(textView)
			}
		}
		scroll?.contentSize = CGSizeMake(CGFloat(Int(screen.width) *  slides.count), screen.height * 0.5)
		scroll?.delegate = self
		dots?.addTarget(self, action: Selector("swipe:"), forControlEvents: UIControlEvents.ValueChanged)
		
		let closeButton = UIButton()
		closeButton.frame = CGRect(x: screen.width - 70, y: 20, width: 60, height: 60)
		closeButton.setTitle("Skip", forState: .Normal)
		closeButton.setTitleColor(UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5), forState: .Normal)
		closeButton.titleLabel!.font =  UIFont.systemFontOfSize(16)
		closeButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
		view.addSubview(closeButton)
	}
	
	override func viewWillAppear(animated: Bool) {
		print("howToUse画面表示")
	}
	
	func pressed(sender: UIButton!) {
		self.dismissViewControllerAnimated(true) { () -> Void in
		}
	}
	
	func getFrame (iW: CGFloat, iH: CGFloat, slide: Int, offset: CGFloat) -> CGRect {
		
		//let screenHeight = Int(UIScreen.mainScreen().bounds.size.height)
			//print(screenHeight)
			// 画面サイズで機種判定
		var mH: CGFloat = screen.height * 0.7
		
//			if screenHeight == 480 {
//				 mH = screen.height * 0.6
//			}else{
//				 mH = screen.height * 0.7
//			}
		
		let mW: CGFloat = screen.width
		var h: CGFloat
		var w: CGFloat
		let r = iW / iH
		if (r <= 1) {
			h = min(mH, iH)
			w = h * r
		} else {
			w = min(mW, iW)
			h = w / r
		}
		return CGRectMake(
			max(0, (mW - w) / 2) + CGFloat(slide) * screen.width,
			max(0, (mH - h) / 2) + offset,
			w,
			h
		)
	}
	
	func swipe(sender: AnyObject) -> () {
		if let scrollView = scroll {
			let x = CGFloat(dots!.currentPage) * scrollView.frame.size.width
			scroll?.setContentOffset(CGPointMake(x, 0), animated: true)
		}
	}
	
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) -> () {
		let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
		dots!.currentPage = Int(pageNumber)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	func insertAdMob(){
		// 以下参考サイトからのコピぺ
		var admobView: GADBannerView = GADBannerView()
		admobView = GADBannerView(adSize:kGADAdSizeBanner)
		
		// 広告の位置を指定している(下に設置)
		admobView.frame.origin = CGPointMake(0, self.view.frame.size.height - admobView.frame.height)
		
		// ↓上に設置の場合
		// admobView.frame.origin = CGPointMake(0, 20)
		// 広告のサイズを指定している
		admobView.frame.size = CGSizeMake(self.view.frame.width, admobView.frame.height)
		admobView.adUnitID = AdMobID
		admobView.delegate = self
		admobView.rootViewController = self
		
		let admobRequest:GADRequest = GADRequest()
		
		if AdMobTest {
			if SimulatorTest {
				admobRequest.testDevices = [kGADSimulatorID]
			} else {
				admobRequest.testDevices = [TEST_DEVICE_ID]
			}
		}
		admobView.loadRequest(admobRequest)
		self.view.addSubview(admobView)
	}
	
	// 色コードをhexで指定できるように
	func hexStr (var hexStr : NSString, alpha : CGFloat) -> UIColor {
		hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
		let scanner = NSScanner(string: hexStr as String)
		var color: UInt32 = 0
		if scanner.scanHexInt(&color) {
			let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
			let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
			let b = CGFloat(color & 0x0000FF) / 255.0
			return UIColor(red:r,green:g,blue:b,alpha:alpha)
		} else {
			print("invalid hex string")
			return UIColor.whiteColor();
		}
	}


	
	
	
	

	
	
	
	
	
	
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }


}
