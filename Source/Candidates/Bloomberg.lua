
Bloomberg = {}
Bloomberg.__index = Bloomberg

function Bloomberg:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Bloomberg)
  candidate.something = 5
  return candidate
end

function Bloomberg:setSomething(value)
  self.something = value
end

return Bloomberg