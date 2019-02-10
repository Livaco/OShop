This file will show you how to create your own items in the addon, and if you are a Addon Developer, how to add OShop support for your addon. This file also shows the Console Commands the addon has.

-------------------------------------------[[General Configuration]]-------------------------------------------

OShop has an IN-GAME configuration menu. The only file stuff you should be changing is the usergroups able to use it, in the previous config file, and your items (more on that bellow). Everything else is done inside of the menu, called by using !oshop_config

-------------------------------------------[[Console Commands]]-------------------------------------------

OShop comes with a few Console Commands to make life easier. These are mainly for Permanent Weapon managment, but you can still use them. Note that everywhere a Player Name is required, requires the player to be online.

oshop_clearallpermas = Removes all perma weapons from every player.
oshop_unbindweapon <Player Name> <Weapon Class> = Removes the specified class from the player's permanent weapons.
oshop_assignweapon <Player Name> <Weapon Class> = Assigns a permanent weapon to the player.

-------------------------------------------[[Adding an item to your server]]-------------------------------------------

To add an item to your server is quite easy, go into lua/oshop/items and create a .lua file called whatever you want. You can also modify the existing ones, or remove them if you don't want them.
First, your going to need a category to put your items into. It's done like this:

OShop.CreateCategory("Test Category", {
  description = "This is a test category",
  color = Color(200, 0, 0)
})

A breakdown of it:

OShop.CreateCategory("[A]", {
  description = "[B]",
  color = Color([C], [D], [E])
})

A = The name of the category, set this to whatever you want, although keep a note of it, as you will need it.
B = The descrption of the category, simply used for display purposes.
C,D,E = R,G,B values for the color. If you don't know how to use RGB, you can read the first few paragraphs here to see a little more: https://www.cs.utah.edu/~germain/PPS/Topics/color.html

Now that we have created the category, we can add the item, done like so:

OShop.CreateItem("Stunstick", {
  category = "Test Category",
  itemtype = "weapon",
  class = "weapon_stunstick",
  description = "A stick that can stun people.",
  price = 600
})

A breakdown of it:

OShop.CreateItem("[A]", {
  category = "[B]",
  itemtype = "[C]",
  class = "[D]",
  description = "[E]",
  price = [F]
})

A = Name of the item.
B = The category the item goes into, needs to be made with the Category function we talked about earlier.
C = The itemtype of the item, this can be one of the following:

    weapon - A SWEP/Gun.
    entity - A Entity from the Entities menu.
    ammo - Ammo for a SWEP/Gun.
    prop - A regular Prop, not sure why you would want this but I included it so.
    perm_weapon - A permanent weapon, once bought, it will stay with the player forever.

D = The class of the item/weapon/whatever you have.
E = The description of the item.
F = The price of the item.

If all is correct, you should be able to add an item successfully, if you still don't understand, goto the default files and see from them, if you still don't, you can make a ticket on my website livaco.tk and il assist you.

-------------------------------------------[[Adding an item to your addon]]-------------------------------------------

If you are a Addon Developer, and wish to add OShop support for it, you can do so with the same method as above, but the oshop lua needs to be in your own addon. Goto YourAddonRootFile/lua/oshop/items, and simply make a lua file with your addon name.
Make the code for it and bang, thats it! It might be a good idea to make a config option to disable OShop Support for your addon or to change some of the settings in it.