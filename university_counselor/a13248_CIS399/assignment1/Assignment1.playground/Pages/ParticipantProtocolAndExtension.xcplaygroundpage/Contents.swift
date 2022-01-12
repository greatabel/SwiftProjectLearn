/*:
[Previous](@previous)

# Participant protocol and extension

### Participant protocol

This work should be done in the Participant.swift file that already exists in the project.

The `Participant` protocol defines a set of methods and properties that must be implemented by any type that will be a
participant in a `TriathlonEvent`. The `Participant` protocol should:

1. have an initializer that takes a single parameter with the label `name` of type `String`.
2. have a method named `completionTime` that:
	* takes a first parameter with the label `for` of type `Sport`
	* takes a second parameter with the label `in` of type `Triathlon`
	* takes a third parameter with the label `randomValue` of type `Double`
	* returns a value of type `Int`
3. have a variable property named `name` of type `String` that provides at least a `get` implementation.
4. have a variable property named `favoriteSport` of the optional type `Sport?` that provides a `get` implementation.

### Extension of Participant

The extension of the `Participant` protocol creates a default implementation that will be added to any `Participant`
type that does not provide its own implementation. Add your extension code at the bottom of the Participant.swift file.
The extension should:

1. add a method to the `Participant` protocol that can be used to get the participants speed for a given sport. This
method should be named `metersPerMinute` and:
	* take a first parameter with the label `for` of type `Sport`
	* take a second parameter with the label `randomValue` of type `Double` which has a default value of
`Double.random(in: 0 ... 1)`
	* return a value of type `Int`

The body of this method should use the following logic:

	var value: Double
	switch sport {
	case .swimming:
		value = 43
	case .cycling:
		value = 500
	case .running:
		value = 157
	}

	var modifier = 0.8 + (randomValue * 0.4)
	if let favoriteSport = self.favoriteSport {
		if favoriteSport == sport {
			modifier += 0.08
		}
		else {
			modifier -= 0.08
		}
	}

	return Int(value * modifier)

2. provide a variation of the `completionTime(for:in:randomValue:)` function without the third parameter. Add a method
with the name `completionTime` that:
	* takes a first parameter with the label `for` of type `Sport`
	* takes a second parameter with the label `in` of type `Triathlon`
	* returns a value of type `Int`
	* calls the three parameter version passing through the `Sport` and `Triathlon` values and
`Double.random(in: 0 ... 1)` for the third parameter
	* returns the result of the call to the three parameter version

3. provide a default implementation of the `completionTime(for:in:randomValue:)` function. The implementation of this
method should:
	* call the `distance(for:)` method on the received `Triathlon` instance with its `Sport` parameter to get the
distance
	* call the `metersPerMinute(for:randomValue:)` method with its `Sport` and `Double` parameters to get the speed
	* return the result of dividing the distance by the speed

Remember to enable the `ParticipantTests` test bundle and run the tests to validate your work.

Use the git client you prefer (the git command line tool, Xcode, the Sourcetree app, etc.) to commit all your work so far.  Make
sure to include a commit message briefly describing the work being commited.

The next page will describe how to [implement the Athlete class](@next).
*/
