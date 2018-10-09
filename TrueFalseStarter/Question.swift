//
//  Question.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 10/9/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

struct Question: Decodable{
    struct Answer: Decodable, Hashable{
        let text: String
        let isCorrect: Bool
    }
    let text: String
    let possibleAnswers: Set<Answer>
    var correctAnswer: Answer?{
        get{
            return possibleAnswers.first(where: {$0.isCorrect})
        }
    }
}
