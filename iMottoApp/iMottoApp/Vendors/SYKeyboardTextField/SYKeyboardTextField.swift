//
//  SYKeyboardTextField.swift
//  DoudouApp
//
//  Created by yushuyi on 15/1/17.
//  Copyright (c) 2015年 DoudouApp. All rights reserved.
//

import UIKit

@objc public protocol SYKeyboardTextFieldDelegate : class {
    
    /**
     点击左边按钮的委托
     */
    @objc optional func keyboardTextFieldPressLeftButton(_ keyboardTextField :SYKeyboardTextField)
    
    /**
     点击右边按钮的委托
     */
    @objc optional func keyboardTextFieldPressRightButton(_ keyboardTextField :SYKeyboardTextField)
    
    /**
     点击键盘上面的回车按钮响应委托
     */
    @objc optional func keyboardTextFieldPressReturnButton(_ keyboardTextField :SYKeyboardTextField)
    
    /**
     键盘将要隐藏时响应的委托
     */
    @objc optional func keyboardTextFieldWillHide(_ keyboardTextField :SYKeyboardTextField)
    
    /**
     键盘已经隐藏时响应的委托
     */
    @objc optional func keyboardTextFieldDidHide(_ keyboardTextField :SYKeyboardTextField)
    
    /**
     键盘将要显示时响应的委托
     */
    @objc optional func keyboardTextFieldWillShow(_ keyboardTextField :SYKeyboardTextField)
    
    /**
     键盘已经显示时响应的委托
     */
    @objc optional func keyboardTextFieldDidShow(_ keyboardTextField :SYKeyboardTextField)
    
    /**
     键盘文本内容被改变时触发
     - parameter text:              本次写入的值
     */
    @objc optional func keyboardTextField(_ keyboardTextField :SYKeyboardTextField , didChangeText text:String)
    
}


private var keyboardViewDefaultHeight : CGFloat = 48.0
private let textViewDefaultHeight : CGFloat = 36.0




open class SYKeyboardTextField: UIView {
    
    fileprivate var hideing = false
    open var sending = false
    
    open var enabled: Bool = true
        {
        didSet {
            textView.isEditable = enabled
            leftButton.isEnabled = enabled
            rightButton.isEnabled = enabled
        }
    }
    open var editing : Bool
    {
        return textView.isFirstResponder
    }
    open var leftButtonHidden : Bool = true {
        didSet
        {
            leftButton.isHidden = leftButtonHidden
            self.setNeedsLayout()
        }
    }
    open var rightButtonHidden : Bool = true {
        didSet
        {
            rightButton.isHidden = rightButtonHidden
            self.setNeedsLayout()
        }
    }
    
    open var text : String! {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
            self.textViewDidChange(textView)
            self.layoutIfNeeded()
        }
    }
    
    open var maxNumberOfWords : Int = 140
    open var minNumberOfWords : Int = 0
    open var maxNumberOfLines : Int = 4
    
    
    //UI
    open lazy var keyboardView = UIView()
    open lazy var textView : SYKeyboardTextView = SYKeyboardTextView()
    open lazy var placeholderLabel = UILabel()
    open lazy var textViewBackground = UIImageView()
    open lazy var leftButton = UIButton()
    open lazy var rightButton = UIButton(type: UIButtonType.system)
    
    
    fileprivate var lastKeyboardFrame : CGRect = CGRect.zero
    
    open weak var delegate : SYKeyboardTextFieldDelegate?
    
    public override init(frame : CGRect) {
        super.init(frame : frame)
        keyboardViewDefaultHeight = frame.height
        self.backgroundColor = UIColor("#f9f9f9") //UIColor.redColor()
        
        keyboardView.frame = self.bounds
        keyboardView.backgroundColor = UIColor("#f9f9f9") //UIColor.yellowColor()
        keyboardView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.addSubview(keyboardView)
        
        keyboardView.addSubview(textViewBackground)
        
        textView.font = UIFont.systemFont(ofSize: 15.0);
        //        textView.autocapitalizationType = UITextAutocapitalizationType.Sentences
        textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, -1, 0, 1);//滚动指示器 皮条
        textView.textContainerInset = UIEdgeInsetsMake(9.0, 3.0, 7.0, 0.0);
        textView.autocorrectionType = .no
        textView.keyboardType = UIKeyboardType.default;
        textView.returnKeyType = UIReturnKeyType.done;
        textView.enablesReturnKeyAutomatically = true;
        
        textView.delegate = self
        textView.textColor = UIColor(white: 0.200, alpha: 1.000)
        //textView.backgroundColor = UIColor.greenColor()
        
        textView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        textView.scrollsToTop = false
        textView.displayBorder()
        keyboardView.addSubview(textView)
        
        placeholderLabel.textAlignment = NSTextAlignment.left
        placeholderLabel.numberOfLines = 1
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = textView.font;
        placeholderLabel.isHidden = false
        placeholderLabel.text = "placeholder"
        textView.addSubview(placeholderLabel)
        
        
        /*leftButton.backgroundColor = UIColor.redColor()
        leftButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        leftButton.setTitle("Left", forState: UIControlState.Normal)
        leftButton.addTarget(self, action: #selector(SYKeyboardTextField.leftButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        keyboardView.addSubview(leftButton)*/
        
        /*rightButton.backgroundColor = UIColor.redColor()
        rightButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        rightButton.setTitle("Right", forState: UIControlState.Normal)*/
        
        rightButton.setImage(FAKIonIcons.iosPaperplaneOutlineIcon(withSize: 30).image(with: CGSize(width: 30, height: 30)), for: UIControlState())
        
        rightButton.addTarget(self, action: #selector(SYKeyboardTextField.rightButtonAction(_:)), for: UIControlEvents.touchUpInside)
        keyboardView.addSubview(rightButton)
        
        self.registeringKeyboardNotification()
        
    }
    
    //便利初始化方法 通过关键字 convenience 然后 再通过 self.xxx 指向 指定构造函数
    public convenience init(point : CGPoint,width : CGFloat) {
        self.init(frame: CGRect(x: point.x, y: point.y, width: width, height: keyboardViewDefaultHeight))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func show () {
        self.textView.becomeFirstResponder()
    }
    
    open func hide () {
        self.textView.resignFirstResponder()
        self.endEditing(true)
    }
    open func clearTestColor() {
        self.backgroundColor = UIColor.clear
        leftButton.backgroundColor = UIColor.clear
        rightButton.backgroundColor = UIColor.clear
        textView.backgroundColor = UIColor.clear
        textViewBackground.backgroundColor = UIColor.clear
    }
    
    func leftButtonAction(_ button : UIButton) {
        self.delegate?.keyboardTextFieldPressLeftButton?(self)
    }
    
    func rightButtonAction(_ button : UIButton) {
        self.delegate?.keyboardTextFieldPressRightButton?(self)
    }
    
    
    open var leftRightDistance : CGFloat = 8.0
    open var middleDistance : CGFloat = 8.0
    
    open var buttonMaxWidth : CGFloat = 65.0
    open var buttonMinWidth : CGFloat = 45.0
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if leftButtonHidden == false {
            var leftButtonWidth : CGFloat = 0.0
            self.leftButton.sizeToFit()
            if (buttonMinWidth <= leftButton.width) {
                leftButtonWidth = leftButton.width + 10
            }else {
                leftButtonWidth = buttonMinWidth
            }
            if (leftButton.width > buttonMaxWidth)
            {
                leftButtonWidth = buttonMaxWidth
            }
            leftButton.frame = CGRect(x: leftRightDistance, y: 0, width: leftButtonWidth, height: textViewDefaultHeight);
            leftButton.toBottom(offset: (keyboardViewDefaultHeight - textViewDefaultHeight) / 2.0)
        }
        
        if rightButtonHidden == false {
            var rightButtonWidth : CGFloat = 0.0
            self.rightButton.sizeToFit()
            if (buttonMinWidth <= rightButton.width) {
                rightButtonWidth = rightButton.width + 10;
            }else {
                rightButtonWidth = buttonMinWidth
            }
            if (rightButton.width > buttonMaxWidth)
            {
                rightButtonWidth = buttonMaxWidth;
            }
            rightButton.frame = CGRect(x: keyboardView.width - leftRightDistance - rightButtonWidth, y: 0, width: rightButtonWidth, height: textViewDefaultHeight);
            rightButton.toBottom(offset: (keyboardViewDefaultHeight - textViewDefaultHeight) / 2.0)
        }
        
        textView.frame =
            CGRect(
                x: (leftButtonHidden == false ? leftButton.right + middleDistance : leftRightDistance),
                y: (keyboardViewDefaultHeight - textViewDefaultHeight) / 2.0 + 0.5,
                width: keyboardView.width
                    - (leftButtonHidden == false ? leftButton.width + middleDistance:0)
                    - (rightButtonHidden == false ? rightButton.width + middleDistance:0)
                    - leftRightDistance * 2,
                height: textViewCurrentHeightForLines(self.textView.numberOfLines())
        )
        textViewBackground.frame = textView.frame;
        
        if placeholderLabel.textAlignment == .left {
            placeholderLabel.sizeToFit()
            placeholderLabel.origin = CGPoint(x: 8.0, y: (textViewDefaultHeight - placeholderLabel.height) / 2);
            
        }else if placeholderLabel.textAlignment == .center {
            placeholderLabel.frame = placeholderLabel.superview!.bounds
        }
    }
    
    deinit {
        if SYKeyboardTextFieldDebugMode {
            print("\(NSStringFromClass(self.classForCoder)) has release!")
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
}


//MARK: TextViewHeight

extension SYKeyboardTextField {
    
    fileprivate func textViewCurrentHeightForLines(_ numberOfLines : Int) -> CGFloat
    {
        var height = textViewDefaultHeight - self.textView.font!.lineHeight
        let lineTotalHeight = self.textView.font!.lineHeight * CGFloat(numberOfLines)
        height += CGFloat(roundf(Float(lineTotalHeight)))
        return CGFloat(Int(height));
    }
    
    fileprivate func appropriateInputbarHeight() -> CGFloat
    {
        var height : CGFloat = 0.0;
        
        if self.textView.numberOfLines() == 1 {
            height = textViewDefaultHeight;
        }else if self.textView.numberOfLines() < self.maxNumberOfLines {
            height = self.textViewCurrentHeightForLines(self.textView.numberOfLines())
        }
        else {
            height = self.textViewCurrentHeightForLines(self.maxNumberOfLines)
        }
        
        height += keyboardViewDefaultHeight - textViewDefaultHeight;
        
        if (height < keyboardViewDefaultHeight) {
            height = keyboardViewDefaultHeight;
        }
        return CGFloat(roundf(Float(height)));
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let object = object,let change = change else { return }
        
        if (object as AnyObject).isEqual(self.textView) && keyPath == "contentSize" {
            if SYKeyboardTextFieldDebugMode {
                let newValue = (change[NSKeyValueChangeKey.newKey] as AnyObject).cgSizeValue
                print("\(newValue)---\(self.appropriateInputbarHeight())")
            }
            
            let newKeyboardHeight = self.appropriateInputbarHeight()
            if newKeyboardHeight != keyboardView.height && self.superview != nil {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                    let lastKeyboardFrameHeight = (self.lastKeyboardFrame.origin.y == 0.0 ? self.superview!.height : self.lastKeyboardFrame.origin.y)
                    self.frame = CGRect(x: self.frame.origin.x,  y: lastKeyboardFrameHeight - newKeyboardHeight, width: self.frame.size.width, height: newKeyboardHeight)
                    }, completion:nil
                )
            }
        }
    }
    
}

//MARK: Keyboard Notification
extension SYKeyboardTextField {
    
    var keyboardAnimationOptions : UIViewAnimationOptions {
        return  UIViewAnimationOptions(rawValue: (7 as UInt) << 16)
    }
    var keyboardAnimationDuration : TimeInterval {
        return  TimeInterval(0.25)
    }
    
    func registeringKeyboardNotification() {
        //  Registering for keyboard notification.
        NotificationCenter.default.addObserver(self, selector: #selector(SYKeyboardTextField.keyboardWillShow(_:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SYKeyboardTextField.keyboardDidShow(_:)),name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SYKeyboardTextField.keyboardWillHide(_:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SYKeyboardTextField.keyboardDidHide(_:)),name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SYKeyboardTextField.keyboardWillChangeFrame(_:)),name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SYKeyboardTextField.keyboardDidChangeFrame(_:)),name:NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        //  Registering for orientation changes notification
        NotificationCenter.default.addObserver(self, selector: #selector(SYKeyboardTextField.willChangeStatusBarOrientation(_:)),name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: nil)
        
    }
    
    func keyboardWillShow(_ notification : Notification) {
        if textView.isFirstResponder {
            self.delegate?.keyboardTextFieldWillShow?(self)
        }
    }
    func keyboardDidShow(_ notification : Notification) {
        if textView.isFirstResponder {
            self.delegate?.keyboardTextFieldDidShow?(self)
        }
    }
    func keyboardWillHide(_ notification : Notification) {
        if textView.isFirstResponder {
            hideing = true
            self.delegate?.keyboardTextFieldWillHide?(self)
        }
    }
    func keyboardDidHide(_ notification : Notification) {
        if hideing {
            hideing = false
            self.delegate?.keyboardTextFieldDidHide?(self)
        }
    }
    func keyboardWillChangeFrame(_ notification : Notification) {
        if self.window == nil { return }
        if !self.window!.isKeyWindow { return }
        
        if textView.isFirstResponder {
            var userInfo = (notification as NSNotification).userInfo as! [String : AnyObject]
            let keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardFrame = keyboardFrameValue.cgRectValue
            lastKeyboardFrame = self.superview!.convert(keyboardFrame, from: UIApplication.shared.keyWindow)
            if SYKeyboardTextFieldDebugMode {
                print("keyboardFrame : \(keyboardFrame)")
            }
            
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0.0, options: keyboardAnimationOptions, animations: { () -> Void in
                self.top = self.lastKeyboardFrame.origin.y - self.keyboardView.height
                }, completion: nil)
            
        }
    }
    
    func keyboardDidChangeFrame(_ notification : Notification) {}
    func willChangeStatusBarOrientation(_ notification : Notification) {}
    
}


//MARK: TapButtonAction
extension SYKeyboardTextField {
    
    fileprivate var tapButtonTag : Int { return 12345 }
    fileprivate var tapButton : UIButton { return self.superview!.viewWithTag(tapButtonTag) as! UIButton }
    func tapAction(_ button : UIButton) {
        self.hide()
    }
    
    fileprivate func setTapButtonHidden(_ hidden : Bool) {
        self.tapButton.isHidden = hidden
        if hidden == false {
            if let tapButtonSuperView = self.tapButton.superview {
                tapButtonSuperView.insertSubview(self.tapButton, belowSubview: self)
            }
        }
    }
    
    override open func didMoveToSuperview() {
        if let superview = self.superview {
            let tapButton = UIButton(frame: superview.bounds)
            tapButton.addTarget(self, action: #selector(SYKeyboardTextField.tapAction(_:)), for: UIControlEvents.touchUpInside)
            tapButton.tag = tapButtonTag
            tapButton.isHidden = true
            tapButton.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            tapButton.backgroundColor = UIColor.clear
            superview.insertSubview(tapButton, at: 0);
        }
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        if ((self.superview != nil) && newSuperview == nil) {
            self.superview?.viewWithTag(tapButtonTag)?.removeFromSuperview()
            textView.removeObserver(self, forKeyPath: "contentSize", context: nil)
        }
    }
}


//MARK: UITextViewDelegate
extension SYKeyboardTextField : UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        
        if (textView.text.characters.isEmpty) {
            placeholderLabel.alpha = 1
        }
        else {
            placeholderLabel.alpha = 0
        }
        
        self.delegate?.keyboardTextField?(self, didChangeText: self.textView.text)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.setTapButtonHidden(false)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.setTapButtonHidden(true)
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if sending { return false }
        if text == "\n" {
            if sending == false {
                self.delegate?.keyboardTextFieldPressReturnButton?(self)
            }
            return false
        }
        return true
    }
}

open class SYKeyboardTextView : UITextView {
    fileprivate var hasDragging : Bool = false
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.isDragging == false {
            if hasDragging {
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.hasDragging = false
                }
            }else {
                if selectedRange.location == text.characters.count {
                    self.contentOffset = CGPoint(x: self.contentOffset.x, y: (self.contentSize.height + 2) - self.height)
                }
            }
            
        }else {
            hasDragging = true
        }
    }
    
    func displayBorder(){
        self.layer.borderColor = COLOR_BTN_TINT.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
    }
    
}
private var SYKeyboardTextFieldDebugMode : Bool = false

//MARK: UITextView extension
extension UITextView {
    
    func numberOfLines() -> Int
    {
        let line = self.contentSize.height / self.font!.lineHeight
        if line < 1.0 { return 1 }
        return abs(Int(line))
    }
}
