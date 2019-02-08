//
//  TouchHandlerLabel.swift
//  TouchHandlerLabel
//
//  Created by Aleksandr Syschenko on 1/9/19.
//  Copyright © 2019 Aleksandr Syschenko. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct TouchHandlerItem {
    
    var ranges: [NSRange]
    var touchHandler: TouchHandler
    
}

open class TouchHandlerLabel: UILabel {
    
    // MARK: - Private properties
    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer()
    private let textStorage = NSTextStorage()
    private var touchHandlerItems = [TouchHandlerItem]()
    private var selectedRange: NSRange?
    private var selectedItem: TouchHandlerItem?
    
    // MARK: - Overridden properties
    override open var text: String? {
        didSet {
            updateTouchHandlerItems()
        }
    }
    
    override open var attributedText: NSAttributedString? {
        didSet {
            updateTouchHandlerItems()
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            updateTouchHandlerItems()
        }
    }
    
    override open var textColor: UIColor! {
        didSet {
            updateTouchHandlerItems()
        }
    }
    
    override open var font: UIFont! {
        didSet {
            updateTouchHandlerItems()
        }
    }
    
    override open var lineBreakMode: NSLineBreakMode {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }
    
    override open var numberOfLines: Int {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            textContainer.size = bounds.size
        }
    }
    
    // MARK: - Private methods
    private func correct(attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var newAttributes = attributes
        
        if attributes[NSAttributedString.Key.foregroundColor] == nil {
            newAttributes[NSAttributedString.Key.foregroundColor] = textColor
        }
        
        if attributes[NSAttributedString.Key.font] == nil {
            newAttributes[NSAttributedString.Key.font] = font
        }
        
        if attributes[NSAttributedString.Key.paragraphStyle] == nil {
            let paragraph = NSMutableParagraphStyle()
            
            paragraph.alignment = textAlignment
            newAttributes[NSAttributedString.Key.paragraphStyle] = paragraph
        }
        return newAttributes
    }
    
    private func updateTextStorage(attributedText: NSAttributedString?) {
        guard let attributedText = attributedText else {
            return
        }
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        
        mutableAttributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length),
                                                  options: []) { (attributes, range, _) in
                                                    mutableAttributedText.setAttributes(correct(attributes: attributes), range: range)
        }
        textStorage.setAttributedString(mutableAttributedText)
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.size = bounds.size
        
        updateTextStorage(attributedText: self.attributedText)
        setNeedsDisplay()
    }
    
    private func textOrigin(inRect rect: CGRect) -> CGPoint {
        let usedRect = layoutManager.usedRect(for: textContainer)
        let heightCorrection = (rect.height - usedRect.height) / 2.0
        let glyphOriginY = heightCorrection > 0.0 ? rect.origin.y + heightCorrection : rect.origin.y
        
        return CGPoint(x: rect.origin.x, y: glyphOriginY)
    }
    
    private func updateTouchHandlerItems() {
        updateTextStorage(attributedText: update(attributedText: attributedText))
        setNeedsDisplay()
    }
    
    private func update(attributedText: NSAttributedString?) -> NSAttributedString? {
        var attrString: NSMutableAttributedString?
        
        if let attributedText = attributedText {
            attrString = NSMutableAttributedString(attributedString: attributedText)
            
            for i in 0..<touchHandlerItems.count {
                touchHandlerItems[i].ranges = touchHandlerItems[i].touchHandler.rangesFor(text: attributedText.string)
                touchHandlerItems[i].ranges.forEach { (currentRange) in
                    attrString?.setAttributes(touchHandlerItems[i].touchHandler.attributesForNormalStateBy(range: currentRange), range: currentRange)
                }
            }
        }
        return attrString
    }
    
    private func touchEnd(touch: UITouch, handle: Bool = true) {
        if let selectedItem = selectedItem, let selectedRange = selectedRange {
            let attributes = selectedItem.touchHandler.attributesForNormalStateBy(range: selectedRange)
            
            textStorage.setAttributes(correct(attributes: attributes), range: selectedRange)
            setNeedsDisplay()
            
            if handle {
                let location = touch.location(in: self)
                var glyphRange = NSRange()
                
                layoutManager.characterRange(forGlyphRange: selectedRange, actualGlyphRange: &glyphRange)
                
                if layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer).contains(location) {
                    var returnString = ""
                    
                    if let range = Range(selectedRange, in: textStorage.string) {
                        returnString = String(textStorage.string[range])
                    }
                    selectedItem.touchHandler.handleClickBy(range: selectedRange, text: returnString)
                }
            }
        }
        selectedItem = nil
        selectedRange = nil
    }
    
    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Public methods
    open func add(touchHandler: TouchHandler) {
        var ranges = [NSRange]()
        
        if let text = text {
            ranges = touchHandler.rangesFor(text: text)
        }
        let currentTouchHandlerItem = TouchHandlerItem(ranges: ranges, touchHandler: touchHandler)
        
        touchHandlerItems.append(currentTouchHandlerItem)
        updateTextStorage(attributedText: update(attributedText: attributedText))
        setNeedsDisplay()
    }
    
    // MARK: - Overriden public methods
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        
        touchHandlerItems.forEach { (currentItem) in
            currentItem.ranges.forEach({ (currentRange) in
                var glyphRange = NSRange()
                
                layoutManager.characterRange(forGlyphRange: currentRange, actualGlyphRange: &glyphRange)
                
                if layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer).contains(location) {
                    let attributes = currentItem.touchHandler.attributesForSelectedStateBy(range: currentRange)
                    
                    selectedItem = currentItem
                    selectedRange = currentRange
                    textStorage.setAttributes(correct(attributes: attributes), range: currentRange)
                    setNeedsDisplay()
                }
            })
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        touchEnd(touch: touch)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        touchEnd(touch: touch, handle: false)
    }
    
    open override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        
        textContainer.size = rect.size
        let newOrigin = textOrigin(inRect: rect)
        
        layoutManager.drawBackground(forGlyphRange: range, at: newOrigin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }
    
}
