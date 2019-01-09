//
//  ViewController.swift
//  TouchHandlerLabelExample
//
//  Created by Aleksandr Syschenko on 1/9/19.
//  Copyright © 2019 Aleksandr Syschenko. All rights reserved.
//

import UIKit
import TouchHandlerLabel

class CustomTouchHandler: TouchHandler {
    
    func rangesFor(text: String) -> [NSRange] {
        if let range = text.range(of: "Custom touch handler") {
            return [NSRange(location: range.lowerBound.encodedOffset,
                            length: range.upperBound.encodedOffset - range.lowerBound.encodedOffset)]
        }
        return [NSRange]()
    }
    
    func attributesForNormalStateBy(range: NSRange) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.blue,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .bold)]
    }
    
    func attributesForSelectedStateBy(range: NSRange) -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.blue,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue,
                NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 15)]
    }
    
    func handleClickBy(range: NSRange, text: String) {
        print("Custom touch handler:", text)
    }
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var label: TouchHandlerLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rangesTouchHandler = RangesTouchHandler(ranges: [NSRange(location: 0, length: 11), NSRange(location: 13, length: 12)]) { (range, str) in
            print("Range:", range)
            print("String:", str)
        }
        
        rangesTouchHandler.normalColor = UIColor.blue
        rangesTouchHandler.selectedColor = UIColor.blue.withAlphaComponent(0.5)
        label.add(touchHandler: rangesTouchHandler)
        
        let simpleTextHandler = SimpleTextTouchHandler(text: "text") { (_, str) in
            print("Simple text:", str)
        }
        
        simpleTextHandler.normalColor = UIColor.red
        simpleTextHandler.selectedColor = UIColor.red.withAlphaComponent(0.5)
        label.add(touchHandler: simpleTextHandler)
        
        let urlHandler = URLTouchHandler { (_, str) in
            print("URL:",str)
        }
        
        urlHandler.normalColor = UIColor.green
        urlHandler.selectedColor = UIColor.green.withAlphaComponent(0.5)
        label.add(touchHandler: urlHandler)
        
        let emailHandler = EmailTouchHandler { (_, str) in
            print("Email:",str)
        }
        
        emailHandler.normalColor = UIColor.gray
        emailHandler.selectedColor = UIColor.gray.withAlphaComponent(0.5)
        label.add(touchHandler: emailHandler)
        
        let phoneNumbersHandler = PhoneNumberTouchHandler { (_, str) in
            print("Phone number:",str)
        }
        
        phoneNumbersHandler.normalColor = UIColor.magenta
        phoneNumbersHandler.selectedColor = UIColor.magenta.withAlphaComponent(0.5)
        label.add(touchHandler: phoneNumbersHandler)
        
        let hashtgsHandler = HashtagTouchHandler { (_, str) in
            print("Hashtag:",str)
        }
        
        hashtgsHandler.normalColor = UIColor.brown
        hashtgsHandler.selectedColor = UIColor.brown.withAlphaComponent(0.5)
        label.add(touchHandler: hashtgsHandler)
        
        label.add(touchHandler: CustomTouchHandler())
    }
    
}

