
bloomberg = {}
bloomberg.__index = bloomberg

function bloomberg:create(x, y, group)
  local candidate = {}
  setmetatable(candidate, bloomberg)
  candidate.something = 5
  return candidate
end

function bloomberg:setSomething(value)
  self.something = value
end

return bloomberg