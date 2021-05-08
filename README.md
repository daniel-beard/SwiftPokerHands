# SwiftPokerHands ![](https://img.shields.io/badge/swift-5-brightgreen.svg)

A simple five card poker hand classifier

### Examples:

##### Identifying a hand rank

```swift
let cards = [
    Card(rank: .four,  suit: .hearts),
    Card(rank: .five,  suit: .diamonds),
    Card(rank: .six,   suit: .clubs),
    Card(rank: .seven, suit: .spades),
    Card(rank: .eight, suit: .hearts),
]
let hand = PokerHand(cards: cards)
print(hand.handRank()) // straight
```

##### Comparing two hands

```swift
let cards = [
    Card(rank: .four,  suit: .hearts),
    Card(rank: .four,  suit: .diamonds),
    Card(rank: .five,  suit: .hearts),
    Card(rank: .five,  suit: .hearts),
    Card(rank: .six,   suit: .hearts),
]
let cards2 = [
    Card(rank: .five,  suit: .hearts),
    Card(rank: .five,  suit: .hearts),
    Card(rank: .seven, suit: .hearts),
    Card(rank: .six,   suit: .hearts),
    Card(rank: .six,   suit: .clubs),
]
let hand = PokerHand(cards: cards)
let hand2 = PokerHand(cards: cards2)

print(hand < hand2) // true
```

##### Other Examples

```swift
let cards = [
    Card(rank: .four,   suit: .hearts),
    Card(rank: .four,   suit: .diamonds),
    Card(rank: .five,   suit: .hearts),
    Card(rank: .five,   suit: .hearts),
    Card(rank: .six,    suit: .hearts),
]
let cards2 = [
    Card(rank: .five,   suit: .hearts),
    Card(rank: .five,   suit: .hearts),
    Card(rank: .seven,  suit: .hearts),
    Card(rank: .six,    suit: .hearts),
    Card(rank: .six,    suit: .clubs),
]
let cards3 = [
    Card(rank: .four,   suit: .hearts),
    Card(rank: .five,   suit: .diamonds),
    Card(rank: .six,    suit: .clubs),
    Card(rank: .seven,  suit: .spades),
    Card(rank: .eight,  suit: .hearts),
]
let hand = PokerHand(cards: cards)
let hand2 = PokerHand(cards: cards2)
let hand3 = PokerHand(cards: cards3)

print(hand < hand2) // true
print(hand2.handRank()) // twoPair

print(hand.suits) // [Suit.diamonds: 1, Suit.hearts: 4]
print(hand.handRank()) // twoPair
print(hand3.handRank()) // straight
```

### License 
MIT
