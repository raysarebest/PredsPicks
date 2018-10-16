//
//  Quiz.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 10/11/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

class Quiz{
    enum QuestionAnswerState{
        case correct
        case incorrect(correctAnswer: Question.Answer?)
    }
    enum QuizError: Error{
        case quizComplete
    }
    private static let allQuestions: [Question] = {
        guard let path = Bundle.main.path(forResource: "Questions", ofType: "plist") else{
            fatalError("Couldn't find questions list")
        }
        do{
            return try PropertyListDecoder().decode([Question].self, from: try Data(contentsOf: URL(fileURLWithPath: path)))
        }
        catch{
            fatalError("Error generating question data: " + error.localizedDescription)
        }    }()

    let questions: [Question]
    private(set) var currentQuestionIndex: Int? = 0 // This will be nil if the quiz has finished
    var currentQuestion: Question?{
        get{
            if let index = currentQuestionIndex{
                return questions[index]
            }
            else{
                return nil
            }
        }
    }
    private(set) var correctQuestions: Set<Question> = []
    private(set) var incorrectQuestions: Set<Question> = []
    var isComplete: Bool{
        get{
            return correctQuestions.count + incorrectQuestions.count == questions.count
        }
    }

    init(questionCount: Int = 4){
        // This gets a shuffled version of `allQuestions` and grabs the first n questions, where n is the `questionCount` passed in, or all of them if more than the total possible is requested
        questions = Array(Quiz.allQuestions.shuffled()[0..<(questionCount > Quiz.allQuestions.count ? Quiz.allQuestions.count : questionCount)])
    }

    func answerCurrentQuestion(_ answer: Question.Answer) throws -> QuestionAnswerState{
        guard let question = currentQuestion else{
            throw QuizError.quizComplete
        }

        defer{
            if let currentIndex = currentQuestionIndex, currentIndex < questions.count - 1{
                currentQuestionIndex = currentIndex + 1
            }
            else{
                currentQuestionIndex = nil
            }
        }
        
        if answer.isCorrect(for: question){
            correctQuestions.insert(question)
            return .correct
        }
        else{
            incorrectQuestions.insert(question)
            return .incorrect(correctAnswer: question.correctAnswer)
        }
    }
}
