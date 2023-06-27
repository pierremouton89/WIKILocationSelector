//
//  LocationTableViewCell.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 26/06/2023.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
  
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "W") ?? UIImage(systemName: "location.circle")
        return imageView
    }()
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Design.smallSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: Design.smallSpacing,
            bottom: 0,
            trailing: Design.largeSpacing
        )
        stackView.addArrangedSubview(dataStack)
        stackView.addArrangedSubview(image)
        return stackView
    }()

    private lazy var name: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.titleFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dataStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        stackView.spacing = Design.smallSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.mediumSpacing,
            leading: Design.largeSpacing,
            bottom: Design.mediumSpacing,
            trailing: Design.largeSpacing
        )
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(longitudeStack)
        stackView.addArrangedSubview(latitudeStack)
        return stackView
    }()
    
    private lazy var longitudeDescription: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.descriptionFont
        label.numberOfLines = 0
        return label
    }()
    private lazy var longitudeValue: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.valueFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var longitudeStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Design.smallSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: Design.smallSpacing,
            bottom: 0,
            trailing: Design.smallSpacing
        )
        stackView.addArrangedSubview(longitudeDescription)
        stackView.addArrangedSubview(longitudeValue)
        return stackView
    }()
    
    private lazy var latitudeDescription: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.descriptionFont
        label.numberOfLines = 0
        return label
    }()
    private lazy var latitudeValue: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.valueFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var latitudeStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: Design.smallSpacing,
            bottom: 0,
            trailing: Design.smallSpacing
        )
        stackView.spacing = Design.smallSpacing
        stackView.addArrangedSubview(latitudeDescription)
        stackView.addArrangedSubview(latitudeValue)
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
         setup()
    }
    private func setup(){
        self.contentView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            //Stackview
            self.contentView.topAnchor.constraint(equalTo: contentStack.topAnchor),//top stackview
            self.contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor), //bottom stackview
            self.contentView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor), //trailing
            self.contentView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),// leading
            image.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.1),
        ])
    }
    
    func configure(with displayModel: LocationDisplayModel) {
        self.name.text = displayModel.name
        self.latitudeDescription.text = displayModel.latitudeDescription
        self.latitudeValue.text = displayModel.latitude
        self.longitudeDescription.text = displayModel.longitudeDescription
        self.longitudeValue.text = displayModel.longitude
        
    }
    
}
