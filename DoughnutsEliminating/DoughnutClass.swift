//
//  DoughnutClass.swift
//  DoughnutsEliminating
//
//  Created by frozenfung on 2023/12/18.
//
import UIKit
import Foundation

class Doughnut {
    var Id: String
    var Button: UIButton
    var ButtonPosition: Int
    var DoughImg: UIImage
    var GlazeImg: UIImage
    var ToppingImg: UIImage
    
    init(newMeta: DoughnutMeta, newButton: UIButton, newButtonPosition: Int) {
        Id = newMeta.uuid
        DoughImg = newMeta.dough!
        GlazeImg = newMeta.glaze!
        ToppingImg = newMeta.topping!
        Button = newButton
        ButtonPosition = newButtonPosition
    }
    
    func updateButtonAlpha(newAlpha: Float) {
        Button.alpha = CGFloat(newAlpha)
    }
    
    func getButtonAlpha() -> Float {
        Float(Button.alpha)
    }
    
    func markAsEliminated() {
        Button.isHidden = true
    }
    
    func toggleClickable(clickable: Bool) {
        Button.isUserInteractionEnabled = clickable
    }
    
    func initButton() {
        Button.isHidden = false
        Button.isUserInteractionEnabled = true
        Button.alpha = 0.95
    }
}
