//
//  ShowGradeViewController.swift
//  DoughnutsEliminating
//
//  Created by frozenfung on 2023/12/20.
//

import UIKit

extension UIViewController: UITextFieldDelegate {}

class ShowGradeViewController: UIViewController {
    var grade:Int! = 0
    var inputName:String = ""
    var alertController:UIAlertController!

    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var regRecord: UIButton!
    @IBOutlet weak var tryAgain: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let grade = grade {
            gradeLabel.text = String(grade)
        }
        
        // create the actual alert controller view that will be the pop-up
        alertController = UIAlertController(title: "Register Grade", message: "type your name", preferredStyle: .alert)

        alertController.addTextField {(textField) in
            textField.delegate = self
            textField.placeholder = "Elon Mask"
        }

        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // this code runs when the user hits the "save" button
            self.inputName = self.alertController.textFields![0].text!
            self.performSegue(withIdentifier: "showLeaderBoard", sender: nil)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

    }
    
    @IBAction func dismissShowGrade(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func regRecord(_ sender: Any) {
        self.present(self.alertController, animated: true, completion: nil)
    }

    @IBSegueAction func showLeaderBoard(_ coder: NSCoder) -> LeaderBoardTableViewController? {
        let controller = LeaderBoardTableViewController(coder: coder)
        controller?.inputName = inputName
        controller?.grade = grade
        return controller
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       var result = true
       if let originalText = textField.text,
          let range = Range(range, in: originalText) {
              let newText = originalText.replacingCharacters(in: range, with: string)
              if newText.contains("香菜") {
                 result = false
              }
       }
       return result
    }
}
