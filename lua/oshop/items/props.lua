--[[// Props category.

OShop.CreateCategory("Props", {
  description = "Make cool stuff!",
  color = Color(0, 0, 200, 255)
})

OShop.CreateItem("Blue Barrel", {
  category = "Props",
  itemtype = "prop",
  class = "models/props_borealis/bluebarrel001.mdl",
  description = "A blue barrel!",
  price = 500
})

OShop.CreateItem("Fridge", {
  category = "Props",
  itemtype = "prop",
  class = "models/props_c17/FurnitureFridge001a.mdl",
  description = "Freeze stuff!",
  price = 500
})
]]
