//
//  Operators.swift
//  Monocle
//
//  Created by to4iki on 12/20/15.
//  Copyright © 2015 to4iki. All rights reserved.
//

import Foundation

/// Left-to-Right Composition
infix operator >>> {
associativity right
precedence 110
}

/// Right-to-Left Composition
infix operator <<< {
associativity right
precedence 170
}

internal func >>> <A, B, C>(f: B -> C, g: A -> B) -> A -> C {
    return { (a: A) -> C in
        return f(g(a))
    }
}

internal func <<< <A, B, C>(f: A -> B, g: B -> C) -> A -> C {
    return { (a: A) -> C in
        return g(f(a))
    }
}
