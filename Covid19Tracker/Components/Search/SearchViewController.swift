//
//  SearchViewController.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class SearchViewController: BaseViewController {
    enum State {
        case loading
        case success
        case error
    }

    // MARK: - Services
    private let countryService = CountryService()

    // MARK: - Notifications
    private var keyboardWillShowNoticationToken: Notification.Token!
    private var keyboardWillHideNoticationToken: Notification.Token!

    // MARK: - Constraints
    private var tableViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties
    private var countries: [Country] = []
    private var filteredCountries: [Country] = []
    private var state: State = .loading {
        didSet {
            changeUIFor(state: state)
        }
    }

    // MARK: - Views
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "back_icon"), for: .normal)
        btn.tintColor = Color.white
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        return btn
    }()

    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.textColor = Color.white
        tf.font = Font.regular(size: 18)
        tf.returnKeyType = .go
        tf.delegate = self

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Color.gray,
            .font: Font.regular(size: 18)
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search for a country", attributes: attributes)
        tf.attributedPlaceholder = attributedPlaceholder
        tf.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        tf.enablesReturnKeyAutomatically = true
        return tf
    }()
    private let textFieldSeparatorView = UIView(backgroundColor: Color.white)

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorColor = Color.grayLight
        tv.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tv.separatorStyle = .singleLine
        tv.layer.cornerRadius = 8
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    private let loadingView = LoadingView()
    private lazy var errorView = ErrorView(delegate: self)

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData()

        keyboardWillHideNoticationToken = NotificationCenter.default.addObserver(using: keyboardWillBeHidden)
        keyboardWillShowNoticationToken = NotificationCenter.default.addObserver(using: keyboardWillBeShown)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if state == .success {
            textField.becomeFirstResponder()
        }
    }

    @objc private func closeModal() {
        dismiss(animated: true)
    }

    private func select(country: Country) {
        NotificationCenter.default.post(name: .onSearchCountry, object: nil, userInfo: ["country": country])
        closeModal()
    }

    private func selectFirstMatch() {
        guard let country = filteredCountries.first else {
            return
        }
        select(country: country)
    }

    private func fetchData() {
        state = .loading

        countryService.fetchAll(sort: false) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let countries):
                self.countries = countries
                self.state = .success
            case .failure:
                self.state = .error
            }
        }
    }

    private func changeUIFor(state: State) {
        switch state {
        case .loading:
            show(view: loadingView)
        case .success:
            textField.becomeFirstResponder()
            show(view: tableView)
            tableView.reloadData()
        case .error:
            show(view: errorView)
        }
    }

    private func show(view: UIView) {
        [tableView, loadingView, errorView].forEach { (v) in
            if view == v {
                v.isHidden = false
            } else {
                v.isHidden = true
            }
        }
    }
}

// MARK: - Keyboard
extension SearchViewController {
    func keyboardWillBeShown(notification: Keyboard.Notification.WillShow) {
        let info = notification.info
        let keyBoardHeight = info.frameEnd.height

        tableViewBottomConstraint.constant = -(keyBoardHeight + 16)

        UIView.animate(
            withDuration: info.duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: UInt(info.animationCurve.rawValue) << 16),
            animations: {
                self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func keyboardWillBeHidden(notification: Keyboard.Notification.WillHide) {
        let info = notification.info

        tableViewBottomConstraint.constant = -16

        UIView.animate(
            withDuration: info.duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: UInt(info.animationCurve.rawValue) << 16),
            animations: {
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

private extension SearchViewController {
    @objc func textFieldValueChanged() {
        guard let text = textField.text else { return }

        filteredCountries = countries.compactMap { (country) -> Country? in
            if country.country.lowercased().contains(text.lowercased()) {
                return country
            }
            return nil
        }
        tableView.reloadData()
    }

    func isFiltering() -> Bool {
        guard let text = textField.text else { return false }
        return !text.isEmpty
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = isFiltering() ? filteredCountries[indexPath.row] : countries[indexPath.row]
        select(country: country)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCountries.count
        }
        return countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let country = isFiltering() ? filteredCountries[indexPath.row] : countries[indexPath.row]
        cell.setup(string: country.country)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }

        guard filteredCountries.count == 1 else {
            return false
        }

        selectFirstMatch()
        return true
    }
}

extension SearchViewController: ErrorViewDelegate {
    func errorViewDidTapTryAgain() {
        fetchData()
    }
}

extension SearchViewController: CodeView {
    func buildViewHierarchy() {
        view.addSubview(backButton)
        view.addSubview(textField)
        textField.addSubview(textFieldSeparatorView)

        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(errorView)
    }

    func setupConstraints() {
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          insets: .init(top: 16, left: 16, bottom: 0, right: 0))
        backButton.anchor(height: 40, width: 40)

        textField.anchor(top: backButton.topAnchor,
                         leading: backButton.trailingAnchor,
                         bottom: backButton.bottomAnchor,
                         trailing: view.trailingAnchor,
                         insets: .init(top: 0, left: 16, bottom: 0, right: 40))

        textFieldSeparatorView.anchor(leading: textField.leadingAnchor,
                                      bottom: textField.bottomAnchor,
                                      trailing: textField.trailingAnchor,
                                      insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        textFieldSeparatorView.anchor(height: 1)

        tableView.anchor(top: textField.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         insets: .init(top: 16, left: 16, bottom: 0, right: 16))
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        tableViewBottomConstraint?.isActive = true

        loadingView.fillSuperview()
        errorView.fillSuperview()
    }

    func setupAdditionalConfiguration() {
        tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
    }
}
