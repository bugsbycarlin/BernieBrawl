
Clinton = {}
Clinton.__index = Clinton

function Clinton:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Clinton)
  candidate.something = 5
  return candidate
end

function Clinton:setSomething(value)
  self.something = value
end

return Clinton