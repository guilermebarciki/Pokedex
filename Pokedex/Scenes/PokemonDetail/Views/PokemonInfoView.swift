//
//  PokemonInfoView.swift
//  Pokedex
//
//  Created by Guilerme Barciki   on 31/07/24.
//
import UIKit

final class PokemonInfoView: UIView {

    // MARK: - Properties
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var heightInfoView: InfoView = InfoView()
    private lazy var weightInfoView: InfoView = InfoView()
    private lazy var typesInfoView: InfoView = InfoView()
    
    private lazy var stackView: TransparentAndRoudedStackView = {
        let stackView = TransparentAndRoudedStackView(arrangedSubviews: [
            UIView(),
            nameLabel,
            UIView(),
            heightInfoView,
            weightInfoView,
            typesInfoView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup Methods
    
    private func setup() {
        addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    func configure(with pokemonInfo: PokemonInfo) {
        nameLabel.text = pokemonInfo.name
        heightInfoView.configure(title: "Height:", value: pokemonInfo.height)
        weightInfoView.configure(title: "Weight:", value: pokemonInfo.weight)
        
        let typesText = pokemonInfo.types.map { $0.getTitle() }.joined(separator: ", ")
        typesInfoView.configure(title: "Types:", value: typesText)
    }
}
