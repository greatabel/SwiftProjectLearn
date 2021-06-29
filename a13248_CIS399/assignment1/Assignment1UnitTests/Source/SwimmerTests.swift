//
//  SwimmerTests.swift
//  Assignment1UnitTests
//
//  Created by Charles Augustine.
//
//


import XCTest


class SwimmerTests: XCTestCase {
	func testFavoriteSport() {
		let swimmer = Swimmer(name: "Foo")
		XCTAssertEqual(swimmer.favoriteSport, Sport.swimming, "Swimmer instance favoriteSport was not Sport.swimming")
	}
}
