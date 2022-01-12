/*:
[Previous](@previous)

# TriathlonEvent class

This work should be done in the TriathlonEvent.swift file that already exists in the project.

The `TriathlonEvent` class implements logic to simulate a triathlon race event. The `TriathlonEvent` class
implementation should:

1. have a constant property that stores what type of triathlon the event is going to simulate named `triathlon` of type
`Triathlon` with no initial value defined

2. have an initializer to create the event that:
	* takes a parameter with the identifier `triathlon` of type `Triathlon`
	* sets the initial value of the `triathlon` property to the parameter value

3. have a variable property to store the state of the event named `eventPerformed` that:
	* is of type `Bool`
	* has the initial value of `false`
	* can only be set privately (Hint: this is done by adding `private(set)` before the `var` keyword)

4. have a method that can be used to register a `Participant` for the event named `register` that should:
	* take a single parameter with the empty label `_` of type `Participant` which:
		* validates that the `eventPerformed` property is `false` with a guard statement
			* if validation fails the function should call `fatalError()`
		* should add the participant to the event
		* give the participant an initial time of 0 minutes
			* how you store participant data is up to you; you may create whatever additional private properties and
methods you like (because we are not trying to implement a complex simulation it is acceptable to assume that
participant names will be unique)

5. have a computed property named `registeredParticipants` of type `[Participant]` that returns an array of all
currently registered participants

6. have a method named to retrieve an event participant's current event time named `raceTime` that:
	* takes a single parameter with the label `for` of type `Participant`
	* returns a value of type `Int?`
	* returns the race time for a registered participant

7. have a method to simulate a participant's performance in one sport of the event named `simulate` that:
	* takes a parameter with the empty label `_` of type `Sport`
	* takes a parameter with the label `for` of type `Participant`
	* takes a parameter with the label `randomValue` of type `Double` which has a default value of
`Double.random(in: 0 ... 1)`
	* validates that the participant's event time is not set to `nil` with a guard statement
		* if validation fails the function should return without performing the below logic or printing anything
	* implements the following logic:
		* if the sport is the participant's favorite sport or the random value is >= 0.06 calculate the completion time
for the participant by calling its `completionTime(for:in:) function`
			* Add this time to the participants event time
		* Otherwise set the participants event time to `nil`
	* print the following text:
		* "<participant name> is about to begin <sport>" prior to the above logic
		* "<participant name> finished the <sport> event in <time for sport> minutes; their total race time is now
<event time> minutes." if the above logic did not set the participant time to `nil`
		* "<participant name> could not finish the <sport> event and will not finish the race." if the above logic set
the participant time to `nil`

8. have a method to run the entire event simulation named `simulate` that:
	* takes no parameters
	* validate that the `eventPerformed` property is `false` with a guard statement
		* if validation fails the function should call `fatalError()`
	* loop through each sport in `Triathlon.sports` and performs the following logic:
		* loop through each registered participant and do the following in each loop:
			* call the `simulate(_:for:)` method with the sport and participant
	* set the `eventPerformed` variable to true

9. have a computed property to retrieve the winner of the event named `winner` of type `Participant?` that provides a
`get` implementation with the following logic:
	* validate that the `eventPerformed` property is `true` with a guard statement
		* if validation fails the function should call `fatalError()`
	* determine the event winner with the following logic:
		* the participant with the lowest time should be the winner
		* if two or more participants are tied with the same winning event time the one who registered first should win
		* it should be possible for there to be no winner if all participants have an event time of `nil` (i.e., a
participant with a `nil` event time should never win)

Remember to enable the `TriathlonEventTests` test bundle and run the tests to validate your work.

Use the git client you prefer (the git command line tool, Xcode, the Sourcetree app, etc.) to commit all your work so far.  Make
sure to include a commit message briefly describing the work being commited.

The next page will describe how to [implement the Main.swift file](@next).
*/
