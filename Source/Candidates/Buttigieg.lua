
Buttigieg = {}
Buttigieg.__index = Buttigieg

function Buttigieg:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Buttigieg)
  candidate.something = 5
  return candidate
end

function Buttigieg:setSomething(value)
  self.something = value
end

return Buttigieg