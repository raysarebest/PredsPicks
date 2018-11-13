# Quiz App Refactoring
## *Treehouse iOS Techdegree Project 2*

You are being given a simple true/false quiz app. The app functions correctly, though much of the code could benefit from major refactoring. For instance, the app currently is based on collection types, which should be converted into custom classes or structs. Similarly, the app does not adhere to the Model-View-Controller design pattern as well as it could.

Additionally, you will need to add several of the features described below, some being mandatory, others optional. For a few of the features, you are being asked to step beyond what you have learned in this course and make use of documentation and outside resources. That said, provided you find the correct resources, you should be able to work through the implementation. Remember, just as important as practicing the specifics of the syntax you’ve learned is getting comfortable with the idea of venturing into the unknown to find and use the right tools for the job.

It is worth noting that while we have provided a final question set and UI screenshots, we encourage you to choose a subject area that interests you (movies, sports, history, technology, etc…) and create your own question set and background imagery/UI to match. This is not a requirement for the project, but will almost certainly make it a more enjoyable experience and better portfolio piece.

#### Required tasks

- [x] The starter files contain a Storyboard scene that is simulated to a 4.7 inch iPhone without any constraints to position elements. If you run the app in the simulator for a 5.5 inch iPhone, the layout looks fine but it breaks on any other device size. Convert the Storyboard back to a universal scene and add constraints to maintain the layout such all UI elements are sized and spaced appropriately for all iPhones of screen sizes 4.7 and 5.5. inches.
- [x] Refactor the existing code such that individual questions are modeled using a class or struct
- [x] Ensure that code adheres to the MVC pattern. Please place your new custom data structure for questions in a new Swift file.
- [x] Enhance the quiz so it can accommodate four answer choices for each question, as shown in the mockups and sample question set.
- [x] Add functionality such that during each game, questions are chosen at random, though no question will be repeated within a single game.
- [ ] Before you submit your project for review, make sure you can check off all of the items on the [Student Project Submission Checklist](http://treehouse-techdegree.s3.amazonaws.com/Student-Project-Submission-Checklist.pdf). The checklist is designed to help you make sure you’ve met the grading requirements and that your project is complete and ready to be submitted!

#### Extra credit

- [ ] Implement a feature so that the app can neatly display a mix of 3-option questions as well as 4-option questions. Inactive buttons should be spaced or resized appropriately, not simply hidden, disabled, or marked as unused (e.g. with the string ‘N/A’). You need to implement this feature using only one view controller.
- [x] Implement a way to appropriately display the correct answer, when a player answers incorrectly.
- [ ] Modify the app to be in "lightning" mode where users only have 15 seconds to select an answer for each question set. Display the number of correct answers at the end of the quiz.
- [ ] Add two sound effects, one for correct answers and one for incorrect. You may also add sounds at the end of the game, or wherever else you see fit. (Hint: you can base your solution on code already found in the starter app.)
