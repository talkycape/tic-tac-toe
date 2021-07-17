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
    
    @State private var isGameBoardDisabled = false
    @State private var alertItem: AlertItem?
    
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
                                if isSquareOccupied(in: moves, forIndex: i) { return }
                                moves[i] = Move(player: .human, boardIndex: i)
                                
                                //                            moves[i] = Move(player: isHumansTurn ? .human : .computer, boardIndex: i)
                                //                            isHumansTurn.toggle()
                                
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
                        Spacer()
                    }
                }
            }
            // aspect ratio of 1.0 enures our 3x3 is square
            .aspectRatio(1.0, contentMode: .fit)
            .disabled(isGameBoardDisabled)
            .alert(item: $alertItem, content: {alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle, action: { resetGame() }))
            })
            Spacer()
        }
        .padding()
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }

    // Originally AI is just doing something random (only that last strategy)
    // BUT
    // A better AI Strategy:
    // if AI can win, then win
    // if AI can't win, then block
    // if AI cant' block, then take middle square
    // if AI can't take middle square, then take random available square
    func determineComputerMovePosition(in moves: [Move?]) -> Int {

        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8],
                                          [0,3,6], [1,4,7], [2,5,8],
                                          [0,4,8], [2,4,6]]

        // if AI can win, then win
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPostions = Set(computerMoves.map { $0.boardIndex })

        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPostions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // if AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })

        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }

        // if AI cant' block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        // if AI can't take middle square, then take random available square
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
