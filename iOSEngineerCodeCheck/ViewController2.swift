//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController2: UIViewController {
    
    @IBOutlet weak var ImgView: UIImageView!
    
    @IBOutlet weak var TtlLbl: UILabel!
    
    @IBOutlet weak var LangLbl: UILabel!
    
    @IBOutlet weak var StrsLbl: UILabel!
    @IBOutlet weak var WchsLbl: UILabel!
    @IBOutlet weak var FrksLbl: UILabel!
    @IBOutlet weak var IsssLbl: UILabel!
    
    var repository: GitHubRepositoryObject.Repository!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LangLbl.text = "Written in \(repository.language ?? "")"
        StrsLbl.text = "\(repository.stargazersCount) stars"
        WchsLbl.text = "\(repository.watchersCount) watchers"
        FrksLbl.text = "\(repository.forksCount) forks"
        IsssLbl.text = "\(repository.openIssuesCount) open issues"
        TtlLbl.text = repository.fullName
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
                    self.ImgView.image = image
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
