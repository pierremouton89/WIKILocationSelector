//
//  LocationsListViewController.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//


import UIKit

class LocationsListViewController: UIViewController {
    
    private static let CELL_IDENTIFIER = "LocationCellIdentifier"
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(LocationTableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        table.keyboardDismissMode = .onDrag
        return table
    }()
    
    private lazy var captureContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.addArrangedSubview(captureView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return stackView
    }()

    private lazy var captureView: LocationCaptureView = {
        let view = LocationCaptureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        view.addSubview(captureContainer)
        view.addSubview(table)
        view.addSubview(loadingView)
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        NSLayoutConstraint.activate([
            captureContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            captureContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            captureContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.topAnchor.constraint(equalTo: captureContainer.bottomAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: loadingView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: loadingView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor)
        ])
    }
    
    private func bind(viewModel: LocationsListViewModel) {
        self.viewModel.title.bind {[weak self] in self?.title = $0 }
        self.viewModel.displayModels.bind {[weak self] _ in self?.table.reloadData() }
        self.bindName(viewModel: viewModel)
        self.bindLatitude(viewModel: viewModel)
        self.bindLongitude(viewModel: viewModel)
        self.bindOpenLocation(viewModel: viewModel)
        self.bindAddLocation(viewModel: viewModel)
        
    }
    private func bindName(viewModel: LocationsListViewModel) {
        self.viewModel.namePlaceHolder.bind { [weak self] in self?.captureView.setName(placeHolder: $0) }
        self.viewModel.nameDescription.bind { [weak self] in self?.captureView.setName(description: $0) }
        self.viewModel.nameInput.bind {[weak self] in self?.captureView.setName(text: $0) }
        self.captureView.setName { [weak self] in self?.viewModel.updateName(with: $0) }
    }
    
    private func bindLatitude(viewModel: LocationsListViewModel) {
        self.viewModel.latitudePlaceHolder.bind { [weak self] in self?.captureView.setLatitude(placeHolder: $0) }
        self.viewModel.latitudeDescription.bind {[weak self] in self?.captureView.setLatitude(description: $0) }
        self.viewModel.latitudeInput.bind {[weak self] in self?.captureView.setLatitude(text: $0) }
        self.captureView.setLatitude { [weak self] in self?.viewModel.updateLatitude(with: $0) }
    }

    private func bindLongitude(viewModel: LocationsListViewModel) {
        self.viewModel.longitudePlaceHolder.bind { [weak self] in self?.captureView.setLongitude(placeHolder: $0) }
        self.viewModel.longitudeDescription.bind {[weak self] in self?.captureView.setLongitude(description: $0) }
        self.viewModel.longitudeInput.bind {[weak self] in self?.captureView.setLongitude(text: $0) }
        self.captureView.setLongitude{ [weak self] in self?.viewModel.updateLongitude(with: $0) }
    }
    
    private func bindOpenLocation(viewModel: LocationsListViewModel) {
        self.captureView.setOpenLocation {[weak self] in self?.viewModel.openLocation() }
        self.viewModel.openLocationEnabled.bind {[weak self] in self?.captureView.setOpenLocation(enabled: $0) }
    }
    
    private func bindAddLocation(viewModel: LocationsListViewModel) {
        self.captureView.setAddLocation{[weak self] in self?.viewModel.addLocation() }
        self.viewModel.addLocationEnabled.bind {[weak self] in self?.captureView.setAddLocation(enabled: $0) }
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
        return self.viewModel.displayModels.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectLocation(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension LocationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView.dequeueReusableCell(withIdentifier: Self.CELL_IDENTIFIER, for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        let displayModel = self.viewModel.displayModels.value[indexPath.row]
        tableCell.configure(with: displayModel)
        return tableCell
    }
}
