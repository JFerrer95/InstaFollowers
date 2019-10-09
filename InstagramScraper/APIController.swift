//
//  APIController.swift
//  DoNothingClubApp
//
//  Created by Jonathan Ferrer on 10/4/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class APIController {

    let baseURL = URL(string: "https://www.instagram.com/")!

    func getUser(of user: String, completion: @escaping (User) -> Void) {

            let url = baseURL.appendingPathComponent(user)

            URLSession.shared.dataTask(with: url) { (data, resp, error) in
                if let error = error {
                    NSLog("Error scraping site: \(error)")
                    return
                }

                guard let data = data else {
                    NSLog("Data was nil")
                    return
                }

                guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else {
                    NSLog("Cannot cast data into string")
                    return
                }

                let leftSideOfTheFollower = """
                edge_followed_by":{"count":
                """
                let rightSideOfTheFollower = """
                },"followed_by_viewer
                """

                let leftSideOfTheFollowing = """
                edge_follow":{"count":
                """
                let rightSideOfTheFollowing = """
                },"follows_viewer
                """
                let leftSideOfThePic = """
                profile_pic_url_hd":"
                """
                let rightSideOfThePic = """
                ","requested_by_viewer
                """
                let leftSideOfTheBio = """
                user":{"biography":"
                """
                let rightSideOfTheBio = """
                ","blocked_by_viewer
                """
                print(htmlString)
                guard let leftRangeFollower = htmlString.range(of: leftSideOfTheFollower) else {
                    NSLog("Cannot find left range")
                    return
                }

                guard let rightRangeFollower = htmlString.range(of: rightSideOfTheFollower) else {
                    NSLog("Cannot find right range")
                    return
                }
                guard let leftRangeFollowing = htmlString.range(of: leftSideOfTheFollowing) else {
                   NSLog("Cannot find left range")
                   return
               }

               guard let rightRangeFollowing = htmlString.range(of: rightSideOfTheFollowing) else {
                   NSLog("Cannot find right range")
                   return
               }

                guard let leftRangePic = htmlString.range(of: leftSideOfThePic) else {
                           NSLog("Cannot find left range")
                           return
                }

                guard let rightRangePic = htmlString.range(of: rightSideOfThePic) else {
                           NSLog("Cannot find right range")
                           return
                }
                guard let leftRangeBio = htmlString.range(of: leftSideOfTheBio) else {
                                          NSLog("Cannot find left range")
                                          return
                               }

               guard let rightRangeBio = htmlString.range(of: rightSideOfTheBio) else {
                          NSLog("Cannot find right range")
                          return
               }

                let rangeOfTheFollowers = leftRangeFollower.upperBound..<rightRangeFollower.lowerBound
                let rangeOfTheFollowing = leftRangeFollowing.upperBound..<rightRangeFollowing.lowerBound
                let rangeOfThePic = leftRangePic.upperBound..<rightRangePic.lowerBound
                let rangeOfTheBio = leftRangeBio.upperBound..<rightRangeBio.lowerBound
                let followers = String(htmlString[rangeOfTheFollowers])
                let following = String(htmlString[rangeOfTheFollowing])
                let pic = String(htmlString[rangeOfThePic])
                let bio = String(htmlString[rangeOfTheBio])

                let userInfo = User(userName: user, followers: followers, following: following, image: pic, bio: bio)
                completion(userInfo)

                print(htmlString)
            }.resume()
        }

    func fetchImage(at urlString: String, completion: @escaping (UIImage?) -> Void) {

            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }

            URLSession.shared.dataTask(with: url) { (data, _, error) in

                if let error = error {
                    NSLog("Error fetching image: \(error)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    NSLog("No data returned from image fetch data task")
                    completion(nil)
                    return
                }

                let image = UIImage(data: data)

                completion(image)

            }.resume()
        }
}
