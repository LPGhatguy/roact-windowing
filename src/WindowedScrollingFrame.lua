local Roact = require(script.Parent.Parent.Roact)

local WindowedScrollingFrame = Roact.PureComponent:extend("WindowedScrollingFrame")

function WindowedScrollingFrame:init()
	self.state = {
		viewStart = 1,
		viewSize = 1,
		paddingStart = 0,
	}

	self.scrollViewRef = function(rbx)
		self.scrollView = rbx
	end

	self.updateViewBoundsCallback = function(...)
		return self:updateViewBounds(...)
	end
end

function WindowedScrollingFrame:updateViewBounds()
	if not self.scrollView then
		return
	end

	local sizeY = self.scrollView.AbsoluteWindowSize.Y
	local offsetY = self.scrollView.CanvasPosition.Y

	-- If our scrolling frame has zero height, let's not bother trying to
	-- recompute our sizing
	if sizeY == 0 then
		return
	end

	local viewSize = math.ceil(sizeY / self.props.itemHeight) + 1
	local viewStart = math.floor(offsetY / self.props.itemHeight)

	local paddingStart = math.max(0, (viewStart - 1) * self.props.itemHeight)

	self:setState({
		viewStart = viewStart,
		viewSize = viewSize,
		paddingStart = paddingStart,
	})
end

function WindowedScrollingFrame:render()
	local items = self.props.items
	local itemHeight = self.props.itemHeight
	local renderItem = self.props.renderItem

	local children = {}

	children["$Layout"] = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	children["$Padding"] = Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, self.state.paddingStart)
	})

	local lowerBound = math.max(1, self.state.viewStart)
	local upperBound = math.min(#items, self.state.viewStart + self.state.viewSize)

	for i = lowerBound, upperBound do
		children[i] = renderItem(items[i], i)
	end

	return Roact.createElement("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(1, 0, 0, #items * itemHeight),

		[Roact.Ref] = self.scrollViewRef,
		[Roact.Change.CanvasPosition] = self.updateViewBoundsCallback,
		[Roact.Change.AbsoluteSize] = self.updateViewBoundsCallback,
	}, children)
end

function WindowedScrollingFrame:didMount()
	self:updateViewBounds()
end

function WindowedScrollingFrame:didUpdate(prevProps, prevState)
	if self.props == prevProps then
		return
	end

	self:updateViewBounds()
end

return WindowedScrollingFrame