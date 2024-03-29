//
//  LeaderBoardTableViewController.swift
//  DoughnutsEliminating
//
//  Created by frozenfung on 2023/12/23.
//

import UIKit

// Decode
//struct LeaderBoardRecords:Decodable {
//    var records:[Records]
//}
//
//struct Records:Decodable {
//    var id:String
//    var createdTime:String
//    var fields:Player
//}
//
//struct Player:Decodable {
//    var name:String
//    var matchCount:String
//}

struct LeaderBoardRecords:Decodable {
    let records:[Record]
    
    struct Record:Decodable {
        let id:String
        let createdTime:String
        let fields:Fields
    }

    struct Fields:Decodable {
        var name:String
        var matchCount:String
    }
}

class LeaderBoardTableViewController: UITableViewController {
    var inputName:String!
    var grade:Int!
    var players:[LeaderBoardRecords.Fields] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchLeaderBoardData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderBoardCell", for: indexPath)
        let player = players[indexPath.row]
        cell.textLabel?.text = player.name
        cell.detailTextLabel?.text = "\(String(player.matchCount)) times"
        return cell
    }
    
    func fetchLeaderBoardData() {
        let databaseUrl = getStringValueFromPlist(forKey: "databaseUrl")
        let apiKey = getStringValueFromPlist(forKey: "airtableApiKey")
        
        let url = URL(string: databaseUrl)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                let decoder = JSONDecoder()
                do {
                    let lbs = try decoder.decode(LeaderBoardRecords.self, from: data)
                    for rec in lbs.records {
                        self.players.append(rec.fields)
                    }
                    self.players = self.players.sorted(by: { Int($0.matchCount)! < Int($1.matchCount)! })
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            } else if let error {
                print(error)
            }
        }.resume()
    }

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
