//
//  ContentView.swift
//  Gestures Practice
//
//  Created by Sai Nikhit Gulla on 05/03/21.
//

import SwiftUI




enum DragDirection {
    case left
    case right
}

struct CardView: View {
    @State var revealMeaning = false
    @State var offset: CGSize = .zero
    
    let dragged: (_ card: Word, _ dragDirection: DragDirection) -> Void
    
    let word: Word
    
    init(word: Word, onDragged: @escaping (_ card: Word, _ dragDirection: DragDirection) -> Void) {
        self.word = word
        self.dragged = onDragged
    }
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { self.offset = $0.translation }
            .onEnded {
                if $0.translation.width < -100 {
                    self.offset = .init(width: -1000, height: 0)
                    self.dragged(word, .left)
                } else if $0.translation.width > 100 {
                    self.offset = .init(width: 1000, height: 0)
                    self.dragged(word, .right)
                } else {
                    self.offset = .zero
                }
             }
        
        return ZStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: 380, height: 210)
                .cornerRadius(12)
            
            VStack {
                Text(word.word)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                if self.revealMeaning {
                    Text(word.meaning)
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
        .shadow(radius: 8)
        .frame(width: 320, height: 210)
        .animation(.spring()).frame(width: 380, height: 210)
        .offset(offset)
        .gesture(dragGesture)
        .gesture(TapGesture().onEnded({
            withAnimation(.spring()) {
                self.revealMeaning = !self.revealMeaning
            }
        }))
    }
}
struct DeckView: View {
    
    @ObservedObject var deck = Deck()
    let onMemorized: () -> Void
    
    init(onMemorized: @escaping () -> Void) {
        self.onMemorized = onMemorized
    }
    
    var body: some View {
        ZStack {
            ForEach(deck.words) { word in
                CardView(word: word) { card, direction in
                    if direction == .left {
                        self.deck.removeWord()
                        self.onMemorized()
                    }
                }
            }
        }
    }
}
struct ContentView: View {
    
    
    @State var correctAnswers = 0
    
    var body: some View {
        ZStack {
            VStack {
                DeckView {
                    self.correctAnswers += 1
                }
                
                Text("Correctly Answered: \(self.correctAnswers)")
                    .font(.headline)
                    .padding(.top)
            }
            VStack {
                Spacer()
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Text("Add New Deck")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(30)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
