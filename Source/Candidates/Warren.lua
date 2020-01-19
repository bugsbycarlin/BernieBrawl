
Warren = {}
Warren.__index = Warren

function Warren:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Warren)
  candidate.something = 5
  return candidate
end

function Warren:setSomething(value)
  self.something = value
end

return Warren