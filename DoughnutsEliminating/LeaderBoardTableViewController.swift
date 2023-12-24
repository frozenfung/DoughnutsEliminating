//
//  LeaderBoardTableViewController.swift
//  DoughnutsEliminating
//
//  Created by frozenfung on 2023/12/23.
//

import UIKit

struct Rank {
    var name: String
    var matchCount: Int
}

class LeaderBoardTableViewController: UITableViewController {
    var inputName:String!
    var grade:Int!

    @IBOutlet var labels: [UILabel]!
    var rankPlaceholder = [
        Rank(name: "Bin Weng", matchCount: 9),
        Rank(name: "Stephen Chidwick", matchCount: 11),
        Rank(name: "Christopher Brewer", matchCount: 13),
        Rank(name: "Tony Ren Lin", matchCount: 15),
        Rank(name: "Jesse Lonis", matchCount: 16),
        Rank(name: "Jason Koon", matchCount: 17),
        Rank(name: "Daniel Chi Tang", matchCount: 19),
        Rank(name: "Adam Hendrix", matchCount: 22),
        Rank(name: "Justin Saliba", matchCount: 25)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        rankPlaceholder.append(Rank(name: inputName, matchCount: grade))
        let sortedRank = rankPlaceholder.sorted(by: { $0.matchCount < $1.matchCount })
        
        for (i, label) in labels.enumerated() {
            label.text = "\(sortedRank[i].name)   \(sortedRank[i].matchCount) times"
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
