
yang = {}
yang.__index = yang

function yang:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, yang)
  candidate.something = 5
  return candidate
end

function yang:setSomething(value)
  self.something = value
end

return yang