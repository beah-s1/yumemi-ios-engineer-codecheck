//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var langLabel: UILabel!
    
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var issuesCountLabel: UILabel!
    
    var repository: GitHubRepositoryObject.Repository!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        langLabel.text = "Written in \(repository.language ?? "")"
        starsCountLabel.text = "\(repository.stargazersCount) stars"
        watchersCountLabel.text = "\(repository.watchersCount) watchers"
        forksCountLabel.text = "\(repository.forksCount) forks"
        issuesCountLabel.text = "\(repository.openIssuesCount) open issues"
        titleLabel.text = repository.fullName
        getImage()
        
    }
    
    func getImage(){
        guard let url = URL(string: repository.owner.avatarUrl) else{
            return
        }
        
        AF.request(url).responseData{ response in
            switch response.result{
            case .success(let result):
                if let image = UIImage(data: result){
                    self.imageView.image = image
                }
            case .failure(let error):
                if let errorDescription = error.errorDescription{
                    let alert = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
}
