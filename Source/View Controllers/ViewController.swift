//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LightningQuizDelegate{

    // MARK: - Properties
    
    var trivia = Quiz()

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }

    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answersView: UIStackView!
    @IBOutlet weak var playAgainView: UIStackView!
    @IBOutlet weak var countdownView: CountdownView!

    // MARK: - Game Management
    
    func displayQuestion() -> Void{
        guard let question = trivia.currentQuestion else{
            displayScore()
            return
        }

        countdownView.resetCount()
        countdownView.tintColor = .white
        answersView.removeAllArrangedSubviews()

        for answer in question.possibleAnswers{
            let button = AnswerButton(answer: answer)
            button.addTarget(self, action: #selector(checkAnswer(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(prepareForAnswer), for: .touchDown)
            answersView.addArrangedSubview(button)
        }

        questionField.text = question.text
        playAgainView.isHidden = true

        if let quiz  = trivia as? LightningQuiz{ // If we're in lightning mode, we need to start the timer once the question is displayed
            quiz.startQuestionTimer()
        }
    }

    @objc private func prepareForAnswer() -> Void{
        GameSound.correctAnswer.prepare()
        GameSound.incorrectAnswer.prepare()
    }
    
    @objc func checkAnswer(_ sender: AnswerButton) -> Void{
        if let lightningQuiz = trivia as? LightningQuiz{
            lightningQuiz.stopQuestionTimer()
        }
        do{
            guard let currentQuestion = trivia.currentQuestion else{
                displayScore()
                return
            }
            let result = try trivia.answerCurrentQuestion(sender.answer)
            displayAnswerRevealView(question: currentQuestion, userAnswerState: result)
            if let sound = result.sound, sound.duration != Double.signalingNaN{
                sound.play()
                loadNextRoundWithDelay(seconds: Int(Double.maximum(sound.duration.rounded(), 3)))
            }
            else{
                loadNextRoundWithDelay()
            }
        }
        catch{
            // The only error that can be thrown is if the quiz is over
            displayScore()
        }
    }

    func displayAnswerRevealView(question: Question, userAnswerState: Quiz.QuestionAnswerState) -> Void{
        if let buttons = answersView.arrangedSubviews as? [AnswerButton]{
            for button in buttons{
                button.displayForAnswerCorectness(button.answer.isCorrect(for: question))
            }
        }
        switch userAnswerState{
        case .correct:
            questionField.text = "Correct!"
        case .incorrect:
            questionField.text = "Sorry, wrong answer!"
        case .unanswered:
            questionField.text = "Oops, out of time!"
        }
    }
    
    func nextRound() -> Void{
        if trivia.isComplete{
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }

    func displayScore() -> Void{
        // Hide the answer buttons and countdown
        answersView.removeAllArrangedSubviews()
        countdownView.isHidden = true

        // Display play again buttons
        playAgainView.isHidden = false

        GameSound.gameEnd.play()

        questionField.text = "Way to go!\nYou got \(trivia.correctQuestions.count) out of \(trivia.questions.count) correct!"
    }
    
    @IBAction func playAgain(_ sender: LightningModeSelectionButton) -> Void{
        newGame(lightning: sender.lightningMode)
    }

    func newGame(lightning: Bool) -> Void{
        trivia = lightning ? LightningQuiz(delegate: self) : Quiz()
        countdownView.isHidden = !lightning
        GameSound.gameStart.play()
        nextRound()
    }
    
    // MARK: - Helper Methods
    
    func loadNextRoundWithDelay(seconds: DispatchTimeInterval) -> Void{
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.nextRound()
        }
    }

    func loadNextRoundWithDelay(seconds: Int = 3) -> Void{
        loadNextRoundWithDelay(seconds: .seconds(seconds))
    }

    // MARK: - LightningQuizDelegate Conformance

    func timerDidTick(for question: Question, remainingSeconds: TimeInterval, quiz: LightningQuiz) -> Void{
        GameSound.clockTicked.play()
        countdownView.tick()
        if remainingSeconds <= 3{
            countdownView.tintColor = .red
        }
        if remainingSeconds == 1{
            GameSound.questionExpired.prepare()
        }
    }

    func timerDidExpire(for question: Question, quiz: LightningQuiz) -> Void{
        displayAnswerRevealView(question: question, userAnswerState: .unanswered(correctAnswer: question.correctAnswer))
        GameSound.questionExpired.play()
        loadNextRoundWithDelay(seconds: 4)
    }
}

// MARK: - Helper Extensions

extension UIStackView{
    func removeAllArrangedSubviews() -> Void{
        for view in arrangedSubviews{
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}


extension Quiz.QuestionAnswerState{
    var sound: GameSound?{
        get{
            switch self {
                case .correct:
                    return .correctAnswer
                case .incorrect:
                    return .incorrectAnswer
                case .unanswered:
                    return .questionExpired
            }
        }
    }
}
