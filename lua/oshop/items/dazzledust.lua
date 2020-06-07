-- Dazzle Dust category.
OShop.CreateCategory("Industrial Supplies", {
  description = "Can be used to make some dazzling product.",
  color = Color(50, 150, 200, 255)
})

OShop.CreateItem("Gas Filter", {
  category = "Industrial Supplies",
  itemtype = "entity",
  class = "zmlab_filter",
  description = "Keeps that parmesan at bay.",
  price = 250
})

OShop.CreateItem("Transport Crate", {
  category = "Industrial Supplies",
  itemtype = "entity",
  class = "zmlab_collectcrate",
  description = "Good for hauling the goods.",
  price = 10
})

OShop.CreateItem("Dazzylamine", {
  category = "Industrial Supplies",
  itemtype = "entity",
  class = "zmlab_methylamin",
  description = "Don't drink it!",
  price = 150
})

OShop.CreateItem("Tinsel", {
  category = "Industrial Supplies",
  itemtype = "entity",
  class = "zmlab_aluminium",
  description = "Very sparkly, but gets everywhere.",
  price = 25
})


OShop.CreateItem("Palette", {
  category = "Industrial Supplies",
  itemtype = "entity",
  class = "zmlab_palette",
  description = "Haul the goods in bulk.",
  price = 10
})
