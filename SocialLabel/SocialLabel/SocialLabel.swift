//
//  SocialLabel.swift
//  SocialLabel
//
//  Created by Boshi Li on 2018/11/14.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

class SocialLabel: UILabel {
    
    // MARK: - Inspectable Properties
    @IBInspectable open var mentionFont: UIFont?
    @IBInspectable open var mentionColor: UIColor = .blue
    @IBInspectable open var mentionSelectedColor: UIColor?
    @IBInspectable open var mentionUnderLineStyle: NSUnderlineStyle = []
    @IBInspectable open var hashtagFont: UIFont?
    @IBInspectable open var hashtagColor: UIColor = .blue
    @IBInspectable open var hashtagSelectedColor: UIColor?
    @IBInspectable open var hashtagUnderLineStyle: NSUnderlineStyle = []
    @IBInspectable open var URLColor: UIColor = .blue
    @IBInspectable open var URLSelectedColor: UIColor?
    @IBInspectable open var URLFont: UIFont?
    @IBInspectable open var URLUnderLineStyle: NSUnderlineStyle = []
    
    open var mentionDict: MentionDict = MentionDict()

    static var enableType: [SocialType] = [.mention, .hashtag, .url]
    private lazy var cachedSocialElements: [SocialElement] = [SocialElement]()
        // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open func becomeSocialized() {
        self.setupLabel()
    }
    
    private func setupLabel() {
        guard var text = self.text else { return }
        var elements: [SocialElement] = []
        elements.append(contentsOf: RegexParser.relpaceMentions(form: &text, with: self.mentionDict))
        elements.append(contentsOf: RegexParser.matches(from: text, withSocialType: .hashtag))
        elements.append(contentsOf: RegexParser.matches(from: text, withSocialType: .url))
        self.cachedSocialElements = elements
        self.text = text
        self.setAttrbuite(formText: text, with: elements)
    }
    
    private func setAttrbuite(formText text: String, with elements: [SocialElement]) {
        let mutableString = NSMutableAttributedString(string: text)
        elements.forEach {
            mutableString.setAttributes(self.createAttributes(with: $0.type), range: $0.range)
        }
        self.attributedText = mutableString
    }
    
    private func createAttributes(with socialType: SocialType) -> [NSAttributedString.Key : Any] {
        var attributes = [NSAttributedString.Key : Any]()
        switch socialType {
        case .mention:
            guard SocialLabel.enableType.contains(socialType) else { break }
            attributes[.font] = mentionFont ?? font!
            attributes[.foregroundColor] = mentionColor
            attributes[.underlineStyle] = mentionUnderLineStyle.rawValue
        case .hashtag:
            guard SocialLabel.enableType.contains(socialType) else { break }
            attributes[.font] = hashtagFont ?? font!
            attributes[.foregroundColor] = hashtagColor
            attributes[.underlineStyle] = hashtagUnderLineStyle.rawValue
        case .url:
            guard SocialLabel.enableType.contains(socialType) else { break }
            attributes[.font] = URLFont ?? font!
            attributes[.foregroundColor] = URLColor
            attributes[.underlineStyle] = URLUnderLineStyle.rawValue
        }
        return attributes
    }
    
}
