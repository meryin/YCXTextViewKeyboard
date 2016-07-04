//
//  ChangeHightTextView.swift
//  YCXTextViewKeyboard
//
//  Created by 尹彩霞 on 16/7/1.
//  Copyright © 2016年 尹彩霞. All rights reserved.
//

import UIKit

let ScreenWidth:CGFloat = UIScreen.mainScreen().bounds.size.width;
let ScreenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height;
let fontSize:CGFloat  = 14.0;//输入框字体大小
let inputLineNum:CGFloat = 4.0;//最多四行的高度

class ChangeHightTextView: UIView,UITextViewDelegate {

    var textView:UITextView = UITextView();
    var keyHight:Double = 0.0;
    var heightText:CGFloat = 0.0;
    var orgin_y:CGFloat = 0.0;
    var height:CGFloat = 0.0;
    override init(frame: CGRect) {
        super.init(frame: frame);
        orgin_y = frame.origin.y;
        height = frame.size.height;
        
        self.backgroundColor = RGB(136, g: 136, b: 136);//背景色
        initTextView(frame);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func RGB(r:CGFloat,g:CGFloat,b:CGFloat)->UIColor
    {
       return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1);
    }
    
    func initTextView(frame:CGRect)
    {
        textView = UITextView(frame: CGRectMake(10, 5, ScreenWidth-90, frame.size.height-10));
        textView.backgroundColor = UIColor.whiteColor();//输入框背景色
        textView.delegate = self;
        textView.returnKeyType = UIReturnKeyType.Send;
        textView.font = UIFont.systemFontOfSize(fontSize);
        self.addSubview(textView);
        let btn :UIButton = UIButton(type: UIButtonType.Custom);
        self.addSubview(btn);
        btn.frame = CGRectMake(ScreenWidth-75, 5, 65, frame.size.height-10);
        btn.setTitle("发送", forState: UIControlState.Normal);
        btn.addTarget(self, action: "submit", forControlEvents: UIControlEvents.TouchUpInside);
        btn.setTitleColor(RGB(51, g: 51, b: 51), forState: UIControlState.Normal);//发送按钮背景色
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getKeyBoardHeight:", name: "keyHeight", object: nil);
        
    }
    
    func submit()
    {
        textView.resignFirstResponder();
        
    }
    
    func getKeyBoardHeight(notification:NSNotification)
    {
        let name = notification.userInfo!["keyHeight"];
        keyHight = (name?.doubleValue)!;
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        changeHeight(textView);
    }
    
    func textViewDidChange(textView: UITextView) {
        changeHeight(textView);
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n" )
        {
            submit();
            return false;
        }
        else {
           return true;
        }
    }
    
    func changeHeight(textView:UITextView)
    {
        var currentLineNum:CGFloat = 1.0;
        let textViewWidth:CGFloat = textView.frame.size.width;
        let content :NSString = NSString(CString: textView.text!.cStringUsingEncoding(NSUTF8StringEncoding)!,
            encoding: NSUTF8StringEncoding)!;
//        let option = NSStringDrawingOptions.UsesLineFragmentOrigin;
        let dict :NSDictionary = [NSFontAttributeName: textView.font!];
        
//        let contentSize:CGSize = content.boundingRectWithSize(CGSizeMake(2000, 1000), options: option, attributes: dict as? [String : AnyObject], context: nil).size;
        let contentSize:CGSize = content.sizeWithAttributes(dict as? [String : AnyObject]);
        
        let numLine = ceil(contentSize.width/textViewWidth);
        
        heightText = contentSize.height;
        if( numLine > currentLineNum )
        {
            if ( numLine < inputLineNum )//最多高4行
            {
                let h1:CGFloat = heightText * (numLine-currentLineNum);
                let y:CGFloat = orgin_y - CGFloat.init(keyHight) - h1;
                
                self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, height+h1);
                textView.frame=CGRectMake(textView.frame.origin.x,5, textView.frame.size.width, height - 10 + heightText*(numLine-currentLineNum));
                
            }
            else
                
            {
                
                self.frame=CGRectMake(self.frame.origin.x,orgin_y - CGFloat.init(keyHight)-heightText*2, self.frame.size.width, height+heightText*2);
                
                textView.frame=CGRectMake(textView.frame.origin.x,5, textView.frame.size.width, height-10+heightText*2);
                
            }
            
            currentLineNum = numLine;
        }
        else if (numLine < currentLineNum ){
    
        //次数为删除的时候检测文字行数减少的时候
        
        self.frame=CGRectMake(self.frame.origin.x,orgin_y-CGFloat.init(keyHight), self.frame.size.width, height);
        
        textView.frame=CGRectMake(textView.frame.origin.x, 5, textView.frame.size.width, height-10);
        
        currentLineNum = numLine;
        
        }

    }
}
