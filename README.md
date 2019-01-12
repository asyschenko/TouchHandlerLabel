# TouchHandlerLabel

## Usage

```swift
let label = TouchHandlerLabel()
let simpleTextHandler = SimpleTextTouchHandler(text: "text") { (_, str) in
            print("Simple text:", str)
}

label.text = "Test text"

simpleTextHandler.normalColor = UIColor.red
simpleTextHandler.selectedColor = UIColor.red.withAlphaComponent(0.5)
label.add(touchHandler: simpleTextHandler)
```

More examples tou can find in TouchHandlerLabelExample
