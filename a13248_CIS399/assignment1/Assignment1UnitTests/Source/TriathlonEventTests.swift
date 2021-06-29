//
//  TriathlonEvent.swift
//  Assignment1UnitTests
//
//  Created by Charles Augustine.
//
//


import XCTest


class TriathlonEventTests: XCTestCase {
	func testInitializer() {
		let sprintTriathlonEvent = TriathlonEvent(triathlon: .sprint)
		XCTAssertEqual(sprintTriathlonEvent.triathlon, Triathlon.sprint, "TriathlonEvent initializer init(triathlon:) invoked with Triathlon.sprint, but triathlon property was different")

		let olympicTriathlonEvent = TriathlonEvent(triathlon: .olympic)
		XCTAssertEqual(olympicTriathlonEvent.triathlon, Triathlon.olympic, "TriathlonEvent initializer init(triathlon:) invoked with Triathlon.olympic, but triathlon property was different")

		let halfIronmanTriathlonEvent = TriathlonEvent(triathlon: .halfIronman)
		XCTAssertEqual(halfIronmanTriathlonEvent.triathlon, Triathlon.halfIronman, "TriathlonEvent initializer init(triathlon:) invoked with Triathlon.halfIronman, but triathlon property was different")

		let ironmanTriathlonEvent = TriathlonEvent(triathlon: .ironman)
		XCTAssertEqual(ironmanTriathlonEvent.triathlon, Triathlon.ironman, "TriathlonEvent initializer init(triathlon:) invoked with Triathlon.ironman, but triathlon property was different")
	}

	func testInitialEventPerformed() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)
		XCTAssertFalse(triathlonEvent.eventPerformed, "TriathlonEvent had initial eventPerformed value of true")
	}

	func testRegisterParticipant() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipantOne = TestParticipant(name: "Foo")
		triathlonEvent.register(testParticipantOne)
		XCTAssertEqual(triathlonEvent.registeredParticipants.map { $0.name }, [testParticipantOne.name], "TriathlonEvent registeredParticipants did not contain the expected participant after one call register(_:)")
		XCTAssertEqual(triathlonEvent.raceTime(for: testParticipantOne), 0, "TriathlonEvent initial race time was not 0 for participant after calling register(_:)")

		let testParticipantTwo = TestParticipant(name: "Bar")
		triathlonEvent.register(testParticipantTwo)
		XCTAssertEqual(triathlonEvent.registeredParticipants.map { $0.name }, [testParticipantOne.name, testParticipantTwo.name], "TriathlonEvent registeredParticipants did not contain the expected participants after two calls registerParticipant(_:)")
		XCTAssertEqual(triathlonEvent.raceTime(for: testParticipantTwo), 0, "TriathlonEvent initial race time was not 0 for participant after calling register(_:)")
	}

	func testRaceTimeForParticipantWithUnregisteredParticipant() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipantOne = TestParticipant(name: "Foo")
		XCTAssertNil(triathlonEvent.raceTime(for: testParticipantOne), "TriathlonEvent race time for unregistered participant was not nil")
	}

	func testRunSportForParticipantAndRaceTimeForParticipantFinishingValueLow() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipant = TestParticipant(name: "Foo")
		triathlonEvent.register(testParticipant)
		triathlonEvent.simulate(Sport.swimming, for: testParticipant, randomValue: 0.06)
		let raceTime = triathlonEvent.raceTime(for: testParticipant)
		XCTAssertNotNil(raceTime, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a random value of 0.06 was nil")
		if let someRaceTime = raceTime {
			XCTAssertGreaterThan(someRaceTime, 0, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a random value of 0.06 was not greater than 0")
		}
	}
	
	func testRunSportForParticipantAndRaceTimeForParticipantFinishingValueHigh() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipant = TestParticipant(name: "Foo")
		triathlonEvent.register(testParticipant)
		triathlonEvent.simulate(Sport.swimming, for: testParticipant, randomValue: 1.0)
		let raceTime = triathlonEvent.raceTime(for: testParticipant)
		XCTAssertNotNil(raceTime, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a random value of 1.0 was nil")
		if let someRaceTime = raceTime {
			XCTAssertGreaterThan(someRaceTime, 0, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a random value of 1.0 was not greater than 0")
		}
	}
	
	func testRunSportForParticipantAndRaceTimeForParticipantNoFavoriteNonFinishingValueLow() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipant = TestParticipant(name: "Foo")
		triathlonEvent.register(testParticipant)
		triathlonEvent.simulate(Sport.swimming, for: testParticipant, randomValue: 0.0)
		let raceTime = triathlonEvent.raceTime(for: testParticipant)
		XCTAssertNil(raceTime, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a random value of 0.0 was not nil")
	}

	func testRunSportForParticipantAndRaceTimeForParticipantNoFavoriteNonFinishingValueHigh() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipant = TestParticipant(name: "Foo")
		triathlonEvent.register(testParticipant)
		triathlonEvent.simulate(Sport.swimming, for: testParticipant, randomValue: 0.05)
		let raceTime = triathlonEvent.raceTime(for: testParticipant)
		XCTAssertNil(raceTime, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a random value of 0.05 was not nil")
	}

	func testRunSportForParticipantAndRaceTimeForParticipantWithFavoriteNonFinishingValue() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .swimming
		triathlonEvent.register(testParticipant)
		triathlonEvent.simulate(Sport.swimming, for: testParticipant, randomValue: 0.0)
		let raceTime = triathlonEvent.raceTime(for: testParticipant)
		XCTAssertNotNil(raceTime, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a favorite sport and a random value of 0.0 was nil")
	}

	func testRunSportForParticipantAndRaceTimeForParticipantNoFavoriteNonFinishingValue() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .running
		triathlonEvent.register(testParticipant)
		triathlonEvent.simulate(Sport.swimming, for: testParticipant, randomValue: 0.0)
		let raceTime = triathlonEvent.raceTime(for: testParticipant)
		XCTAssertNil(raceTime, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a non favorite sport and a random value of 0.0 was not nil")
	}

	func testRunSportForParticipantAndRaceTimeForParticipantWithFavoriteNonFinishingValueTwo() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .running
		triathlonEvent.register(testParticipant)
		triathlonEvent.simulate(Sport.running, for: testParticipant, randomValue: 0.0)
		let raceTime = triathlonEvent.raceTime(for: testParticipant)
		XCTAssertNotNil(raceTime, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a favorite sport and a random value of 0.0 was nil")
	}

	func testRunSportForParticipantAndRaceTimeForParticipantNoFavoriteNonFinishingValueTwo() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		let testParticipant = TestParticipant(name: "Foo")
		testParticipant.favoriteSport = .swimming
		triathlonEvent.register(testParticipant)
		triathlonEvent.simulate(Sport.running, for: testParticipant, randomValue: 0.0)
		let raceTime = triathlonEvent.raceTime(for: testParticipant)
		XCTAssertNil(raceTime, "TriathlonEvent race time for registered participant after call to simulate(_:for:) with a non favorite sport and a random value of 0.0 was not nil")
	}

	func testPerformEventSetsEventPerformed() {
		let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

		triathlonEvent.simulate()
		XCTAssertTrue(triathlonEvent.eventPerformed, "TriathlonEvent eventPerformed false after call to simulate(_:)")
	}

	func testPerformEventNonZeroOrNilRaceTimes() {
		// Tests a randomized function, so the test is performed some fairly large number of times
		continueAfterFailure = false
		for _ in 0...1000 {
			let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

			let testParticipantOne = TestParticipant(name: "Foo")
			triathlonEvent.register(testParticipantOne)
			let testParticipantTwo = TestParticipant(name: "Bar")
			triathlonEvent.register(testParticipantTwo)

			triathlonEvent.simulate()

			let testParticipantOneRaceTime = triathlonEvent.raceTime(for: testParticipantOne)
			if let someRaceTime = testParticipantOneRaceTime {
				XCTAssertGreaterThan(someRaceTime, 0)
			}

			let testParticipantTwoRaceTime = triathlonEvent.raceTime(for: testParticipantTwo)
			if let someRaceTime = testParticipantTwoRaceTime {
				XCTAssertGreaterThan(someRaceTime, 0)
			}
		}
	}

	func testWinner() {
		// Tests a randomized function, so the test is performed some fairly large number of times
		continueAfterFailure = false
		for _ in 0...1000 {
			let triathlonEvent = TriathlonEvent(triathlon: .halfIronman)

			let testParticipantOne = TestParticipant(name: "Foo")
			triathlonEvent.register(testParticipantOne)
			let testParticipantTwo = TestParticipant(name: "Bar")
			triathlonEvent.register(testParticipantTwo)

			triathlonEvent.simulate()

			let testParticipantOneRaceTime = triathlonEvent.raceTime(for: testParticipantOne)
			let testParticipantTwoRaceTime = triathlonEvent.raceTime(for: testParticipantTwo)

			if let someTestParticipantOneRaceTime = testParticipantOneRaceTime, let someTestParticipantTwoRaceTime = testParticipantTwoRaceTime {
				let expectedWinner = someTestParticipantOneRaceTime <= someTestParticipantTwoRaceTime ? testParticipantOne : testParticipantTwo
				if let actualWinner = triathlonEvent.winner {
					XCTAssertEqual(actualWinner.name, expectedWinner.name, "\(testParticipantOne.name) had a time of \(someTestParticipantOneRaceTime) and \(testParticipantTwo.name) had a time of \(someTestParticipantTwoRaceTime), but \(actualWinner.name) was the winner (\(testParticipantOne.name) should win ties)")
				}
				else {
					XCTFail("Both test participants had a time, but the winner was nil")
				}
			}
			else if testParticipantOneRaceTime != nil {
				XCTAssertEqual(triathlonEvent.winner?.name, testParticipantOne.name, "Only one participant had a time but they were not the winner")
			}
			else if testParticipantTwoRaceTime != nil {
				XCTAssertEqual(triathlonEvent.winner?.name, testParticipantTwo.name, "Only one participant had a time but they were not the winner")
			}
			else {
				XCTAssertNil(triathlonEvent.winner, "No test participants had a time, but the winner was not nil")
			}
		}
	}
}
