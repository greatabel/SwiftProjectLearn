//
//  TriathlonTests.swift
//  Assignment1UnitTests
//
//  Created by Charles Augustine.
//
//


import XCTest
@testable import Assignment1


class TriathlonTests: XCTestCase {
	func testSprintDistances() {
		XCTAssertEqual(Triathlon.sprint.distance(for: .swimming), 750, "Triathlon.sprint.distance(for:) did not return expected distance of 750 meters for Sport.swimming")
		XCTAssertEqual(Triathlon.sprint.distance(for: .cycling), 20000, "Triathlon.sprint.distance(for:) did not return expected distance of 20000 meters for Sport.cycling")
		XCTAssertEqual(Triathlon.sprint.distance(for: .running), 5000, "Triathlon.sprint.distance(for:) did not return expected distance of 5000 meters for Sport.running")
	}

	func testOlympicDistances() {
		XCTAssertEqual(Triathlon.olympic.distance(for: .swimming), 1500, "Triathlon.olympic.distance(for:) did not return expected distance of 1500 meters for Sport.swimming")
		XCTAssertEqual(Triathlon.olympic.distance(for: .cycling), 40000, "Triathlon.olympic.distance(for:) did not return expected distance of 40000 meters for Sport.cycling")
		XCTAssertEqual(Triathlon.olympic.distance(for: .running), 10000, "Triathlon.olympic.distance(for:) did not return expected distance of 10000 meters for Sport.running")
	}

	func testHalfIronmanDistances() {
		XCTAssertEqual(Triathlon.halfIronman.distance(for: .swimming), 1930, "Triathlon.halfIronman.distance(for:) did not return expected distance of 1930 meters for Sport.swimming")
		XCTAssertEqual(Triathlon.halfIronman.distance(for: .cycling), 90000, "Triathlon.halfIronman.distance(for:) did not return expected distance of 90000 meters for Sport.cycling")
		XCTAssertEqual(Triathlon.halfIronman.distance(for: .running), 21090, "Triathlon.halfIronman.distance(for:) did not return expected distance of 21090 meters for Sport.running")
	}

	func testIronmanDistances() {
		XCTAssertEqual(Triathlon.ironman.distance(for: .swimming), 3860, "Triathlon.ironman.distance(for:) did not return expected distance of 3860 meters for Sport.swimming")
		XCTAssertEqual(Triathlon.ironman.distance(for: .cycling), 180000, "Triathlon.ironman.distance(for:) did not return expected distance of 180000 meters for Sport.cycling")
		XCTAssertEqual(Triathlon.ironman.distance(for: .running), 42200, "Triathlon.ironman.distance(for:) did not return expected distance of 42200 meters for Sport.running")
	}

	func testTriathlonSports() {
		XCTAssertEqual(Triathlon.sports.count, 3, "Triathlon.sports did not contain 3 elements")
		XCTAssertEqual(Triathlon.sports[0], Sport.swimming, "Triathlon.sports[0] was not Sport.swimming")
		XCTAssertEqual(Triathlon.sports[1], Sport.cycling, "Triathlon.sports[1] was not Sport.cycling")
		XCTAssertEqual(Triathlon.sports[2], Sport.running, "Triathlon.sports[2] was not Sport.running")
	}
}
