--[[// Weapons category.
OShop.CreateCategory("Weapons", {
  description = "Bang Bang!",
  color = Color(200, 0, 0, 255)
})

OShop.CreateItem("357 Magnum", {
  category = "Weapons",
  itemtype = "weapon",
  class = "weapon_357",
  description = "A classic Magnum.",
  price = 200
})

OShop.CreateItem("SMG", {
  category = "Weapons",
  itemtype = "weapon",
  class = "weapon_smg1",
  description = "A sub-machine gun.",
  price = 400
})

OShop.CreateItem("RPG", {
  category = "Weapons",
  itemtype = "weapon",
  class = "weapon_rpg",
  description = "A rocket propelled grenade.",
  price = 1000
})
]]
