//
//  PrismTests.swift
//  Monocle
//
//  Created by to4iki on 12/29/15.
//  Copyright © 2015 to4iki. All rights reserved.
//

import XCTest
@testable import Monocle

class PrismTests: XCTestCase {
    
    let plus100: Int -> Int = { $0 + 100 }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBasic_Success() {
        assert(String.stringToInt.getOption("1") == .Some(1))
        assert(String.stringToInt.reverseGet(1) == "1")
        assert((String.stringToInt.modify("1", f: plus100)) == .Some("101"))
    }
    
    func testBasice_Failure() {
        assert(String.stringToInt.getOption("") == .None)
        assert((String.stringToInt.modify("", f: plus100)) == .None)
    }
    
    func testCompose() {
        let _tuesday = Prism<DayOfWeek, String>(
            getOption: { $0 == .Tuesday ? .Some($0.rawValue) : nil },
            reverseGet: { _ in .Tuesday }
        )
        
        let _dayOfWeekToInt: Prism<DayOfWeek, Int> = _tuesday >>> String.stringToInt
        
        assert(_dayOfWeekToInt.reverseGet(100) == .Tuesday)
        assert(_dayOfWeekToInt.getOption(.Tuesday) == .Some(2))
        assert(_dayOfWeekToInt.getOption(.Monday) == .None)
    }
}
