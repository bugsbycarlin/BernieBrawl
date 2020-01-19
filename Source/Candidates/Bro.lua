
Bro = {}
Bro.__index = Bro

function Bro:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Bro)
  candidate.something = 5
  return candidate
end

function Bro:setSomething(value)
  self.something = value
end

return Bro