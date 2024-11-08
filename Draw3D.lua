
---@class Draw3D
---@field _enabled boolean
---@field _world World
---@field _line_objects LineObject[]
local Draw3D = class("Draw3D")

---@param self Draw
---@param world World e.g `Managers.world:world("level_world"))`
Draw3D.init = function(self, world)
	self._world = world
	self._enabled = true
    self._line_objects = {}
end

---@param self Draw
---@return LineObject?
Draw3D.create_line = function(self)
    local line_object = World.create_line_object(self._world)
    if line_object then
        self._line_objects[#self._line_objects + 1] = line_object
    end
    return line_object
end

---@param self Draw
Draw3D.enable = function(self)
	self._enabled = true
end

---@param self Draw
Draw3D.disable = function(self)
	self._enabled = false
end

---@param self Draw
Draw3D.update = function(self)
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
Draw3D.line = function(self, from, to, color)
	color = color or Color(255, 255, 255)

    local line_object = self:create_line()
    if line_object then
        LineObject.add_line(line_object, color, from, to)
    end
    return line_object
end

---@param self Draw
---@param center Vector3
---@param radius number
---@param color Vector4? ARGB. Default: White (255, 255, 255, 255)
---@param segments integer? Default: `20`
---@param parts integer? Default: `2`
---@return LineObject?
Draw3D.sphere = function(self, center, radius, color, segments, parts)
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
---@param radius number
---@param color Vector4? ARGB. Default: White (255, 255, 255, 255)
---@param segments integer? Default: `20`
---@param circles integer? Default: `4`
---@param bars integer? Default: `10`
---@return LineObject?
Draw3D.capsule = function(self, from, to, radius, color, segments, circles, bars)
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

---@param self Draw
---@param pose Matrix4x4
---@param extents Vector3
---@param color Vector4 ARGB. Default: White (255, 255, 255, 255)
---@return LineObject?
Draw3D.box = function(self, pose, extents, color)
	color = color or Color(255, 255, 255)

    local line_object = self:create_line()
    if line_object then
        LineObject.add_box(line_object, pose, extents)
    end
    return line_object
end

---@param self Draw
---@param center Vector3 The center point of the circle.
---@param radius number The radius of the circle.
---@param normal Vector3 The normal vector
---@param color Vector4? ARGB. Default: White (255, 255, 255, 255)
---@param segments integer? The number of line segments that will be used to draw the circle. Default: `20`
---@return LineObject?
Draw3D.circle = function(self, center, radius, normal, color, segments)
	color = color or Color(255, 255, 255)
    segments = segments or 20

    local line_object = self:create_line()
    if line_object then
        LineObject.add_circle(line_object, color, center, radius, normal, segments)
    end
    return line_object
end

---@param self Draw
---@param from Vector3
---@param to Vector3
---@param radius number
---@param color Vector4? ARGB. Default: White (255, 255, 255, 255)
---@param segments integer? Default: `20`
---@param bars integer? Default: `10`
---@return LineObject?
Draw3D.cone = function(self, from, to, radius, color, segments, bars)
	color = color or Color(255, 255, 255)
    segments = segments or 20
    bars = bars or 10

    local line_object = self:create_line()
    if line_object then
        LineObject.add_cone(line_object, color, from, to, radius, segments, bars)
    end
    return line_object
end

---Dispatch all line objects
---@param self Draw
Draw3D.destroy_all = function(self)
	for index, line_object in ipairs(self._line_objects) do
        LineObject.dispatch(self._world, line_object)
        table.remove(self._line_objects, index)
    end
end

return Draw3D