//: Playground - noun: a place where people can play

import UIKit

enum Suit: Int {
    case Spades, Hearts, Clubs, Diamonds
}

enum Rank: Int {
    case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King, Ace
}

struct PokerCard {
    let rank: Rank
    let suit: Suit
}

enum PokerHandRank: Int {
    case HighCard = 1
    case OnePair
    case TwoPair
    case ThreeOfAKind
    case Straight
    case Flush
    case FullHouse
    case FourOfAKind
    case StraightFlush
    case RoyalFlush
}

struct PokerHand: Comparable {
    let ranks: [Rank: Int]
    let suits: [Suit: Int]
    
    init(cards: [PokerCard]) {
        if cards.count != 5 {
            fatalError("Wrong number of cards!")
        }
        var ranks = [Rank: Int]()
        var suits = [Suit: Int]()
        for card in cards {
            ranks[card.rank] = ranks[card.rank] != nil ? ranks[card.rank]! + 1 : 1
            suits[card.suit] = suits[card.suit] != nil ? suits[card.suit]! + 1 : 1
        }
        self.ranks = ranks
        self.suits = suits
    }
    
    func handRank() -> PokerHandRank {
        let tripleRanks = ranks.values.lazy.filter { $0 == 3 }
        let doubleRanks = ranks.values.lazy.filter { $0 == 2 }

        if isRoyalFlush() {
            return .RoyalFlush
        }
        if isStraight() && isFlush() {
            return .StraightFlush
        }
        if ranks.values.contains(4) {
            return .FourOfAKind
        }
        if tripleRanks.count == 1 && doubleRanks.count == 1 {
            return .FullHouse
        }
        if isFlush() {
            return .Flush
        }
        if isStraight() {
            return .Straight
        }
        if ranks.values.contains(3) {
            return .ThreeOfAKind
        }
        if doubleRanks.count == 2 {
            return .TwoPair
        }
        if doubleRanks.count == 1 {
            return .OnePair
        }
        return .HighCard
    }
    
    func isRoyalFlush() -> Bool {
        let validCards: [Rank] = [.Ten, .Jack, .Queen, .King, .Ace]
        if suits.keys.count == 1 && ranks.keys.lazy.filter({validCards.contains($0)}).count == 5 {
            return true
        }
        return false
    }
    
    func isFlush() -> Bool {
        return suits.keys.count == 1
    }
    
    func isStraight() -> Bool {
        guard ranks.keys.count == 5 else {
            return false
        }
        let sortedRanks = ranks.keys.map({$0.rawValue}).sort()
        var lastRank = sortedRanks[0]
        for i in 1..<5 {
            if sortedRanks[i] - lastRank != 1 {
                return false
            }
            lastRank = sortedRanks[i]
        }
        return true
    }
    
    func orderedArray() -> [Rank] {
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
            sortedWithinRanks[value] = rankArray.sort{ $0.rawValue > $1.rawValue }
        }
        
        // Generate final sorted array
        var result = [Rank]()
        for (value, rankArray) in sortedWithinRanks {
            for rank in rankArray {
                let currentRanks = [Rank](count: value, repeatedValue: rank)
                result += currentRanks
            }
        }
        
        return result
    }
}

// Compare hand ranks first, then if they are the same, compare card by card.
func ==(x: PokerHand, y: PokerHand) -> Bool {
    if x.handRank() != y.handRank() {
        return false
    }
    let sortedXRanks = x.orderedArray()
    let sortedYRanks = y.orderedArray()
    for i in 0..<5 {
        if sortedXRanks[i] != sortedYRanks[i] {
            return false
        }
    }
    return true
}

// Compare hand rands first, then if they are the same, compare card by card.
func <(x: PokerHand, y: PokerHand) -> Bool {
    if x.handRank() < y.handRank() {
        return true
    } else if x.handRank() != y.handRank() {
        return false
    }
    let sortedXRanks = x.orderedArray()
    let sortedYRanks = y.orderedArray()
    for i in 0..<5 {
        if sortedXRanks[i] < sortedYRanks[i] {
            return true
        }
    }
    return false
}

func <(x: PokerHandRank, y: PokerHandRank) -> Bool {
    return x.rawValue < y.rawValue
}

func <(x: Rank, y: Rank) -> Bool {
    return x.rawValue < y.rawValue
}

//===============================================

let cards = [
    PokerCard(rank: .Four, suit: .Hearts),
    PokerCard(rank: .Four, suit: .Diamonds),
    PokerCard(rank: .Ten, suit: .Clubs),
    PokerCard(rank: .Ten, suit: .Spades),
    PokerCard(rank: .Jack, suit: .Hearts),
]
let cards2 = [
    PokerCard(rank: .Four, suit: .Hearts),
    PokerCard(rank: .Four, suit: .Diamonds),
    PokerCard(rank: .Ten, suit: .Clubs),
    PokerCard(rank: .Ten, suit: .Spades),
    PokerCard(rank: .Ace, suit: .Hearts),
]
let cards3 = [
    PokerCard(rank: .Four, suit: .Hearts),
    PokerCard(rank: .Five, suit: .Diamonds),
    PokerCard(rank: .Six, suit: .Clubs),
    PokerCard(rank: .Seven, suit: .Spades),
    PokerCard(rank: .Eight, suit: .Hearts),
]
let hand = PokerHand(cards: cards)
let hand2 = PokerHand(cards: cards2)
let hand3 = PokerHand(cards: cards3)

print(hand < hand2)
print(hand2.handRank())

print(hand.suits)
print(hand.handRank())
print(hand.orderedArray())

print(hand3.handRank())


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
