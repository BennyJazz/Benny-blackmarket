# benny_blackmarket

A black market resource for FiveM using the Overextended framework and st_libs.

NPC-based interaction with a modern, dark-themed NUI shop interface.

## Preview

- Centered UI with rounded corners and teal accent theme
- Left panel: item list with search and category tabs
- Right panel: item detail with image, price, stock, and quantity selector
- NPC dealer with 3D interaction text

## Dependencies

- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_lib](https://github.com/overextended/ox_lib)
- [st_libs](https://github.com/Stausi/st_libs)

## Installation

1. Download and place `benny_blackmarket` in your resources folder
2. Add to `server.cfg`:
   ```
   ensure ox_lib
   ensure ox_inventory
   ensure st_libs
   ensure benny_blackmarket
   ```
3. Configure `config.lua` to your needs

## Configuration

All configuration is done in `config.lua`.

### Currency

```lua
Config.Currency = 'black_money'
```

Change to whichever item you use as currency in ox_inventory.

### Locale

All UI text and server messages are defined in `Config.Locale`. Edit these values to change language or wording:

```lua
Config.Locale = {
    ui_title = 'BLACK MARKET',
    ui_open_shop = 'Open Shop',
    ui_all = 'All',
    ui_search = 'Search item...',
    ui_price = 'Price',
    ui_stock = 'Stock',
    ui_quantity = 'Qty',
    ui_total = 'Total:',
    ui_add_to_cart = 'ADD TO CART',
    -- ...
}
```

### Locations

Add or modify dealer locations. Each location spawns an NPC and a map blip:

```lua
Config.Locations = {
    {
        coords = vector3(152.12, -3216.78, 5.85),
        heading = 180.0,
        ped = {
            model = 's_m_y_ammucity_01',       -- Ped model
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT', -- Animation
        },
        blip = {
            enabled = true,
            sprite = 110,
            color = 1,
            scale = 0.7,
            label = 'Black Market',
        },
        displayDist = 3.0,   -- Distance to show interaction marker
        interactDist = 2.0,  -- Distance to interact
    },
}
```

### Categories & Items

Add categories and items. Set `stock = -1` for unlimited stock:

```lua
Config.Categories = {
    {
        id = 'weapons',
        label = 'Weapons',
        items = {
            {
                name = 'WEAPON_PISTOL',    -- ox_inventory item name
                label = 'Pistol',
                price = 15000,
                stock = -1,                -- -1 = unlimited
                description = 'Standard 9mm pistol',
            },
        },
    },
}
```

Item images are loaded from `nui://ox_inventory/web/images/` automatically.

## File Structure

```
benny_blackmarket/
├── fxmanifest.lua
├── config.lua
├── client/
│   └── main.lua
├── server/
│   └── main.lua
└── html/
    ├── index.html
    ├── style.css
    └── script.js
```

## Features

- NPC dealer with configurable model and animation
- Map blips per location
- NUI shop interface with category tabs and search
- Item detail panel with image, description, price, and stock
- Quantity selector
- Inventory space check before purchase
- Currency validation with rollback on failure
- Fade in/out animations
- Escape to close
- Fully configurable locale for any language
- Clean resource stop (NPC cleanup)

## License

MIT
