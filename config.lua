Config = {}

Config.Currency = 'black_money'

Config.Locale = {
    ui_title = 'BLACK MARKET',
    ui_open_shop = 'Åben Butikken',
    ui_all = 'Alle',
    ui_search = 'Søg vare...',
    ui_price = 'Pris',
    ui_stock = 'Lager',
    ui_quantity = 'Antal',
    ui_total = 'I alt:',
    ui_add_to_cart = 'TILFØJ TIL KURV',
    ui_adding = 'TILFØJER...',
    msg_invalid_request = 'Ugyldig anmodning',
    msg_unknown_item = 'Ukendt vare',
    msg_not_enough_money = 'Ikke nok penge',
    msg_no_space = 'Ikke nok plads i inventory',
    msg_cant_remove_money = 'Kunne ikke trække penge',
    msg_cant_give_item = 'Kunne ikke give vare',
    msg_purchased = 'Købte %dx %s for $%s',
    msg_shop_closed = 'Butikken er lukket',
    msg_purchase_failed = 'Køb fejlede',
    msg_something_wrong = 'Noget gik galt',
}

Config.Locations = {
    {
        coords = vector3(152.12, -3216.78, 5.85),
        heading = 180.0,
        ped = {
            model = 's_m_y_ammucity_01',
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT',
        },
        blip = {
            enabled = true,
            sprite = 110,
            color = 1,
            scale = 0.7,
            label = 'Black Market',
        },
        displayDist = 3.0,
        interactDist = 2.0,
    },
}

Config.Categories = {
    {
        id = 'weapons',
        label = 'Våben',
        items = {
            { name = 'WEAPON_PISTOL',          label = 'Pistol',             price = 15000,  stock = -1, description = 'Standard 9mm pistol' },
            { name = 'WEAPON_SMG',             label = 'SMG',                price = 35000,  stock = -1, description = 'Compact submachine gun' },
            { name = 'WEAPON_ASSAULTRIFLE',    label = 'Assault Rifle',      price = 75000,  stock = -1, description = 'Fuld-automatisk riffel' },
            { name = 'WEAPON_PUMPSHOTGUN',     label = 'Pump Shotgun',       price = 45000,  stock = -1, description = 'Kraftig haglgevaer' },
            { name = 'WEAPON_SNIPERRIFLE',     label = 'Sniper Rifle',       price = 120000, stock = -1, description = 'Langdistance praecisionsriffel' },
        },
    },
    {
        id = 'ammo',
        label = 'Ammunition',
        items = {
            { name = 'ammo-9',           label = '9mm Ammo (x24)',     price = 500,   stock = -1, description = 'Standard 9mm ammunition' },
            { name = 'ammo-rifle',       label = 'Rifle Ammo (x24)',   price = 1000,  stock = -1, description = 'Riffel ammunition' },
            { name = 'ammo-shotgun',     label = 'Shotgun Ammo (x12)', price = 750,   stock = -1, description = 'Hagl ammunition' },
            { name = 'ammo-sniper',      label = 'Sniper Ammo (x6)',   price = 1500,  stock = -1, description = 'Sniper ammunition' },
        },
    },
    {
        id = 'attachments',
        label = 'Tilbehør',
        items = {
            { name = 'at_suppressor',    label = 'Lyddaemper',          price = 8000,  stock = -1, description = 'Reducerer lydniveau' },
            { name = 'at_flashlight',    label = 'Lommelygte',         price = 3000,  stock = -1, description = 'Taktisk lommelygte' },
            { name = 'at_grip',          label = 'Greb',               price = 5000,  stock = -1, description = 'Forbedret greb til stabilitet' },
            { name = 'at_scope_medium',  label = 'Medium Sigte',       price = 6000,  stock = -1, description = 'Medium zoom sigte' },
        },
    },
    {
        id = 'misc',
        label = 'Diverse',
        items = {
            { name = 'armour',           label = 'Skudsikker Vest',    price = 10000, stock = -1, description = 'Beskyttelse mod skud' },
            { name = 'lockpick',         label = 'Lockpick',           price = 2000,  stock = -1, description = 'Bruges til at dirke laase' },
            { name = 'radio',            label = 'Radio',              price = 5000,  stock = -1, description = 'Kommunikationsenhed' },
        },
    },
}
