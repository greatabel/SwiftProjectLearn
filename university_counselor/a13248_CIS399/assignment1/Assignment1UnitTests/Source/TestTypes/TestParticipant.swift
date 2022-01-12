//
//  TestParticipant.swift
//  Assignment1
//
//  Created by Charles Augustine.
//
//


class TestParticipant: Participant {
	required init(name: String) {
		self.name = name
	}

	let name: String
	var favoriteSport: Sport? = nil
}
