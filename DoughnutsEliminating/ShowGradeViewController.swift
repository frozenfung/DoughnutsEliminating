//
//  ShowGradeViewController.swift
//  DoughnutsEliminating
//
//  Created by frozenfung on 2023/12/20.
//

import UIKit

// Encode
struct RankBody:Encodable {
    let records: [Record]
    
    struct Record: Encodable {
        let fields: Fields
    }
    
    struct Fields: Encodable {
        let name:String
        let matchCount:String
    }
}

extension UIViewController: UITextFieldDelegate {}

class ShowGradeViewController: UIViewController {
    var grade:Int! = 0
    var inputName:String = "NoName"
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
            self.uploadRank()
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
    
    func uploadRank() {
        let databaseUrl = getStringValueFromPlist(forKey: "databaseUrl")
        let apiKey = getStringValueFromPlist(forKey: "airtableApiKey")
        
        let url = URL(string: databaseUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let httpBody = RankBody(records: [
            .init(fields: .init(
                name: inputName,
                matchCount: String(grade)
            ))
        ])
        request.httpBody = try? encoder.encode(httpBody)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data,
               let content = String(data: data, encoding: .utf8) {
            }
        }.resume()
    }
}
