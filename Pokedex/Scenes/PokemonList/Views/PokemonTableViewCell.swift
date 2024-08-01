//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 29/07/24.
//

import UIKit

final class PokemonTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    
    static let identifier = String(describing: PokemonTableViewCell.self)
    
    
    // MARK: - Properties
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonImageView.image = nil
        nameLabel.text = nil
        numberLabel.text = nil
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        addSubview(nameLabel)
        addSubview(numberLabel)
        addSubview(pokemonImageView)
        
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            pokemonImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 70),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            numberLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            numberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration Method
    
    func configure(pokemon: Pokemon, isCaught: Bool, presentationMode: PresentationMode) {
        numberLabel.text = "No. \(pokemon.number)"
        
        if isCaught || presentationMode == .all {
            pokemonImageView.loadImage(urlString: pokemon.pokemonImage, placeholder: UIImage(named: "pokeball"))
            nameLabel.text = pokemon.name
        } else {
            pokemonImageView.image = UIImage(named: "pokeball")
            nameLabel.text = "????"
        }
    }
    
}

