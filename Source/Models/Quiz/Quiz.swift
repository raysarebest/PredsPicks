//
//  Quiz.swift
//  TrueFalseStarter
//
//  Created by Michael Hulet on 10/11/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

class Quiz{

    // MARK: - Static Helper Properties

    fileprivate static let defaultLength = 4
    private static let allQuestions: [Question] = {
        guard let path = Bundle.main.path(forResource: "Questions", ofType: "plist") else{
            fatalError("Couldn't find questions list")
        }
        do{
            return try PropertyListDecoder().decode([Question].self, from: try Data(contentsOf: URL(fileURLWithPath: path)))
        }
        catch{
            fatalError("Error generating question data: " + error.localizedDescription)
        }
    }()

    // MARK: - Subtype Definitions

    enum QuestionAnswerState{
        case correct
        case incorrect(correctAnswer: Question.Answer)
        case unanswered(correctAnswer: Question.Answer)
    }
    enum QuizError: Error{
        case quizComplete
    }

    // MARK: - Properties

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

    // MARK: - Initializers

    init(questionCount: Int = Quiz.defaultLength){
        // This gets a shuffled version of `allQuestions` and grabs the first n questions, where n is the `questionCount` passed in, or all of them if more than the total possible is requested
        questions = Array(Quiz.allQuestions.shuffled()[0..<(questionCount > Quiz.allQuestions.count ? Quiz.allQuestions.count : questionCount)])
    }

    // MARK: - State Management

    func answerCurrentQuestion(_ answer: Question.Answer?) throws -> QuestionAnswerState{
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
        
        if let givenAnswer = answer, givenAnswer.isCorrect(for: question){
            correctQuestions.insert(question)
            return .correct
        }
        else{
            incorrectQuestions.insert(question)
            return answer == nil ? .unanswered(correctAnswer: question.correctAnswer) : .incorrect(correctAnswer: question.correctAnswer)
        }
    }
}

// MARK: - Lightning Mode

protocol LightningQuizDelegate: class{
    func timerDidTick(for question: Question, remainingSeconds: TimeInterval, quiz: LightningQuiz)
    func timerDidExpire(for question: Question, quiz: LightningQuiz)
}

class LightningQuiz: Quiz{ // I wanted to put this in a different file, but I kept it in this one so the initializer would have access to the fileprivate Quiz.defaultLength

    // MARK: - Properties

    private(set) weak var delegate: LightningQuizDelegate?
    private(set) var questionTimer: QuizTimer? = nil

    // MARK: - Initializers

    init(questionCount: Int = Quiz.defaultLength, delegate: LightningQuizDelegate) {
        self.delegate = delegate
        super.init(questionCount: questionCount)
    }

    // MARK: - Timer Management

    func startQuestionTimer() -> Void{
        guard !isComplete, let question = currentQuestion else{ // No need for a new question/timer if the quiz is already over
            return
        }
        stopQuestionTimer()
        questionTimer = QuizTimer(countdownHandler: { [weak self] (remainingSeconds: TimeInterval) in
            guard let this = self else{ // This should never really happen, but force unwrapping is bad
                return
            }
            this.delegate?.timerDidTick(for: question, remainingSeconds: remainingSeconds, quiz: this)

            if remainingSeconds == 0{
                this.delegate?.timerDidExpire(for: question, quiz: this)
                let _ = try? this.answerCurrentQuestion(nil) // Error handling happens in the delegate and not here
                self?.stopQuestionTimer()
            }
        })
    }

    func stopQuestionTimer() -> Void{
        questionTimer?.stop()
        questionTimer = nil
    }
}
