//
//  ViewController.swift
//  Maulik_RedditDemo
//
//  Created by Maulik Bhuptani on 26/04/19.
//  Copyright © 2019 Maulik Bhuptani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var posts : Array<Dictionary<String, Any>>?
    private let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(reloadPostsTableView), for: .valueChanged)
        self.refreshControl.beginRefreshing()

        reloadPostsTableView()
    }
    
    @objc private func reloadPostsTableView(){
        BusinessLayer.shared.getRandomPosts { (postsArray) in
//            print(postsArray ?? "")
            self.posts = postsArray
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let postTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as? PostTableViewCell{
            if let thumbnailString = self.posts?[indexPath.row]["thumbnail"] as? String{
                BusinessLayer.shared.downloadImage(link: thumbnailString, completion: { (downloadedImage) in
                    DispatchQueue.main.async {
                        postTableViewCell.titleLabel.text = self.posts?[indexPath.row]["title"] as? String
                        postTableViewCell.descriptionLabel.text = self.posts?[indexPath.row]["url"] as? String
                        postTableViewCell.thumbnailImageView.image = downloadedImage
                    }
                })
            }
            return postTableViewCell
        }
        return UITableViewCell()
    }
}

