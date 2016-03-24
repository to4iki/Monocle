//
//  Example.swift
//  Monocle
//
//  Created by to4iki on 12/29/15.
//  Copyright © 2015 to4iki. All rights reserved.
//

import Foundation

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

enum DayOfWeek: String {
    case Monday = "1"
    case Tuesday = "2"
    case Wednesday = "3"
    case Thursday = "4"
    case Friday = "5"
    case Saturday = "6"
    case Sunday = "7"
}
