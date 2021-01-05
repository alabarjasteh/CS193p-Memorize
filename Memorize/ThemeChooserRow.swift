//
//  ThemeChooserRow.swift
//  Memorize
//
//  Created by Amirala on 10/14/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import SwiftUI

struct ThemeChooserRow: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    
    var theme: EmojiMemoryGame.Theme
    var isEditing: Bool
    
    @State var showThemeEditor = false
    
    var body: some View {
        HStack {
            Group {
                if isEditing {
                    Image(systemName: "slider.vertical.3")
                        .onTapGesture {
                            showThemeEditor = true
                        }
                        .sheet(isPresented: $showThemeEditor) {
                            ThemeEditor(theme: theme, isShowing: $showThemeEditor)
                                .environmentObject(store)
                        }
                        .padding()
                }
            }
            VStack(alignment: .leading) {
                Text(theme.name)
                    .font(.headline)
                    .foregroundColor(Color(theme.color))
                HStack {
                    Text("\(theme.numberOfPairs) pairs from")
                        .layoutPriority(1)
                    Text(theme.emojisToString())
                        .frame(maxWidth: 300, maxHeight: 20)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
