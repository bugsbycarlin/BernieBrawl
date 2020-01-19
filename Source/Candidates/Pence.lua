
Pence = {}
Pence.__index = Pence

function Pence:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Pence)
  candidate.something = 5
  return candidate
end

function Pence:setSomething(value)
  self.something = value
end

return Pence