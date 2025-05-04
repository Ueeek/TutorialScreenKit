//
//  TutorialReducer.swift
//  CleanAI
//
//  Created by KoichiroUeki on 2025/03/30.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
public struct TutorialReducer {
    @ObservableState
    public struct State: Equatable {
        // Can be used to show tutorial only once.
        @Shared(.appStorage("hasShownTutorial")) var hasShownTutorial: Bool = false

        var selection: Int = 0
        var tutorials: [TutorialData]

        var isSkipButtonEnabled: Bool {
            selection < tutorials.count - 1
        }

        var isNextButtonEnabled: Bool {
            selection < tutorials.count - 1
        }

        var isBackButtonEnabled: Bool {
            selection > 0
        }
    }

    public enum Action: BindableAction, Sendable {
        case nextButtonTapped
        case backButtonTapped
        case skipButtonTapped
        case binding(BindingAction<State>)
        case appear
    }

    @Dependency(\.dismiss) var dismiss
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .nextButtonTapped:
                if state.selection < state.tutorials.count - 1 {
                    state.selection += 1
                }
                return .none
            case .backButtonTapped:
                if state.selection > 0 {
                    state.selection -= 1
                }
                return .none
            case .skipButtonTapped:
                return .run {[dismiss] _ in
                    await dismiss(animation: .default)
                }
            case .appear:
                state.$hasShownTutorial.withLock { $0 = true }
                return .none
            }
        }
    }
}
