local Roact = require(script.Parent.Parent.Roact)

local WindowedView = Roact.PureComponent:extend("WindowedView")

function WindowedView:init()
	self.state = {}

	self.scrollViewRef = function(rbx)
		self.scrollView = rbx
	end
end

function WindowedView:render()
	local items = self.props.items
	local itemHeight = self.props.itemHeight
	local renderItem = self.props.renderItem

	local children = {}

	children["$Layout"] = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	for key, item in ipairs(items) do
		children[key] = renderItem(item)
	end

	return Roact.createElement("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(1, 0, 0, #items * itemHeight)
	}, children)
end

return WindowedView