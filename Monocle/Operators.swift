import Foundation

/// Left-to-Right Composition
infix operator >>> : MultiplicationPrecedence

/// Right-to-Left Composition
infix operator <<< : MultiplicationPrecedence

internal func <<< <A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return { (a: A) -> C in
        return f(g(a))
    }
}

internal func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { (a: A) -> C in
        return g(f(a))
    }
}
