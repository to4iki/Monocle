//
//  MonocleTests.swift
//  MonocleTests
//
//  Created by to4iki on 12/20/15.
//  Copyright © 2015 to4iki. All rights reserved.
//

import XCTest
@testable import Monocle

class LensTests: XCTestCase {
    
    let _name: Lens<Street, String> = Lens(get: { $0.name }, set: { Street(name: $1) })
    let _street: Lens<Address, Street> = Lens(get: { $0.street }, set: { Address(street: $1) })
    let _address: Lens<Company, Address> = Lens(get: { $0.address }, set: { Company(address: $1) })
    let _company: Lens<Employee, Company> = Lens(get: { $0.company }, set: { Employee(company: $1) })
    
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
        
        let lifted = _name.lift()
        let extra = lifted.get(streets)
        
        assert(extra == ["street1", "street2"])
    }
    
    func testLiftSet() {
        let streets = [Street(name: "street1"), Street(name: "street2")]
        
        let lifted = _name.lift()
        let extra = lifted.set(streets, ["new street1", "new street2"])
        
        assert(extra == [Street(name: "new street1"), Street(name: "new street2")])
    }
    
    func testSplitGet() {
        let address = Address(street: Street(name: "street1"))
        let street = Street(name: "street2")
        
        let both = (_street >>> _name).split(_name)
        let extra = both.get((address, street))
        
        assert(extra.0 == "street1")
        assert(extra.1 == "street2")
    }
    
    func testSplitSet() {
        let address = Address(street: Street(name: "street1"))
        let street = Street(name: "street2")
        
        let both = (_street >>> _name).split(_name)
        let extra = both.set((address, street), ("new street1", "new street2"))
        
        assert(extra.0.street.name == "new street1")
        assert(extra.1.name == "new street2")
    }
    
    func testFanoutGet() {
        let address = Address(street: Street(name: "street1"))
        
        let both = _street.fanout((_street >>> _name))
        let extra = both.get(address)
        
        assert(extra.0.name == "street1")
        assert(extra.1 == "street1")
    }
    
    func testFanoutSet() {
        let address = Address(street: Street(name: "street1"))
        
        let both = _street.fanout((_street >>> _name))
        let extra = both.set(address, (Street(name: "new street1"), "new street2"))
        
        print(extra.street.name == "new street2")
    }
    
    func testPerformanceExample() {
        self.measureBlock {
        }
    }
    
}
