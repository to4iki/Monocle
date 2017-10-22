import XCTest
@testable import Monocle

final class LensTests: XCTestCase {
    let _name: Lens<Street, String> = Lens(get: { $0.name }, set: { Street(name: $1) })
    let _street: Lens<Address, Street> = Lens(get: { $0.street }, set: { Address(street: $1) })
    let _address: Lens<Company, Address> = Lens(get: { $0.address }, set: { Company(address: $1) })
    let _company: Lens<Employee, Company> = Lens(get: { $0.company }, set: { Employee(company: $1) })
    let employee = Employee(company: Company(address: Address(street: Street(name: "street"))))
    
    func testGet_LeftToRight() {
        let actual = (_company >>> _address >>> _street >>> _name).get(employee)
        XCTAssertEqual(actual, "street")
    }
    
    func testGet_RightToLeft() {
        let actual = (_name <<< _street <<< _address <<< _company).get(employee)
        XCTAssertEqual(actual, "street")
    }
    
    func testSet() {
        let actual = (_company >>> _address >>> _street >>> _name).set(employee, "new street")
        XCTAssertEqual(actual, Employee(company: Company(address: Address(street: Street(name: "new street")))))
    }
    
    func testModify() {
        let actual = (_company >>> _address >>> _street >>> _name).modify(employee) { $0.capitalized }
        XCTAssertEqual(actual, Employee(company: Company(address: Address(street: Street(name: "Street")))))
    }
}
