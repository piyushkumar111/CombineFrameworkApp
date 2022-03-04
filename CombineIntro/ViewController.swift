//
//  ViewController.swift
//  CombineIntro
//
//  Created by Piyush Kachariya on 3/4/22.
//

import UIKit
import Combine

class CustomCell: UITableViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var action = PassthroughSubject<String, Never>() // It will never return error

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        button.frame = CGRect(x: 10, y: 3, width: contentView.frame.size.width-20, height: contentView.frame.size.height - 6)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        action.send("Button has been tapped!!!")
    }
    
    func config(_ value: String) {
        button.titleLabel?.text = value
    }
}

class ViewController: UIViewController {

    private var compniesList: [String] = [String]()
    
    var observer: [AnyCancellable] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        
        // Call api to get data
        callApi()
    }
    
    private func buildView() {
        self.view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.frame = self.view.bounds
    }
    
    private func callApi() {
        ApiHandler.shared.fetchListOfCompnines()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { result in
                self.compniesList = result
                self.tableView.reloadData()
            }).store(in: &observer)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compniesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomCell else {
            fatalError()
        }
        cell.textLabel?.text = self.compniesList[indexPath.row]
        cell.config(compniesList[indexPath.row])
        cell.action
            .sink { value in
                print(value)
            }
            .store(in: &observer)
        return cell
    }
}

