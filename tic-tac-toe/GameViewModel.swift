//
//  GameViewModel.swift
//  tic-tac-toe
//
//  Created by Ya-Chieh Lai on 7/10/21.
//

import SwiftUI

// final means it can't be sub-classed
// like the State variable, anytime things change, it will publish an update
final class GameViewModel: ObservableObject {

    // empty game board is 9 nils
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        
        // human move processing
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
                
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

        // computer move processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
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
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        if moves[index] != nil {return true}
        return false
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
