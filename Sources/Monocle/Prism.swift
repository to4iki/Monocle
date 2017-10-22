public struct Prism<S, A>: OpticType {
    public typealias Source = S
    public typealias Target = A
    
    private let _getOption: (S) -> A?
    private let _reverseGet: (A) -> S
    
    public init(getOption: @escaping (S) -> A?, reverseGet: @escaping (A) -> S) {
        _getOption = getOption
        _reverseGet = reverseGet
    }
}

extension Prism {
    /// Attempts to focus the prism on the given source.
    public func getOption(_ source: Source) -> Target? {
        return _getOption(source)
    }
    
    /// Injects a value back into a modified form of the original structure.
    public func reverseGet(_ target: Target) -> Source {
        return _reverseGet(target)
    }
    
    /// Attempts to run a value of type `S` along both parts of the Prism.
    /// If `.None` is encountered along the getter returns `.None`,
    /// else returns `.Some` containing the final value.
    public func modify(_ source: Source, transform: @escaping (Target) throws -> Target) rethrows -> Source? {
        return try getOption(source).map { (t: Target) in
            let transformed = try transform(t)
            return reverseGet(transformed)
        }
    }
    
    /// Composes a `Prism` with the receiver.
    public func compose<T>(_ other: Prism<Target, T>) -> Prism<Source, T> {
        return Prism<Source, T>(
            getOption: { (s: Source) -> T? in
                self.getOption(s).flatMap { (t: Target) -> T? in
                    other.getOption(t)
                }
        },
            reverseGet: { (t: T) -> Source in
                (self.reverseGet <<< other.reverseGet)(t)
        }
        )
    }
}

// MARK: - Operator

public func >>> <S, A, T>(lhs: Prism<S, A>, rhs: Prism<A, T>) -> Prism<S, T> {
    return lhs.compose(rhs)
}

public func <<< <S, A, T>(lhs: Prism<A, T>, rhs: Prism<S, A>) -> Prism<S, T> {
    return rhs.compose(lhs)
}
