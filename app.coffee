
aliasProperty = (property, alias) ->
	get: -> @[property]
	set: (value) ->
		@[property] = value
		@emit "change:#{alias}", value

class Label extends Layer
	constructor: (opts={}) ->
		opts.text ?= "Label Text"
		opts.lineHeight ?= "normal"
		opts.backgroundColor ?= "transparent"
		opts.color ?= "black"

		@_constrained = true if opts.maxWidth

		super _.extend opts,
			# add multi-line truncation styles
			style:
				display: '-webkit-box'
				webkitBoxOrient: 'vertical'
				overflow: 'hidden'
				textOverflow: 'ellipsis'
				webkitLineClamp: opts.lineNumber
		
		# size layer
		@update()

	update: ->
		style =
			lineHeight: @style.lineHeight
			textTransform: @style.textTransform
			letterSpacing: @style.letterSpacing
			fontFamily: @style.fontFamily
			fontStyle: @style.fontStyle
			fontVariant: @style.fontVariant
			fontSize: @style.fontSize
			fontWeight: @style.fontWeight
		
		# width constraint
		constraints = {}
		constraints.width = @maxWidth if @_constrained

		# get computed size
		size = Utils.textSize @text, _.clone(style)

		# ...and now with constraints (if they exist)
		constrainedSize = Utils.textSize @text, _.clone(style), constraints
		
		# set width
		@width = Math.min size.width, constrainedSize.width
		
		# remove non-breaking space character
		# if less than or equal to `maxWidth`
		@html = @html.replace " &nbsp;", "" if size.width <=
			constrainedSize.width
		
		# cap the `height` when more `lineNumber`s than intrinsic height
		if !@lineNumber or @lineNumber * size.height > constrainedSize.height
			@height = constrainedSize.height
		else
			@height = @lineNumber * size.height

	@define "maxWidth",
		get: -> @_maxWidth
		set: (value) ->
			@_maxWidth = value
			@_constrained = if value then true else false
			@update()
			@emit "change:maxWidth", value
	
	@define "text",
		get: -> @_text?.replace " \xA0", ""
		set: (value) ->
			@_text = value
			# append a non-breaking space to correct
			# truncation for the last word in the string
			@html = if @_constrained then "#{value} \xA0" else value
			@update()
			@emit "change:text", value
	
	@define "lineCount",
		get: -> @_lineCount
		set: (value) ->
			@_lineCount = value
			@style.webkitLineClamp = if value then value else ""
			@update()
			@emit "change:lineCount", value

# set aliases for `lineCount`
for alias in ["numberOfLines", "lineNumber", "lineClamp"]
	Label.define alias, aliasProperty "lineCount", alias

# create getters/setters for all typography-related style props
# thant aren't already `Layer` properties
_.keys document.createElement("div").style
	.filter (prop) ->
		/^font|text|letter|line/.test(prop) and
		!Layer.prototype.hasOwnProperty(prop)
	.forEach (prop) ->
		Label.define prop,
			get: ->
				p = @style[prop].replace "px", ""
				if isNaN p then p else +p
			set: (value) ->
				# add 'px' suffix when appropriate
				@style[prop] = if typeof value is "number" and
					unitlessNumbers.indexOf(prop) is -1
					then "#{value}px" else value
				@emit "change:#{prop}", value

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

module?.exports = Label
