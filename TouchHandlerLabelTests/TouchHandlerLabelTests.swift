//
//  TouchHandlerLabelTests.swift
//  TouchHandlerLabelTests
//
//  Created by Aleksandr Syschenko on 1/9/19.
//  Copyright © 2019 Aleksandr Syschenko. All rights reserved.
//

import XCTest
@testable import TouchHandlerLabel

class BasicTouchHandlerTest: XCTestCase {
    
    private let testString = "Test string"
    private let testRange = NSRange(location: 0, length: 11)
    
    
    private var touchHandler: TouchHandler?
    private var handlerCallResult = false
    private var handlerParametersResult = false
    
    override func setUp() {
        touchHandler = BasicTouchHandler(handler: { [weak self] (range, str) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.handlerCallResult = true
            
            if range == weakSelf.testRange && str == weakSelf.testString {
                weakSelf.handlerParametersResult = true
            }
        })
    }
    
    func testCallHandler() {
        touchHandler?.handleClickBy(range: testRange, text: testString)
        XCTAssertTrue(handlerCallResult, "Handler was not called")
        XCTAssertTrue(handlerParametersResult, "Parameters of handler were not matched")
    }
    
}

class RangesTouchHandlerTest: XCTestCase {
    
    private let testRanges = [NSRange(location: 0, length: 1), NSRange(location: 2, length: 2), NSRange(location: 5, length: 10)]
    private var touchHandler: TouchHandler?
    
    override func setUp() {
        touchHandler = RangesTouchHandler(ranges: testRanges)
    }
    
    func testRangesParameters() {
        let result = testRanges == touchHandler?.rangesFor(text: "")
        
        XCTAssertTrue(result, "Ranges were not matched")
    }
    
}

class SimpleTextTouchHandlerTest: XCTestCase {
    
    private let testString = "Test, test, test, Test, Test, some text"
    private var touchHandlerCaseInsensitiveFirstMatching: TouchHandler?
    private var touchHandlerNoCaseInsensitiveFirstMatching: TouchHandler?
    private var touchHandlerCaseInsensitiveNoFirstMatching: TouchHandler?
    private var touchHandlerNoCaseInsensitiveNoFirstMatchingUppercase: TouchHandler?
    private var touchHandlerNoCaseInsensitiveNoFirstMatchingLowercase: TouchHandler?
    
    override func setUp() {
        touchHandlerCaseInsensitiveFirstMatching = SimpleTextTouchHandler(text: "Test", caseInsensitive: true, firstMatching: true)
        touchHandlerNoCaseInsensitiveFirstMatching = SimpleTextTouchHandler(text: "test", caseInsensitive: false, firstMatching: true)
        touchHandlerCaseInsensitiveNoFirstMatching = SimpleTextTouchHandler(text: "Test", caseInsensitive: true, firstMatching: false)
        touchHandlerNoCaseInsensitiveNoFirstMatchingUppercase = SimpleTextTouchHandler(text: "Test", caseInsensitive: false, firstMatching: false)
        touchHandlerNoCaseInsensitiveNoFirstMatchingLowercase = SimpleTextTouchHandler(text: "test", caseInsensitive: false, firstMatching: false)
    }
    
    func testSearchTextWhereCaseInsensitiveAndFirstMatching() {
        let ranges = touchHandlerCaseInsensitiveFirstMatching?.rangesFor(text: testString)
        let firstRange = ranges?.first ?? NSRange()
        
        XCTAssertEqual(ranges?.count ?? 0, 1, "Ranges count test failed")
        XCTAssertTrue(firstRange.location == 0 && firstRange.length == 4, "Ranges matching test failed")
    }
    
    func testSearchTextWhereNoCaseInsensitiveAndFirstMatching() {
        let ranges = touchHandlerNoCaseInsensitiveFirstMatching?.rangesFor(text: testString)
        let firstRange = ranges?.first ?? NSRange()
        
        XCTAssertEqual(ranges?.count ?? 0, 1, "Ranges count test failed")
        XCTAssertTrue(firstRange.location == 6 && firstRange.length == 4, "Ranges matching test failed")
    }
    
    func testSearchTextWhereCaseInsensitiveAndNoFirstMatching() {
        let ranges = touchHandlerCaseInsensitiveNoFirstMatching?.rangesFor(text: testString)
        
        XCTAssertEqual(ranges?.count ?? 0, 5, "Ranges count test failed")
    }
    
    func testSearchTextWhereNoCaseInsensitiveAndNoFirstMatching() {
        let rangesUppercase = touchHandlerNoCaseInsensitiveNoFirstMatchingUppercase?.rangesFor(text: testString)
        let rangesLowwercase = touchHandlerNoCaseInsensitiveNoFirstMatchingLowercase?.rangesFor(text: testString)
        
        XCTAssertEqual(rangesUppercase?.count ?? 0, 3, "Ranges count test failed")
        XCTAssertEqual(rangesLowwercase?.count ?? 0, 2, "Ranges count test failed")
    }
    
}

class RegExpTouchHandlerTest: XCTestCase {
    
    private let testString = "Regual expression test string, 1234 numbers container (1234), (4321), four4, 5five, 1, 2, 4"
    private var touchHandlerFirstMatching: TouchHandler?
    private var touchHandlerNoFirstMatching: TouchHandler?
    
    override func setUp() {
        guard let regExp = try? NSRegularExpression(pattern: "\\([\\d]+\\)", options: []) else {
            return
        }
        touchHandlerFirstMatching = RegExpTouchHandler(regExp: regExp, firstMatching: true)
        touchHandlerNoFirstMatching = RegExpTouchHandler(regExp: regExp, firstMatching: false)
    }
    
    func testSearchTextWithFirstMatching() {
        let ranges = touchHandlerFirstMatching?.rangesFor(text: testString)
        let firstRange = ranges?.first ?? NSRange()
        
        XCTAssertEqual(ranges?.count ?? 0, 1, "Ranges count test failed")
        XCTAssertTrue(firstRange.location == 54 && firstRange.length == 6, "Ranges matching test failed")
    }
    
    func testSearchTextWithoutFirstMatching() {
        let ranges = touchHandlerNoFirstMatching?.rangesFor(text: testString)
        
        XCTAssertEqual(ranges?.count ?? 0, 2, "Ranges count test failed")
    }
    
}

class URLTouchHandlerTest: XCTestCase {
    
    private let testString = "https://translate.google.ru " +
        "https://www.apple.com " +
        "https://www.apple.com/shop/buy-iphone/iphone-8 " +
        "https://www.google.com/ " +
        "http://www.fake-domen.com/ " +
        "http://login:password@host:128/path?param1=1&param2=2#ancher" +
    "http:\\ww.incorrect-domen"
    private var touchHandlerFirstMatching: TouchHandler?
    private var touchHandlerNoFirstMatching: TouchHandler?
    
    override func setUp() {
        touchHandlerFirstMatching = URLTouchHandler(firstMatching: true)
        touchHandlerNoFirstMatching = URLTouchHandler(firstMatching: false)
    }
    
    func testSearchTextWithFirstMatching() {
        let ranges = touchHandlerFirstMatching?.rangesFor(text: testString)
        
        XCTAssertEqual(ranges?.count ?? 0, 1, "Ranges count test failed")
    }
    
    func testSearchTextWithoutFirstMatching() {
        let ranges = touchHandlerNoFirstMatching?.rangesFor(text: testString)
        
        print(testString)
        XCTAssertEqual(ranges?.count ?? 0, 6, "Ranges count test failed")
    }
    
}

class PhoneNumberTouchHandlerTest: XCTestCase {
    
    private let testString = "+111 (11) 111 11 11, +222222222222, +333(33)3333333, 242344223"
    private var touchHandlerFirstMatching: TouchHandler?
    private var touchHandlerNoFirstMatching: TouchHandler?
    
    override func setUp() {
        touchHandlerFirstMatching = PhoneNumberTouchHandler(firstMatching: true)
        touchHandlerNoFirstMatching = PhoneNumberTouchHandler(firstMatching: false)
    }
    
    func testSearchTextWithFirstMatching() {
        let ranges = touchHandlerFirstMatching?.rangesFor(text: testString)
        
        XCTAssertEqual(ranges?.count ?? 0, 1, "Ranges count test failed")
    }
    
    func testSearchTextWithoutFirstMatching() {
        let ranges = touchHandlerNoFirstMatching?.rangesFor(text: testString)
        
        print(testString)
        XCTAssertEqual(ranges?.count ?? 0, 3, "Ranges count test failed")
    }
    
}

class EmailTouchHandlerTest: XCTestCase {
    
    private let testString = "some_mail@mail.com, somemail@gmail.com, SOME_M_A_I_L@mail.com, incorrect-mail.com"
    private var touchHandlerFirstMatching: TouchHandler?
    private var touchHandlerNoFirstMatching: TouchHandler?
    
    override func setUp() {
        touchHandlerFirstMatching = EmailTouchHandler(firstMatching: true)
        touchHandlerNoFirstMatching = EmailTouchHandler(firstMatching: false)
    }
    
    func testSearchTextWithFirstMatching() {
        let ranges = touchHandlerFirstMatching?.rangesFor(text: testString)
        
        XCTAssertEqual(ranges?.count ?? 0, 1, "Ranges count test failed")
    }
    
    func testSearchTextWithoutFirstMatching() {
        let ranges = touchHandlerNoFirstMatching?.rangesFor(text: testString)
        
        print(testString)
        XCTAssertEqual(ranges?.count ?? 0, 3, "Ranges count test failed")
    }
    
}

class HashtagTouchHandlerTest: XCTestCase {
    
    private let testString = "#hashtag, #hashtag2, #2hashtag_incorrect"
    private var touchHandlerFirstMatching: TouchHandler?
    private var touchHandlerNoFirstMatching: TouchHandler?
    
    override func setUp() {
        touchHandlerFirstMatching = HashtagTouchHandler(firstMatching: true)
        touchHandlerNoFirstMatching = HashtagTouchHandler(firstMatching: false)
    }
    
    func testSearchTextWithFirstMatching() {
        let ranges = touchHandlerFirstMatching?.rangesFor(text: testString)
        
        XCTAssertEqual(ranges?.count ?? 0, 1, "Ranges count test failed")
    }
    
    func testSearchTextWithoutFirstMatching() {
        let ranges = touchHandlerNoFirstMatching?.rangesFor(text: testString)
        
        print(testString)
        XCTAssertEqual(ranges?.count ?? 0, 2, "Ranges count test failed")
    }
    
}
