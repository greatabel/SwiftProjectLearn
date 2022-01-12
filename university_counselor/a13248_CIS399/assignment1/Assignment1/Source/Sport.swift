//
//  Sport.swift
//  Assignment1
//


enum Sport : CustomStringConvertible {
    case swimming
    case cycling
    case running
    
    public var description: String {
        get {
            let result: String
            switch self {
            case .swimming:
                result = "swimming"
            case .cycling:
                result = "cycling"
            case .running:
                result = "running"
            }
            return result
        }
    }
}

