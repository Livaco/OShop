--[[// Weapons category.
OShop.CreateCategory("Permanent Weapons", {
  description = "Buy one: Get it forever!",
  color = Color(200, 0, 0, 255)
})

OShop.CreateItem("Pistol", {
  category = "Permanent Weapons",
  itemtype = "perm_weapon",
  class = "weapon_pistol",
  description = "A basic pistol.",
  price = 500
})

OShop.CreateItem("Shotgun", {
  category = "Permanent Weapons",
  itemtype = "perm_weapon",
  class = "weapon_shotgun",
  description = "A shotgun. Great for hunting!",
  price = 1200
})
]]
