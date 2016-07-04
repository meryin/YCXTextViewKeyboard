//
//  ViewController.swift
//  YCXTextViewKeyboard
//
//  Created by 尹彩霞 on 16/7/1.
//  Copyright © 2016年 尹彩霞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var textView:ChangeHightTextView = ChangeHightTextView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor();
        textView = ChangeHightTextView(frame: CGRectMake(0,ScreenHeight - 50, ScreenWidth, 50));
        self.view.addSubview(textView);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil);
    
    }
    

    func keyboardWillShow(notification:NSNotification)
    {
        let diction:NSDictionary = notification.userInfo!;
        let keyBoardRect:CGRect = (diction.objectForKey("UIKeyboardFrameEndUserInfoKey")?.CGRectValue)!;
        let deltaY:CGFloat = keyBoardRect.size.height;
        let dict:NSMutableDictionary = NSMutableDictionary();
        dict.setValue(deltaY, forKey: "keyHeight")
    NSNotificationCenter.defaultCenter().postNotificationName("keyHeight", object: nil, userInfo: dict as [NSObject : AnyObject]);
        UIView.animateWithDuration((diction.objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue)!) { () -> Void in
            self.textView.transform = CGAffineTransformMakeTranslation(0,-deltaY);
            
        };
        
    }
    
    func keyboardWillHide(notification:NSNotification )
    {
        let diction:NSDictionary = notification.userInfo!;
        UIView.animateWithDuration((diction.objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue)!) { () -> Void in
            self.textView.transform = CGAffineTransformIdentity;
        };
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

