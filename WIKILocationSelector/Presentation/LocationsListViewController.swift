//
//  LocationsListViewController.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//


import UIKit

class LocationsListViewController: UIViewController {
    
    private static let cellIdentifier = "LocationCellIdentifier"
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return table
    }()
    
    private let viewModel: LocationsListViewModel
    
    init(viewModel: LocationsListViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Did not implement coder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind(viewModel: viewModel)
        self.showLoading()
        Task {
            await viewModel.loadContent()
            self.hideLoading()
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        view.addSubview(table)
        view.addSubview(loadingView)
        table.delegate = self
        table.dataSource = self
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: table.topAnchor),
            view.bottomAnchor.constraint(equalTo: table.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: table.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: table.trailingAnchor),
            
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: loadingView.topAnchor),
            view.bottomAnchor.constraint(equalTo: loadingView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor)
        ])
    }
    
    private func bind(viewModel: LocationsListViewModel) {
        self.viewModel.title.bind {[weak self] in self?.title = $0 }
        self.viewModel.locations.bind {[weak self] _ in self?.table.reloadData() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func showLoading() {
        self.loadingView.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    private func hideLoading() {
        self.loadingView.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
   
}

extension LocationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.locations.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectLocation(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension LocationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        tableCell.textLabel?.text = self.viewModel.locations.value[indexPath.row].name
        return tableCell
    }
}
