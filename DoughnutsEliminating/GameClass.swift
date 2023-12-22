//
//  GameClass.swift
//  DoughnutsEliminating
//
//  Created by frozenfung on 2023/12/18.
//

import UIKit
import Foundation
import FoodTruckKit

var doughnuts:[Doughnut] = []
let maxSelectedDough = 2
var selectedDoughs:[Doughnut] = []

var doughImg1:MultiLayerDoughnut?
var doughImg2:MultiLayerDoughnut?

struct DoughnutMeta {
    var uuid: String
    var dough: UIImage?
    var glaze: UIImage?
    var topping: UIImage?
}

enum Phase:String {
    case Ongoing, Ended
}

class Game {
    var matchCount: Int = 0
    var flippers:[UIButton] = []
    var eliminatedDoughnut: Int = 0 {
        willSet {
            if newValue == doughnutCount {
                self.phase = .Ended
            }
        }
    }
    var phase:Phase = .Ongoing {
        willSet {
            if newValue == .Ended {
                self.restartGame(flippers: self.flippers)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.phase = .Ongoing
                    self.matchCount = 0
                    self.eliminatedDoughnut = 0
                    self.flushSelectedDoughs()
                }
            }
        }
    }

    let doughnutCount = 16

    init(flippers: [UIButton], multiLayerDough1: MultiLayerDoughnut, multiLayerDough2: MultiLayerDoughnut) {
        self.flippers = flippers
        doughImg1 = multiLayerDough1
        doughImg2 = multiLayerDough2
        // setup doughnuts' UUID and image
        var metas:[DoughnutMeta] = []
        for i in 1...doughnutCount {
            if i % 2 == 0 {
                metas.append(metas.last!)
            } else {
                metas.append(DoughnutMeta(
                    uuid: UUID().uuidString,
                    dough: Donut.Dough.all.randomElement()!.uiImage(thumbnail: false),
                    glaze: Donut.Glaze.all.randomElement()!.uiImage(thumbnail: false),
                    topping: Donut.Topping.all.randomElement()!.uiImage(thumbnail: false)
                ))
            }
        }
        
        metas.shuffle()
        
        // given doughnut same view by UUID
        for i in 1...doughnutCount {
            doughnuts.append(Doughnut(
                newMeta: metas[i-1],
                newButton: flippers[i-1],
                newButtonPosition: i-1
            ))
        }
    }
    
    func findDoughnutByButtonPosition(index: Int) -> Doughnut {
        for i in 1...doughnutCount {
            if (index == doughnuts[i-1].ButtonPosition) {
                return doughnuts[i-1]
            }
        }
        fatalError("Not found Button with given Index")
    }
    
    func appendSelectedDough(index: Int) -> MatchStatus {
        for i in 1...doughnutCount {
            if (index == doughnuts[i-1].ButtonPosition) {
                selectedDoughs.append(doughnuts[i-1])
                self.updateDoughImg(dIndex: (i-1))
            }
        }
        self.updateSelectedDoughsAlpha(newAlpha: 0)

        if selectedDoughs.count < maxSelectedDough {
            return MatchStatus.GetAnother
        } else {
            self.lockFlippers()
            // Match
            let result:MatchStatus = self.compareId()

            if result == .Congratulation {
                self.matchSuccess()
                return MatchStatus.Congratulation
            } else {
                self.matchFail()
                return MatchStatus.NotThisOne
            }
        }
    }
    
    func lockFlippers() {
        for d in doughnuts {
            d.toggleClickable(clickable: false)
        }
    }
    
    func compareId() -> MatchStatus {
        self.matchCount += 1
        if selectedDoughs.first!.Id == selectedDoughs.last!.Id {
            return MatchStatus.Congratulation
        }

        return MatchStatus.NotThisOne
    }
    
    func flushSelectedDoughs() {
        self.updateSelectedDoughsAlpha(newAlpha: 0.95)
        selectedDoughs.removeAll()
    }
    
    func updateSelectedDoughsAlpha(newAlpha: Float) {
        let selectDoughtsCount = selectedDoughs.count
        if selectDoughtsCount > 0 {
            for i in 1...selectedDoughs.count {
                selectedDoughs[i-1].updateButtonAlpha(newAlpha: newAlpha)
                selectedDoughs[i-1].toggleClickable(clickable: false)
            }
        }
    }
    
    func matchFail() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.flushSelectedDoughs()
            // unlock screen
            for d in doughnuts {
                d.toggleClickable(clickable: true)
            }
        }
    }
    
    func matchSuccess() {
        self.eliminatedDoughnut += 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for sd in selectedDoughs {
                sd.markAsEliminated()
                doughImg1?.dough.image = nil
                doughImg1?.glaze.image = nil
                doughImg1?.topping.image = nil
                doughImg2?.dough.image = nil
                doughImg2?.glaze.image = nil
                doughImg2?.topping.image = nil
            }
            self.flushSelectedDoughs()
            // unlock screen
            for d in doughnuts {
                d.toggleClickable(clickable: true)
            }
        }
    }
    
    func restartGame(flippers: [UIButton]) {
        // clear game data
        doughnuts.removeAll()
        // re-init game
        var metas:[DoughnutMeta] = []
        for i in 1...doughnutCount {
            if i % 2 == 0 {
                metas.append(metas.last!)
            } else {
                metas.append(DoughnutMeta(
                    uuid: UUID().uuidString,
                    dough: Donut.Dough.all.randomElement()!.uiImage(thumbnail: false),
                    glaze: Donut.Glaze.all.randomElement()!.uiImage(thumbnail: false),
                    topping: Donut.Topping.all.randomElement()!.uiImage(thumbnail: false)
                ))
            }
        }
        
        metas.shuffle()
        
        // given doughnut same view by UUID
        for i in 1...doughnutCount {
            let d = Doughnut(
                newMeta: metas[i-1],
                newButton: flippers[i-1],
                newButtonPosition: i-1
            )
            d.initButton()
            doughnuts.append(d)
        }
    }
    
    func updateDoughImg(dIndex: Int) {
        let x:CGFloat = doughnuts[dIndex].Button.frame.origin.x
        let y:CGFloat = doughnuts[dIndex].Button.frame.origin.y
        
        if selectedDoughs.count == 1 {
            doughImg1?.dough.frame.origin.x = x
            doughImg1?.glaze.frame.origin.x = x
            doughImg1?.topping.frame.origin.x = x
            doughImg1?.dough.frame.origin.y = y
            doughImg1?.glaze.frame.origin.y = y
            doughImg1?.topping.frame.origin.y = y

            doughImg1?.dough.image = doughnuts[dIndex].DoughImg
            doughImg1?.glaze.image = doughnuts[dIndex].GlazeImg
            doughImg1?.topping.image = doughnuts[dIndex].ToppingImg
        } else {
            doughImg2?.dough.frame.origin.x = x
            doughImg2?.glaze.frame.origin.x = x
            doughImg2?.topping.frame.origin.x = x
            doughImg2?.dough.frame.origin.y = y
            doughImg2?.glaze.frame.origin.y = y
            doughImg2?.topping.frame.origin.y = y
            
            doughImg2?.dough.image = doughnuts[dIndex].DoughImg
            doughImg2?.glaze.image = doughnuts[dIndex].GlazeImg
            doughImg2?.topping.image = doughnuts[dIndex].ToppingImg
        }
    }
}

