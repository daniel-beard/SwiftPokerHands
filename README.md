# SwiftPokerHands
A simple five card poker hand classifier

Example:

```
let cards = [
    PokerCard(rank: .Four, suit: .Hearts),
    PokerCard(rank: .Four, suit: .Diamonds),
    PokerCard(rank: .Five, suit: .Hearts),
    PokerCard(rank: .Five, suit: .Hearts),
    PokerCard(rank: .Six, suit: .Hearts),
]
let cards2 = [
    PokerCard(rank: .Five, suit: .Hearts),
    PokerCard(rank: .Five, suit: .Hearts),
    PokerCard(rank: .Seven, suit: .Hearts),
    PokerCard(rank: .Six, suit: .Hearts),
    PokerCard(rank: .Six, suit: .Clubs),
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

print(hand.suits) // [Suit.Diamonds: 1, Suit.Hearts: 4]
print(hand.handRank()) // TwoPair
print(hand3.handRank()) // Straight
```
