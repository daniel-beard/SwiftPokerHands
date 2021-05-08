//
//  SwiftPokerHands.swift
//  SwiftPokerHands
//
//  Created by Daniel Beard on 6/7/17.
//  Copyright © 2017 dbeard. All rights reserved.
//

import Foundation

enum Suit: Int {
    case spades, hearts, clubs, diamonds
}

enum Rank: Int {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king, ace
}

struct Card {
    let rank: Rank
    let suit: Suit
}

enum PokerHandRank: Int, Comparable {
    case highCard = 1
    case onePair
    case twoPair
    case threeOfAKind
    case straight
    case flush
    case fullHouse
    case fourOfAKind
    case straightFlush
    case royalFlush
}

struct PokerHand {
    let ranks: [Rank: Int]
    let suits: [Suit: Int]

    init(cards: [Card]) {
        guard cards.count == 5 else { fatalError("Wrong number of cards!") }
        var ranks = [Rank: Int]()
        var suits = [Suit: Int]()
        for card in cards {
            ranks[card.rank, default: 0] += 1
            suits[card.suit, default: 0] += 1
        }
        self.ranks = ranks
        self.suits = suits
    }

    func handRank() -> PokerHandRank {
        let tripleRanks = ranks.values.filter { $0 == 3 }
        let doubleRanks = ranks.values.filter { $0 == 2 }

        if suits.keys.count == 1 && ranks.keys.lazy.filter({[.ten,.jack,.queen,.king,.ace].contains($0)}).count == 5 {
            return .royalFlush
        }
        if isStraight() && isFlush() {
            return .straightFlush
        }
        if ranks.values.contains(4) {
            return .fourOfAKind
        }
        if tripleRanks.count == 1 && doubleRanks.count == 1 {
            return .fullHouse
        }
        if isFlush() {
            return .flush
        }
        if isStraight() {
            return .straight
        }
        if ranks.values.contains(3) {
            return .threeOfAKind
        }
        if doubleRanks.count == 2 {
            return .twoPair
        }
        if doubleRanks.count == 1 {
            return .onePair
        }
        return .highCard
    }

    func isFlush() -> Bool {
        return suits.keys.count == 1
    }

    func isStraight() -> Bool {
        guard ranks.keys.count == 5 else { return false }
        let sortedRanks = ranks.keys.map({$0.rawValue}).sorted(by: >)
        return sortedRanks[0] - sortedRanks[4] == 4
    }


    func histogram() -> ([Int], [Rank]) {
        // Group by number of cards
        var sortedWithinRanks = [Int: [Rank]]()
        for (rank, value) in ranks {
            if let valueArray = sortedWithinRanks[value] {
                var result = valueArray
                result.append(rank)
                sortedWithinRanks[value] = result
            } else {
                sortedWithinRanks[value] = [rank]
            }
        }

        // Sort ranks within number of cards
        for (value, rankArray) in sortedWithinRanks {
            sortedWithinRanks[value] = rankArray.sorted{ $0.rawValue > $1.rawValue }
        }

        // Generate final sorted array
        var result = [Rank]()
        var histogram = [Int]()
        for key in sortedWithinRanks.keys.sorted(by: >) {
            for rank in sortedWithinRanks[key]!.sorted(by: >) {
                histogram.append(key)
                let currentRanks = [Rank](repeating: rank, count: key)
                result += currentRanks
            }
        }

        // histogram
        return (histogram, result)
    }
}

// Compare hand rands first, then if they are the same, compare card by card.
func <(x: PokerHand, y: PokerHand) -> Bool {
    if x.handRank() < y.handRank() {
        return true
    } else if x.handRank() != y.handRank() {
        return false
    }
    let xHistogram = x.histogram()
    let yHistogram = y.histogram()
    for (x, y) in zip(xHistogram.1, yHistogram.1) {
        if x < y { return true }
        if x > y { return false }
    }
    return false
}

func <(x: PokerHandRank, y: PokerHandRank) -> Bool {
    return x.rawValue < y.rawValue
}

func <(x: Rank, y: Rank) -> Bool {
    return x.rawValue < y.rawValue
}

func >(x: Rank, y: Rank) -> Bool {
    return x.rawValue > y.rawValue
}


//===============================================
func runHandClassifier() {

    let cards = [
        Card(rank: .four, suit: .hearts),
        Card(rank: .four, suit: .diamonds),
        Card(rank: .five, suit: .hearts),
        Card(rank: .five, suit: .hearts),
        Card(rank: .six, suit: .hearts),
        ]
    let cards2 = [
        Card(rank: .five, suit: .hearts),
        Card(rank: .five, suit: .hearts),
        Card(rank: .seven, suit: .hearts),
        Card(rank: .six, suit: .hearts),
        Card(rank: .six, suit: .clubs),
        ]
    let cards3 = [
        Card(rank: .four, suit: .hearts),
        Card(rank: .five, suit: .diamonds),
        Card(rank: .six, suit: .clubs),
        Card(rank: .seven, suit: .spades),
        Card(rank: .eight, suit: .hearts),
        ]
    let hand = PokerHand(cards: cards)
    let hand2 = PokerHand(cards: cards2)
    let hand3 = PokerHand(cards: cards3)

    print(hand.handRank())
    print(hand2.handRank())
    print(hand < hand2)
    print(hand2.handRank())

    print(hand.suits)
    print(hand.handRank())
    print(hand3.handRank())

    func cardFromString(_ string: String) -> Card {
        let rankString = String(string.prefix(1))
        let suitString = String(string.suffix(1))

        let suit: Suit
        switch suitString {
        case "D": suit = .diamonds
        case "H": suit = .hearts
        case "C": suit = .clubs
        case "S": suit = .spades
        default: suit = .diamonds
        }

        let rank: Rank
        switch rankString {
        case "T": rank = .ten
        case "J": rank = .jack
        case "Q": rank = .queen
        case "K": rank = .king
        case "A": rank = .ace
        default:
            rank = Rank(rawValue: (rankString as NSString).integerValue)!
        }
        return Card(rank: rank, suit: suit)
    }

    let fileURL = Bundle.main.url(forResource: "p54", withExtension: "txt")
    let content = try! String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
    let array = content.components(separatedBy: "\n")
    var count = 0
    for line in array {
        let hands = line.components(separatedBy: " ")
        var h1 = [Card]()
        var h2 = [Card]()
        for i in 0..<5 {
            let c1 = cardFromString(hands[i])
            let c2 = cardFromString(hands[i+5])
            h1.append(c1)
            h2.append(c2)
        }
        let g1 = PokerHand(cards: h1)
        let g2 = PokerHand(cards: h2)
        if (g1 < g2) == false {
            count += 1
        }
    }
    print(count)
}
/*
 In the card game poker, a hand consists of five cards and are ranked, from lowest to highest, in the following way:

 + High Card: Highest value card.
 + One Pair: Two cards of the same value.
 + Two Pairs: Two different pairs.
 + Three of a Kind: Three cards of the same value.
 + Straight: All cards are consecutive values.
 + Flush: All cards of the same suit.
 + Full House: Three of a kind and a pair.
 + Four of a Kind: Four cards of the same value.
 + Straight Flush: All cards are consecutive values of same suit.
 + Royal Flush: Ten, Jack, Queen, King, Ace, in same suit.
 The cards are valued in the order:
 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King, Ace.

 If two players have the same ranked hands then the rank made up of the highest value wins; for example, a pair of eights beats a pair of fives (see example 1 below). But if two ranks tie, for example, both players have a pair of queens, then highest cards in each hand are compared (see example 4 below); if the highest cards tie then the next highest cards are compared, and so on.
 */
