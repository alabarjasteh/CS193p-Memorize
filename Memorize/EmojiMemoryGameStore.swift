//
//  EmojiMemoryGameStore.swift
//  Memorize
//
//  Created by Amirala on 10/14/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import SwiftUI
import Combine

class EmojiMemoryGameStore: ObservableObject {
    @Published var themes = [EmojiMemoryGame.Theme]()
    
    static let colors: [UIColor] = [.black, .blue, .cyan, .green, .magenta, .orange, .purple, .red, .yellow, .gray]
    
    private var autosave: AnyCancellable?
    
    init() {
        let defaultsKey = "EmojiMemoryGameStore.Memorize"
        themes = Array(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKey))
//        themes = [EmojiMemoryGame.Theme]()
        autosave = $themes.sink { themes in
            UserDefaults.standard.set(themes.asPropertyList, forKey: defaultsKey)
        }
    }
    
    
    // MARK: - Intents
    
    func addTheme() {
        let defaultTheme = EmojiMemoryGame.Theme(name: "Default Theme", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🎳", "🏓"], color: .magenta, numberOfPairs: 6)
        themes.append(defaultTheme)
    }
    
    func removeTheme(_ theme: EmojiMemoryGame.Theme) {
        let index = themes.firstIndex(of: theme)!
        themes.remove(at: index)
    }
    
    func renameTheme(_ theme: EmojiMemoryGame.Theme, to newName: String) {
        let index = themes.firstIndex(of: theme)!
        themes[index].name = newName
    }
    
    func addEmojis(to theme: EmojiMemoryGame.Theme, emojis: String) {
        let index = themes.firstIndex(of: theme)!
        emojis.forEach { themes[index].emojis.append(String($0)) }
    }
    
    @discardableResult
    func removeEmoji(_ emoji: String, from theme: EmojiMemoryGame.Theme) -> Bool {
        let index = themes.firstIndex(of: theme)!
        guard themes[index].numberOfPairs < themes[index].emojis.count else {
            return false
        }
        if let emojiIndex = themes[index].emojis.firstIndex(where: { $0 == emoji }) {
            themes[index].emojis.remove(at: emojiIndex)
        }
        return true
    }
    
    @discardableResult
    func incrementSize(for theme: EmojiMemoryGame.Theme) -> Bool {
        let index = themes.firstIndex(of: theme)!
        guard themes[index].emojis.count > themes[index].numberOfPairs else {
            return false
        }
        themes[index].numberOfPairs += 1
        return true
    }
    
    @discardableResult
    func decrementSize(for theme: EmojiMemoryGame.Theme) -> Bool {
        let index = themes.firstIndex(of: theme)!
        guard 2 < themes[index].numberOfPairs else {
            return false
        }
        themes[index].numberOfPairs -= 1
        return true
    }
    
    func chooseColor(_ color: UIColor, for theme: EmojiMemoryGame.Theme) {
        let index = themes.firstIndex(of: theme)!
        themes[index].color = color
    }
}

extension Array where Element == EmojiMemoryGame.Theme {
    var asPropertyList: [Data] {
        var jsons = [Data]()
        for theme in self {
            jsons.append(theme.json!)
        }
        return jsons
    }
    
    init(fromPropertyList pList: Any?) {
        self.init()
        let jsons = pList as? [Data] ?? []
        for json in jsons {
            let theme = try! JSONDecoder().decode(EmojiMemoryGame.Theme.self, from: json)
            self.append(theme)
        }
    }
}
