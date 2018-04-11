local Roact = require(game.ReplicatedStorage.Roact)
local Windowing = require(game.ReplicatedStorage.Windowing)

local ITEM_HEIGHT = 64

local ITEMS = {}

for i = 1, 10 do
	local item = {
		text = "Hello, with item " .. i
	}

	ITEMS[i] = item
end

local function renderItem(item)
	return Roact.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, ITEM_HEIGHT),
		Text = item.text,
		BackgroundColor3 = Color3.new(0.9, 0.9, 0.9),
		TextSize = 32,
		Font = Enum.Font.SourceSans,
	})
end

local function App()
	return Roact.createElement("ScreenGui", {}, {
		Container = Roact.createElement("Frame", {
			Size = UDim2.new(0, 400, 0, 300),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		}, {
			Items = Roact.createElement(Windowing.WindowedView, {
				items = ITEMS,
				itemHeight = ITEM_HEIGHT,
				renderItem = renderItem,
			})
		})
	})
end

Roact.reify(Roact.createElement(App), game.Players.LocalPlayer.PlayerGui, "Windowing")