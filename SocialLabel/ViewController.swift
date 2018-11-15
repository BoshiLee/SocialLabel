//
//  ViewController.swift
//  SocialLabel
//
//  Created by Boshi Li on 2018/11/14.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var testString: String = "你好啊啊啊http://www.bump.app 啊啊啊啊啊ㄚ ㄘ<tagUser>@Vvvv</tagUser>AA🌡B啊啊啊 🃂◉♼ #AAAAAA<tagUser>@aav</tagUser> 發發發55💃🏾5 #123 "
    
    @IBOutlet weak var originLabel: UILabel! {
        didSet {
            self.originLabel.text = testString
        }
    }
    
    @IBOutlet weak var socialLabel: SocialLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLable()
    }
    
    func setupLable() {
        var mentionDict: MentionDict = MentionDict()
        mentionDict["Vvvv"] = "👨‍👨‍👧‍👧Ray🤬 🤬🤬🤬C👨‍👨‍👧‍👧👨‍👨‍👧‍👧🧖🏿‍♂️h"
        mentionDict["aav"] = "Lee🥵 B🥵o🥵.🥵 s👨‍👨‍👧‍👧h👼🏿i"
        self.socialLabel.mentionDict = mentionDict
        self.socialLabel.text = testString
        let activeFont = UIFont.boldSystemFont(ofSize: 13.0)
        self.socialLabel.hashtagColor = .tagBlue
        self.socialLabel.hashtagFont = activeFont
        self.socialLabel.URLColor = .textBlack
        self.socialLabel.URLUnderLineStyle = .single
        self.socialLabel.URLFont = activeFont
        self.socialLabel.mentionColor = .tagBlue
        self.socialLabel.mentionFont = activeFont
        
        self.socialLabel.handleURLTap { print($0) }
        self.socialLabel.handleHashtagTap { print($0) }
        self.socialLabel.handleMentionTap { print($0)}
    }
    

}

