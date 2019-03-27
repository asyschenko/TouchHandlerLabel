//
//  SimpleTextTouchHandler.swift
//  TouchHandlerLabel
//
//  Created by Aleksandr Syschenko on 1/9/19.
//  Copyright © 2019 Aleksandr Syschenko. All rights reserved.
//

import Foundation

open class SimpleTextTouchHandler: BasicTouchHandler {
    
    open private (set) var text: String
    open private (set) var firstMatching: Bool
    open private (set) var caseInsensitive: Bool
    
    public init(text: String, caseInsensitive: Bool = true, firstMatching: Bool = true, handler: Handler? = nil) {
        self.text = text
        self.firstMatching = firstMatching
        self.caseInsensitive = caseInsensitive
        super.init(handler: handler)
    }
    
    open override func rangesFor(text: String) -> [NSRange] {
        var ranges = [Range<String.Index>]()
        let options: String.CompareOptions = caseInsensitive ? [String.CompareOptions.caseInsensitive] : []
        
        while let range = text.range(of: self.text, options: options, range: (ranges.last?.upperBound ?? text.startIndex)..<text.endIndex) {
            ranges.append(range)
        }
        
        let returnRanges = ranges.map({ (currentRange) -> NSRange in
            let location = currentRange.lowerBound.utf16Offset(in: text)
            let length = currentRange.upperBound.utf16Offset(in: text) - location
            
            return NSRange(location: location, length: length)
        })
        
        if let first = returnRanges.first {
            if firstMatching {
                return [first]
            }
            return returnRanges
        }
        return [NSRange]()
    }
    
}
