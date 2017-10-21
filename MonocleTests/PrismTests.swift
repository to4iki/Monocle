import XCTest
@testable import Monocle

final class PrismTests: XCTestCase {
    let stringToIntPrism: Prism<String, Int> = Prism(getOption: { Int($0) }, reverseGet: { String($0) })
    let add100: (Int) -> Int = { $0 + 100 }
    
    let _tuesday = Prism<DayOfWeek, String>(
        getOption: { $0 == .tuesday ? .some($0.rawValue) : nil },
        reverseGet: { _ in .tuesday }
    )
    
    func testBasic_Success() {
        XCTAssertEqual(stringToIntPrism.getOption("1"), .some(1))
        XCTAssertEqual(stringToIntPrism.reverseGet(1), "1")
        XCTAssertEqual((stringToIntPrism.modify("1", transform: add100)), .some("101"))
    }
    
    func testBasice_Failure() {
        XCTAssertNil(stringToIntPrism.getOption(""))
        XCTAssertNil(stringToIntPrism.modify("", transform: add100))
    }
    
    func testCompose() {
        let _dayOfWeekToInt: Prism<DayOfWeek, Int> = _tuesday >>> stringToIntPrism
        XCTAssertEqual(_dayOfWeekToInt.reverseGet(100), .tuesday)
        XCTAssertEqual(_dayOfWeekToInt.getOption(.tuesday), .some(2))
        XCTAssertNil(_dayOfWeekToInt.getOption(.monday))
    }
}
