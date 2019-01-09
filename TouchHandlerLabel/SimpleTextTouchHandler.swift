//
//  SimpleTextTouchHandler.swift
//  TouchHandlerLabel
//
//  Created by Aleksandr Syschenko on 1/9/19.
//  Copyright © 2019 Aleksandr Syschenko. All rights reserved.
//

import Foundation

open class RegExpTouchHandler: BasicTouchHandler {
    
    open private (set) var regExp: NSRegularExpression
    open private (set) var firstMatching: Bool
    
    public init(regExp: NSRegularExpression, firstMatching: Bool = true, handler: Handler? = nil) {
        self.regExp = regExp
        self.firstMatching = firstMatching
        super.init(handler: handler)
    }
    
    open override func rangesFor(text: String) -> [NSRange] {
        let result = regExp.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        
        if let first = result.first {
            if firstMatching {
                return [first.range]
            }
            return result.map({ (resultItem) -> NSRange in
                return resultItem.range
            })
        }
        return [NSRange]()
    }
    
}
