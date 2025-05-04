//
//  File.swift
//  TutorialScreenKit
//
//  Created by KoichiroUeki on 2025/05/04.
//

import ComposableArchitecture
import SwiftUI

extension TutorialData {
    static func getTutorials(uuid: UUIDGenerator) -> [TutorialData] {
        return [
            .init(
                id: uuid(),
                title: "Welcome to CleanAI",
                description: "Cleaning made easy! Just take a photo, and we’ll suggest the best cleaning method for you.",
                image: Image("LaunchImage")
            ),
            .init(
                id: uuid(),
                title: "Take a photo",
                description: "Capture an image of the area you want to clean. Our AI will automatically identify the objects.",
                image: Image(systemName: "camera")
            ),
            .init(
                id: uuid(),
                title: "AI Analysis",
                description: "Our AI analyzes the photo and determines what needs to be cleaned.",
                image: Image(systemName: "brain.head.profile")
            ),
            .init(
                id: uuid(),
                title: "Get Cleaning suggestions",
                description: "We’ll provide the best cleaning methods along with the necessary tools.",
                image: Image(systemName: "bubbles.and.sparkles.fill")
            ),
            .init(
                id: uuid(),
                title: "Unock more with Premium",
                description: "Enjoy high-precision AI, detailed cleaning guides, and unlimited usage with our premium plan.",
                image: Image(systemName: "crown")
            )
        ]
    }
}
