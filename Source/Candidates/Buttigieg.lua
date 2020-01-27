
buttigieg = {}
buttigieg.__index = buttigieg

function buttigieg:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, buttigieg)
  candidate.something = 5
  return candidate
end

function buttigieg:setSomething(value)
  self.something = value
end

return buttigieg