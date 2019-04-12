//
//  ZBRandeSlider.swift
//  ZBRandeSlider
//
//  Created by Nick luo on 2019/4/9.
//  Copyright © 2019 Nick luo. All rights reserved.
//

import UIKit
import Foundation

/// 样式类型
public enum ZBRandeSliderStyle {
    
    case ZBSliderStyle_Nomal   /*默认样式 例如|________|________|________|________|*/
    case ZBSliderStyle_Cross   /*默认样式 例如|--------|--------|--------|--------|*/
    case ZBSliderStyle_Point   /*默认样式 例如 ●--------●--------●--------●--------●*/
}

//点击代理
public protocol ZBRandeSliderDelegate:class{
    
    func ZBRandeSliderValue(index:Int)
    
}


class ZBRandeSlider: UIControl {
    
    
    //代理者
    open weak var delegate: ZBRandeSliderDelegate?
    
    /**
     刻度样式 详情参考 枚举值 ZBRandeSliderStyle 默认 ZBSliderStyle_Nomal
     */
    open var sliderStyle: ZBRandeSliderStyle = .ZBSliderStyle_Nomal
    
    /**
     滑块填充颜色
     */
    open var thumbTintColor: UIColor = UIColor.clear
    
    
    /**
     滑块阴影颜色
     */
    open var thumbShadowColor: UIColor = UIColor.clear
    
    
    /**
     滑块阴影透明度
     */
    open var thumbShadowOpacity: CGFloat = 0.0
    
    
    /**
     滑块直径 默认20
     */
    open var thumbDiameter: CGFloat = 0.0
    
    /**
     刻度线 线条颜色
     */
    open var scaleLineColor: UIColor = UIColor.lightGray
    
    /**
     刻度线 线条宽度
     */
    open var scaleLineWidth: CGFloat = 0.0
    
    /**
     刻度线 线条高度
     */
    open var scaleLineHeight: CGFloat = 0.0
    
    
    /**
     刻度线 刻度数量
     */
    open var scaleLineNumber: NSInteger = 0
    
    
    /**
     当前滑块所处 刻度的索引 默认0
     */
    open var currentIdx: NSInteger = 0
    
    /**
     滑块
     */
    open var thumbLayer: CALayer = CALayer.init()
    
    /**
     是否点击
     */
    open var touchOnCircleLayer: Bool = false
    
    /**
     最后的框架
     */
    open var lastFrame: CGRect =  CGRect.init()
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInitialization()
        
    }
    
    
    //初始化
    private func customInitialization() {
        
        //添加手势
        let signdebtsViewTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(signdebtsViewTap)
        
        self.touchOnCircleLayer = false
        self.currentIdx = 0
        self.sliderStyle = .ZBSliderStyle_Nomal
        
        //滑块相关
        self.thumbShadowOpacity = 0.6
        //        self.thumbShadowColor = UIColor.yellow
        //        self.thumbTintColor = UIColor.lightGray
        self.thumbDiameter = 20
        
        let thumbImage = UIImageView(image: UIImage(named: "btn-change"))
        
        //        self.thumbLayer = CALayer.init()
        self.thumbLayer = thumbImage.layer
        self.thumbLayer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        self.thumbLayer.backgroundColor  = self.thumbTintColor.cgColor
        self.thumbLayer.shadowColor = self.thumbShadowColor.cgColor
        self.thumbLayer.shadowOpacity = Float(self.thumbShadowOpacity)
        self.layer.addSublayer(self.thumbLayer)
        
        //刻度线相关
        self.scaleLineWidth = 1.0
        self.scaleLineColor = UIColor.lightGray
        self.scaleLineNumber = 4
        self.scaleLineHeight = 5
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.lastFrame.equalTo(self.frame){
            self.lastFrame = self.frame
            self.setNeedsDisplay()
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let W:CGFloat = self.bounds.size.width
        let H:CGFloat = self.bounds.size.height
        
        //设置滑块的位置
        let thumLayerFrameX = self.thumbLayerFrameXAtindex(idx: self.currentIdx)
        let tmpRect = CGRect.init(x: thumLayerFrameX, y: (H-self.thumbDiameter)*0.5, width:  self.thumbDiameter, height: self.thumbDiameter)
        self.setThumbLayerFrame(frame: tmpRect, animated: true)
        
        //绘制背景颜色
        self.backgroundColor?.setFill()
        UIRectFill(self.bounds)
        
        //绘制主刻度线
        
        let spindleScaleStartPoint:CGPoint = CGPoint.init(x: self.thumbDiameter*0.5, y: H * 0.5)
        let spindleScaleEndPoint:CGPoint = CGPoint.init(x: W - self.thumbDiameter*0.5, y: H * 0.5)
        
        //设置刻度线颜色
        self.scaleLineColor.setStroke()
        
        //绘主刻度轴(X轴)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineCap(.square)
        context.setLineJoin(.round)
        context.setLineWidth(self.scaleLineWidth)
        context.move(to: CGPoint(x:spindleScaleStartPoint.x, y:spindleScaleStartPoint.y))
        context.addLine(to: CGPoint(x:spindleScaleEndPoint.x, y:spindleScaleEndPoint.y))
        context.strokePath()
        
        
        if self.sliderStyle == .ZBSliderStyle_Nomal || self.sliderStyle == .ZBSliderStyle_Cross{
            
            let lineNum:NSInteger = self.scaleLineNumber + 1
            let oneW:CGFloat = (W - self.thumbDiameter)/CGFloat(self.scaleLineNumber)
            let x:CGFloat = self.thumbDiameter * 0.5
            var startY:CGFloat = 0
            var endY:CGFloat = H
            
            if self.sliderStyle == .ZBSliderStyle_Nomal{
                startY = max(0, spindleScaleStartPoint.y-self.scaleLineHeight)
                endY = spindleScaleStartPoint.y;
            }else{
                startY = max((H-self.scaleLineHeight)*0.5, 0);
                endY = min(H, startY+self.scaleLineHeight);
            }
            
            //绘制竖直刻度短线
            for i in 0..<lineNum {
                let startP:CGPoint = CGPoint.init(x: x+(CGFloat(i)*(oneW)), y: startY)
                let endP:CGPoint = CGPoint.init(x: x+(CGFloat(i)*(oneW)), y: endY)
                context.move(to: CGPoint(x:startP.x, y: startP.y))
                context.addLine(to: CGPoint(x:endP.x, y:endP.y))
                context.strokePath()
            }
        }else{
            
            let lineNum:NSInteger = self.scaleLineNumber + 1
            let oneW:CGFloat = (W - self.thumbDiameter)/CGFloat(self.scaleLineNumber)
            let x:CGFloat = self.thumbDiameter * 0.5
            let y:CGFloat = spindleScaleStartPoint.y
            
            //绘制竖直刻度短线
            for i in 0..<lineNum {
                let point:CGPoint = CGPoint.init(x: x+(CGFloat(i)*(oneW)), y: y)
                context.setFillColor(self.scaleLineColor.cgColor)
                context.setLineWidth(1)
                context.addArc(center: point, radius: self.scaleLineHeight, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
                context.drawPath(using: .fillStroke)
                
            }
            
        }
    }
    
    
    //设置滑块的位置
    func thumbLayerFrameXAtindex(idx:NSInteger) ->CGFloat{
        let W:CGFloat  = self.frame.size.width
        let oneW:CGFloat = (W - self.thumbDiameter)/CGFloat(self.scaleLineNumber)
        let x:CGFloat = oneW*CGFloat(idx)
        return x
    }
    
    func setThumbLayerFrame(frame:CGRect,animated:Bool){
        
        self.thumbLayer.actions = nil
        self.thumbLayer.frame = frame
    }
    
    //滑动
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var p:CGPoint = touch.location(in: self)
        
        if p.y >= 0 && p.y <= self.frame.height{
            p.y = self.thumbLayer.position.y
        }
        
        if self.thumbLayer.frame.contains(p){
            self.touchOnCircleLayer = true
            self.didSeleCtcircleLayer()
            return true
        }
        self.touchOnCircleLayer = false
        return false
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        if self.touchOnCircleLayer{
            
            
            let point:CGPoint = touch.location(in: self)
            var mRect:CGRect = self.thumbLayer.frame
            let x = point.x - self.thumbDiameter * 0.5
            mRect.origin.x = max(x, 0)
            mRect.origin.x = min(mRect.origin.x, self.frame.width-self.thumbDiameter)
            
            self.setThumbLayerFrame(frame: mRect, animated: false)
            
            let W:CGFloat = self.frame.width
            let oneW:CGFloat = (W - self.thumbDiameter)/CGFloat(self.scaleLineNumber)
            
            var offX:CGFloat = point.x - self.thumbDiameter * 0.5 + oneW * 0.5
            offX = max(0, offX)
            offX = min(offX, self.frame.width)
            
            let idx:CGFloat = offX/oneW
            var cIdx:Int  = Int(idx)
            cIdx = min(cIdx, Int(self.scaleLineNumber))
            cIdx = max(cIdx, 0)
            
            if self.currentIdx != cIdx{
                self.currentIdx = cIdx
                self.delegate?.ZBRandeSliderValue(index: self.currentIdx)
                self.sendActions(for: .valueChanged)
            }
            
            return true
        }
        return false
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        self.desSelectCircleLayer()
    }
    
    override func cancelTracking(with event: UIEvent?) {
        self.desSelectCircleLayer()
    }
    
    //取消点中
    func desSelectCircleLayer(){
        self.thumbLayer.transform = CATransform3DIdentity
        var tmpRect:CGRect = self.thumbLayer.frame
        tmpRect.origin.x = self.thumbLayerFrameXAtindex(idx: self.currentIdx)
        
        self.thumbLayer.actions = nil
        self.thumbLayer.frame =  tmpRect
        
    }
    
    //选中
    func didSeleCtcircleLayer(){
        //  self.thumbLayer.transform = CATransform3DScale(self.thumbLayer.transform, 1.2, 1.2, 1)
        self.thumbLayer.transform = CATransform3DIdentity
    }
    
    
    //  设置 滑块选中的刻度索引
    //  animated 是否有动画效果
    open func setSelectedIndex(_ index: NSInteger,animated:Bool) {
        
        
        var temIndex = max(0, index)
        temIndex = min(temIndex, self.scaleLineNumber)
        self.currentIdx = temIndex
        
        var tmpRect:CGRect = self.thumbLayer.frame
        tmpRect.origin.x = self.thumbLayerFrameXAtindex(idx: self.currentIdx)
        self.setThumbLayerFrame(frame: tmpRect, animated: animated)
        
    }
    
    // 点击进度条后执行的  手势事件
    @objc func tapAction(tap : UITapGestureRecognizer){
        
        let point: CGPoint = tap.location(in: self)
        
        var mRect:CGRect = self.thumbLayer.frame
        let x = point.x - self.thumbDiameter * 0.5
        mRect.origin.x = max(x, 0)
        mRect.origin.x = min(mRect.origin.x, self.frame.width-self.thumbDiameter)
        
        self.setThumbLayerFrame(frame: mRect, animated: false)
        
        let W:CGFloat = self.frame.width
        let oneW:CGFloat = (W - self.thumbDiameter)/CGFloat(self.scaleLineNumber)
        
        var offX:CGFloat = point.x - self.thumbDiameter * 0.5 + oneW * 0.5
        offX = max(0, offX)
        offX = min(offX, self.frame.width)
        
        let idx:CGFloat = offX/oneW
        var cIdx:Int  = Int(idx)
        cIdx = min(cIdx, Int(self.scaleLineNumber))
        cIdx = max(cIdx, 0)
        
        if self.currentIdx != cIdx{
            self.currentIdx = cIdx
            self.sendActions(for: .valueChanged)
        }
        
        self.setSelectedIndex(self.currentIdx, animated: true)
        
        // 进度条改变了 出发代理执行代理事件  让用的地方可以相应的改变  比如音频视频的播放进度调整
        self.delegate?.ZBRandeSliderValue(index: self.currentIdx)
    }
    
    
    
    
    
}
