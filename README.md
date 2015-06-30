
# Framer `Label` module

![screenshot](./screenshot.png)

Create a layer that is the intrinsic size (height and width) of the text content
it contains. There is also support for single/multi-line truncation when
constraining the label’s `width`.

## Usage
```shell
$ cd <myProject>.framer
$ npm install framer-label
```

modules/myModule.coffee:
```coffeescript
exports.Label = require "framer-label"
```

app.coffee:
```javascript
{Label} = require "myModule"

new Label
  text: "My amazing label"
  width: 100
  lineNumber: 2
```

## TODO

- Add `Layer#text` and `Layer#lineNumber` API

## License
The MIT License (MIT)

Copyright (c) 2015 Pete Schaffner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
