//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Guilerme Barciki on 29/07/24.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var viewModel = PokemonListViewModel(delegate: self)
    
    private lazy var router: PokemonListRouter? = {
        guard let navigationController = navigationController else { return nil }
        return PokemonListRouter(with: navigationController)
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupConstraints()
        setupSearchController()
        viewModel.fetchAllPokemon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure search bar is visible initially
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Allow search bar to hide when scrolling after the view appears
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
}

// MARK: - Setup Methods

extension PokemonListViewController {
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
#warning("botar placeholder em estrutura de strings")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
#warning("botar placeholder em estrutura de strings")
        searchController.searchBar.placeholder = "Search Pokémon"
        searchController.isActive = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
    }
    
}

// MARK: - Navigation

extension PokemonListViewController {
    
    func prepareForNavigation(with navigationData: PokemonListNavigationData) {
        viewModel.prepareForNavigation(with: navigationData)
    }
    
}

// MARK: - UISearchResultsUpdating

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.updateSearchQuery(searchText)
    }
}

// MARK: - UITableViewDataSource

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
#warning("usar extension de celula pra criar a celula")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pokemon = viewModel.pokemon(at: indexPath.row)
        cell.textLabel?.text = pokemon.name
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = viewModel.pokemon(at: indexPath.row)
        let x = "dsds"
        router?.navigateToPokemonDetail()
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
