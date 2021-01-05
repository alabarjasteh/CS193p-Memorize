//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Amirala on 10/14/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import SwiftUI

struct ThemeEditor: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    
    var theme: EmojiMemoryGame.Theme
    @Binding var isShowing: Bool
    
    @State private var themeName: String = ""
    @State private var numberOfPairs: Int = 0
    @State private var emojisToShow: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Theme Editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }, label: {Text("Done") }).padding()
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Theme Name", text: $themeName, onEditingChanged: { began in
                        if !began {
                            store.renameTheme(theme, to: themeName)
                        }
                    })
                }
                
                Section(header: Text("Add Emoji")) {
                    AddEmojisView(theme: theme, emojisToShow: $emojisToShow).environmentObject(store)
                }
                Section(header: HStack {
                    Text("Emojis")
                    Spacer()
                    Text("tap emoji to exclude").font(.caption)
                })
                {
                    RemoveEmojisView(theme: theme, emojisToShow: $emojisToShow).environmentObject(store)
                }
                Section(header: Text("Card Count")) {
                    CardCountView(theme: theme, numberOfPairs: $numberOfPairs).environmentObject(store)
                }
                Section(header: Text("Color")) {
                    ColorView(theme: theme).environmentObject(store)
                }
            }
            .onAppear {
                emojisToShow = theme.emojis
                numberOfPairs = theme.numberOfPairs
            }
        }
    }
    
}

struct ColorView: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    var theme: EmojiMemoryGame.Theme
    
    @State private var chosenColor: UIColor = .black
    
    var body: some View {
        Grid(EmojiMemoryGameStore.colors, id: \.rgb) { color in
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(Color(color))
                    .aspectRatio(1, contentMode: .fit)
                    .padding(paddingValue)
                Image(systemName: "checkmark.circle")
                    .imageScale(.large)
                    .opacity(color == chosenColor ? 1 : 0)
                    .offset(x: 15.0, y: 15.0)
            }
            .onTapGesture {
                store.chooseColor(color, for: theme)
                chosenColor = color
            }
        }
        .frame(height: height)
        .onAppear { chosenColor = theme.color }
    }
    
    // MARK: - Drawing Constants
    var height: CGFloat {
        CGFloat((6.0) / 6) * 70 + 70
    }
    let cornerRadius: CGFloat = 4.0
    let paddingValue: CGFloat = 2.0
}



struct AddEmojisView: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    
    var theme: EmojiMemoryGame.Theme
    
    @State private var emojisToAdd: String = ""
    @Binding var emojisToShow: [String]
    
    var body: some View {
        ZStack {
            TextField("Emoji", text: $emojisToAdd)
            HStack {
                Spacer()
                Button(action: {
                    store.addEmojis(to: theme, emojis: emojisToAdd)
                    emojisToAdd.forEach { emojisToShow.append(String($0)) }
                    emojisToAdd.removeAll()
                }, label: { Text("Add") })
            }
        }
    }
}


struct RemoveEmojisView: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    
    var theme: EmojiMemoryGame.Theme
    
    @Binding var emojisToShow: [String]
    @State private var cannotRemoveMoreEmojis: Bool = false
    
    var body: some View {
        Grid(emojisToShow, id: \.self) { emoji in
            Text(emoji).font(Font.system(size: fontSize))
                .onTapGesture {
                    if store.removeEmoji(emoji, from: theme) {
                        let emojiIndex = emojisToShow.firstIndex(of: emoji)!
                        emojisToShow.remove(at: emojiIndex)
                    } else {
                        cannotRemoveMoreEmojis = true
                    }
                }
                .alert(isPresented: $cannotRemoveMoreEmojis) {
                    return Alert(
                        title: Text("Cannot Remove Emojis"),
                        message: Text("Number of emjis reached the minimum number of cards for this theme, try adding more emojis then exclude what you want."),
                        dismissButton: .default(Text("OK"))
                    )
                }
        }
        .frame(height: height)
    }
    
    // MARK: - Drawing Constants
    var height: CGFloat {
        CGFloat((theme.emojis.count - 1) / 6) * 70 + 70
    }
    let fontSize: CGFloat = 40

}


struct CardCountView: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    var theme: EmojiMemoryGame.Theme
    @Binding var numberOfPairs: Int

    var body: some View {
        HStack {
            Text("\(numberOfPairs) Pairs")
            Spacer()
            Stepper(onIncrement: {
                if store.incrementSize(for: theme) {
                    numberOfPairs += 1
                }
            }, onDecrement: {
                if store.decrementSize(for: theme) {
                    numberOfPairs -= 1
                }
            }, label: { EmptyView() })
        }
    }
}
