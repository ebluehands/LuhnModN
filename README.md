# LuhnModN

This is an implementation of the [Luhn mod N algorithm](https://en.wikipedia.org/wiki/Luhn_mod_N_algorithm) in Swift.

Features : 

* Add the check digit to a string
* Check the validity of a string
* Works in mod 2 to 36

## Installation

### Cocoapods
[CocoaPods](https://github.com/CocoaPods/CocoaPods) is a dependency manager for Cocoa projects. You can install it with the following command:

`$ gem install cocoapods`

To integrate LuhnModN into your Xcode project using CocoaPods, add this line in your Podfile:

```
pod 'LuhnModN'
```

## Usage

### Add the check digit

By default the mod is 10 because it's the most used.

```swift
let visa = try? LuhnModN.addCheckCharacter(to: "401288888888188")
```
To use another modulo, simply add it as parameter :

```swift
let hexaString = try? LuhnModN.addCheckCharacter(to: "1450c2697d3a4925a1ec59f5dd3a9956", withModulo: 16)
```

### Errors

There are two possible errors :

```swift
enum LuhnError: Error {
    case invalidCharacters
    case moduloOutOfRange
}
```

### Check the validity

By default the mod is 10 because it's the most used.

```swift
LuhnModN.isValid("4012888888881881")
```

To use another modulo, simply add it as parameter :

```swift
LuhnModN.isValid("1450c2697d3a4925a1ec59f5dd3a9956b", withModulo : 16)
```

## License

The MIT License (MIT)

Copyright (c) 2015 Arnaud Bultot

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
