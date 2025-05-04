//
//  File.swift
//  TutorialScreenKit
//
//  Created by KoichiroUeki on 2025/05/04.
//

import ComposableArchitecture
import SwiftUI

#Preview {
    let configuration: TutorialViewConfiguration = .init(
        backgroundColor: .gray.opacity(0.5),
        tintColor: .blue,
        textProvider: { key in
            Text(key)
                .foregroundStyle(.blue)
        })
    
    TutorialView(
        store: .init(
            initialState: .init( tutorials: TutorialData.getTutorials(uuid: .incrementing)),
            reducer: {
                TutorialReducer()
            }
        ),
        configuration: configuration
    )
}
