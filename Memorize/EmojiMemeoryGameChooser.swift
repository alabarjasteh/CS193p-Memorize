//
//  EmojiMemeoryGameChooser.swift
//  Memorize
//
//  Created by Amirala on 10/14/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import SwiftUI

struct EmojiMemeoryGameChooser: View {
    @EnvironmentObject var store: EmojiMemoryGameStore
    
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMermoryGameView(viewModel: EmojiMemoryGame(theme: theme))
                                    .navigationBarTitle(theme.name)
                    ) {
                        ThemeChooserRow(theme: theme, isEditing: editMode.isEditing).environmentObject(store)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { store.themes[$0] }.forEach { theme in
                        store.removeTheme(theme)
                    }
                }
            }
            .navigationBarTitle("Memorize")
            .navigationBarItems(
                leading: Button(action: {
                store.addTheme()
            }, label: {
                Image(systemName: "plus").imageScale(.large)
            }),
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
    }
}
