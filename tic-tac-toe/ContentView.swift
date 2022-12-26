//
//  ContentView.swift
//  tic-tac-toe
//
//  Created by Ya-Chieh Lai on 7/10/21.
//  With thanks to Sean Allen for his youtube example
//  https://www.youtube.com/watch?v=MCLiPW2ns2w
//
//  Incorporating UI elements from the SwiftUI Cookbook by Scalzo and Nzokwe
//

import SwiftUI


struct ContentView: View {
    // empty game board is 9 nils
    // a nil means it is empty (as versus '0' or 'false' which are specifc values)
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    
    @State private var isGameBoardDisabled = false
    @State private var alertItem: AlertItem?
    
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
                                ZStack {
                                    Rectangle()
                                        .fill(.clear)
                                        .contentShape(Rectangle()) // allows the clear area to be tap-able
                                    if (moves[i]?.indicator == "X") {
                                        Cross()
                                    }
                                    else if (moves[i]?.indicator == "O") {
                                        Nought()
                                    }
                                    else {
                                        Color.clear
                                    }
                                }
                                .padding(20)
                                .onTapGesture {
                                    if isSquareOccupied(in: moves, forIndex: i) { return }
                                    moves[i] = Move(player: .human, boardIndex: i)
                                    
                                    // check for win condition or draw
                                    if checkWinCondition(for: .human, in: moves) {
                                        alertItem = AlertContext.humanWin
                                        return
                                    }
                                    if checkForDraw(in: moves) {
                                        alertItem = AlertContext.draw
                                        return
                                    }
                                    
                                    // lock the board once human has moved (computer's turn)
                                    isGameBoardDisabled = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        let computerPosition = determineComputerMovePosition(in: moves)
                                        moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                        
                                        // unlock the board once the computer has moved (humans' turn)
                                        isGameBoardDisabled = false
                                        
                                        // check for win condition or draw
                                        if checkWinCondition(for: .computer, in: moves) {
                                            alertItem = AlertContext.computerWin
                                            return
                                        }
                                        if checkForDraw(in: moves) {
                                            alertItem = AlertContext.draw
                                            return
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(20)
            .disabled(isGameBoardDisabled)
            .alert(item: $alertItem, content: {alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { resetGame() }))
            })
        }
        .aspectRatio(contentMode: .fit)
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        if moves[index] != nil {return true}
        return false
    }
    
    // AI is just doing something random
    // BUT
    // A better AI Strategy:
    // if AI can win, then win
    // if AI can't win, then block
    // if AI cant' block, then take middle square
    // if AI can't take middle square, then take random available square
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
            
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }

    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: [[Int]] = [[0,1,2], [3,4,5], [6,7,8],
                                    [0,3,6], [1,4,7], [2,5,8],
                                    [0,4,8], [2,4,6]]
        
        for pattern in winPatterns {
            // for all winPatterns, check to see if player has chosen all 3 winning slots
            if (moves[pattern[0]]?.player == player) &&
                (moves[pattern[1]]?.player == player) &&
                (moves[pattern[2]]?.player == player) {
                return true
            }
        }
        return false
    }
 
    func checkForDraw(in moves: [Move?]) -> Bool {
        // draw if all possible moves have been taken
        if (moves[0] != nil) &&
            (moves[1] != nil) &&
            (moves[2] != nil) &&
            (moves[3] != nil) &&
            (moves[4] != nil) &&
            (moves[5] != nil) &&
            (moves[6] != nil) &&
            (moves[7] != nil) &&
            (moves[8] != nil) {
            return true
        }
        return false
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
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
