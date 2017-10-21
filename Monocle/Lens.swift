public struct Lens<S, A>: OpticType {
    public typealias Source = S
    public typealias Target = A
    
    private let _get: (S) -> A
    private let _set: (S, A) -> S
    
    public init(get: @escaping (S) -> A, set: @escaping (S, A) -> S) {
        self._get = get
        self._set = set
    }
}

extension Lens {
    /// Runs the getter on a given structure.
    public func get(_ source: Source) -> Target {
        return _get(source)
    }
    
    /// Runs the setter on a given structure and value to yield a new structure.
    public func set(_ source: Source, _ target: Target) -> Source {
        return _set(source, target)
    }

    /// Transform the value of the retrieved field by a function.
    public func modify(_ source: Source, transform: (Target) throws -> Target) rethrows -> Source {
        return set(source, try transform(get(source)))
    }
    
    /// Composes a `Lens` with the receiver.
    public func compose<T>(_ other: Lens<Target, T>) -> Lens<Source, T> {
        return Lens<Source, T>(
            get: { (s: Source) -> T in
                other.get(self.get(s))
            },
            set: { (s: Source, t: T) -> Source in
                self.set(s, other.set(self.get(s), t))
            }
        )
    }
}

// MARK: - Operator

public func >>> <S, A, T>(lhs: Lens<S, A>, rhs: Lens<A, T>) -> Lens<S, T> {
    return lhs.compose(rhs)
}

public func <<< <S, A, T>(lhs: Lens<A, T>, rhs: Lens<S, A>) -> Lens<S, T> {
    return rhs.compose(lhs)
}
