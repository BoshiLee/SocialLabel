//
//  RegexParser.swift
//  SocialLabel
//
//  Created by Boshi Li on 2018/11/14.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import Foundation

struct RegexParser {
    
    static var hashtagRegex = try? NSRegularExpression(pattern: "#(.+?)(?=[\\s]|$)", options: [.caseInsensitive])
    static var mentionRegex = try? NSRegularExpression(pattern: "(\\<tagUser\\>\\@)(.+?)(\\<\\/tagUser\\>)", options: [.caseInsensitive]);
    static var urlRegex = try? NSRegularExpression(pattern: "(?:http(s)?\\:\\/\\/|www\\.)(.+?)(?=[\\s]|$)", options: [.caseInsensitive])
    
    private static var cachedRegularExpressions: [String : NSRegularExpression] = [:]
    
    static func regularExpression(forSocialType type: SocialType) -> NSRegularExpression? {
        switch type {
        case .mention:
            return self.mentionRegex
        case .hashtag:
            return self.hashtagRegex
        case .url:
            return self.urlRegex
        }
    }
    
}
