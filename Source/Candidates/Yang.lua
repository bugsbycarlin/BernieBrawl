
Yang = {}
Yang.__index = Yang

function Yang:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Yang)
  candidate.something = 5
  return candidate
end

function Yang:setSomething(value)
  self.something = value
end

return Yang