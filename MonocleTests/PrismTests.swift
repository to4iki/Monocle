import XCTest
@testable import Monocle

final class PrismTests: XCTestCase {
    let plus100: (Int) -> Int = { $0 + 100 }
    
    let _tuesday = Prism<DayOfWeek, String>(
        getOption: { $0 == .tuesday ? .some($0.rawValue) : nil },
        reverseGet: { _ in .tuesday }
    )
    
    func testBasic_Success() {
        XCTAssert(String.stringToInt.getOption("1") == .some(1))
        XCTAssert(String.stringToInt.reverseGet(1) == "1")
        XCTAssert((String.stringToInt.modify("1", f: plus100)) == .some("101"))
    }
    
    func testBasice_Failure() {
        XCTAssert(String.stringToInt.getOption("") == .none)
        XCTAssert((String.stringToInt.modify("", f: plus100)) == .none)
    }
    
    func testCompose() {
        let _dayOfWeekToInt: Prism<DayOfWeek, Int> = _tuesday >>> String.stringToInt
        XCTAssert(_dayOfWeekToInt.reverseGet(100) == .tuesday)
        XCTAssert(_dayOfWeekToInt.getOption(.tuesday) == .some(2))
        XCTAssert(_dayOfWeekToInt.getOption(.monday) == .none)
    }
    
    func testLift() {
        let lifted = String.stringToInt.lift()
        XCTAssert((lifted.getOption(["1", "2"]) ?? []) == [1, 2])
        XCTAssert((lifted.getOption(["", "2"]) ?? []) == [2])
    }
    
    func testSplit() {
        let both = String.stringToInt.split(_tuesday)
        
        let extra1 = both.getOption(("1", .monday))
        XCTAssert(extra1?.0 == .none)
        XCTAssert(extra1?.1 == .none)
        
        let extra2 = both.getOption(("1", .tuesday))
        XCTAssert(extra2?.0 == .some(1))
        XCTAssert(extra2?.1 == .some("2"))
    }
    
    func testFanout() {
        let both = String.stringToInt.fanout(String.stringToDouble)
        XCTAssert(both.getOption("1")?.0 == .some(1))
        XCTAssert(both.getOption("1")?.1 == .some(1.0))
        XCTAssert(both.getOption("a")?.0 == .none)
        XCTAssert(both.getOption("a")?.1 == .none)
    }
}
