import Parsing

var strings: [String] = ["a", "b", "c"]

func compactMapStrings1(_ strings: [String]) -> [String] {
    strings.compactMap {
        if $0 == "a" { return nil }
        return $0.uppercased()
    }
}

func compactMapStrings2(_ strings: [String]) -> [String] {
    // This seems to be favoring `Parser.compactMap` even though it returns a completely
    // different type (`Parsers.CompactMap`) to this function. The compiler error would
    // not make any sense if it was choosing the correct `Array.compactMap` as that takes
    // a closure that returns an optional.
    strings.compactMap {
        if $0 == "a" { return nil } // error: 'nil' is incompatible with return type 'String'
        if $0 == "b" {
            return 123 // no error here as expected
        }
        return $0.uppercased()
    }
}

func compactMapStrings3(_ strings: [String]) -> [String] {
    strings.compactMap { value -> String? in
        if value == "a" { return nil }
        if value == "b" {
            return "x"
        }
        return value.uppercased()
    }
}

// The errors on this version make it really clear its choosing the wrong overload.
func compactMapStrings4(_ strings: [String]) -> [String] {
    // Cannot convert return expression of type 'Parsers.CompactMap<[String], String>' to return type [String]
    strings.compactMap { value -> String? in
        if value == "a" { return nil } // Type '()' cannot conform to 'StringProtocol'
        if value == "b" {
            return 123 // no error here as expected
        }
        return value.uppercased()
    }
}

print("✅")
