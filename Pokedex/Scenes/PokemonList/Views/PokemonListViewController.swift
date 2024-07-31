//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Guilerme Barciki on 29/07/24.
//

import UIKit

final class PokemonListViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var viewModel = PokemonListViewModel(delegate: self)
    
    private lazy var router: PokemonListRouter? = {
        guard let navigationController = navigationController else { return nil }
        return PokemonListRouter(with: navigationController)
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.identifier)
        return tableView
    }()
    
    private let headerView = PokemonListHeaderView()
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupConstraints()
        setupSearchController()
        setupTapGesture()
        viewModel.fetchAllPokemon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - Actions
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.setPresentationStatus(index: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - Setup Methods

extension PokemonListViewController {
    
    private func setupInterface() {
        view.backgroundColor = .white
        title = "Pokedex"
        view.addSubview(tableView)
        setupTableHeaderView()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 92)
        tableView.tableHeaderView = headerView
        headerView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupSearchController() {
        headerView.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - UISearchBarDelegate

extension PokemonListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchQuery(searchText)
    }
    
}

// MARK: - UITableViewDataSource

extension PokemonListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PokemonTableViewCell = .createCell(tableView: tableView, indexPath: indexPath)
        guard let pokemon = viewModel.pokemon(at: indexPath.row) else {
            return UITableViewCell()
        }

        let isCaught = viewModel.isPokemonCaught(index: indexPath.row)
        cell.configure(pokemon: pokemon, isCaught: isCaught, presentationMode: viewModel.getPresentationStatus())
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pokemon = viewModel.pokemon(at: indexPath.row) else { return }
        //        router?.navigateToPokemonDetail(with: pokemon)
        router?.navigateToPokemonDetail(with: pokemon.name)
    }
}

// MARK: - PokemonListDelegate

extension PokemonListViewController: PokemonListDelegate {
    
    func didUpdatePokemonList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}




