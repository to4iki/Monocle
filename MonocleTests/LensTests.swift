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
    
    func testGet() {
        let extra = (_company >>> _address >>> _street >>> _name).get(employee)
        assert(extra == "street")
    }
    
    func testSet() {
        let extra = (_company >>> _address >>> _street >>> _name).set(employee, to: "new street")
        
        assert(extra.company.address.street.name == "new street")
        assert(extra == Employee(company: Company(address: Address(street: Street(name: "new street")))))
    }
    
    func testPerformanceExample() {
        self.measureBlock {
        }
    }
    
}
