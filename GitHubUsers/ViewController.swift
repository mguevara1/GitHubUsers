//
//  ViewController.swift
//  GitHubUsers
//
//  Created by Marco Guevara on 17/01/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var cancellable: Set<AnyCancellable> = []
    var viewModel: ViewModel!
    
    init(viewModel: ViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel?.searchUsers(query: "octocat")
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.$users
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                guard let self = self else { return }
                print(users)
            }
            .store(in: &cancellable)
    }
}
