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

struct MentionUser: Codable{
    let account: String
    let nickName: String
    let shouldActiveInt: Int
    
    enum CodingKeys: String, CodingKey {
        case account
        case nickName
        case shouldActiveInt = "canLink"
    }
}

extension MentionUser {
    var shouldActive: Bool { return self.shouldActiveInt == 1}
}

struct SocialElement {
    let type: SocialType
    let content: String
    let range: NSRange
}

/// key = id, value: MentionUser
typealias MentionDict = [String: MentionUser]
