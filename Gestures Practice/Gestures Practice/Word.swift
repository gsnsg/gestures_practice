//
//  Word.swift
//  Gestures Practice
//
//  Created by Sai Nikhit Gulla on 05/03/21.
//

import Foundation


struct Word: Identifiable {
    let id = UUID()
    var word: String
    var meaning: String
    
    static func ==(lhs: Word, rhs: Word) -> Bool {
        return lhs.word == rhs.word
        
    }
}



class Deck: ObservableObject {
    @Published var words: [Word]
    
    let questionsDict: [String: String] = ["maintain" : "to ascertain", "commensurate" : "in proportion to", "wanting" : "lacking"]
    
    init() {
        self.words = self.questionsDict.map { Word(word: $0, meaning: $1) }
    }
    
    
    func removeWord() {
        self.words.removeFirst()
    }
}
