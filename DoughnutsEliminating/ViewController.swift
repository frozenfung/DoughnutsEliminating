//
//  ViewController.swift
//  DoughnutsEliminating
//
//  Created by frozenfung on 2023/12/17.
//

import UIKit
import FoodTruckKit


enum MatchStatus:String {
    case Congratulation, NotThisOne, GetAnother
}

class MultiLayerDoughnut {
    var dough: UIImageView
    var glaze: UIImageView
    var topping: UIImageView
    init(newDough: UIImageView, newGlaze: UIImageView, newTopping: UIImageView) {
        dough = newDough
        glaze = newGlaze
        topping = newTopping
    }
}


var md1:MultiLayerDoughnut?
var md2:MultiLayerDoughnut?

class ViewController: UIViewController {
    var game: Game!
    
    // Dough1
    @IBOutlet weak var doughImageView: UIImageView!
    @IBOutlet weak var glazeImageView: UIImageView!
    @IBOutlet weak var toppingImageView: UIImageView!
    
    // Dough2
    @IBOutlet weak var doughImageView2: UIImageView!
    @IBOutlet weak var glazeImageView2: UIImageView!
    @IBOutlet weak var toppingImageView2: UIImageView!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet var flippers: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        md1 = MultiLayerDoughnut(
            newDough: doughImageView,
            newGlaze: glazeImageView,
            newTopping: toppingImageView
        )
        
        md2 = MultiLayerDoughnut(
            newDough: doughImageView2,
            newGlaze: glazeImageView2,
            newTopping: toppingImageView2
        )
        view.sendSubviewToBack(toppingImageView2)
        view.sendSubviewToBack(glazeImageView2)
        view.sendSubviewToBack(doughImageView2)
        
        game = Game(
            flippers: flippers,
            multiLayerDough1: md1!,
            multiLayerDough2: md2!
        )
    }

    @IBAction func clickFlipper(_ sender: UIButton) {
        let focusButIndex = flippers.firstIndex(of: sender)
        let matchStatus:MatchStatus = game.appendSelectedDough(index: focusButIndex!)
        status.text = matchStatus.rawValue
        if game.phase == .Ended {
            performSegue(withIdentifier: "showGrade", sender: nil)
        }
    }

    @IBSegueAction func showGradeView(_ coder: NSCoder, sender: Any?) -> ShowGradeViewController? {
        let controller = ShowGradeViewController(coder: coder)
        controller?.grade = game.matchCount
        return controller
    }
}

