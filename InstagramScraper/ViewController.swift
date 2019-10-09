//
//  ViewController.swift
//  DoNothingClubApp
//
//  Created by Jonathan Ferrer on 10/3/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var user: User?
    let apiController = APIController()
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!

    @IBOutlet weak var followingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func getFollowersPressed(_ sender: Any) {
        guard let username = userTextField.text else { return }
        apiController.getUser(of: username) { (user) in
            self.user = user
            self.updateViews()

        }
        
    }

    func updateViews() {
        guard let user = user else { return }
        apiController.fetchImage(at: user.image) { (pic) in

            DispatchQueue.main.async {
                self.imageView.image = pic
                self.usernameLabel.text = "User: \(user.userName)"
                self.followersLabel.text = "Followers: \(user.followers)"
                self.followingLabel.text = "Following: \(user.following)"
                var bio = user.bio
                bio = bio.replacingOccurrences(of: "\\u2800" , with: "", options: NSString.CompareOptions.literal, range: nil)
                bio = bio.replacingOccurrences(of: "\\u2063" , with: "", options: NSString.CompareOptions.literal, range: nil)
                bio = bio.replacingOccurrences(of: "\\n" , with: " ", options: NSString.CompareOptions.literal, range: nil)
                bio = bio.replacingOccurrences(of: "\\ud83d\\udcf8" , with: "🍔", options: NSString.CompareOptions.literal, range: nil)



                self.bioTextView.text = bio

            }
        }

    }

    


}

