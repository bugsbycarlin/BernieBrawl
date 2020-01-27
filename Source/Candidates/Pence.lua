
pence = {}
pence.__index = pence

function pence:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, pence)
  candidate.something = 5
  return candidate
end

function pence:setSomething(value)
  self.something = value
end

return pence