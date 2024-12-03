//
//  ContentView.swift
//  FreshTables
//
//  Created by Theo Luciano on 11/8/24.
//

import SwiftUI

struct ButtonLabel: Identifiable {
    let id = UUID()
    let value: Int
}

struct ContentView: View {
    @State private var chosenTableValue = 2
    @State private var numberOfQuestions = [5, 10, 20]
    @State private var selectedNumberOfQuestions = 10
    @State private var currentScore = 0
    @State private var currentQuestion = 1
    @State private var buttonLabels = [ButtonLabel]()
    @State private var correctAnswer = Int.random(in: 1...12)
    
    private let multiples = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    private var computedAnswer: Int {
        correctAnswer * chosenTableValue
    }
    
    @State private var isShowingAlert = false
   

    
//    @State private var isShowingSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Select the number of questions")
                    
                    Picker("Number of Questions", selection: $selectedNumberOfQuestions) {
                        ForEach(numberOfQuestions, id: \.self) { num in
                            Text("\(num)")
                        }
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(.green)
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(.green.opacity(0.2))
                .cornerRadius(8)
                .foregroundStyle(.primary)
                .font(.subheadline)
                
          
                
                HStack {
                    Text("Number to practice with")
                    Spacer()
                    Picker("Number to practice with", selection: $chosenTableValue) {
                        ForEach(2...12, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.menu)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .colorMultiply(.green)
                }
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 20)
                .background(.green.opacity(0.2))
                .cornerRadius(8)
                .foregroundStyle(.primary)
                .font(.subheadline)
            }
            Spacer()
            Spacer()
            Text("\(chosenTableValue) x __ = \(computedAnswer)")
                .font(.system(size: 64))
                .fontDesign(.rounded)
            Spacer()
            HStack {
                ForEach(buttonLabels) { button in
                    Button {
                        checkAnswer(button.value)
                    } label: {
                        Text("\(button.value)")
                            .padding()
                            .font(.title)
                            .fontDesign(.rounded)
                    }
                    .buttonStyle(.bordered)
                    .colorMultiply(.green)
                }
            }
            Spacer()
            Spacer()
            Text("Question \(currentQuestion) of \(selectedNumberOfQuestions)")
                .font(.headline)
                .foregroundStyle(.secondary)
                
        }
        .alert("Game over", isPresented: $isShowingAlert) {
            Button("Play again", action: setupGame)
        } message: {
            if currentScore < 5 {
                Text("You need to practice more... you only got \(currentScore) out of \(selectedNumberOfQuestions) correct")
            } else {
                Text("You got \(currentScore) out of \(selectedNumberOfQuestions) correct. Great job!")
            }
        }
        .padding()
        .onAppear {
            setupGame()
        }
    }
    
    func setupGame() {
        currentQuestion = 1
        currentScore = 0
        correctAnswer = Int.random(in: 1...12)
        createButtonLabels()
    }
    
    func newQuestion() {
        currentQuestion += 1
        correctAnswer = Int.random(in: 1...12)
        createButtonLabels()
    }
    
    func checkAnswer(_ answer: Int) {
        if answer == correctAnswer {
            currentScore += 1
        }
        
        if currentQuestion == selectedNumberOfQuestions {
            isShowingAlert.toggle()
            
        } else {
            newQuestion()
        }
    }
    
    func createButtonLabels() {
        var selectedNumbers: Set<Int> = [correctAnswer]
        while selectedNumbers.count < 3 {
            if let randomChoice = multiples.randomElement() {
                selectedNumbers.insert(randomChoice)
            }
        }
        
        buttonLabels = Array(selectedNumbers).map { ButtonLabel(value: $0) }.shuffled()
    }
}

#Preview {
    ContentView()
}
