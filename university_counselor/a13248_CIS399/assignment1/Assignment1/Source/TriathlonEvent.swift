//
//  TriathlonEvent.swift
//  Assignment1
//

class TriathlonEvent {
    
    let triathlon: Triathlon
    
    var participantTime: [Int?] = []
    
    init(triathlon: Triathlon) {
        self.triathlon = triathlon
    }
    
    private(set) var eventPerformed: Bool = false
    
    var participantName: [Participant] = []
    
    func register(_ participant: Participant) {
        guard eventPerformed == false else {
            fatalError("Participant unregisted")
        }
        participantTime.append(0)
        participantName.append(participant)
    }
    
    var registeredParticipants: [Participant] {
        get {
            return participantName
        }
    }
    
    
    /// find the time of certain participant
    /// - Parameter participant: participant name
    /// - Returns: silumated race time
    func raceTime(for participant: Participant) -> Int? {
        let result: Int?
        let pos = participantName.firstIndex{$0.name == participant.name}
        if pos != nil {
            result = participantTime[pos!]
            return result
        }else{
            return nil
        }
    }
    
    
    /// simulator race according to assigment logic
    /// - Parameters:
    ///   - sport: sport type
    ///   - participant: which participant
    ///   - value: no particular return , because results is already saved in participantTime
    func simulate(_ sport: Sport, for participant: Participant, randomValue value: Double = Double.random(in: 0 ..< 1.0)) {
        
        let position = participantName.firstIndex{$0.name == participant.name}!
        print(participant.name + " is about to begin " + sport.description)
        
        guard participantTime[position] != nil else {
            return
        }
        
        if sport == participant.favoriteSport || value >= 0.06 {
            let resultingTime: Int = participant.completionTime(for: sport, in: triathlon)
            participantTime[position] = participantTime[position]! + resultingTime
            print(participant.name + " finished the " + sport.description + " event in " + String(resultingTime) + " minutes; their total race time is now " + String(participantTime[position]!) + " minutes.")
            
        }else if sport != participant.favoriteSport && value < 0.06 {
            participantTime[position] = nil
            print(participant.name + " could not finish the " + sport.description + " event and will not finish the race.")
        }
    }
    
    func simulate() {
        for sports in Triathlon.sports {
            for registered in participantName {
                simulate(sports, for: registered)
            }
        }
        eventPerformed = true
        
        guard eventPerformed == true else {
            fatalError("Perform error")
        }
    }
    
    var winner: Participant? {
        get{
            guard eventPerformed == true else{
                fatalError("Participants have no event times")
            }
            var index: Int?
            var lesser: Int? = participantTime[0]
            for time in participantTime{
                if time != nil{
                    if lesser != nil {
                        if let Lesser: Int = lesser, let Time: Int = time{
                            if Lesser > Time {
                                lesser = time
                            }
                        }
                    }else{
                        lesser = time
                    }
                }
            }
            
            if lesser == nil{
                return nil
            }else{
                index = participantTime.firstIndex{$0 == lesser}
                return participantName[index!]
            }
        }
    }
}

