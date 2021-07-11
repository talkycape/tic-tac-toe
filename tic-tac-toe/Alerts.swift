//
//  Alerts.swift
//  tic-tac-toe
//
//  Created by Ya-Chieh on 7/10/21.
//  With thanks to Sean Allen for his youtube example
//  https://www.youtube.com/watch?v=MCLiPW2ns2w
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    message: Text("You just beat the AI!"),
                                    buttonTitle: Text("Woohoo"))
    static let computerWin = AlertItem(title: Text("You Lost"),
                                       message: Text("You programmed a super AI"),
                                       buttonTitle: Text("Oh Nooo"))
    static let draw = AlertItem(title: Text("Draw"),
                                message: Text("What a battle of wits"),
                                buttonTitle: Text("Try Again"))
}
