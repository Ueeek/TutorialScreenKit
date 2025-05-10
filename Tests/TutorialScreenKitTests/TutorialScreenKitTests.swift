import Testing
import ComposableArchitecture
@testable import TutorialScreenKit
import Foundation

@Suite("TutorialReducer Test")
class TutorialReducerTests {
    let uuid: UUIDGenerator = .constant(UUID(uuidString: "12345678-1234-1234-1234-123456789012")!)
    let tutorials: Int = TutorialData.getTutorials(uuid: .constant(UUID(00000000-0000-0000-0000-000000000000))).count
    
    @MainActor
    @Test func testTapNextButton() async {
        let store = TestStore(initialState: TutorialReducer.State(tutorials: TutorialData.getTutorials(uuid: uuid))) {
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
    
    @MainActor
    @Test func testTapBackButton() async {
        let tutorials: Int = TutorialData.getTutorials(uuid: uuid).count
        
        let store = TestStore(initialState: TutorialReducer.State(tutorials: TutorialData.getTutorials(uuid: uuid), selection: tutorials - 1)) {
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
    
    @MainActor
    @Test func buttonEnable() async {
        let tutorials = TutorialData.getTutorials(uuid: uuid).count
        
        // NextButton
        for i in 0..<tutorials {
            let state = TutorialReducer.State(tutorials: TutorialData.getTutorials(uuid: uuid), selection: i)
            if i == tutorials - 1 {
                #expect(state.isNextButtonEnabled == false)
            } else {
                #expect(state.isNextButtonEnabled == true)
            }
        }
        
        // BackButton
        for i in 0..<tutorials {
            let state = TutorialReducer.State(tutorials: TutorialData.getTutorials(uuid: uuid), selection: i)
            if i == 0 {
                #expect(state.isBackButtonEnabled == false)
            } else {
                #expect(state.isBackButtonEnabled == true)
            }
        }
        
        // SkipButton
        for i in 0..<tutorials {
            let state = TutorialReducer.State(tutorials: TutorialData.getTutorials(uuid: uuid), selection: i)
            if i == tutorials - 1 {
                #expect(state.isSkipButtonEnabled == false)
            } else {
                #expect(state.isSkipButtonEnabled == true)
            }
        }
    }
    
    @MainActor
    @Test func testTapSkipButton() async {
        let isDismissInvoked: LockIsolated<[Bool]> = .init([])
        let store = TestStore(initialState: TutorialReducer.State(tutorials: TutorialData.getTutorials(uuid: uuid), selection: tutorials - 1)) {
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
