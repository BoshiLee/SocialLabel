//
//  SocialLabel.swift
//  SocialLabel
//
//  Created by Boshi Li on 2018/11/14.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

public protocol ActiveLabelDelegate: class {
    func didSelect(_ text: String, type: SocialType)
}

class SocialLabel: UILabel {
    
    // MARK: - override UILabel properties
    override open var text: String? {
        didSet { updateTextStorage() }
    }
    
    override open var attributedText: NSAttributedString? {
        didSet { updateTextStorage() }
    }
    
    override open var font: UIFont! {
        didSet { updateTextStorage(parseText: false) }
    }
    
    override open var textColor: UIColor! {
        didSet { updateTextStorage(parseText: false) }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet { updateTextStorage(parseText: false)}
    }
    
    open override var numberOfLines: Int {
        didSet { textContainer.maximumNumberOfLines = numberOfLines }
    }
    
    open override var lineBreakMode: NSLineBreakMode {
        didSet { textContainer.lineBreakMode = lineBreakMode }
    }
    
    // MARK: - Inspectable Properties
    @IBInspectable open var mentionFont: UIFont?  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var mentionColor: UIColor = .blue  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var mentionSelectedColor: UIColor?  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var mentionUnderLineStyle: NSUnderlineStyle = []  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var hashtagFont: UIFont?  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var hashtagColor: UIColor = .blue  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var hashtagSelectedColor: UIColor?  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var hashtagUnderLineStyle: NSUnderlineStyle = []  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var URLColor: UIColor = .blue  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var URLSelectedColor: UIColor?  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var URLFont: UIFont?  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable open var URLUnderLineStyle: NSUnderlineStyle = []  {
        didSet { updateTextStorage(parseText: false) }
    }

    @IBInspectable public var minimumLineHeight: CGFloat = 0 {
        didSet { updateTextStorage(parseText: false) }
    }
    
    @IBInspectable public var lineSpacing: CGFloat = 0 {
        didSet { updateTextStorage(parseText: false) }
    }
    
    // MARK: - Private Properties don't open it
    private lazy var cachedSocialElements: [SocialElement] = [SocialElement]()
    var selectedElement: SocialElement?
    
    fileprivate var _customizing: Bool = true
    internal lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
    private var heightCorrection: CGFloat = 0
    
    internal var mentionTapHandler: ((String) -> ())?
    internal var hashtagTapHandler: ((String) -> ())?
    internal var urlTapHandler: ((URL) -> ())?
    
    // MARK: - public properties
    open var mentionDict: MentionDict = MentionDict() {
        didSet { updateTextStorage() }
    }
    open var enableType: [SocialType] = [.mention, .hashtag, .url]
    
    open weak var delegate: ActiveLabelDelegate?
    
    // MARK: - public methods
    open func handleMentionTap(_ handler: @escaping (String) -> ()) {
        mentionTapHandler = handler
    }
    
    open func handleHashtagTap(_ handler: @escaping (String) -> ()) {
        hashtagTapHandler = handler
    }
    
    open func handleURLTap(_ handler: @escaping (URL) -> ()) {
        urlTapHandler = handler
    }
    
    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        _customizing = false
        self.setupLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _customizing = false
        self.setupLabel()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate func updateTextStorage(parseText: Bool = true) {
        if _customizing { return }
        // clean up previous active elements
        guard let attributedText = self.attributedText, attributedText.length > 0 else {
            self.clearActiveElements()
            self.textStorage.setAttributedString(NSAttributedString())
            setNeedsDisplay()
            return
        }
        
        let mutAttrString = addLineBreak(attributedText)
        
        if parseText {
            self.clearActiveElements()
            let newString = parseTextAndExtractActiveElements(mutAttrString)
            mutAttrString.mutableString.setString(newString)
        }
        
        textStorage.setAttributedString(mutAttrString)
        _customizing = true
        self.setAttrbuite(formText: mutAttrString.mutableString as String, with: self.cachedSocialElements)
        text = mutAttrString.string
        _customizing = false
        setNeedsDisplay()
    }
    
    fileprivate func clearActiveElements() {
        selectedElement = nil
        self.cachedSocialElements.removeAll()
        
    }
    
    /// use regex check all link ranges
    fileprivate func parseTextAndExtractActiveElements(_ attrString: NSAttributedString) -> String {
        var textString = attrString.string
        var elements: [SocialElement] = []
        elements.append(contentsOf: RegexParser.relpaceMentions(form: &textString, with: self.mentionDict))
        elements.append(contentsOf: RegexParser.matches(from: textString, withSocialType: .hashtag))
        elements.append(contentsOf: RegexParser.matches(from: textString, withSocialType: .url))
        self.cachedSocialElements = elements
        return textString
    }
    
    /// add line break mode
    fileprivate func addLineBreak(_ attrString: NSAttributedString) -> NSMutableAttributedString {
        let mutAttrString = NSMutableAttributedString(attributedString: attrString)
        
        var range = NSRange(location: 0, length: 0)
        var attributes = mutAttrString.attributes(at: 0, effectiveRange: &range)
        
        let paragraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.minimumLineHeight = minimumLineHeight > 0 ? minimumLineHeight: self.font.pointSize * 1.14
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        mutAttrString.setAttributes(attributes, range: range)
        
        return mutAttrString
    }
    
    /**
     Use this func to active social elements in labe
     - Parameter mentionDict: Pass this parameter for create custom mention id, NickName
     - format = [id: nickName]
     */
    open func becomeSocialized(withMentionDict mentionDict: MentionDict = MentionDict()) {
        self.mentionDict = mentionDict
    }
    
    private func setupLabel() {
        
        // setup tap handle properties
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        isUserInteractionEnabled = true
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        
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
            guard self.enableType.contains(socialType) else { break }
            attributes[.font] = mentionFont ?? font!
            attributes[.foregroundColor] = mentionColor
            attributes[.underlineStyle] = mentionUnderLineStyle.rawValue
        case .hashtag:
            guard self.enableType.contains(socialType) else { break }
            attributes[.font] = hashtagFont ?? font!
            attributes[.foregroundColor] = hashtagColor
            attributes[.underlineStyle] = hashtagUnderLineStyle.rawValue
        case .url:
            guard self.enableType.contains(socialType) else { break }
            attributes[.font] = URLFont ?? font!
            attributes[.foregroundColor] = URLColor
            attributes[.underlineStyle] = URLUnderLineStyle.rawValue
        }
        return attributes
    }
    
    
}

extension SocialLabel {
    
    open override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        textContainer.size = CGSize(width: superSize.width, height: CGFloat.greatestFiniteMagnitude)
        let size = layoutManager.usedRect(for: textContainer)
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    open override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)

        textContainer.size = rect.size
        let newOrigin = textOrigin(inRect: rect)

        layoutManager.drawBackground(forGlyphRange: range, at: newOrigin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }

    private func textOrigin(inRect rect: CGRect) -> CGPoint {
        let usedRect = layoutManager.usedRect(for: textContainer)
        heightCorrection = (rect.height - usedRect.height)/2
        let glyphOriginY = heightCorrection > 0 ? rect.origin.y + heightCorrection : rect.origin.y
        return CGPoint(x: rect.origin.x, y: glyphOriginY)
    }

}

extension SocialLabel {
    fileprivate func element(at location: CGPoint) -> SocialElement? {
        guard textStorage.length > 0 else {
            return nil
        }
        
        var correctLocation = location
        correctLocation.y -= heightCorrection
        let boundingRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
        guard boundingRect.contains(correctLocation) else {
            return nil
        }
        
        let index = layoutManager.glyphIndex(for: correctLocation, in: textContainer)
        
        for element in self.cachedSocialElements {
            if index >= element.range.location && index <= element.range.location + element.range.length {
                return element
            }
        }
        
        return nil
    }
    
    // MARK: - touch events
    func onTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        var avoidSuperCall = false
        
        switch touch.phase {
        case .began, .moved:
            if let element = element(at: location) {
                if element.range.location != selectedElement?.range.location || element.range.length != selectedElement?.range.length {
                    selectedElement = element
                }
                avoidSuperCall = true
            } else {
                selectedElement = nil
            }
        case .ended:
            guard let selectedElement = selectedElement else { return avoidSuperCall }
            
            switch selectedElement.type {
            case .mention: self.didTapMention(selectedElement.content)
            case .hashtag: self.didTapHashtag(selectedElement.content)
            case .url: self.didTapStringURL(selectedElement.content)
            }
            
            let when = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.selectedElement = nil
            }
            avoidSuperCall = true
        case .cancelled:
            selectedElement = nil
        case .stationary:
            break
        }
        
        return avoidSuperCall
    }
    
    //MARK: - ActiveLabel handler
    fileprivate func didTapMention(_ userId: String) {
        guard let mentionHandler = mentionTapHandler else {
            delegate?.didSelect(userId, type: .mention)
            return
        }
        mentionHandler(userId)
    }
    
    fileprivate func didTapHashtag(_ hashtag: String) {
        guard let hashtagHandler = hashtagTapHandler else {
            delegate?.didSelect(hashtag, type: .hashtag)
            return
        }
        hashtagHandler(hashtag)
    }
    
    fileprivate func didTapStringURL(_ stringURL: String) {
        guard let urlHandler = urlTapHandler, let url = URL(string: stringURL) else {
            delegate?.didSelect(stringURL, type: .url)
            return
        }
        urlHandler(url)
    }
    
    open func removeHandle(for type: SocialType) {
        switch type {
        case .hashtag:
            hashtagTapHandler = nil
        case .mention:
            mentionTapHandler = nil
        case .url:
            urlTapHandler = nil
        }
    }

}
//MARK: - Handle UI Responder touches
extension SocialLabel {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesMoved(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        _ = onTouch(touch)
        super.touchesCancelled(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesEnded(touches, with: event)
    }

}

extension SocialLabel: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
