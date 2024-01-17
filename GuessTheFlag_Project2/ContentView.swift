//
//  ContentView.swift
//  GuessTheFlag_Project2
//
//  Created by Peter Szots on 15/04/2022.
//

import SwiftUI

//this is a custom view made for the Image view modifiers use for the flag pics
struct FlagImage: View {
    var string: String
    
    var body: some View {
        Image(string)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

//this is a custom ViewModifier with its accompanying extension to define a custom sytile for the main title
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var showingGameRules = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var gameCounter = 0
    @State private var animationAmount = 0.0
    @State private var selected = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let gameRulesText = Text("This game is a guessing game that helps users learn some of the many flags of the world. \n\n Blabla bladi blaaaa. Many people find SwiftUI’s way of showing alerts a little odd at first: creating it, adding a condition, then simply triggering that condition at some point in the future seems like a lot more work than just asking the alert to show itself. But like I said, it’s important that our views always be a reflection of our program state, and that rules out us just showing alerts whenever we want to.")
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .titleStyle()
                
                Button {
                    showingGameRules.toggle()
                }label: {
                    Text("Game Rules")
                }
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3, id: \.self) { number in
                        Button {
                            self.selected = number
                            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                                animationAmount += 360
                            }
                            flagTapped(number)
                            gameCounter += 1
                        } label : {
                            FlagImage(string: countries[number])
                        }
                        .opacity( (selected != number) ? 0.4 : 1.0 )
                        .blur( radius: (selected != number) ? 3 : 0 )
                        .rotation3DEffect(.degrees( (selected == number) ? animationAmount : 0.0 ), axis: (x: 0, y:1, z:0))
                    }
                    
                   
                    
                
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title2.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if gameCounter <= 2 {
                Button("Continue", action: askQuestion)
            } else {
                HStack {
                    Button("Continue", action: askQuestion)
                    Button("Reset", action: resetGame)
                }
            }
        } message: {
            Text("Your score is: \(userScore)")
        }
        
        .alert("End of the game.", isPresented: $showingFinalScore) {
            Button("Restart", action: resetGame)
        } message: {
            Text("Your final score is: \(userScore)")
        }
        
        .alert("Game Rules", isPresented: $showingGameRules) {
            Button("Let's Go!", role: .cancel) { }
        } message: {
            gameRulesText
        }
    }
    
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            scoreTitle = "Correct answer!"
            userScore += 1
            
        } else {
            scoreTitle = "Wrong answer! That is the flag of \(countries[number])."
        }
        
        showingScore = true
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        if gameCounter == 10 {
            showingFinalScore = true
        }
    }
    
    func resetGame() {
        userScore = 0
        gameCounter = 0
        askQuestion()
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
