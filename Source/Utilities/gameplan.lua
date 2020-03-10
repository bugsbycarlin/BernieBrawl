
gameplan = {}
gameplan.__index = gameplan

local composer = require( "composer" )


function gameplan:nextRound()
  candidate = composer.getVariable("candidate")

  location_number = composer.getVariable("location_number")
  location_number = location_number + 1
  composer.setVariable("location_number", location_number)

  local candidates = composer.getVariable("candidates")
  local new_candidates = {}
  for i = 1, #candidates do
  	if candidates[i] ~= candidate then
  	  table.insert(new_candidates, candidates[i])
  	end
  end
  if #new_candidates < 1 then
  	new_candidates = {"trump"}
  end
  local opponent = table.remove(new_candidates, math.random(1, #new_candidates))
  composer.setVariable("opponent", opponent)
  composer.setVariable("candidates", new_candidates)

  composer.setVariable("player_wins", 0)
  composer.setVariable("opponent_wins", 0)
  composer.setVariable("round", 1)
end

function gameplan:setup()
  composer.setVariable("candidates", {"warren", "sanders", "biden"})
  composer.setVariable("nicknames", {
    warren="the planner",
    sanders="the populist",
    biden="the smiler",
    buttigieg="the polyglot",
    yang="the founder",
    bloomberg="the money"})
  composer.setVariable("selectable_names", {"biden", "sanders", "warren",})
  composer.setVariable("locations", {
    "Iowa Caucus",
    "New Hampshire Primary",
    "Super Tuesday Helicarrier",
    "White House Battleground"
  })
  composer.setVariable("location_number", 0)

  composer.setVariable("game_scene", "primary")
end

function gameplan:true_setup()
  composer.setVariable("candidates", {"warren", "sanders", "biden", "buttigieg", "yang", "bloomberg"})
  composer.setVariable("nicknames", {
    warren="the planner",
    sanders="the populist",
    biden="the smiler",
    buttigieg="the polyglot",
    yang="the founder",
    bloomberg="the money"})
  composer.setVariable("selectable_names", {"biden", "sanders", "warren",})
  composer.setVariable("locations", {
    "Iowa Caucus",
    "New Hampshire Primary",
    "Super Tuesday",
    "Milwaukee Convention",
    "Salt Lake City VP Debate",
    "South Bend Debate",
    "Nashville Debate",
    "White House Battlegrounds"
  })
  composer.setVariable("location_number", 0)

end

function gameplan:quick_setup(candidate, opponent)
  composer.setVariable("candidate", candidate)
  local remaining_candidates = {}
  local candidates = composer.getVariable("candidates")
  local locations = composer.getVariable("locations")
  for i = 1, #candidates do
    if candidate ~= candidates[i] and opponent ~= candidates[i] then
      table.insert(remaining_candidates, candidates[i])
    end
  end
  composer.setVariable("opponent", opponent)
  composer.setVariable("remaining_candidates", remaining_candidates)
  location = table.remove(locations, 1)
  composer.setVariable("locations", locations)
  composer.setVariable("player_wins", 0)
  composer.setVariable("opponent_wins", 0)
  composer.setVariable("round", 1)
  composer.setVariable("location_number", 1)
end

return gameplan