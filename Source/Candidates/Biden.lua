
Biden = {}
Biden.__index = Biden

function Biden:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Biden)
  candidate.something = 5
  return candidate
end

function Biden:setSomething(value)
  self.something = value
end

return Biden