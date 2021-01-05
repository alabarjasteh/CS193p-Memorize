//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Amirala on 8/9/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    var theme: Theme
    
//    init() {
//        theme = EmojiMemoryGame.randomTheme()
//        model = EmojiMemoryGame.createMemoryGame(with: theme)
//    }
    
    init(theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
    
    private static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
        let size = theme.numberOfPairs// ?? theme.emojies.count.random(startingFrom: 2)
        guard size <= theme.emojis.count else { fatalError("number of pairs of cards of \(theme.name) theme exceeds emojis.count") }
        var chosenEmojies = [String]()
        while chosenEmojies.count < size {
            let emoji = theme.emojis.randomElement()!
            if !chosenEmojies.contains(emoji) {
                chosenEmojies.append(emoji)
            }
        }
        return MemoryGame<String>(numberOfPairsOfCards: size) { pairIndex in
            chosenEmojies[pairIndex]
        }
    }
    
    struct Theme: Codable, Hashable, Identifiable {
        var id: UUID
        
        static func == (lhs: Theme, rhs: Theme) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var name: String
        var emojis: [String]
        var color: UIColor {
            get { UIColor(themeColor) }
            set { themeColor = newValue.rgb }
        }
        var numberOfPairs: Int
        
        private var themeColor: UIColor.RGB
        
        init(id: UUID? = nil, name: String, emojis: [String], color: UIColor, numberOfPairs: Int) {
            self.id = id ?? UUID()
            self.name = name
            self.emojis = emojis
            self.themeColor = color.rgb
            self.numberOfPairs = numberOfPairs
        }
        
        var json: Data? {
            try? JSONEncoder().encode(self)
        }
        
        func emojisToString() -> String {
            var out = String()
            for emoji in emojis {
                out.append(emoji)
            }
            return out
        }
    }
    
    static var themes: [Theme] = [
        Theme(name: "Holloween", emojis: ["👻", "🎃", "🕷", "😈", "💀"], color: .orange, numberOfPairs: 3),
        Theme(name: "Animals", emojis: ["🐼", "🦊", "🐨", "🐶", "🐱"], color: .green, numberOfPairs: 4),
        Theme(name: "Sports", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🎳", "🏓"], color: .magenta, numberOfPairs: 6),
        Theme(name: "Faces", emojis: ["🥶", "😡", "😇", "😂", "🥺", "😃"], color: .purple, numberOfPairs: 6),
        Theme(name: "Fruits", emojis: ["🍎", "🍐", "🍊", "🍌", "🍉", "🍇", "🍓", "🍍", "🥝"], color: .yellow, numberOfPairs: 9),
        Theme(name: "Flags", emojis: ["🇨🇴", "🇨🇨", "🇨🇽", "🇨🇳", "🇹🇩", "🇪🇨", "🇹🇫", "🇰🇷", "🇵🇪", "🇺🇸"], color: .blue, numberOfPairs: 10)
    ]
    
    static func randomTheme(from themes: [Theme] = EmojiMemoryGame.themes) -> Theme {
        return themes.randomElement()!
    }

    // MARK: - Access to the model
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        self.theme = EmojiMemoryGame.randomTheme()
        self.model = EmojiMemoryGame.createMemoryGame(with: theme)
        print(self.theme.json?.utf8 ?? "cannot encode/decode theme")
    }
}
