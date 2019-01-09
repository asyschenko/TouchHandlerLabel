//
//  BasicTouchHandler.swift
//  TouchHandlerLabel
//
//  Created by Aleksandr Syschenko on 1/9/19.
//  Copyright © 2019 Aleksandr Syschenko. All rights reserved.
//

import Foundation

open class BasicTouchHandler: TouchHandler {
    
    public typealias Handler = (NSRange, String) -> Void
    
    open var normalAttributes = [NSAttributedString.Key: Any]()
    open var selectedAttributes = [NSAttributedString.Key: Any]()
    open var handler: Handler?
    
    public init(handler: Handler? = nil) {
        self.handler = handler
    }
    
    open func rangesFor(text: String) -> [NSRange] {
        return [NSRange]() // Stub
    }
    
    open func attributesForNormalStateBy(range: NSRange) -> [NSAttributedString.Key: Any] {
        return normalAttributes
    }
    
    open func attributesForSelectedStateBy(range: NSRange) -> [NSAttributedString.Key : Any] {
        return selectedAttributes
    }
    
    open func handleClickBy(range: NSRange, text: String) {
        handler?(range, text)
    }
    
}

extension BasicTouchHandler {
    
    open var normalColor: UIColor? {
        set {
            guard let color = newValue else {
                return
            }
            normalAttributes[NSAttributedString.Key.foregroundColor] = color
        }
        get {
            return normalAttributes[NSAttributedString.Key.foregroundColor] as? UIColor
        }
    }
    open var selectedColor: UIColor? {
        set {
            guard let color = newValue else {
                return
            }
            selectedAttributes[NSAttributedString.Key.foregroundColor] = color
        }
        get {
            return selectedAttributes[NSAttributedString.Key.foregroundColor] as? UIColor
        }
    }
    open var underlineStyle: NSUnderlineStyle? {
        set {
            normalAttributes[NSAttributedString.Key.underlineStyle] = newValue?.rawValue
            selectedAttributes[NSAttributedString.Key.underlineStyle] = newValue?.rawValue
        }
        get {
            guard let style = normalAttributes[NSAttributedString.Key.underlineStyle] as? Int else {
                return nil
            }
            return NSUnderlineStyle(rawValue: style)
        }
    }
    
}

