//
//  SettingsViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/4/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import UIKit
import RealmSwift
import Toast_Swift

class SettingsViewController: UIViewController {

    var viewModel = SettingsViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = viewModel[indexPath.row]?.localizedTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = viewModel[indexPath.row] else {return}
        
        switch item {
        case .disclaimer:
            Utility.showDisclaimer()
        case .rateUs:
            Utility.rateApp()
        case .feedback:
            sendFeedBack()
        case .shareApp:
            shareApp()
        case .aboutUs:
            Utility.aboutApp()
        }
    }
}
