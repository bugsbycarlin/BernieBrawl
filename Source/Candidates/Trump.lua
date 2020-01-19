
Trump = {}
Trump.__index = Trump

function Trump:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Trump)
  candidate.something = 5
  return candidate
end

function Trump:setSomething(value)
  self.something = value
end

return Trump