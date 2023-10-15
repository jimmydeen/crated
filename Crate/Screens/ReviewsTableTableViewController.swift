//
//  ReviewsTableTableViewController.swift
//  Crate
//
//  Created by JD Chiang on 18/5/2023.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase

class ReviewTableCell: UITableViewCell {
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var user: UILabel!
    
    @IBOutlet weak var reviewDescription: UILabel!
}

class ReviewsTableTableViewController: UITableViewController {
    
    
    
    let SEGUE_REVIEW = "reviewSegue"
    let CELL_REVIEW = "reviewCell"
    
    var reviews = [Review]()
    var reviewsRef: CollectionReference?
    var databaseListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = Firestore.firestore()
        reviewsRef = database.collection("reviews")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_REVIEW, for: indexPath) as! ReviewTableCell
        
        let review = reviews[indexPath.row]
        
        cell.rating.text = String(describing: review.ratingValue)
        ///ACCESS DATABASE TO GET USER NAME FOR USER ID
        ///
        ///
        cell.user.text = review.userId
        cell.reviewDescription.text = review.reviewDescription ?? ""
        
        
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let review = reviews[indexPath.row]
        performSegue(withIdentifier: SEGUE_REVIEW, sender: review)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseListener = reviewsRef?.addSnapshotListener(){
            (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.reviews.removeAll()
            querySnapshot?.documents.forEach() { snapshot in
                let id = snapshot.documentID
                let albumId = snapshot["albumId"] as! String
                let rating = snapshot["ratingValue"] as! Int
                let userName = snapshot["userDisplayName"] as! String
                let userId = snapshot["userId"] as! String
                let reviewDescription = snapshot["reviewDescription"] as! String
                
                let review = Review(reviewId: id, albumId: albumId, userId: userId, userDisplayName: userName, ratingValue: rating, reviewDescription: reviewDescription)
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseListener?.remove()
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
