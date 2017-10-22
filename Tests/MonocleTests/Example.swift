struct Street: Equatable {
    let name: String
    
    static func == (lhs: Street, rhs: Street) -> Bool {
        return lhs.name == rhs.name
    }
}

struct Address: Equatable {
    let street: Street
    
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.street == rhs.street
    }
}

struct Company: Equatable {
    let address: Address
    
    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.address == rhs.address
    }
}

struct Employee: Equatable {
    let company: Company
    
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.company == rhs.company
    }
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
