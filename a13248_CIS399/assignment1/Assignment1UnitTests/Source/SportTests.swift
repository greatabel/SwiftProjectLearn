//
//  SportTests.swift
//  Assignment1UnitTests
//
//  Created by Charles Augustine.
//
//


import XCTest
@testable import Assignment1


class Assignment1UnitTests: XCTestCase {
    func testSwimmingDescription() {
		XCTAssertEqual("swimming", Sport.swimming.description, "Sport.swimming.description expected value of \"swimming\"")
    }
    
    func testCyclingDescription() {
		XCTAssertEqual("cycling", Sport.cycling.description, "Sport.cycling.description expected value of \"cycling\"")
    }

	func testRunningDescription() {
		XCTAssertEqual("running", Sport.running.description, "Sport.running.description expected value of \"running\"")
	}
}
