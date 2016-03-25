//
//  String.swift
//  Monocle
//
//  Created by to4iki on 12/29/15.
//  Copyright © 2015 to4iki. All rights reserved.
//

import Foundation

extension String: StringOptics {}

public protocol StringOptics {}

extension StringOptics {

    public static var stringToInt: Prism<String, Int> {
        return Prism(getOption: { Int($0) }, reverseGet: { String($0) })
    }
    
    public static var stringToDouble: Prism<String, Double> {
        return Prism(getOption: { Double($0) }, reverseGet: { String($0) })
    }
    
    public static var stringToArray: Prism<String, Array<String>> {
        return Prism(getOption: { Array(arrayLiteral: $0) }, reverseGet: { String($0) })
    }
    
    public static var stringToBool: Prism<String, Bool> {
        return Prism(getOption: { !$0.isEmpty }, reverseGet: { String($0) })
    }
    
    public static var stringToNSURL: Prism<String, NSURL> {
        return Prism(getOption: { NSURL(string: $0) }, reverseGet: { String($0) } )
    }
}
