//
//  TutorialData.swift
//  CleanAI
//
//  Created by KoichiroUeki on 2025/03/30.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct TutorialData: Equatable, Identifiable {
    public var id: UUID
    var title: LocalizedStringKey
    var description: LocalizedStringKey
    var image: Image
    
    public init(id: UUID, title: LocalizedStringKey, description: LocalizedStringKey, image: Image) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
    }
}
