//
//  ViewController.swift
//  SocialLabel
//
//  Created by Boshi Li on 2018/11/14.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var testString: String =
    """
活動畢業
拿到聖杯立刻餵給術閃～

我迦術閃lv90 了☺️
"""
    
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
        
        let gamplexDev: MentionUser = MentionUser(account: "gamplexDev", nickName: "Gamplex小編👩‍👩‍👦ggg", shouldActiveInt: 1)

        let mentions = [gamplexDev]
        
        self.socialLabel.setContent(self.testString, mentions: mentions)
        let activeFont = UIFont.boldSystemFont(ofSize: 14.0)
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

