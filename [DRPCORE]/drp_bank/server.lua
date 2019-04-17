RegisterServerEvent("DRP_Bank:RequestATMInfo")
AddEventHandler("DRP_Bank:RequestATMInfo", function()
    local src = source
       TriggerEvent("DRP_ID:GetCharacterData", src, function(CharacterData)
            TriggerEvent("DRP_Bank:GetCharacterMoney", CharacterData.charid, function(characterMoney)
            TriggerClientEvent("DRP_Bank:OpenMenu", src, CharacterData.name, characterMoney.data[1].bank, characterMoney.data[1].cash)
        end)
    end)
end)

---------------------------------------------------------------------------
-- Withdrawing Money
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Bank:WithdrawMoney")
AddEventHandler("DRP_Bank:WithdrawMoney", function(amount)
    local src = source
    TriggerEvent("DRP_ID:GetCharacterData", src, function(CharacterData)
        TriggerEvent("DRP_Bank:GetCharacterMoney", CharacterData.charid, function(characterMoney)
            local bankBalance = characterMoney.data[1].bank
            local newBankBalance = characterMoney.data[1].bank - tonumber(amount)
            
            if bankBalance >= tonumber(amount) then
                exports["externalsql"]:DBAsyncQuery({
                    string = "UPDATE `characters` SET `bank` = :bank WHERE `id` = :charid",
                    data = {
                        bank = newBankBalance,
                        charid = CharacterData.charid
                    }
                }, function(results)

                    local cashBalance = characterMoney.data[1].cash
                    local newCashBalance = characterMoney.data[1].cash + tonumber(amount)
                    print(cashBalance)
                    print(newCashBalance)
                    exports["externalsql"]:DBAsyncQuery({
                        string = "UPDATE `characters` SET `cash` = :cash WHERE `id` = :charid",
                        data = {
                            cash = newCashBalance,
                            charid = CharacterData.charid
                        }
                    }, function(results)
                        TriggerClientEvent("DRP_Bank:ActionCallback", src, true, "Success", newBankBalance, newCashBalance)
                    end)
                end)
            else 
                TriggerClientEvent("DRP_Bank:ActionCallback", src, false, "Insufficiant Funds", false)
            end
        end)
    end)
end)

---------------------------------------------------------------------------
-- Depositing Money
---------------------------------------------------------------------------
RegisterServerEvent("DRP_Bank:DepositMoney")
AddEventHandler("DRP_Bank:DepositMoney", function(amount)
    local src = source
    TriggerEvent("DRP_ID:GetCharacterData", src, function(CharacterData)
        TriggerEvent("DRP_Bank:GetCharacterMoney", CharacterData.charid, function(characterMoney)

            local cashBalance = characterMoney.data[1].cash
            local newCashBalance = characterMoney.data[1].cash - tonumber(amount)
            
            if cashBalance >= tonumber(amount) then
                exports["externalsql"]:DBAsyncQuery({
                    string = "UPDATE `characters` SET `cash` = :cash WHERE `id` = :charid",
                    data = {
                        cash = newCashBalance,
                        charid = CharacterData.charid
                    }
                }, function(results)

                    local bankBalance = characterMoney.data[1].bank
                    local newBankBalance = characterMoney.data[1].bank + tonumber(amount)

                    exports["externalsql"]:DBAsyncQuery({
                        string = "UPDATE `characters` SET `bank` = :bank WHERE `id` = :charid",
                        data = {
                            bank = newBankBalance,
                            charid = CharacterData.charid
                        }
                    }, function(results)
                        TriggerClientEvent("DRP_Bank:ActionCallback", src, true, "Success", newBankBalance, newCashBalance)
                    end)
                end)
            else 
                TriggerClientEvent("DRP_Bank:ActionCallback", src, false, "Insufficiant Funds", false)
            end
        end)
    end)
end)

---------------------------------------------------------------------------
-- Adding BANK Money
---------------------------------------------------------------------------
AddEventHandler("DRP_Bank:AddBankMoney", function(amount)
    local src = source
    if type(amount) == "number" then
        TriggerEvent("DRP_ID:GetCharacterData", src, function(CharacterData)
            TriggerEvent("DRP_Bank:GetCharacterMoney", CharacterData.charid, function(characterMoney)
                local newBankBalance = characterMoney.data[1].bank + tonumber(amount)
                exports["externalsql"]:DBAsyncQuery({
                    string = "UPDATE `characters` SET `bank` = :bank WHERE `id` = :charid",
                    data = {
                        bank = newBankBalance,
                        charid = CharacterData.charid
                    }
                }, function(results)
                    TriggerClientEvent("DRP_Bank:ActionCallback", src, true, "Success", newBankBalance)
                end)
            end)
        end)
    end
end)

---------------------------------------------------------------------------
-- Removing BANK money
---------------------------------------------------------------------------
AddEventHandler("DRP_Bank:RemoveBankMoney", function(source, amount)
    local src = source
    print(amount)
    TriggerEvent("DRP_ID:GetCharacterData", src, function(characterData)
        TriggerEvent("DRP_Bank:GetCharacterMoney", characterData.charid, function(characterMoney)
            local newBankBalance = characterMoney.data[1].bank - tonumber(amount)
            exports["externalsql"]:DBAsyncQuery({
                string = "UPDATE `characters` SET `bank` = :bank WHERE `id` = :charid",
                data = {
                    bank = newBankBalance,
                    charid = characterData.charid
                }
            }, function(results)
                TriggerClientEvent("DRP_Bank:ActionCallback", src, true, "Success", newBankBalance)
            end)
        end)
    end)
end)

---------------------------------------------------------------------------
-- Adding CASH Money
---------------------------------------------------------------------------
AddEventHandler("DRP_Bank:AddCashMoney", function(source, amount)
    local src = source
    if type(amount) == "number" then
        TriggerEvent("DRP_ID:GetCharacterData", src, function(CharacterData)
            TriggerEvent("DRP_Bank:GetCharacterMoney", CharacterData.charid, function(characterMoney)
                local newCashBalance = characterMoney.data[1].cash + tonumber(amount)
                exports["externalsql"]:DBAsyncQuery({
                    string = "UPDATE `characters` SET `cash` = :cash WHERE `id` = :charid",
                    data = {
                        cash = newCashBalance,
                        charid = CharacterData.charid
                    }
                }, function(results)
                    TriggerClientEvent("DRP_Bank:ActionCallback", src, true, "Success", newBankBalance)
                end)
            end)
        end)
    end
end)

---------------------------------------------------------------------------
-- Removing CASH Money
---------------------------------------------------------------------------
AddEventHandler("DRP_Bank:RemoveCashMoney", function(source, amount)
    local src = source
    print(amount)
    TriggerEvent("DRP_ID:GetCharacterData", src, function(characterData)
        TriggerEvent("DRP_Bank:GetCharacterMoney", characterData.charid, function(characterMoney)
            local moneyRemoved = 25
            local newCashBalance = characterMoney.data[1].cash - tonumber(amount)
            print(newCashBalance)
            exports["externalsql"]:DBAsyncQuery({
                string = "UPDATE `characters` SET `cash` = :cash WHERE `id` = :charid",
                data = {
                    cash = newCashBalance,
                    charid = characterData.charid
                }
            }, function(results)
                TriggerClientEvent("ISRP:Notify", src, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Money Removed :  - ~r~$~s~ "..moneyRemoved.." ~n~New Cash Total : + ~g~$~s~ "..newCashBalance.."")
            end)
        end)
    end)
end)

---------------------------------------------------------------------------
-- Add PayCheck Money
---------------------------------------------------------------------------
AddEventHandler("DRP_Bank:AddPayCheckMoney", function(source, amount)
    local src = source
    TriggerEvent("DRP_ID:GetCharacterData", src, function(characterData)
        -- Check to see if they have even selected a character and have loaded into the server.
        if characterData.charid == nil then 
            return
        else
        -- Check if the data has been loaded and if it has then do the below and add the paycheck money they require
            TriggerEvent("DRP_Bank:GetCharacterMoney", characterData.charid, function(characterMoney)
                local newPayCheckBalance = characterMoney.data[1].paycheck + tonumber(amount)
                exports["externalsql"]:DBAsyncQuery({
                    string = "UPDATE `characters` SET `paycheck` = :paycheck WHERE `id` = :charid",
                    data = {
                        paycheck = newPayCheckBalance,
                        charid = characterData.charid
                    }
                }, function(results)
                end)
            end)
        end
    end)
end)
---------------------------------------------------------------------------
-- Get Character Money Data
---------------------------------------------------------------------------
AddEventHandler("DRP_Bank:GetCharacterMoney", function(charid, callback)
	local src = source
		exports["externalsql"]:DBAsyncQuery({
			string = "SELECT * FROM `characters` WHERE `id` = :char_id",
			data = {
				char_id = charid
			}
		}, function(results)
		callback(results)
	end)
end)

---------------------------------------------------------------------------
-- All Commands For Banking
---------------------------------------------------------------------------
RegisterCommand('cash', function(source, args, user)
    local src = source
    TriggerEvent("DRP_ID:GetCharacterData", src, function(CharacterData)
        TriggerEvent("DRP_Bank:GetCharacterMoney", CharacterData.charid, function(characterMoney)
            TriggerClientEvent("chatMessage", src, tostring("^2Cash^0: Your Cash total: ^2$"..characterMoney.data[1].cash.."^0 "))
        end)
    end)
end, false)

RegisterCommand('bank', function(source, args, user)
    local src = source
    TriggerEvent("DRP_ID:GetCharacterData", src, function(CharacterData)
        TriggerEvent("DRP_Bank:GetCharacterMoney", CharacterData.charid, function(characterMoney)
            TriggerClientEvent("chatMessage", src, tostring("^4Bank^0: Your Latest Bank Statement: ^4$"..characterMoney.data[1].bank.."^0 "))
        end)
    end)
end, false)