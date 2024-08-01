//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import UIKit

enum PokemonDetailFactory {
    
    static func make(with pokemonName: PokemonDetailNavigationData) -> PokemonDetailViewController {
        let viewModel = PokemonDetailViewModel(pokemonName: pokemonName)
        let vc = PokemonDetailViewController(viewModel: viewModel)
        return vc
    }
    
}

final class PokemonDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: PokemonDetailViewModel
    
    private lazy var router: PokemonDetailRouter? = {
        guard let navigationController = navigationController else { return nil }
        return PokemonDetailRouter(with: navigationController)
    }()
    
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pokemonInfoView: PokemonInfoView = {
           let view = PokemonInfoView()
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
    
//    private lazy var nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private lazy var heightInfoView: InfoView = {
//        let view = InfoView()
//        return view
//    }()
//    
//    private lazy var weightInfoView: InfoView = {
//        let view = InfoView()
//        return view
//    }()
//    
//    private lazy var typesInfoView: InfoView = {
//        let view = InfoView()
//        return view
//    }()
    
    
    
    // MARK: - Init
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.setDelegate(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupConstraints()
        
        fetchPokemon()
    }
    
    
    // MARK: - Setup Methods
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(pokemonImageView)
        view.addSubview(pokemonInfoView)
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 200),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 200),
            
            pokemonInfoView.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            pokemonInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pokemonInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    
    // MARK: - Private Methods
    
    private func updateInterface(with pokemonInfo: PokemonInfo) {
        pokemonImageView.loadImage(urlString: pokemonInfo.imageUrl)
        pokemonInfoView.configure(with: pokemonInfo)
        
        
        view.backgroundColor = pokemonInfo.types.first?.getColor()
        
    }
    
    private func fetchPokemon() {
        showLoadingIndicator()
        viewModel.fetchPokemonDetail()
    }
    
}


// MARK: - PokemonDetailDelegate

extension PokemonDetailViewController: PokemonDetailDelegate {
    
    func didFail(errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
            self?.showAlert(message: errorMessage, action: {
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
    func didFetchPokemonDetail(_ detail: PokemonInfo) {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: false)
            self?.hideLoadingIndicator()
            self?.updateInterface(with: detail)
        }
    }
    
}
