//
//  Question.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 10/9/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

typealias Quizzable = Decodable & Hashable

struct Question: Quizzable{

    // MARK: - Answer Model Definition

    struct Answer: Quizzable{ // I spent a long time trying to make this a generic, because an answer could reasonably be anything, but Swift's generic system didn't wanna work with me, so values are just Strings for now
        let value: String
        func isCorrect(for question: Question) -> Bool{
            return value == question.correctAnswer.value
        }
        fileprivate init(value: String){
            self.value = value
        }
    }

    // MARK: - Properties

    let text: String
    let possibleAnswers: Set<Answer>
    let correctAnswer: Answer
}
