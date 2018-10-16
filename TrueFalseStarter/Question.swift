//
//  Question.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 10/9/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

typealias Quizzable = Decodable & Hashable

struct Question: Quizzable{
    struct Answer: Quizzable{
        let value: String
        func isCorrect(for question: Question) -> Bool{
            return value == question.correctAnswer.value
        }
    }
    let text: String
    let possibleAnswers: Set<Answer>
    let correctAnswer: Answer
}
