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
    case monday = "1"
    case tuesday = "2"
    case wednesday = "3"
    case thursday = "4"
    case friday = "5"
    case saturday = "6"
    case sunday = "7"
}
