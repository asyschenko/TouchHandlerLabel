//
//  TouchHandler.swift
//  TouchHandlerLabel
//
//  Created by Aleksandr Syschenko on 1/9/19.
//  Copyright © 2019 Aleksandr Syschenko. All rights reserved.
//

import Foundation

public protocol TouchHandler {
    
    func rangesFor(text: String) -> [NSRange]
    func attributesForNormalStateBy(range: NSRange) -> [NSAttributedString.Key: Any]
    func attributesForSelectedStateBy(range: NSRange) -> [NSAttributedString.Key: Any]
    func handleClickBy(range: NSRange, text: String)
    
}
