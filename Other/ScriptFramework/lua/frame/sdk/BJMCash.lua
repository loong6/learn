--[[
Author : ZangXu @Bojoy 2014
FileName: BJMCash.lua
Description: 
]]

local sdk = bjm.sdk
sdk.Cash = {}
local cash = sdk.Cash
cash.config = nil

local config_name = "cash_config"

--[[------------------------------------------------------------------------------
-**
prepare config
*]]
cash.Prepare = function()
	 if (cash.config == nil) then
	 	cash.config = bjm.data.json.FindConfig(config_name)
	 	if (cash.config == nil) then
	 		cash.config = bjm.data.json.AddConfigFile(config_name, make_uri(bjm.global.uri.game_res_home, "dataconfig/cash.json"), true)
	 	end	 	
	 end	 

	 if (cash.config == nil) then
	 	releaselog("cash config not found!!!")
	 	return false
	 end

	 return true
end

--[[------------------------------------------------------------------------------
-**
get product
*]]
cash.GetProduct = function(product_id)
	if (cash.config == nil) then do return nil end end

	local operator = tostring(bjm.util.config.GetOperator())

	local count = #cash.config
	for i = 1, count, 1 do
		local product = cash.config[i]
		if (tostring(product.id) == tostring(product_id) and tostring(product.platform) == operator) then
			do return product end
		elseif bjm.sdk.manager.IsAppstore(operator) then
			if tostring(product.id) == tostring(product_id) then
				if bjm.sdk.manager.IsAppstore(tostring(product.platform)) == true then
					do return product end
				end
			end
		end
	end

	releaselog("fail to find product: " .. product_id)
	return nil
end

--[[------------------------------------------------------------------------------
-**
get products by operator
*]]
cash.GetProducts = function ()
	local operator = tostring(bjm.util.config.GetOperator())

	local products = {}
	local count = #cash.config
	for i = 1, count, 1 do
		local product = cash.config[i]
		if (tostring(product.platform) == operator) then
			table.insert(products, product)
		end
	end

	return products
end

--[[------------------------------------------------------------------------------
-**
pay
*]]
cash.Pay = function(product_id, quantity, yuanbao_rate,price_rmb)
	releaselog("cash pay: product_id: " .. product_id .. ", quantity: " .. quantity)
	yuanbao_rate = yuanbao_rate or 0.1
	local success = cash.Prepare()
	if (success == false) then
		do return end
	end

	local product = cash.GetProduct(product_id)
	if (product == nil) then
		do return end
	end

	local money = tonumber(product.money)
	local proxyParams = BJMProxyUtil:NewBJMProxyParams()

	local price_rmb_num = money * yuanbao_rate
	if price_rmb ~= nil then
		price_rmb_num = price_rmb
	end

	local param = {
		iap_product_price_yuanbao = money,
		iap_product_price_rmb = price_rmb_num,--money * yuanbao_rate,
		iap_product_id = product_id,
		iap_product_quantity = quantity,
		iap_product_name = product.name
	}

	dump(param, "param")
		
	for k, v in pairs(param) do
		proxyParams:AddParam(tostring(k), v)
	end

	BJMProxyUtil:OnGameToProxyEventLua("event_pay", proxyParams)
	BJMProxyUtil:ReleaseBJMProxyParams(proxyParams)
end

--[[------------------------------------------------------------------------------
-**
pay with order number
*]]
cash.PayWithOrderNo = function(product_id, quantity, yuanbao_rate, orderNo)
	releaselog("cash pay with order number: product_id: " .. product_id .. ", quantity: " .. quantity)
	yuanbao_rate = yuanbao_rate or 0.1
	local success = cash.Prepare()
	if (success == false) then
		do return end
	end

	local product = cash.GetProduct(product_id)
	if (product == nil) then
		do return end
	end
	
	local productName = ""
	if orderNo ~= nil and orderNo ~= "" then
		productName = product.name .. "`" .. orderNo
	else
		productName = product.name
	end
	
	local money = tonumber(product.money)
	local proxyParams = BJMProxyUtil:NewBJMProxyParams()
	
	local param = {
		iap_product_price_yuanbao = money,
		iap_product_price_rmb = money * yuanbao_rate,
		iap_product_id = product_id,
		iap_product_quantity = quantity,
		iap_product_name = productName
	}

	dump(param, "param")
		
	for k, v in pairs(param) do
		proxyParams:AddParam(tostring(k), v)
	end

	BJMProxyUtil:OnGameToProxyEventLua("event_pay", proxyParams)
	BJMProxyUtil:ReleaseBJMProxyParams(proxyParams)
end