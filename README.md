# SwiftPokerHands
A simple five card poker hand classifier

Example:

```
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

print(hand < hand2) // true
print(hand2.handRank()) // TwoPair

print(hand.suits) // [Suit.Clubs: 1, Suit.Diamonds: 1, Suit.Hearts: 2, Suit.Spades: 1]
print(hand.handRank()) // TwoPair
print(hand.orderedArray()) // [Rank.Ten, Rank.Ten, Rank.Four, Rank.Four, Rank.Jack]

print(hand3.handRank()) // Straight
```
