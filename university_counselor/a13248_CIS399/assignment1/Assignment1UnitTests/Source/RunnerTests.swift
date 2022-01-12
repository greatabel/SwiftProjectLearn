//
//  RunnerTests.swift
//  Assignment1UnitTests
//
//  Created by Charles Augustine.
//
//


import XCTest


class RunnerTests: XCTestCase {
	func testFavoriteSport() {
		let runner = Runner(name: "Foo")
		XCTAssertEqual(runner.favoriteSport, Sport.running, "Runner instance favoriteSport was not Sport.running")
	}
}
