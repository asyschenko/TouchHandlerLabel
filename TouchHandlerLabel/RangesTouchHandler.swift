//
//  RangesTouchHandler.swift
//  TouchHandlerLabel
//
//  Created by Aleksandr Syschenko on 1/9/19.
//  Copyright © 2019 Aleksandr Syschenko. All rights reserved.
//

import Foundation

open class RangesTouchHandler: BasicTouchHandler {
    
    open private (set) var ranges = [NSRange]()
    
    public init(ranges: [NSRange], handler: Handler? = nil) {
        self.ranges = ranges
        super.init(handler: handler)
    }
    
    open override func rangesFor(text: String) -> [NSRange] {
        return ranges
    }
    
}
