//
//  KeyboardAwakeModifier.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 01/01/24.
//

import SwiftUI

struct KeyboardAwareModifier: ViewModifier {
    @State private var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, currentHeight)
            .onAppear(perform: subscribeToKeyboardEvents)
    }

    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                currentHeight = keyboardSize.height
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            currentHeight = 0
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


