//
//  ItemsListVC.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//

import UIKit

class ItemsListVC: UIViewController {
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
}

//MARK: -
//MARK: TableView Delegate and DataSource conformance
extension ItemsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //FIXME: Implementation
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //FIXME: Implementation
        return UITableViewCell()
    }
}

//MARK: -
//MARK: StoryboardInstantiable conformance
extension ItemsListVC: StoryboardInstantiable {
    static let codeExerciseStoryboard: CodeExerciseStoryboards = .main
    static let sceneIdentifier: String = "ItemsListVC"
}
