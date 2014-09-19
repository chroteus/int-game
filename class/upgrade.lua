Upgrade = Button:subclass "Upgrade"

function Upgrade:initialize(arg)
	self.text = tostring(arg.name) or "Undefined name"
	self.desc = tostring(arg.desc) or "Undefined desc"
	self.cost = tonumber(arg.cost) or error("No cost defined")
	self.upg_func = function(self, level) arg.func(self, level) end
	self.func = function() self:upgrade() end
									
	self.max_level = max_level or 10
	
	self.width  = arg.width  or 140
	self.height = arg.height or 60
	self.level = 0
	
	Button.initialize(self, 0,0, self.width, self.height, 
					 self.text, self.func)
end

function Upgrade:upgrade()
	if self.level + 1 > self.max_level and not self.tricked then
		
		local show = false
		
		if not self.tricked then
			DialogBoxes:new("Maximum level reached!",
							{"Unacceptable!", function() 
									 DialogBoxes:new(
										"Well, for triple the price, "..
										"we can upgrade disregarding"..
										" the level cap.\n *the merchant "..
										"is rubbing his hands*",
										{"Cancel", dbox2},
										{"Upgrade", function()
											self.tricked = true
											self.cost = self.cost*3
											
											self:upgrade()
										end}
									 
									 ):show()
								 end
							
							},
							{"OK", function() end}
			):show()
		end
	else
		if Player.money - self.cost >= 0 then
			if disregard then self.max_level = self.max_level+1 end
			self.level = self.level + 1
			self.upg_func(self, self.level)
			Player.money = Player.money - self.cost
		else
			DialogBoxes:new("Not enough money!",
							{"OK", function() end}):show()
		end
	end
end

function Upgrade:draw()
	Button.draw(self)
	
	local PADDING = 5
	local barH = 10
	
	if not self.tricked then
		love.graphics.setColor(guiColors.bg)
		love.graphics.rectangle("fill", self.x+2,self.y+self.height-barH-1,self.width-4,barH)
		--love.graphics.setColor(guiColors.fg)
		love.graphics.rectangle("fill", self.x+2,self.y+self.height-barH-1, 
								((self.width-4)/self.max_level)*self.level,barH)
	else
		love.graphics.setColor(guiColors.fg)
		love.graphics.setFont(gameFont[12])
		love.graphics.printf("Level: " .. self.level, self.x,
							self.y+self.height-PADDING*4, 
							self.width-PADDING, "center")
							
		love.graphics.setFont(gameFont["default"])
	end
	
	love.graphics.setColor(255,255,255)
	
	if checkCol(the.mouse, self) then
		guiInfoBox(the.mouse.x, the.mouse.y, self.text 
					.. " ("..self.cost.."G)",self.desc)
	end
end
	
		
		
	
