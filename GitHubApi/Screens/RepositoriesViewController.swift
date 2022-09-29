//
//  RepositoriesViewController.swift
//  GitHubApi
//
//  Created by Никита Мошенцев on 28.09.2022.
//

import UIKit

class RepositoriesViewController: UIViewController {

    private let networkService = NetworkService()
    
    private var repositoriesView: RepositoriesView {
        return view as! RepositoriesView
    }
    
    override func loadView() {
        super.loadView()
        self.view = RepositoriesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UserSession.instance.token)
        networkService.searchRepos(searchText: "repo") { result in
            switch result {
            case .success(let repos):
                print(repos)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
