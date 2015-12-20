# Monocle

[![Carthage compatible][carthage-image]][carthage-url]
[![License][license-image]][license-url]

a Lens library

## Description

Inspired by Scala [julien-truffaut/Monocle](https://github.com/julien-truffaut/Monocle).

## Installation

#### [Carthage](https://github.com/Carthage/Carthage)

- Insert `github "to4iki/Monocle"` to your Cartfile.
- Run `carthage update`.
- Link your app with `Monocle.framework` in `Carthage/Checkouts`.

## Usage

This swift struct already provides getters and setters, but modifying nested object is verbose which makes code difficult to understand and reason about.
Some examples:

```swift
struct Street { let name: String }
struct Address { let street: Street }
struct Company { let address: Address }
struct Employee { let company: Company }
```

A employee and we need to set "modify" of his company street name address:
Need to repeat at each level the full path to reach it...

```swift
let employee: Employee = ...

Employee(company:
    Company(address:
        Address(street:
            Street(name: "modify \(employee.company.address.street.name)")
        )
    )
)
```

Use lens:

```swift
let _name: Lens<Street, String> = Lens(getter: { $0.name }, setter: { Street(name: $1) })
let _street: Lens<Address, Street> = Lens(getter: { $0.street }, setter: { Address(street: $1) })
let _address: Lens<Company, Address> = Lens(getter: { $0.address }, setter: { Company(address: $1) })
let _company: Lens<Employee, Company> = Lens(getter: { $0.company }, setter: { Employee(company: $1) })

(composeLens(_company, right: composeLens(_address, right: composeLens(_street, right: _name)))).modify(employee) { "modify \($0)" }
// => operator syntax
(_company >>> _address >>> _street >>> _name).modify(employee) { "modify \($0)" }
```

## Author

[to4iki](https://github.com/to4iki)

## Licence

[MIT](http://to4iki.mit-license.org/)

[carthage-url]: https://github.com/Carthage/Carthage
[carthage-image]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat

[license-url]: http://to4iki.mit-license.org/
[license-image]: http://img.shields.io/badge/license-MIT-brightgreen.svg
