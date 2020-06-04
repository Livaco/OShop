-- Other category.

OShop.CreateCategory("Other", {
  description = "Lots of other fancy things here.",
  color = Color(0, 200, 0, 255)
})

OShop.CreateItem("Big Battery", {
  category = "Other",
  itemtype = "entity",
  class = "tierp_battery",
  setowning_ent = false,
  description = "Looks like it would be compatible with the industrial printer!",
  price = 500
})
