local isOpen = false
local spawnedPeds = {}
local L = nil

local function openBlackmarket()
    if isOpen then return end
    isOpen = true

    local categories = st.callback.await('benny_blackmarket:getCategories', false)
    local currency = st.callback.await('benny_blackmarket:getPlayerCurrency', false)

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        categories = categories,
        currency = currency,
        dealerName = L.ui_title,
        locales = {
            title = L.ui_title,
            all = L.ui_all,
            search = L.ui_search,
            price = L.ui_price,
            stock = L.ui_stock,
            quantity = L.ui_quantity,
            total = L.ui_total,
            add_to_cart = L.ui_add_to_cart,
            adding = L.ui_adding,
            purchase_failed = L.msg_purchase_failed,
            something_wrong = L.msg_something_wrong,
        },
    })
end

local function closeBlackmarket()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function spawnPed(location)
    local model = GetHashKey(location.ped.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    local ped = CreatePed(0, model, location.coords.x, location.coords.y, location.coords.z - 1.0, location.heading, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, location.heading)

    if location.ped.scenario then
        TaskStartScenarioInPlace(ped, location.ped.scenario, 0, true)
    end

    SetModelAsNoLongerNeeded(model)

    while not DoesEntityExist(ped) do
        Wait(10)
    end

    return ped
end

RegisterNUICallback('close', function(_, cb)
    closeBlackmarket()
    cb('ok')
end)

RegisterNUICallback('purchase', function(data, cb)
    if not isOpen then
        cb({ success = false, message = L and L.msg_shop_closed or 'Shop closed' })
        return
    end

    local result = st.callback.await('benny_blackmarket:purchaseItem', false, data.item, data.amount)
    cb(result)
end)

RegisterNUICallback('getBalance', function(_, cb)
    local currency = st.callback.await('benny_blackmarket:getPlayerCurrency', false)
    cb({ balance = currency })
end)

st.ready(function()
    L = Config.Locale

    for i, location in pairs(Config.Locations) do
        if location.blip and location.blip.enabled then
            local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
            SetBlipSprite(blip, location.blip.sprite)
            SetBlipColour(blip, location.blip.color)
            SetBlipScale(blip, location.blip.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(location.blip.label)
            EndTextCommandSetBlipName(blip)
        end

        local ped = spawnPed(location)
        spawnedPeds[#spawnedPeds + 1] = ped

        st.create3DTextUIOnEntity('blackmarket_' .. tostring(i), {
            {
                id = 1,
                text = L.ui_open_shop,
                entity = ped,
                displayDist = location.displayDist,
                interactDist = location.interactDist,
                key = 'E',
                keyNum = 38,
                onSelect = function()
                    openBlackmarket()
                end,
            },
        })
    end
end)

st.stopped(function()
    for _, ped in pairs(spawnedPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    spawnedPeds = {}
end)
