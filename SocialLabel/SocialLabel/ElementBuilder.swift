//
//  ElementBuilder.swift
//  SocialLabel
//
//  Created by Boshi Li on 2018/11/15.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import Foundation

struct ElementBuilder {
    
    static func matches(from text: String, withSocialType type: SocialType) -> [String] {
        guard let regex = RegexParser.regularExpression(forSocialType: type) else { return [] }
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return results.map { String(text[Range($0.range, in: text)!]) }
    }
    
    static func matches(from text: String, withSocialType type: SocialType) -> [SocialElement] {
        guard let regex = RegexParser.regularExpression(forSocialType: type) else { return [] }
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return results.map {
            let nsRange = text.nsRange(from: Range($0.range, in: text)!)
            let subString = text.subString(with: nsRange)
            return SocialElement(type: type, content: subString, range: nsRange)
        }
    }
    
    static func matchesMentions(form text: String) -> [NSRange] {
        guard let regex = RegexParser.regularExpression(forSocialType: .mention) else { return [] }
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return results.map { text.nsRange(from: Range($0.range, in: text)!) }
    }
    
    static func matchesFirstMention(form text: String) -> NSRange? {
        guard let regex = RegexParser.regularExpression(forSocialType: .mention) else { return nil}
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        guard !results.isEmpty, let firstResult = results.first else {
            return nil
        }
        return text.nsRange(from: Range(firstResult.range, in: text)!)
    }
    
    static func relpaceMentions(form text: inout String, with mentionDict: MentionDict) -> [SocialElement] {
        var newElements = [SocialElement]()
        let counts = self.matchesMentions(form: text).count
        for _ in 0..<counts {
            guard let nickNameRange = self.replaceFirstMention(form: &text, with: mentionDict) else { continue }
            newElements.append(nickNameRange)
        }
        return newElements
    }
    
    private static func replaceFirstMention(form text: inout String, with mentionDict: MentionDict) -> SocialElement? {
        var originText = text
        guard let fristMention = self.matchesFirstMention(form: originText) else { return nil }
        guard let fristMentionRange = originText.range(from: fristMention) else { return nil }
        let fristMentionTag = originText.subString(with: fristMention)
        let id = self.getId(fristMentionTag)
        guard let user = mentionDict[id] else { return nil }
        // 移除第一個 tag
        originText.replaceSubrange(fristMentionRange, with: "")
        // 插入 nickNameTag
        let nickNameMention = "@\(user.nickName)"
        let firstIndex = fristMentionRange.lowerBound
        originText.insert(contentsOf: nickNameMention, at: firstIndex)
        // 取得 nickNameTag 的 NSRange
        let nickNameRange = NSRange(location: fristMention.location, length: nickNameMention.characterLength)
        text = originText
        return SocialElement(type: .mention, content: id, range: nickNameRange)
    }

    private static func getId(_ mentionTag: String) -> String {
        return String(mentionTag.removeHTMLTags().dropFirst())
    }
}
