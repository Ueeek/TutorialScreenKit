import Testing
@testable import TutorialScreenKit

import Foundation
import Testing
import UIKit
import ComposableArchitecture
@testable import CleanAI

@Suite("TutorialReducer Test")
class TutorialReducerTests {
    let uuid: UUIDGenerator = .constant(UUID(uuidString: "12345678-1234-1234-1234-123456789012")!)
    let tutorials: Int = TutorialData.getTutorials(uuid: .constant(UUID(00000000-0000-0000-0000-000000000000))).count
    
    @Test func testTapNextButton() async {
        let store = await TestStore(initialState: TutorialReducer.State(tutorials: TutorialData.getTutorials(uuid: uuid))) {
            TutorialReducer()
        }
        
        for i in 1..<tutorials {
            await store.send(.nextButtonTapped) { [i] in
                $0.selection = i
            }
        }
        
        // Tap next button on the last tutorial
        await store.send(.nextButtonTapped)
    }
    
    @Test func testTapBackButton() async {
        let tutorials: Int = TutorialData.getTutorials(uuid: uuid).count
        
        let store = await TestStore(initialState: TutorialReducer.State(selection: tutorials - 1, tutorials: TutorialData.getTutorials(uuid: uuid))) {
            TutorialReducer()
        }
        
        for i in 1..<tutorials {
            await store.send(.backButtonTapped) {[i, tutorials] in
                $0.selection = tutorials - i - 1
            }
        }
        
        // Tap back button on the first tutorial
        await store.send(.backButtonTapped)
    }
    
    @Test func buttonEnable() async {
        let tutorials = TutorialData.getTutorials(uuid: uuid).count
        
        // NextButton
        for i in 0..<tutorials {
            let state = TutorialReducer.State(selection: i, tutorials: TutorialData.getTutorials(uuid: uuid))
            if i == tutorials - 1 {
                #expect(state.isNextButtonEnabled == false)
            } else {
                #expect(state.isNextButtonEnabled == true)
            }
        }
        
        // BackButton
        for i in 0..<tutorials {
            let state = TutorialReducer.State(selection: i, tutorials: TutorialData.getTutorials(uuid: uuid))
            if i == 0 {
                #expect(state.isBackButtonEnabled == false)
            } else {
                #expect(state.isBackButtonEnabled == true)
            }
        }
        
        // SkipButton
        for i in 0..<tutorials {
            let state = TutorialReducer.State(selection: i, tutorials: TutorialData.getTutorials(uuid: uuid))
            if i == tutorials - 1 {
                #expect(state.isSkipButtonEnabled == false)
            } else {
                #expect(state.isSkipButtonEnabled == true)
            }
        }
    }
    
    @Test func testTapSkipButton() async {
        let isDismissInvoked: LockIsolated<[Bool]> = .init([])
        let store = await TestStore(initialState: TutorialReducer.State(selection: tutorials - 1, tutorials: TutorialData.getTutorials(uuid: uuid))) {
            TutorialReducer()
        } withDependencies: {
            $0.dismiss = DismissEffect {
                isDismissInvoked.withValue {
                    $0.append(true)
                }
            }
        }
        
        await store.send(.skipButtonTapped)
        #expect(isDismissInvoked.value == [true])
    }
}
