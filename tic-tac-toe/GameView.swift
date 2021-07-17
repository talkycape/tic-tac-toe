//
//  GameView.swift
//  tic-tac-toe
//
//  Created by Ya-Chieh Lai on 7/10/21.
//  With thanks to Sean Allen for his youtube example
//  https://www.youtube.com/watch?v=MCLiPW2ns2w
//

import SwiftUI


struct GameView: View {

    @StateObject private var viewModel = GameViewModel()

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
                                GameSquareView()
                                PlayerIndicator(symbol: viewModel.moves[i]?.indicator ?? "")
                            }
                            // aspect ratio of 1.0 ensures each rectangle is square
                            .aspectRatio(1.0, contentMode: .fit)
                            .onTapGesture {
                                viewModel.processPlayerMove(for: i)
                            }
                        }
                        Spacer()
                    }
                }
            }
            // aspect ratio of 1.0 enures our 3x3 is square
            .aspectRatio(1.0, contentMode: .fit)
            .disabled(viewModel.isGameBoardDisabled)
            .alert(item: $viewModel.alertItem, content: {alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            })
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

struct GameSquareView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.blue).opacity(0.5)
    }
}

struct PlayerIndicator: View {
    var symbol: String
    var body: some View {
        Text(symbol)
            // create giant font size and then let it scale itself down
            .font(.system(size: 500))
            .minimumScaleFactor(0.01)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
