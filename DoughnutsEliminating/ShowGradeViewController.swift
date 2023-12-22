//
//  ShowGradeViewController.swift
//  DoughnutsEliminating
//
//  Created by frozenfung on 2023/12/20.
//

import UIKit

class ShowGradeViewController: UIViewController {
    var grade:Int! = 0

    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var tryAgain: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let grade = grade {
            gradeLabel.text = String(grade)
        }
    }
    
    @IBAction func dismissShowGrade(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
