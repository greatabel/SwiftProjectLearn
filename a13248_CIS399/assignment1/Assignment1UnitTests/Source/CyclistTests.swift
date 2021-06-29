//
//  CyclistTests.swift
//  Assignment1UnitTests
//
//  Created by Charles Augustine.
//
//


import XCTest


class CyclistTests: XCTestCase {
	func testFavoriteSport() {
		let cyclist = Cyclist(name: "Foo")
		XCTAssertEqual(cyclist.favoriteSport, Sport.cycling, "Cyclist instance favoriteSport was not Sport.cycling")
	}
}
