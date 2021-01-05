//
//  EmojiMermoryGameView.swift
//  Memorize
//
//  Created by Amirala on 8/6/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import SwiftUI

struct EmojiMermoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame  
    
    var body: some View {
        VStack {
//            Text(viewModel.theme.name)
//                .font(.largeTitle)
            
            Grid(viewModel.cards) { card in
                CardView(card: card, ThemeColor: viewModel.theme.color).onTapGesture {
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.choose(card: card)
                    }
                }
                .aspectRatio(0.67, contentMode: .fit)
                .padding(5)
            }
            .padding()
            
            Button("New Game") {
                withAnimation(.easeInOut) {
                    viewModel.resetGame()
                }
            }
            .font(.title)
            
            Text(String(viewModel.score))
                .font(.title)
        }
        .foregroundColor(Color(viewModel.theme.color))
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var ThemeColor: UIColor
    
    //    var body: some View {
    //        GeometryReader { geometry in
    //            if card.isFaceUp || !card.isMatched {
    //                ZStack {
    //                    Pie(startAngle: Angle.degrees(0-90), endAngle: .degrees(110-90), clockwise: true)
    //                        .padding(5).opacity(0.4)
    //                    Text(card.content)
    //                }
    //                .cardify(isFaceUp: card.isFaceUp)
    //                //            .aspectRatio(0.67, contentMode: .fit)
    //                .font(Font.system(size: fontsize(for: geometry.size)))
    //            }
    //        }
    //    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)
                .transition(.scale)
                Text(card.content)
                    .font(Font.system(size: fontsize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(.scale)
        }
    }
    
    // MARK: - Drawing Constants
    
    private func fontsize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.6
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let game = EmojiMemoryGame()
//        game.choose(card: game.cards[0])
//        return EmojiMermoryGameView(viewModel: game)
//    }
//}
