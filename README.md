# Monocle

[![Build Status][status-image]][status-url]
[![Carthage compatible][carthage-image]][carthage-url]
[![License][license-image]][license-url]

a Lens library

## Description

Inspired by Scala [julien-truffaut/Monocle](https://github.com/julien-truffaut/Monocle).

## Installation

#### [Carthage](https://github.com/Carthage/Carthage)

- Insert `github "to4iki/Monocle" ~> 0.0.3` to your Cartfile.
- Run `carthage update`.
- Link your app with `Monocle.framework` in `Carthage/Checkouts`.

## Usage

### Lens

This swift struct already provides getters and setters, but modifying nested object is verbose which makes code difficult to understand and reason about.
Some examples:

```swift
struct Street { let name: String }
struct Address { let street: Street }
struct Company { let address: Address }
struct Employee { let company: Company }
```

Need to set the first character of company street name address in upper case

```swift
let employee: Employee = ...

Employee(company:
    Company(address:
        Address(street:
            Street(name: employee.company.address.street.name.capitalizedString)
        )
    )
)
```

Use lens:

```swift
let _name: Lens<Street, String> = Lens(get: { $0.name }, set: { Street(name: $1) })
let _street: Lens<Address, Street> = Lens(get: { $0.street }, set: { Address(street: $1) })
let _address: Lens<Company, Address> = Lens(get: { $0.address }, set: { Company(address: $1) })
let _company: Lens<Employee, Company> = Lens(get: { $0.company }, set: { Employee(company: $1) })

(_company.compose(_address.compose(_street).compose(_name))).modify(employee) { $0.capitalizedString }
// => operator syntax
(_company >>> _address >>> _street >>> _name).modify(employee) { $0.capitalizedString }
```

### Prism
Prism is like a "Lens began to be expressed fail"

Use prism:

```swift
let stringToInt: Prism<String, Int> = Prism(getOption: { Int($0) }, reverseGet: { String($0) })
```

```swift
stringToInt.getOption("1") // .Some(1)
stringToInt.getOption("") // .None
stringToInt.reverseGet(1) // "1"
stringToInt.modify("1") { $0 + 100 } // .Some(101)
stringToInt.modify("") { $0 + 100 } // .None
```

## Author

[to4iki](https://github.com/to4iki)

## Licence

[MIT](http://to4iki.mit-license.org/)

[status-url]: https://travis-ci.org/to4iki/Monocle
[status-image]: https://travis-ci.org/to4iki/Monocle.svg

[carthage-url]: https://github.com/Carthage/Carthage
[carthage-image]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat

[license-url]: http://to4iki.mit-license.org/
[license-image]: http://img.shields.io/badge/license-MIT-brightgreen.svg
