local ox_inventory = exports.ox_inventory

st.ready(function()
    local L = Config.Locale

    st.callback.register('benny_blackmarket:getCategories', function(source)
        return Config.Categories
    end)

    st.callback.register('benny_blackmarket:getPlayerCurrency', function(source)
        local items = ox_inventory:Search(source, 'count', Config.Currency)
        return items or 0
    end)

    st.callback.register('benny_blackmarket:purchaseItem', function(source, itemName, amount)
        if not itemName or not amount or amount < 1 then
            return { success = false, message = L.msg_invalid_request }
        end

        amount = math.floor(amount)

        local itemConfig = nil
        for _, category in pairs(Config.Categories) do
            for _, item in pairs(category.items) do
                if item.name == itemName then
                    itemConfig = item
                    break
                end
            end
            if itemConfig then break end
        end

        if not itemConfig then
            return { success = false, message = L.msg_unknown_item }
        end

        local totalPrice = itemConfig.price * amount
        local currency = ox_inventory:Search(source, 'count', Config.Currency)

        if not currency or currency < totalPrice then
            return { success = false, message = L.msg_not_enough_money }
        end

        local canCarry = ox_inventory:CanCarryItem(source, itemName, amount)
        if not canCarry then
            return { success = false, message = L.msg_no_space }
        end

        local removed = ox_inventory:RemoveItem(source, Config.Currency, totalPrice)
        if not removed then
            return { success = false, message = L.msg_cant_remove_money }
        end

        local added = ox_inventory:AddItem(source, itemName, amount)
        if not added then
            ox_inventory:AddItem(source, Config.Currency, totalPrice)
            return { success = false, message = L.msg_cant_give_item }
        end

        local remaining = ox_inventory:Search(source, 'count', Config.Currency)

        return {
            success = true,
            message = L.msg_purchased:format(amount, itemConfig.label, totalPrice),
            newBalance = remaining or 0,
        }
    end)
end)
