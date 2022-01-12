/*:
[Previous](@previous)

# Sport enum

This work should be done in the Sport.swift file that already exists in the project.

The `Sport` enum contains the collection of constants representing the three sports that are part of a triathlon. It
should:
1. contain three different enum cases: `swimming`, `cycling`, and `running`.

The only additional code necessary in the `Sport` enum is the adoption of a protocol from the Swift standard library
that allows for it to be easily printed to the console output. Modify your `Sport` enum implementation to:
1. conform to the `CustomStringConvertible` protocol
2. implement the `public var description: String { get }` requirement defined in the `CustomStringConvertible` protocol
with the following logic:
	* the `swimming` case should return the `String` "swimming"
	* the `cycling` case should return the `String` "cycling"
	* the `running` case should return the `String` "running"

The next page will describe how to [validate your work with the provided unit tests](@next).
*/
