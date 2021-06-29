//
//  AthleteTests.swift
//  Assignment1UnitTests
//
//  Created by Charles Augustine.
//
//


import XCTest
@testable import Assignment1


class AthleteTests: XCTestCase {
	func testInitializer() {
		let fooAthlete = Athlete(name: "Foo")
		XCTAssertEqual(fooAthlete.name, "Foo", "Athlete initializer init(name:) invoked with name \"Foo\", but name property was \"\(fooAthlete.name)\"")

		let barAthlete = Athlete(name: "Bar")
		XCTAssertEqual(barAthlete.name, "Bar", "Athlete initializer init(name:) invoked with name \"Bar\", but name property was \"\(barAthlete.name)\"")
	}

	func testFavoriteSport() {
		let athlete = Athlete(name: "Foo")
		XCTAssertNil(athlete.favoriteSport, "Athlete instance had a non-nil favorite sport")
	}
}
