// Entities category.

OShop.CreateCategory("Entities", {
  description = "Do Cool Stuff!",
  color = Color(0, 200, 0, 255)
})

OShop.CreateItem("Bouncy Ball", {
  category = "Entities",
  itemtype = "entity",
  class = "sent_ball",
  setowning_ent = false,
  description = "Bouncy!",
  price = 50
})

OShop.CreateItem("Helicopter Bomb", {
  category = "Entities",
  itemtype = "entity",
  class = "grenade_helicopter",
  setowning_ent = false,
  description = "Bang! Explode anyone you want!",
  price = 128000000
})