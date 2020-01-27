
clinton = {}
clinton.__index = clinton

function clinton:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, clinton)
  candidate.something = 5
  return candidate
end

function clinton:setSomething(value)
  self.something = value
end

return clinton