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
    
    init() {
        theme = EmojiMemoryGame.randomTheme()
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
    
    private static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
        let size = theme.numberOfPairs ?? theme.emojies.count.random(startingFrom: 2)
        var chosenEmojies = [String]()
        while chosenEmojies.count < size {
            let emoji = theme.emojies.randomElement()!
            if !chosenEmojies.contains(emoji) {
                chosenEmojies.append(emoji)
            }
        }
        return MemoryGame<String>(numberOfPairsOfCards: size) { pairIndex in
            chosenEmojies[pairIndex]
        }
    }
    
    struct Theme {
        let name: String
        let emojies: [String]
        let color: Color
        var numberOfPairs: Int?
    }
    
    static var themes: [Theme] = [
        Theme(name: "Holloween", emojies: ["👻", "🎃", "🕷", "😈", "💀"], color: .orange),
        Theme(name: "Animals", emojies: ["🐼", "🦊", "🐨", "🐶", "🐱"], color: .green, numberOfPairs: 4),
        Theme(name: "Sports", emojies: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🎳", "🏓"], color: .pink),
        Theme(name: "Faces", emojies: ["🥶", "😡", "😇", "😂", "🥺", "😃"], color: .purple, numberOfPairs: 5),
        Theme(name: "Fruits", emojies: ["🍎", "🍐", "🍊", "🍌", "🍉", "🍇", "🍓", "🍍", "🥝"], color: .yellow, numberOfPairs: 6),
        Theme(name: "Flags", emojies: ["🇨🇴", "🇨🇨", "🇨🇽", "🇨🇳", "🇹🇩", "🇪🇨", "🇹🇫", "🇰🇷", "🇵🇪", "🇺🇸"], color: .blue, numberOfPairs: 3)
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
    }
}




struct EmojiMemoryGame_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
