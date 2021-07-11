//
//  ContentView.swift
//  tic-tac-toe
//
//  Created by Ya-Chieh Lai on 7/10/21.
//  With thanks to Sean Allen for his youtube example
//  https://www.youtube.com/watch?v=MCLiPW2ns2w
//

import SwiftUI


struct ContentView: View {

    // empty game board is 9 nils
    // a nil means it is empty (as versus '0' or 'false' which are specifc values)
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    
    // this variable only used here for testing/demonstration purposes
    @State private var isHumansTurn = true
            
    // here is the main body
    var body: some View {
        VStack {
            Spacer()
            Text("Tic Tac Toe")
            VStack {
                ForEach(0..<3) { column in
                    HStack {
                        Spacer()
                        ForEach(0..<3) { row in
                            let i = 3*column + row
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.blue).opacity(0.5)
                                    // aspect ratio of 1.0 ensures each rectangle is square
                                    .aspectRatio(1.0, contentMode: .fit)
                                Text(moves[i]?.indicator ?? " ")
                                    // create giant font size and then let it scale itself down
                                    .font(.system(size: 500))
                                    .minimumScaleFactor(0.01)
                            }
                            .onTapGesture {
                                moves[i] = Move(player: isHumansTurn ? .human : .computer, boardIndex: i)
                                isHumansTurn.toggle()
                            }
                        }
                        Spacer()
                    }
                }
            }
            // aspect ratio of 1.0 enures our 3x3 is square
            .aspectRatio(1.0, contentMode: .fit)
            Spacer()
        }
        .padding()
    }
}
 
enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "X" : "O"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
