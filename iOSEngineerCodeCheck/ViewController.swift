//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var controller = RepositoryTableViewController()
    var selectedRepository: GitHubRepositoryObject.Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        
        // タップイベントで、UIViewControllerに依存するメソッドを呼び出すためDelegateのみself
        self.tableView.delegate = self
        self.tableView.dataSource = self.controller
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.controller.updateRepositories(text: searchBar.text, tableView: self.tableView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 選択されたrepositoryのオブジェクトを渡す
        guard let nextViewController = segue.destination as? DetailViewController else{
            return
        }
        
        nextViewController.repository = self.selectedRepository
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRepository = self.controller.repositoryObject.items[indexPath.row]
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

class RepositoryTableViewController: NSObject, UITableViewDataSource{
    var repositoryObject = GitHubRepositoryObject()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryObject.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)
        cell.textLabel?.text = repositoryObject.items[indexPath.row].fullName
        cell.detailTextLabel?.text = repositoryObject.items[indexPath.row].language ?? ""
        
        return cell
    }
    
    func updateRepositories(text: String?, tableView: UITableView) {
        // repositoryのリストを更新
        guard let text = text else{
            return
        }
        
        // 非同期で取得
        if let url = URL(string: "https://api.github.com/search/repositories?q=\(text)"){
            AF.request(url).responseData { (response) in
                
                switch response.result{
                case .success(let result):
                    do {
                        self.repositoryObject = try JSONDecoder().decode(GitHubRepositoryObject.self, from: result)
                    } catch {
                        fatalError("FAILED TO PARSE")
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "Unknown Error")
                    
                }
                
                tableView.reloadData()
            }
        } else {
            print("URL Parse Error")
        }
    }
}

struct GitHubRepositoryObject: Codable{
    // JSON Decoder用のモデル
    
    /*
     格納する情報
     ・リポジトリ名
     ・オーナーアイコン
     ・プロジェクト言語
     ・Star数
     ・Watcher数
     ・Fork数
     ・Issue数
     */
    
    var totalCount = 0
    var incompleteResults = false
    var items: [Repository] = []
    
    struct Repository: Codable{
        var id = 0
        var name = ""
        var fullName = ""
        var language: String?
        var owner: Owner
        var stargazersCount = 0
        var watchersCount = 0
        var forksCount = 0
        var openIssuesCount = 0
        
        enum CodingKeys: String, CodingKey{
            case id = "id"
            case name = "name"
            case fullName = "full_name"
            case language = "language"
            case owner = "owner"
            case stargazersCount = "stargazers_count"
            case watchersCount = "watchers_count"
            case forksCount = "forks_count"
            case openIssuesCount = "open_issues_count"
        }
        
        struct Owner: Codable{
            var login = ""
            var id = 0
            var nodeId = ""
            var avatarUrl = ""
            var url = ""
            var htmlUrl = ""
            
            enum CodingKeys: String, CodingKey{
                case login = "login"
                case id = "id"
                case nodeId = "node_id"
                case avatarUrl = "avatar_url"
                case url = "url"
                case htmlUrl = "html_url"
            }
        }
        
    }
    
    enum CodingKeys: String, CodingKey{
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items = "items"
    }
}
