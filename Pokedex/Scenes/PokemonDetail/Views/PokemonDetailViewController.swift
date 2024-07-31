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
    
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var heightInfoView: InfoView = {
        let view = InfoView()
        return view
    }()
    
    private lazy var weightInfoView: InfoView = {
        let view = InfoView()
        return view
    }()
    
    private lazy var typesInfoView: InfoView = {
        let view = InfoView()
        return view
    }()
    
    private lazy var stackView: TransparentAndRoudedStackView = {
        let stackView = TransparentAndRoudedStackView(
            arrangedSubviews: [
                UIView(),
                nameLabel,
                UIView(),
                heightInfoView,
                weightInfoView,
                typesInfoView,
                UIView()
            ]
        )
        stackView.axis = .vertical
        stackView.alignment = .center
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
        
        nameLabel.text = data.name.capitalized
        heightInfoView.configure(title: "Height:", value: data.height.formattedHeight())
        weightInfoView.configure(title: "Weigh:", value: data.weight.formattedWeight())
        pokemonImageView.loadImage(urlString: data.image)
        
        let typesText = data.types.map { $0.getTitle() }.joined(separator: ", ")
        typesInfoView.configure(title: "Types:", value: typesText)
        
        if let primaryType = data.types.first {
            view.backgroundColor = primaryType.getColor()
        }
    }
    
    // MARK: - Navigation
    
    func prepareForNavigation(with navigationData: PokemonDetailNavigationData) {
        showLoadingIndicator()
        viewModel.prepareForNavigation(with: navigationData)
    }
}

// MARK: - PokemonDetailDelegate

extension PokemonDetailViewController: PokemonDetailDelegate {
    
    func didFail(errorMessage: String) {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
            self?.showAlert(title: "Error", message: errorMessage, buttonTitle: "Ok", action: {
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    
    func didFetchPokemonDetail(_ detail: PokemonDetail) {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: false)
            self?.hideLoadingIndicator()
            self?.updateInterface(with: detail)
        }
    }
    
}


