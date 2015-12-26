//
//  MonocleTests.swift
//  MonocleTests
//
//  Created by to4iki on 12/20/15.
//  Copyright © 2015 to4iki. All rights reserved.
//

import XCTest
@testable import Monocle

struct Street: Equatable {
    let name: String
}

struct Address: Equatable {
    let street: Street
}

struct Company: Equatable {
    let address: Address
}

struct Employee: Equatable {
    let company: Company
}

func == (lhs: Street, rhs: Street) -> Bool {
    return lhs.name == rhs.name
}

func == (lhs: Address, rhs: Address) -> Bool {
    return lhs.street == rhs.street
}

func == (lhs: Company, rhs: Company) -> Bool {
    return lhs.address == rhs.address
}

func == (lhs: Employee, rhs: Employee) -> Bool {
    return lhs.company == rhs.company
}

class LensTests: XCTestCase {
    
    let _name: Lens<Street, String> = Lens(getter: { $0.name }, setter: { Street(name: $1) })
    let _street: Lens<Address, Street> = Lens(getter: { $0.street }, setter: { Address(street: $1) })
    let _address: Lens<Company, Address> = Lens(getter: { $0.address }, setter: { Company(address: $1) })
    let _company: Lens<Employee, Company> = Lens(getter: { $0.company }, setter: { Employee(company: $1) })
    
    let employee = Employee(company: Company(address: Address(street: Street(name: "street"))))
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGet_LeftToRight() {
        // andThen
        let extra = (_company >>> _address >>> _street >>> _name).get(employee)
        
        assert(extra == "street")
    }
    
    func testGet_RightToLeft() {
        // compose
        let extra = (_name <<< _street <<< _address <<< _company).get(employee)
        
        assert(extra == "street")
    }
    
    func testSet() {
        let extra = (_company >>> _address >>> _street >>> _name).set(employee, "new street")
        
        assert(extra == Employee(company: Company(address: Address(street: Street(name: "new street")))))
    }
    
    func testModify() {
        let extra = (_company >>> _address >>> _street >>> _name).modify(employee) { $0.capitalizedString }
        
        assert(extra == Employee(company: Company(address: Address(street: Street(name: "Street")))))
    }
    
    func testLiftGet() {
        let streets = [Street(name: "street1"), Street(name: "street2")]
        
        let extra = _name.lift().get(streets)
        
        assert(extra == ["street1", "street2"])
    }
    
    func testLiftSet() {
        let streets = [Street(name: "street1"), Street(name: "street2")]
        
        let extra = _name.lift().set(streets, ["new street1", "new street2"])
        
        assert(extra == [Street(name: "new street1"), Street(name: "new street2")])
    }
    
    func testPerformanceExample() {
        self.measureBlock {
        }
    }
    
}
