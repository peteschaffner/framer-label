
module.exports = class Label extends Layer
  constructor: (opts={}) ->
    opts.name ?= "label"
    opts.text ?= "Label Text"
    opts.lineHeight ?= "normal"
    opts.lineNumber ?= 1
    opts.backgroundColor ?= "transparent"
    opts.color ?= "black"

    # remove `Layer` properties
    style = _.omit opts, (value, prop) -> Layer.prototype.hasOwnProperty prop

    # add 'px' suffix when appropriate
    style = _.mapValues style, (value, prop) ->
      if typeof value is 'number' and
      unitlessNumbers.indexOf(prop) is -1
      then value += 'px'
      else value

    # width constraint
    constraints = {}
    constraints.width = opts.width if opts.width

    # reset cached `width` on `_textSizeNode` if it exists
    # TODO: this is brittle ... consider suggesting a change upstream
    document.getElementById("_textSizeNode")?.style.width = ""

    # get computed size
    size = Utils.textSize opts.text, _.clone(style)

    # ...and now with constraints (if they exist)
    constrainedSize = Utils.textSize opts.text, _.clone(style), constraints

    # cap the `height` when more `lineNumber`s than intrinsic height
    if opts.lineNumber * size.height > constrainedSize.height
      opts.height = constrainedSize.height
      opts.lineNumber = Utils.round constrainedSize.height / size.height 
    else
      opts.height = opts.lineNumber * size.height

    # append a non-breaking space to correct
    # truncation for the last word in the string
    opts.text = if opts.width then opts.text + " \xA0" else opts.text

    super _.extend opts,
      width: opts.width || size.width
      html: opts.text
      # add multi-line truncation styles
      style: _.extend style,
        display: '-webkit-box'
        webkitBoxOrient: 'vertical'
        overflow: 'hidden'
        textOverflow: 'ellipsis'
        webkitLineClamp: opts.lineNumber

  # TODO: implement getters/setters for `text` and `lineNumber`
  #       This will require abstracting a lot of construction logic
  #       into an update function of sorts.

  # @define "text",
  #   get: -> @_text
  #   set: (value) ->
  #     @_text = value.replace " \xA0", ""
  #     @html = @_text

# CSS properties which accept numbers but are not in units of "px".
# Taken from facebook/react: http://git.io/vt1XW
unitlessNumbers = [
  "boxFlex"
  "boxFlexGroup"
  "columnCount"
  "flex"
  "flexGrow"
  "flexPositive"
  "flexShrink"
  "flexNegative"
  "fontWeight"
  "lineClamp"
  "lineHeight"
  "opacity"
  "order"
  "orphans"
  "tabSize"
  "widows"
  "zIndex"
  "zoom"
  # SVG-related properties
  "fillOpacity"
  "strokeDashoffset"
  "strokeOpacity"
  "strokeWidth"
]

