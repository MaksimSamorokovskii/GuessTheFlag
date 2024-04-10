//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Максим Самороковский on 06.02.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var questionCount = 0
    @State private var showAlert = false
    
    var labels = [
        "Estonia": "Flag with theree horizontal stripes. Top stripe blue, middle stripe black, buttom stripe white.",
        "France": "Flag with theree vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with theree horizontal stripes. Top stripe black, middle stripe red, buttom stripe gold.",
        "Ireland": "Flag with theree vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with theree vertiocal stripes. Left stripe green, middle stripe white, right stripe red.",
        "Monaco": "Flag with two horizontal stripes. Top stripe red, bottom stripe white",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with two horizontal stripes. Top thin stripe red, middle thick stripe is gold with crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                FlagButtons(countries: countries, correctAnswer: correctAnswer) { number in
                    flagTapped(number)
                }
                
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .frame(width: 240, height: 40)
                    .background(LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom))
                    .clipShape(Capsule())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: {
                if questionCount < 8 {
                    askQuestion()
                } else {
                    showAlert = true
                }
            })
        } message: {
            if !scoreTitle.isEmpty {
                Text(scoreTitle == "Correct" ? "Your score is \(userScore)" : "Wrong! This is flag of \(countries[correctAnswer])")
            }
        }
        .alert("Game Over", isPresented: $showAlert) {
            Button("Restart", action: reset)
        } message: {
            Text("You have completed 8 questions. Your final score is \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        questionCount += 1
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        showingScore = false
        scoreTitle = ""
        userScore = 0
        questionCount = 0
        showAlert = false
    }
}

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct FlagButtons: View {
    let countries: [String]
    let correctAnswer: Int
    let action: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            VStack {
                Text("Tap the flag of")
                    .font(.subheadline.weight(.heavy))
                    .foregroundColor(.secondary)
                Text(countries[correctAnswer])
                    .font(.largeTitle.weight(.semibold))
            }
            ForEach(0..<3) { number in
                Button {
                    action(number)
                } label: {
                    FlagImage(imageName: countries[number])
                }
//                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
            }
        }
        .frame(width: 240, height: 430)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
