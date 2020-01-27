
sanders = {}
sanders.__index = sanders

function sanders:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, sanders)
  candidate.something = 5
  return candidate
end

function sanders:setSomething(value)
  self.something = value
end

return sanders