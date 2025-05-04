## What
We can create TutorialScreen with small code

## Input
```swift
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

```

## Output

