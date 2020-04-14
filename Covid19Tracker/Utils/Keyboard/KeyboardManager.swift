//
//  KeyboardManager.swift
//  Covid19Tracker
//
//  Created by Jonathan Bijos on 13/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

import UIKit

final class KeyboardManager: NSObject {
    private var keyboardWillShowNoticationToken: Notification.Token!
    private var keyboardWillHideNoticationToken: Notification.Token!

    var doneAction: (() -> Void)?
    var keyboardWillBeShownAction: ((Double) -> Void)?
    var keyboardWillBeHiddenAction: ((Double) -> Void)?

    private weak var currentTextField: UITextField? {
        didSet {
            if textFields?().last == currentTextField {
                currentTextField?.returnKeyType = .done
            } else {
                currentTextField?.returnKeyType = .next
            }
        }
    }

    weak var scrollView: UIScrollView? {
        didSet {
            oldValue?.delegate = nil
            scrollView?.delegate = self
        }
    }
    var textFields: (() -> ([UITextField]))? {
        didSet {
            oldValue?().forEach { $0.delegate = nil }
            textFields?().forEach { $0.delegate = self }
            currentTextField = nil
        }
    }

    override init() {
        super.init()

        keyboardWillHideNoticationToken = NotificationCenter.default.addObserver(using: keyboardWillBeHidden)
        keyboardWillShowNoticationToken = NotificationCenter.default.addObserver(using: keyboardWillBeShown)
    }
}

private extension KeyboardManager {
    func keyboardWillBeShown(notification: Keyboard.Notification.WillShow) {
        keyboardWillBeShownAction?(notification.info.duration)

        var contentInset: UIEdgeInsets = scrollView?.contentInset ?? .zero
        contentInset.bottom = notification.info.frameEnd.height + 23.0
        scrollView?.contentInset = contentInset
        if let textField = currentTextField {
            scroll(to: textField)
        }
    }

    func keyboardWillBeHidden(notification: Keyboard.Notification.WillHide) {
        keyboardWillBeHiddenAction?(notification.info.duration)

        var contentInset: UIEdgeInsets = scrollView?.contentInset ?? .zero
        contentInset.bottom = 0.0
        scrollView?.contentInset = contentInset
    }

    func scroll(to textField: UITextField) {
        var frame = textField.frame
        frame.origin.x -= (scrollView?.contentOffset.x ?? 0)
        frame.origin.y -= (scrollView?.contentOffset.y ?? 0)

        scrollView?.scrollRectToVisible(frame, animated: true)
    }
}

extension KeyboardManager: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        scroll(to: textField)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textFields?().next(item: textField) {
            nextTextField.becomeFirstResponder()
        }

        if textFields?().last == textField {
            doneAction?()
        }

        return true
    }
}

extension KeyboardManager: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleTextFieldsVisibility()
    }

    private func handleTextFieldsVisibility() {
        guard let scrollView = self.scrollView else { return }

        textFields?().forEach { textField in
            let contentOffsetY = scrollView.contentOffset.y + scrollView.contentInset.top
            let textFieldY = textField.frame.minY

            if contentOffsetY > textFieldY {
                hide(textField: textField)
            } else {
                show(textField: textField)
            }
        }
    }

    private func hide(textField: UITextField) {
        guard textField != currentTextField else { return }

        textField.alpha = 0.0
    }

    private func show(textField: UITextField) {
        textField.alpha = 1.0
    }
}


