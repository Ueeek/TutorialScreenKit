//
//  TutorialView.swift
//  CleanAI
//
//  Created by KoichiroUeki on 2025/03/30.
//

import ComposableArchitecture
import SwiftUI

public struct TutorialViewConfiguration {
    var backgroundColor: Color
    var tintColor: Color
    var textProvider: (LocalizedStringKey) -> Text
}

public struct TutorialView: View {
    var store: StoreOf<TutorialReducer>
    var configuration: TutorialViewConfiguration
    
    public var body: some View {
        TutorialPageView(
            store: store,
            textViewProvider: configuration.textProvider,
            tintColor: configuration.tintColor
        )
            .safeAreaInset(edge: .top, alignment: .trailing) {
                TopButton(
                    onTap: {
                        store.send(.skipButtonTapped, animation: .easeInOut)
                    }, isSkipButtonEnabled: store.isSkipButtonEnabled, tintColor: configuration.tintColor
                )
            }
            .safeAreaInset(edge: .bottom) {
                BottomButtons(store: store, tintColor: configuration.tintColor)
            }
            .onAppear {
                store.send(.appear)
            }
            .frame(maxWidth: .infinity)
            .background(configuration.backgroundColor)
    }
}

private struct TopButton: View {
    var onTap: () -> Void
    var isSkipButtonEnabled: Bool
    var tintColor: Color

    var body: some View {
        Button(isSkipButtonEnabled ? "Skip": "Close") {
            onTap()
        }
        .buttonStyle(.borderedProminent)
        .tint(tintColor)
        .padding(.trailing, 30)
    }
}

private struct BottomButtons: View {
    var store: StoreOf<TutorialReducer>
    var tintColor: Color

    var body: some View {
        HStack(spacing: 30) {
            Button {
                store.send(.backButtonTapped, animation: .easeInOut)
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(
                        Circle()
                    )
            }
            .tint(tintColor)
            .disabled(!store.isBackButtonEnabled)

            Button {
                store.send(.nextButtonTapped, animation: .easeInOut)
            } label: {
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(
                        Circle()
                    )

            }
            .tint(tintColor)
            .disabled(!store.isNextButtonEnabled)
        }
    }
}

struct TutorialPageView: View {
    @Bindable var store: StoreOf<TutorialReducer>
    
    var textViewProvider: (LocalizedStringKey) -> Text
    var tintColor: Color

    var body: some View {
        TabView(selection: $store.selection) {
            ForEach(Array(store.tutorials.enumerated()), id: \.offset) { index, tutorial in
                TutorialStepView(
                    item: tutorial,
                    textViewProvider: textViewProvider,
                    tintColor: tintColor
                )
                    .tag(index)
            }
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

private struct TutorialStepView: View {
    let item: TutorialData
    var textViewProvider: (LocalizedStringKey) -> Text
    var tintColor: Color

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            textViewProvider(item.title)
                .font(.title)
            Spacer()
            Text(item.description)
                .font(.title2)
            Spacer()
            item
                .image
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(height: 100)
                .foregroundStyle(tintColor)
            Spacer()
        }
    }
}
