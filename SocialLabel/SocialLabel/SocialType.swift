//
//  SocialType.swift
//  SocialLabel
//
//  Created by Boshi Li on 2018/11/14.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import Foundation

public enum SocialType {
    case mention
    case hashtag
    case url
    
    var pattern: String {
        switch self {
        case .mention: return RegexParser.mentionRegex!.pattern
        case .hashtag: return RegexParser.hashtagRegex!.pattern
        case .url: return RegexParser.urlRegex!.pattern
        }
    }
}

struct SocialElement {
    let type: SocialType
    let content: String
    let range: NSRange
}
/// key = id, value: nickName
typealias MentionDict = [String: String]
