extension String: StringOptics {}

public protocol StringOptics {}

extension StringOptics {
    public static var stringToInt: Prism<String, Int> {
        return Prism(getOption: { Int($0) }, reverseGet: { String($0) })
    }
    
    public static var stringToDouble: Prism<String, Double> {
        return Prism(getOption: { Double($0) }, reverseGet: { String($0) })
    }
    
    public static var stringToArray: Prism<String, [String]> {
        return Prism(getOption: { [$0] }, reverseGet: { String(describing: $0) })
    }
    
    public static var stringToBool: Prism<String, Bool> {
        return Prism(getOption: { !$0.isEmpty }, reverseGet: { String($0) })
    }
    
    public static var stringToNSURL: Prism<String, URL> {
        return Prism(getOption: { URL(string: $0) }, reverseGet: { String(describing: $0) } )
    }
}
