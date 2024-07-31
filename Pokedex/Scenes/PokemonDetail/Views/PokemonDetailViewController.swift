//  
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import UIKit

final class PokemonDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var viewModel = PokemonDetailViewModel(delegate: self)
    
    private lazy var router: PokemonDetailRouter? = {
        guard let navigationController = navigationController else { return nil }
        return PokemonDetailRouter(with: navigationController)
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let baseExperienceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let typesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: TransparentAndRoudedStackView = {
        let stackView = TransparentAndRoudedStackView(
            arrangedSubviews: [
                UIView(),
                nameLabel,
                baseExperienceLabel,
                heightLabel,
                weightLabel,
                typesLabel,
                UIView()
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: - View's life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(pokemonImageView)
        view.addSubview(stackView)
        
    }
    
    private func setupConstraints() {
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 200),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 200),
            
            stackView.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Update Methods

    private func updateInterface(with data: PokemonDetail) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel.text = data.name.capitalized
            self?.heightLabel.text = "Height: \(data.height.formattedHeight())"
            self?.weightLabel.text = "Weight: \(data.weight.formattedWeight())"
            self?.pokemonImageView.loadImage(urlString: data.image)
            let typesText = data.types.map { $0.getTitle() }.joined(separator: ", ")
            self?.typesLabel.text = "Types: \(typesText)"
            
            if let primaryType = data.types.first {
                self?.view.backgroundColor = primaryType.getColor()
            }
        }
    }
    
    // MARK: - Navigation
    
    func prepareForNavigation(with navigationData: PokemonDetailNavigationData) {
        viewModel.prepareForNavigation(with: navigationData)
    }
}

// MARK: - PokemonDetailDelegate

extension PokemonDetailViewController: PokemonDetailDelegate {
    func didFetchPokemonDetail(_ detail: PokemonDetail) {
        updateInterface(with: detail)
    }
}


