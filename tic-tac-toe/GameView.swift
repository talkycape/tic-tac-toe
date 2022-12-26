//
//  GameView.swift
//  tic-tac-toe
//
//  Created by Ya-Chieh Lai on 7/10/21.
//  With thanks to Sean Allen for his youtube example
//  https://www.youtube.com/watch?v=MCLiPW2ns2w
//
//  Incorporating UI elements from the SwiftUI Cookbook by Scalzo and Nzokwe
//

import SwiftUI


struct GameView: View {

    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack {
            Spacer()
            Text("Tic Tac Toe")
                .font(.title)
            Spacer()
            ZStack {
                GridShape()
                    .stroke(.indigo, lineWidth: 15)
                VStack {
                    ForEach(0..<3) { column in
                        HStack {
                            ForEach(0..<3) { row in
                                let i = 3*column + row
                                ZStack{
                                    GameSquareView()
                                    PlayerIndicator(symbol: viewModel.moves[i]?.indicator ?? "")
                                }
                                .padding(20)
                                .onTapGesture {
                                    viewModel.processPlayerMove(for: i)
                                }
                            }
                        }
                    }
                }
            }
            .padding(20)
            .disabled(viewModel.isGameBoardDisabled)
            .alert(item: $viewModel.alertItem, content: {alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            })
        }
        .aspectRatio(contentMode: .fit)
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


struct Nought: View {
    var body: some View {
        Circle()
            .stroke(.red, lineWidth: 10)
    }
}

struct CrossShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path() { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}

struct Cross: View {
    var body: some View {
        CrossShape()
            .stroke(.green, style:  StrokeStyle(lineWidth: 10,
                                                lineCap: .round,
                                                lineJoin: .round))
    }
}

struct GridShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path() { path in
            path.move(to: CGPoint(x: rect.width/3, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.width/3, y: rect.maxY))
            path.move(to: CGPoint(x: 2*rect.width/3, y: rect.minY))
            path.addLine(to: CGPoint(x: 2*rect.width/3, y: rect.maxY))
            path.move(to: CGPoint(x: rect.minX, y: rect.height/3))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.height/3))
            path.move(to: CGPoint(x: rect.minX, y: 2*rect.height/3))
            path.addLine(to: CGPoint(x: rect.maxX, y: 2*rect.height/3))

        }
    }
}


struct GameSquareView: View {
    var body: some View {
        Rectangle()
            .fill(.clear)
            .contentShape(Rectangle()) // allows the clear area to be tap-able
    }
}

struct PlayerIndicator: View {
    var symbol: String
    var body: some View {
        if (symbol == "X") {
            Cross()
        } else if (symbol == "O") {
            Nought()
        } else {
            Color.clear
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
