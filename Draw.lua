
---@class Draw
---@field _enabled boolean
---@field _world World
---@field _line_objects LineObject[]
local Draw = class("Draw")

---@param self Draw
---@param world World Get with `Managers.world:world("level_world"))`
Draw.init = function(self, world)
	self._world = world
	self._enabled = true
    self._line_objects = {}
end

---@param self Draw
---@return LineObject?
Draw.create_line = function(self)
    local line_object = World.create_line_object(self._world)
    if line_object then
        self._line_objects[#self._line_objects + 1] = line_object
    end
    return line_object
end

---@param self Draw
Draw.enable = function(self)
	self._enabled = true
end

---@param self Draw
Draw.disable = function(self)
	self._enabled = false
end

---@param self Draw
Draw.update = function(self)
	if self._enabled then
        for _, line_object in ipairs(self._line_objects) do
            LineObject.reset(line_object)
        end
    end
end

---@param self Draw
---@param from Vector3
---@param to Vector3
---@param color Vector4? ARGB. Default: White (255, 255, 255, 255)
---@return LineObject?
Draw.line = function(self, from, to, color)
	color = color or Color(255, 255, 255)

    local line_object = self:create_line()
    if line_object then
        LineObject.add_line(line_object, color, from, to)
    end
    return line_object
end

---@param self Draw
---@param center Vector3
---@param radius integer
---@param color Vector4? ARGB. Default: White (255, 255, 255, 255)
---@param segments integer? Default: 20
---@param parts integer? Default: 2
---@return LineObject?
Draw.sphere = function(self, center, radius, color, segments, parts)
	color = color or Color(255, 255, 255)
    segments = segments or 20
    parts = parts or 2

    local line_object = self:create_line()
    if line_object then
        LineObject.add_sphere(line_object, color, center, radius, segments, parts)
    end
    return line_object
end

---@param self Draw
---@param from Vector3
---@param to Vector3
---@param radius integer
---@param color Vector4?
---@param segments integer? Default: 20
---@param circles integer? Default: 4
---@param bars integer? Default: 10
---@return LineObject?
Draw.capsule = function(self, from, to, radius, color, segments, circles, bars)
	color = color or Color(255, 255, 255)
    segments = segments or 20
    circles = circles or 4
    bars = bars or 10

    local line_object = self:create_line()
    if line_object then
        LineObject.add_capsule(line_object, color, from, to, radius, segments, circles, bars)
    end
    return line_object
end

return Draw