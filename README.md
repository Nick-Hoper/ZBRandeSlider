# ZBRandeSlider

>Swift 4.2 编写进度条组件，支持点击选择以及滑块滑动

![test.jpg](https://github.com/Nick-Hoper/ZBRandeSlider/blob/master/test.png)


## Features

- 完美支持Swift4.2编译
- 支持代码添加以及storyboard设置
- 支持手势滑动以及点击
- 集成使用简单，二次开发扩展强大


## Requirements

- iOS 9+
- Xcode 8+
- Swift 4.0+
- iPhone

## Example


        //1、storyBoard设置
        @IBOutlet var mSlider1: ZBRandeSlider!
        @IBOutlet var labelStatue: UILabel!
        
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
        
        //2、代码设置
        var mSlider2:ZBRandeSlider = ZBRandeSlider()
        
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
       

更详细集成方法，根据实际的例子请查看源代码中的demo



