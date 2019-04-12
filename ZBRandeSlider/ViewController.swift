//
//  ViewController.swift
//  ZBRandeSlider
//
//  Created by Nick luo on 2019/4/9.
//  Copyright © 2019 Nick luo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //storyBoard设置
    @IBOutlet var mSlider1: ZBRandeSlider!
    @IBOutlet var labelStatue: UILabel!
    
    //代码设置
    var mSlider2:ZBRandeSlider = ZBRandeSlider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mSlider1.sliderStyle = .ZBSliderStyle_Point
        self.mSlider1.backgroundColor = UIColor.cyan
        self.mSlider1.thumbTintColor = UIColor.green
        self.mSlider1.thumbShadowColor = UIColor.black
        self.mSlider1.thumbShadowOpacity = 0.6;
        self.mSlider1.thumbDiameter = 20;
        self.mSlider1.scaleLineColor = UIColor.black
        self.mSlider1.scaleLineWidth = 0.5;
        self.mSlider1.scaleLineHeight = 4;
        self.mSlider1.scaleLineNumber = 9;
        self.mSlider1.addTarget(self, action: #selector(slider01ChangeAction(_:)), for: .valueChanged)
     
        self.mSlider2 = ZBRandeSlider.init(frame: CGRect(x:10,y:200,width:200,height:40))
        self.mSlider2.sliderStyle = .ZBSliderStyle_Cross
        self.mSlider2.backgroundColor = UIColor.clear
        self.mSlider2.thumbTintColor = UIColor.green
        self.mSlider2.thumbShadowColor = UIColor.black
        self.mSlider2.thumbShadowOpacity = 1.0;
        self.mSlider2.thumbDiameter = 23;
        self.mSlider2.scaleLineColor = UIColor.lightGray
        self.mSlider2.scaleLineWidth = 2.0;
        self.mSlider2.scaleLineHeight = 10;
        self.mSlider2.scaleLineNumber = 4;
        self.mSlider2.addTarget(self, action: #selector(slider02ChangeAction(_:)), for: .valueChanged)
       self.mSlider2.setSelectedIndex(2, animated: true)
        
        self.mSlider2.delegate = self
        self.view.addSubview(self.mSlider2)
   
    }
    
    @objc func slider01ChangeAction(_ sender: ZBRandeSlider){
        
       
        self.labelStatue.text = "当前滑动滑杆1 value: \(sender.currentIdx)"
        
        
    }
    
    @objc func slider02ChangeAction(_ sender: ZBRandeSlider){
        
        self.labelStatue.text = "当前滑动滑杆2 value: \(sender.currentIdx)"
        
        
    }



}


///MARK: - 实现手势点击的协议方法 //2、添加手势的进度条
extension  ViewController: ZBRandeSliderDelegate {
    
    func ZBRandeSliderValue(index:Int) {
        print("index=\(index)")
        
        self.labelStatue.text = "当前滑动滑杆3 value: \(index)"

    }
}

