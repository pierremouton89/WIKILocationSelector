//
//  LocationCaptureView.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 26/06/2023.
//

import UIKit

class LocationCaptureView: UIView {
    typealias InputTextChangeListener = (InputTextStateChanges)-> ()
    typealias TapAction = (() -> ())
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.mediumSpacing,
            leading: Design.mediumSpacing,
            bottom: Design.mediumSpacing,
            trailing: Design.mediumSpacing
        )
        stackView.spacing = Design.mediumSpacing
        stackView.addArrangedSubview(nameStack)
        stackView.addArrangedSubview(latitudeStack)
        stackView.addArrangedSubview(longitudeStack)
        stackView.addArrangedSubview(buttonStack)
        
        return stackView
    }()
    
    private lazy var nameStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Design.mediumSpacing
        stackView.addArrangedSubview(nameText)
        stackView.addArrangedSubview(nameInput)
        return stackView
    }()
    
    // MARK: Name
    
    private lazy var nameText: UILabel = {
        let label = UILabel()
        label.font = Design.descriptionFont
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private var nameInputListener: InputTextChangeListener?
    private lazy var nameInput: UITextField = {
        let field = UITextField()
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        field.font = Design.inputFont
        field.addTarget(self, action: #selector(nameTextChange(textField:)), for: .editingChanged)
        field.addTarget(self, action: #selector(nameTextEndEditing), for: .editingDidEnd)
        return field
    }()
    
    @objc
    private func nameTextChange(textField: UITextField) {
        nameInputListener?(.changed(textField.text))
    }
    
    @objc
    private func nameTextEndEditing() {
        nameInputListener?(.endEditing)
    }
    
    // MARK: - Latitude
    
    private lazy var latitudeStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Design.mediumSpacing
        stackView.addArrangedSubview(latitudeText)
        stackView.addArrangedSubview(latitudeInput)
        return stackView
    }()
    private lazy var latitudeText: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.font = Design.descriptionFont
        return label
    }()
    
    private var latitudeInputListener: InputTextChangeListener?
    private lazy var latitudeInput: UITextField = {
        let field = UITextField()
        field.font = Design.inputFont
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        field.keyboardType = .numbersAndPunctuation
        field.addTarget(self, action: #selector(latitudeTextChange(textField:)), for: .editingChanged)
        field.addTarget(self, action: #selector(latitudeTextEndEditing), for: .editingDidEnd)
        return field
    }()
    
    @objc
    private func latitudeTextChange(textField: UITextField) {
        latitudeInputListener?(.changed(textField.text))
    }
    
    @objc
    private func latitudeTextEndEditing() {
        latitudeInputListener?(.endEditing)
    }
    
    // MARK: - Longitude
    
    private lazy var longitudeStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Design.mediumSpacing
        stackView.addArrangedSubview(longitudeText)
        stackView.addArrangedSubview(longitudeInput)
        return stackView
    }()
    
    private lazy var longitudeText: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.font = Design.descriptionFont
        return label
    }()
    
    private var longitudeInputListener: InputTextChangeListener?
    private lazy var longitudeInput: UITextField = {
        let field = UITextField()
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        field.font = Design.inputFont
        field.keyboardType = .numbersAndPunctuation
        field.addTarget(self, action: #selector(longitudeTextChange(textField:)), for: .editingChanged)
        field.addTarget(self, action: #selector(longitudeTextEndEditing), for: .editingDidEnd)
        return field
    }()
    
    @objc
    private func longitudeTextChange(textField: UITextField) {
        longitudeInputListener?(.changed(textField.text))
    }
    
    @objc
    private func longitudeTextEndEditing() {
        longitudeInputListener?(.endEditing)
    }
    
    // MARK: - Button
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = Design.mediumSpacing
        stackView.addArrangedSubview(addLocation)
        stackView.addArrangedSubview(openLocation)
        return stackView
    }()
    
    private lazy var addLocation: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(onAddLocationTapped), for: .touchUpInside)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = button.tintColor.cgColor
        button.layer.cornerRadius = Design.smallSpacing
        return button
    }()
    
    private var addTapAction: TapAction?
    @objc
    private func onAddLocationTapped() {
        addTapAction?()
    }
    
    private lazy var openLocation: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open", for: .normal)
        button.addTarget(self, action: #selector(onOpenLocationTapped), for: .touchUpInside)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = button.tintColor.cgColor
        button.layer.cornerRadius = Design.smallSpacing
        return button
    }()
    
    private var openTapAction: TapAction?
    @objc
    private func onOpenLocationTapped() {
        openTapAction?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    private func setup() {
        self.addSubview(contentView)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
}

// MARK: - Name

extension LocationCaptureView {
    func setName(placeHolder: String) {
        self.nameInput.placeholder = placeHolder
    }
    
    func setName(description: String) {
        self.nameText.text = description
    }
    
    func setName(text: String) {
        self.nameInput.text = text
    }
    
    func setName(inputListener: @escaping InputTextChangeListener) {
        self.nameInputListener = inputListener
    }
    
}

// MARK: - Longitude

extension LocationCaptureView {
    func setLongitude(placeHolder: String) {
        self.longitudeInput.placeholder = placeHolder
    }
    
    func setLongitude(description: String) {
        self.longitudeText.text = description
    }
    
    func setLongitude(text: String) {
        self.longitudeInput.text = text
    }
    
    func setLongitude(inputListener: @escaping InputTextChangeListener) {
        self.longitudeInputListener = inputListener
    }
}

// MARK: - Latitude

extension LocationCaptureView {
    func setLatitude(placeHolder: String) {
        self.latitudeInput.placeholder = placeHolder
    }
    
    func setLatitude(description: String) {
        self.latitudeText.text = description
    }
    
    func setLatitude(text: String) {
        self.latitudeInput.text = text
    }
    
    func setLatitude(inputListener: @escaping InputTextChangeListener) {
        self.latitudeInputListener = inputListener
    }
}

// MARK: - Open Location button

extension LocationCaptureView {
    
    func setOpenLocation(tapAction: @escaping TapAction) {
        self.openTapAction = tapAction
    }
    
    func setOpenLocation(enabled: Bool) {
        self.openLocation.isEnabled = enabled
    }
}


// MARK: - Add Location button

extension LocationCaptureView {
    
    func setAddLocation(tapAction: @escaping TapAction) {
        self.addTapAction = tapAction
    }
    
    func setAddLocation(enabled: Bool) {
        self.addLocation.isEnabled = enabled
    }
}

