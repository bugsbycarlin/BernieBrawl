
Sanders = {}
Sanders.__index = Sanders

function Sanders:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, Sanders)
  candidate.something = 5
  return candidate
end

function Sanders:setSomething(value)
  self.something = value
end

return Sanders