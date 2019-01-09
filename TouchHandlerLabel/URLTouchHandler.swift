//
//  URLTouchHandler.swift
//  TouchHandlerLabel
//
//  Created by Aleksandr Syschenko on 1/9/19.
//  Copyright © 2019 Aleksandr Syschenko. All rights reserved.
//

import Foundation

open class URLTouchHandler: RegExpTouchHandler {
    
    public init(firstMatching: Bool = false, handler: Handler? = nil) {
        let pattern = "[\\w]*:\\/\\/[\\w\\d\\/\\.\\-%#_@?:=&]+"
        var regExp = NSRegularExpression()
        
        if let urlRegExp = try? NSRegularExpression(pattern: pattern, options: []) {
            regExp = urlRegExp
        }
        super.init(regExp: regExp, firstMatching: firstMatching, handler: handler)
        underlineStyle = .single
    }
    
}
