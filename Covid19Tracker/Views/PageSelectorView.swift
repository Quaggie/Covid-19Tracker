//
//  PageSelectorView.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 11/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

protocol PageSelectorViewDelegate: AnyObject {
    func pageSelectorViewDidChange(index: Int)
}

final class PageSelectorView: UIView {
    // MARK: - Properties
    var delegate: PageSelectorViewDelegate?
    private var selectedTitle: String
    private var selectedButtonLineWidthConstraint: NSLayoutConstraint?
    private var selectedButtonLineCenterXConstraint: NSLayoutConstraint?

    private let font = Font.semiBold(size: 16)
    private let selectedColor = Color.white
    private let unselectedColor = Color.white.withAlphaComponent(0.3)
    private let lineHeight: CGFloat = 2

    var selectedButtonIndex: Int? {
        return buttons.firstIndex(where: { $0.currentTitle == selectedTitle })
    }
    private var selectedButtonWidth: CGFloat {
        return 104
    }

    // MARK: - Views
    private let buttons: [UIButton]
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 0
        return sv
    }()
    private lazy var selectedButtonLine: UIView = {
        let v = UIView()
        v.backgroundColor = selectedColor
        return v
    }()

    // MARK: - Init
    init(titles: [String], selectedTitle: String) {
        var btns: [UIButton] = []

        for title in titles {
            let btn = UIButton(type: .custom)
            btn.titleEdgeInsets = .zero
            btn.contentEdgeInsets = .zero
            btn.imageEdgeInsets = .zero
            btn.setTitle(title.capitalized, for: .normal)
            btn.setTitleColor(selectedColor, for: .normal)
            btn.titleLabel?.font = font
            btns.append(btn)
        }
        self.buttons = btns
        self.selectedTitle = selectedTitle

        super.init(frame: .zero)
        setupViews()
        buttons.forEach {
            $0.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
            $0.addTarget(self, action: #selector(didTouchDownButton(sender:)), for: .touchDown)
            $0.addTarget(self, action: #selector(didTouchDragEnterButton(sender:)), for: .touchDragEnter)
            $0.addTarget(self, action: #selector(didTouchDragExitButton(sender:)), for: .touchDragExit)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func setup() {
        let button = buttons.first(where: { $0.currentTitle == selectedTitle }) ?? buttons[0]
        centerSelectedLine(sender: button)
        layoutButtons()
        button.setTitleColor(selectedColor, for: .normal)
    }

    // MARK: - Actions
    @objc private func didTapButton(sender: UIButton) {
        UIView.animate(withDuration: 0.20) {
            self.highlightButton(false, button: sender)
            if sender.currentTitle == self.selectedTitle {
                self.highlightLine(false)
            }
        }
        selectedTitle = sender.currentTitle ?? ""

        guard let selectedButtonIndex = selectedButtonIndex else { return }
        delegate?.pageSelectorViewDidChange(index: selectedButtonIndex)
        animateLine(sender: sender)
    }

    @objc private func didTouchDownButton(sender: UIButton) {
        UIView.animate(withDuration: 0.05) {
            self.highlightButton(true, button: sender)
            if sender.currentTitle == self.selectedTitle {
                self.highlightLine(true)
            }
        }
    }

    @objc private func didTouchDragEnterButton(sender: UIButton) {
        UIView.animate(withDuration: 0.20) {
            self.highlightButton(true, button: sender)
            if sender.currentTitle == self.selectedTitle {
                self.highlightLine(true)
            }
        }
    }

    @objc private func didTouchDragExitButton(sender: UIButton) {
        UIView.animate(withDuration: 0.20) {
            self.highlightButton(false, button: sender)
            if sender.currentTitle == self.selectedTitle {
                self.highlightLine(false)
            }
        }
    }

    private func highlightButton(_ bool: Bool, button: UIButton) {
        button.alpha = bool ? 0.2 : 1
    }

    private func highlightLine(_ bool: Bool) {
        selectedButtonLine.alpha = bool ? 0.2 : 1
    }

    private func centerSelectedLine(sender: UIButton) {
        selectedButtonLineWidthConstraint?.constant = selectedButtonWidth

        selectedButtonLineCenterXConstraint?.isActive = false
        selectedButtonLineCenterXConstraint = selectedButtonLine.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
        selectedButtonLineCenterXConstraint?.isActive = true
    }

    private func animateLine(sender: UIButton) {
        centerSelectedLine(sender: sender)

        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [], animations: {
            self.layoutButtons()
            self.layoutIfNeeded()
        }, completion: nil)
    }

    private func layoutButtons() {
        for button in buttons {
            let isSelectedButton = button.currentTitle == selectedTitle
            button.setTitleColor(isSelectedButton ? selectedColor : unselectedColor, for: .normal)
        }
    }
}

// MARK: - CodeView
extension PageSelectorView: CodeView {
    func buildViewHierarchy() {
        addSubview(stackView)
        addSubview(selectedButtonLine)
    }

    func setupConstraints() {
        stackView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         insets: .init(top: 10, left: 0, bottom: 2, right: 0))

        selectedButtonLine.anchor(bottom: bottomAnchor)
        selectedButtonLine.anchor(height: lineHeight)

        selectedButtonLineWidthConstraint = selectedButtonLine.widthAnchor.constraint(equalToConstant: selectedButtonWidth)
        selectedButtonLineWidthConstraint?.isActive = true

        let selectedbuttonCenterXAnchor: NSLayoutXAxisAnchor = buttons[selectedButtonIndex ?? 0].centerXAnchor
        selectedButtonLineCenterXConstraint = selectedButtonLine.centerXAnchor.constraint(equalTo: selectedbuttonCenterXAnchor)
        selectedButtonLineCenterXConstraint?.isActive = true
    }

    func setupAdditionalConfiguration() {}
}

extension WeakRefVirtualProxy: PageSelectorViewDelegate where T: PageSelectorViewDelegate {
    func pageSelectorViewDidChange(index: Int) {
        object?.pageSelectorViewDidChange(index: index)
    }
}
