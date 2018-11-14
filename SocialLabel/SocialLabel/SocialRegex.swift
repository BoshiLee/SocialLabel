//
//  SocialRegex.swift
//  SocialLabel
//
//  Created by Boshi Li on 2018/11/14.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import Foundation

extension SocialLabel {
    // Mark Setup Custom Regex by passing Regeies at AppDelegate didFinishLaunched
    public static func setupMentionRegex(_ regex:NSRegularExpression) {
        RegexParser.mentionRegex = regex
    }
    
    public static func setupHashtagRegex(_ regex:NSRegularExpression) {
        RegexParser.hashtagRegex = regex
    }
    
    public static func setupURLRegex(_ regex:NSRegularExpression) {
        RegexParser.urlRegex = regex
    }
}
