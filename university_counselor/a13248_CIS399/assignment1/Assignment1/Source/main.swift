//
//  main.swift
//  Assignment1
//


/// enter point of the whole project
func my_main() {
//    print("---")
    let te = TriathlonEvent(triathlon: Triathlon.olympic)
        
    let SwimmerA = Swimmer(name: "Cassi")
    te.register(SwimmerA)
    let SwimmerB = Swimmer(name: "Jason")
    te.register(SwimmerB)
    let SwimmerC = Swimmer(name: "Kathy")
    te.register(SwimmerC)
    let CyclistA = Cyclist(name: "Asia")
    te.register(CyclistA)
    
    let CyclistB = Cyclist(name: "David")
    te.register(CyclistB)
    let RunnerA = Runner(name: "Sign")
    te.register(RunnerA)
    let RunnerB = Runner(name: "Becky")
    te.register(RunnerB)
    let AthleteA = Athlete(name: "Charles")
    te.register(AthleteA)
    
    let AthleteB = Athlete(name: "Chuck")
    te.register(AthleteB)

    te.simulate()

    if te.winner != nil {
        let participantTime = te.raceTime(for: te.winner!)!
        print(te.winner!.name + " wins first place with a total time of "
                + String(participantTime) + " minutes!")
    }else {
        print("No one finished the race!")
    }
}

my_main()
