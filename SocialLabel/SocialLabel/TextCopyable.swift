//
//  TextCopyable.swift
//  SocialLabel
//
//  Created by Boshi Li on 2018/11/14.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

// MARK: - Copyable
extension SocialLabel {
    
    override open var canBecomeFirstResponder: Bool { return true }
    var menu: UIMenuController {
        return UIMenuController.shared
    }
    
    // 让其有交互能力，并添加一个长按手势
    func setupCopyable() {
        isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clickLabel)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.menuWillHide), name: UIMenuController.willHideMenuNotification, object: nil)
    }
    
    @objc func menuWillHide() {
        self.backgroundColor = .clear
    }
    
    @objc func clickLabel() {
        
        // 让其成为响应者
        self.becomeFirstResponder()
        self.backgroundColor =  #colorLiteral(red: 0.67, green: 0.67, blue: 0.67, alpha: 1)
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
        // 拿出菜单控制器单例
        
        // 创建一个复制的item
        let copy = UIMenuItem(title: "Copy", action: #selector(copyText))
        // 将复制的item交给菜单控制器（菜单控制器其实可以接受多个操作）
        menu.menuItems = [copy]
        // 设置菜单控制器的点击区域为这个控件的bounds
        menu.setTargetRect(bounds, in: self)
        // 显示菜单控制器，默认是不可见状态
        menu.setMenuVisible(true, animated: true)
        
    }
    
    @objc func copyText() {
        UIPasteboard.general.string = self.text
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copyText) {
            return true
        } else {
            return false
        }
    }
    
}
