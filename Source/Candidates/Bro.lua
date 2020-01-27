
bro = {}
bro.__index = bro

function bro:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, bro)
  candidate.something = 5
  return candidate
end

function bro:setSomething(value)
  self.something = value
end

return bro