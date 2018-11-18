//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController, LightningQuizDelegate{
    
    var gameSound: SystemSoundID = 0
    
    var trivia = Quiz()

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answersView: UIStackView!
    @IBOutlet weak var playAgainView: UIStackView!
    

    override func viewDidLoad() -> Void{
        super.viewDidLoad()

        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }
    
    func displayQuestion() {
        guard let question = trivia.currentQuestion else{
            displayScore()
            return
        }

        answersView.removeAllArrangedSubviews()

        for answer in question.possibleAnswers{
            let button = AnswerButton(answer: answer)
            button.addTarget(self, action: #selector(checkAnswer(_:)), for: .touchUpInside)
            answersView.addArrangedSubview(button)
        }

        questionField.text = question.text
        playAgainView.isHidden = true

        if let quiz  = trivia as? LightningQuiz{ // If we're in lightning mode, we need to start the timer once the question is displayed
            quiz.startQuestionTimer()
        }
    }
    
    func displayScore() {
        // Hide the answer buttons
        answersView.removeAllArrangedSubviews()
        
        // Display play again buttons
        playAgainView.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(trivia.correctQuestions.count) out of \(trivia.questions.count) correct!"
        
    }
    
    @objc func checkAnswer(_ sender: AnswerButton) -> Void{
        do{
            guard let currentQuestion = trivia.currentQuestion else{
                displayScore()
                return
            }
            let result = try trivia.answerCurrentQuestion(sender.answer)
            displayAnswerRevealView(question: currentQuestion, userAnswerState: result)
        }
        catch{
            // The only error that can be thrown is if the quiz is over
            displayScore()
        }
    }
    
    func nextRound() {
        if trivia.isComplete{
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain(_ sender: LightningModeSelectionButton) -> Void{
        print(sender.lightningMode)
        trivia = sender.lightningMode ? LightningQuiz(delegate: self) : Quiz()
        nextRound()
    }

    func newGame(lightning: Bool) -> Void{
        trivia = lightning ? LightningQuiz(delegate: self) : Quiz()
        nextRound()
    }
    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: DispatchTimeInterval) -> Void{
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.nextRound()
        }
    }

    func loadNextRoundWithDelay(seconds: Int = 2) -> Void{
        loadNextRoundWithDelay(seconds: .seconds(seconds))
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
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
        loadNextRoundWithDelay()
    }
    // MARK: - LightningQuizDelegate Conformance

    func timerDidTick(for question: Question, remainingSeconds: TimeInterval, quiz: LightningQuiz) -> Void{

    }

    func timerDidExpire(for question: Question, quiz: LightningQuiz) -> Void{
        displayAnswerRevealView(question: question, userAnswerState: .unanswered(correctAnswer: question.correctAnswer))
        loadNextRoundWithDelay()
    }
}

extension UIStackView{
    func removeAllArrangedSubviews() -> Void{
        for view in arrangedSubviews{
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
