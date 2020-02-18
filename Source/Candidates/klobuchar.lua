
klobuchar = {}
klobuchar.__index = klobuchar

function klobuchar:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, klobuchar)
  candidate.something = 5
  return candidate
end

function klobuchar:setSomething(value)
  self.something = value
end

return klobuchar