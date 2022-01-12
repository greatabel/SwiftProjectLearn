//
//  Triathlon.swift
//  Assignment1
//


enum Triathlon {
    case sprint
    case olympic
    case halfIronman
    case ironman
    
    /// distance that accept different sport
    /// - Parameter sport: sport type
    /// - Returns: distance (unit meter) of the input sport
    func distance(for sport: Sport) -> Int {
        let meter: Int
        switch (self, sport) {
        case (.sprint, .swimming):
            meter = 750
        case (.sprint, .cycling):
            meter = 20000
        case (.sprint, .running):
            meter = 5000
            
        case (.olympic, .swimming):
            meter = 1500
        case (.olympic, .cycling):
            meter = 40000
        case (.olympic, .running):
            meter = 10000
            
        case (.halfIronman, .swimming):
            meter = 1930
        case (.halfIronman, .cycling):
            meter = 90000
        case (.halfIronman, .running):
            meter = 21090
            
        case (.ironman, .swimming):
            meter = 3860
        case (.ironman, .cycling):
            meter = 180000
        case (.ironman, .running):
            meter = 42200
        }
        return meter
    }
    static let sports: Array<Sport> = [Sport.swimming, Sport.cycling, Sport.running]
    
}
