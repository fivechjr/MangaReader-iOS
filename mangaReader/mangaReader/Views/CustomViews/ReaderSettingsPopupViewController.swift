//
//  ReaderSettingsPopupViewController.swift
//  mangaReader
//
//  Created by Yiming Dong on 2018/11/21.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

class ReaderSettingsPopupViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    var dismissed: (() -> Void)?
    
    let readerModes: [ReaderMode] = [.pageHorizontal, .pageVertical, .pageCurl, .collectionHorizontal, .collectionVertical]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = currentTheme.backgroundColor
        tableView.backgroundColor = .clear
        
        tableView.ezRegisterNib(cellType: SettingSelectCell.self)
        tableView.tableFooterView = UIView()
    }
    
    static func present(in viewController: UIViewController, dismissed: @escaping () -> Void) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReaderSettingsPopupViewController") as! ReaderSettingsPopupViewController
        
        vc.dismissed = dismissed
        
        viewController.modalPresentationStyle = .formSheet
        
        viewController.present(vc, animated: true, completion: nil)
    }

    @IBAction func closeAction(_ sender: Any) {
        farewell()
    }
    
}

extension ReaderSettingsPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readerModes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingSelectCell") as! SettingSelectCell
        let readerMode = readerModes[indexPath.row]
        
        let isSelected = readerMode.rawValue == ReaderMode.currentMode.rawValue
        cell.viewModel = SettingSelectCellViewModel(title: readerMode.title, selected: isSelected)
        cell.titleLabel.textColor = currentTheme.textColor

        return cell
    }
}

extension ReaderSettingsPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readerMode = readerModes[indexPath.row]
        ReaderMode.currentMode = readerMode
        
        farewell()
        
        dismissed?()
    }
}

