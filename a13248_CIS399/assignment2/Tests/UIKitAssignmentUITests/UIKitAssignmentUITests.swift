//
//  UIKitAssignmentUITests.swift
//  UIKitAssignmentUITests
//


import XCTest


class UIKitAssignmentUITests: XCTestCase {
	override func setUp() {
		super.setUp()
		continueAfterFailure = false

		XCUIApplication().launch()
	}

	func testNavigation() {
		// Get the application
		let app = XCUIApplication()

		// Get the main view navigation bar and navigation buttons
		let mainNavigationBar = app.navigationBars["Main View"]
		let showImageBarButtonItem = mainNavigationBar.buttons["Show Image"]
		let showDetailsButton = app.buttons["Show Details"]

		// Assert that the navigation buttons exist
		XCTAssertTrue(showImageBarButtonItem.exists, "The main view does not have a Show Image bar button item")
		XCTAssertTrue(showDetailsButton.exists, "The main view does not have a Show Details button")

		// Navigate to the detail view
		showDetailsButton.tap()

		// Get the detail view navigation bar and navigation buttons
		let detailNavigationBar = app.navigationBars["Detail View"]
		let detailBackButton = detailNavigationBar.buttons["Main View"]
		let detailDoneButton = detailNavigationBar.buttons["Done"]

		// Assert that there is a back button and that there is not a done button
		XCTAssertTrue(detailBackButton.exists, "The detail view does not have a back button")
		XCTAssertFalse(detailDoneButton.exists, "The detail view has a done button")

		// Navigate back to the main view
		detailBackButton.tap()

		// Navigate to the modal view
		showImageBarButtonItem.tap()

		// Get the modal view navigation bar and navigation buttons
		let modalNavigationBar = app.navigationBars["Modal View"]
		let modalBackButton = modalNavigationBar.buttons["Main View"]
		let modalDoneButton = modalNavigationBar.buttons["Done"]

		// Assert that there is a doen button and that there is not a back button
		XCTAssertFalse(modalBackButton.exists, "The image view has a back button")
		XCTAssertTrue(modalDoneButton.exists, "The image view does not have a done button")

		// Navigate the main view
		modalDoneButton.tap()

		// Assert that the main view navigation bar exists (i.e., that navigation was successful)
		XCTAssertTrue(mainNavigationBar.exists, "Could not navigate back to the main view")
	}

	func testDetailActionCountUpdate() {
		// Get the application
		let app = XCUIApplication()

		// Get the detail acount count label
		let detailActionCountLabel = app.staticTexts["DetailActionCount"]

		// Assert that the detail account count label exists
		XCTAssertTrue(detailActionCountLabel.exists, "The main view does not have a label with the identifier DetailActionCount")

		// Assert that the initial detail action count label text is the expected value
		XCTAssertEqual(detailActionCountLabel.label, "The detail action has been performed 0 times", "The inital value of the DetailActionCount label was not correct")

		// Navigate to the detail view
		let showDetailsButton = app.buttons["Show Details"]
		showDetailsButton.tap()

		// Get the perform action button
		let performActionButton = app.buttons["Perform Action"]

		// Assert that the perform action button exists
		XCTAssertTrue(performActionButton.exists, "The detail view does not have a perform action button")

		// Tap the perform action button
		performActionButton.tap()

		// Navigate to the main view
		let detailNavigationBar = app.navigationBars["Detail View"]
		let detailBackButton = detailNavigationBar.buttons["Main View"]
		detailBackButton.tap()

		// Assert that the detail action count label text is the expected value
		XCTAssertEqual(detailActionCountLabel.label, "The detail action has been performed 1 time", "The value of the DetailActionCount label was not correct")

		// Navigate to the detail view
		showDetailsButton.tap()

		// Tap the perform action button a few times
		performActionButton.tap()
		performActionButton.tap()
		performActionButton.tap()

		// Navigate to the main view
		detailBackButton.tap()

		// Assert that the detail action count label text is the expected value
		XCTAssertEqual(detailActionCountLabel.label, "The detail action has been performed 4 times", "The value of the DetailActionCount label was not correct")
	}

	func testImageViewExistance() {
		// Get the application
		let app = XCUIApplication()

		// Get the main view navigation bar and navigation buttons
		let mainNavigationBar = app.navigationBars["Main View"]
		let showImageBarButtonItem = mainNavigationBar.buttons["Show Image"]

		// Navigate to the modal view
		showImageBarButtonItem.tap()

		// Get the image views
		let imageViews = app.images

		// Assert that there is one image view
		XCTAssertEqual(imageViews.count, 1, "There was not one image view")
	}
}
