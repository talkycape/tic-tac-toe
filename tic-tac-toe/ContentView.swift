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
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.blue).opacity(0.5)
                                    .aspectRatio(1.0, contentMode: .fit)
                                Image(systemName: moves[gridPosition(column: column, row: row)]?.indicator ?? "")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                moves[gridPosition(column: column, row: row)] =
                                    Move(player: isHumansTurn ? .human : .computer, boardIndex: gridPosition(column: column, row: row))
                                isHumansTurn.toggle()
                            }
                        }
                        Spacer()
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
    // there must be a cleaner way to do this part
    func gridPosition(column y: Int, row x: Int) -> Int {
        return 3*y + x
    }
}
 

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
