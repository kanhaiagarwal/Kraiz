//
//  VibeQuotes.swift
//  Kraiz
//
//  Created by Kanhai Agarwal on 23/12/18.
//  Copyright © 2018 Kumar Agarwal, Kanhai. All rights reserved.
//

import Foundation

class VibeQuotes {
    static public let shared = VibeQuotes()

    private init() {}

    private let quotes = [["Imagine falling in love with a person having same sense of humour, same dirty mind, and most importantly same caring nature.", "The feeling of love is sacred, you can't feign this feeling if you don't actually fall for the person."], ["The best thing about journey is the gush of air sauntering pass you, and eventually giving a wide smile on your face.", "If you want your ROI to reach its culmination, then invest in experiences and adventures."], ["Waking up with sound of birds and prayers, then watching sun spread its beautiful crimson light. Isn't it a 'GOOD' morning?", "Lying on a beach, with sand kissing your body; water playing a 'touch and run' game with you, and sun smiling, watching this is my kinda perfect day."], ["If music and dance was sold as a drug, people wouldn't need the actual drugs.", "Singing and dancing with strangers, eventually friends, capturing each and every moment in my giga pixels camera, eyes, is a never forgettable party."], ["I still remember the chortles of my friends mocking me, fight for that one last slice of pizza and their one last hug.", "Don't you miss those days when the biggest headache was completing your homework and excitement was talking over a landline phone."], ["The only day when you feel like a celebrity, with wishes pounding on you is the day you crawled into this beautiful world.", "Sometimes, I feel wedding are the best things that could happen to me; you get to wear your favourite dress"]]

    /// Returns the quote for a particular tag.
    /// - Parameters:
    ///     - tagIndex: Index of the Tag.
    ///     - quoteIndex: Index of the Quote.
    /// - Returns: Quote.
    public func getQuote(tagIndex: Int, quoteIndex: Int) -> String {
        return quotes[tagIndex][quoteIndex]
    }
    
    /// Returns the number of quotes for a tag Index.
    /// - Parameters:
    ///     - tagIndex - Tag Index.
    /// - Returns: Number of Quotes in the Tag.
    public func getNumberOfQuotesForATag(tagIndex: Int) -> Int {
        return quotes[tagIndex].count
    }
}
