//
//  KeyboardContext.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-06-15.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation
import UIKit

/**
 This protocol can be implemented by any classes that can be
 used to provide the keyboard extension with contextual info.
 */
public protocol KeyboardContext: AnyObject {
    
    @available(*, deprecated, message: "This property will be removed in KK 4. Usage is strongly discouraged.")
    var controller: KeyboardInputViewController { get }
    
    
    // MARK: - Manually set properties
    
    /**
     The current keyboard action handler that can be used to
     handle actions that are triggered by the user or system.
     */
    var actionHandler: KeyboardActionHandler { get set }

    /**
     The emoji category that should be displayed when an app
     switches over to an emoji keyboard.
     */
    var emojiCategory: EmojiCategory { get set }
    
    /**
     The current keyboard input set provider.
     */
    var inputSetProvider: KeyboardInputSetProvider { get set }
    
    /**
     The current keyboard type. You can change this with the
     `changeKeyboardType` function, which lets you specify a
     delay as well.
     */
    var keyboardType: KeyboardType { get set }
    
    
    // MARK: - Synced properties
    
    /**
     The current device orientation.
     */
    var deviceOrientation: UIInterfaceOrientation { get set }
    
    /**
     Whether or not the keyboard extension has a "dictation"
     key. If not, you can provide a custom dictation button.
     */
    var hasDictationKey: Bool { get set }
    
    /**
     Whether or not the keyboard extension has "full access".
     */
    var hasFullAccess: Bool { get set }
    
    /**
     Whether or not the keyboard extension should provide an
     input mode switch key.
     */
    var needsInputModeSwitchKey: Bool { get set }
    
    /**
     The current primary language of the keyboard.
     */
    var primaryLanguage: String? { get set }
    
    /**
     The current text document proxy.
     */
    var textDocumentProxy: UITextDocumentProxy { get set }
    
    /**
     The current text input mode.
     */
    var textInputMode: UITextInputMode? { get set }
    
    /**
     The current trait collection.
     */
    var traitCollection: UITraitCollection { get set }
}


// MARK: - Public Properties

public extension KeyboardContext {
    
    /**
     The current keyboard appearance, which is resolved from
     the `textDocumentProxy`, but has a fallback to `.light`.
     */
    var keyboardAppearance: UIKeyboardAppearance {
        textDocumentProxy.keyboardAppearance ?? .light
    }
}


// MARK: - Public Functions

public extension KeyboardContext {
    
    /**
     This function changes keyboard type, using the standard
     system behavior, where it's not possible to change from
     caps locked keyboards to upper-case ones.
     
     The delay can be used to allow a double-tap action time
     to finish before changing the keyboard.
     */
    func changeKeyboardType(to type: KeyboardType, after delay: DispatchTimeInterval, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard self.keyboardType.canBeReplaced(with: type) else { return }
            self.keyboardType = type
            completion()
        }
    }
    
    /**
     Sync the context with the current state of the keyboard
     input view controller.
     */
    func sync(with controller: UIInputViewController) {
        self.deviceOrientation = controller.deviceOrientation
        self.hasDictationKey = controller.hasDictationKey
        self.hasFullAccess = controller.hasFullAccess
        self.needsInputModeSwitchKey = controller.needsInputModeSwitchKey
        self.primaryLanguage = controller.primaryLanguage
        self.textDocumentProxy = controller.textDocumentProxy
        self.textInputMode = controller.textInputMode
        self.traitCollection = controller.traitCollection
    }
}
