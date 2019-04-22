local BaseAlgorithm = import(".BaseAlgorithm")
local ShuangKouCardType = import(".ShuangKouCardType")
local ShuangKouTiShi = {}



--[[
提示规则
按输入的牌型来决定返回的提示列表
返回: 按所输入的牌型返回对应的提示列表
如: ShuangKouTiShi.getTiShi({108}, {106,209,209,209,109,310,314,520,104,204,304,404}, nil)
返回如下: {{310}, {314}, {520}, {104,204,304,404}}
]]
function ShuangKouTiShi.getTiShi(cards, handCards, config)
	if handCards == nil then
		return {}
	end
	local bianPai = config.bianPai
	--config.bianPai or 0
    local cardType, typeData = ShuangKouCardType.getType(cards,bianPai)
	local tempCards = clone(handCards)
	table.sort(tempCards, ShuangKouCardType.sortByValue_)
	local result = {}
	local res = {}
	if not cardType and not typeData then
		res = ShuangKouTiShi.tiShiWithDanZhang_(tempCards, {2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithDuiZi_(tempCards, {2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithSanZhang_(tempCards, {2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithShunZi_(tempCards, {5,2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithLianDui_(tempCards, {3,2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithLianShanZhang_(tempCards, {3,2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		return result
	end
	if cardType >= ShuangKouCardType.DAN_ZHANG and cardType <= ShuangKouCardType.LIAN_SAN_ZHANG then
		if cardType == ShuangKouCardType.DAN_ZHANG then
			res = ShuangKouTiShi.tiShiWithDanZhang_(tempCards, typeData, bianPai)
		end
		if cardType == ShuangKouCardType.DUI_ZI then
			res = ShuangKouTiShi.tiShiWithDuiZi_(tempCards, typeData, bianPai)
		end
		if cardType == ShuangKouCardType.SAN_ZHANG then
			res = ShuangKouTiShi.tiShiWithSanZhang_(tempCards, typeData, bianPai)
		end
		if cardType == ShuangKouCardType.SHUN_ZI then
			res = ShuangKouTiShi.tiShiWithShunZi_(tempCards, typeData, bianPai)
		end
		if cardType == ShuangKouCardType.LIAN_DUI then
			res = ShuangKouTiShi.tiShiWithLianDui_(tempCards, typeData, bianPai)
		end
		if cardType == ShuangKouCardType.LIAN_SAN_ZHANG then
			res = ShuangKouTiShi.tiShiWithLianShanZhang_(tempCards, typeData, bianPai)
		end
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithZhaDan_(tempCards, {4,2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithLianZhaDan_(tempCards, {3,2,4}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithSanWangZha_(tempCards, typeData, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithTianWangZha_(tempCards, typeData, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
	elseif cardType == ShuangKouCardType.ZHA_DAN then
		res = ShuangKouTiShi.tiShiWithZhaDan_(tempCards, typeData, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		if typeData[1] <= 5 then
			res = ShuangKouTiShi.tiShiWithSanWangZha_(tempCards, typeData, bianPai)
			if #res > 0 then
				table.insertto(result,res)
			end
		end
		if typeData[1] <= 6 then
			res = ShuangKouTiShi.tiShiWithTianWangZha_(tempCards, typeData, laiZiCards)
			if #res > 0 then
				table.insertto(result,res)
			end
		end
	elseif cardType == ShuangKouCardType.LIAN_ZHA_DAN then
		res = ShuangKouTiShi.tiShiWithLianZhaDan_(tempCards, typeData, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithZhaDan_(tempCards, {typeData[1]+typeData[2],2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
	elseif cardType == ShuangKouCardType.SAN_WANG_ZHA then
		res = ShuangKouTiShi.tiShiWithZhaDan_(tempCards, {6,2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithLianZhaDan_(tempCards, {3,2,4}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
	elseif cardType == ShuangKouCardType.TIAN_WANG_ZHA then
		res = ShuangKouTiShi.tiShiWithZhaDan_(tempCards, {7,2}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
		res = ShuangKouTiShi.tiShiWithLianZhaDan_(tempCards, {3,2,4}, bianPai)
		if #res > 0 then
			table.insertto(result,res)
		end
	end
	-- dump(result,"resultresultresult")
	return result
end

function ShuangKouTiShi.tiShiWithDanZhang_(handCards,typeData,bianPai)
	local resInfo,changeInfo = ShuangKouCardType.getCardData(handCards,0)
	local result = {}
	for i = 1,3 do
		local needInfo = resInfo[i]
		if needInfo then
			for i = 1, #needInfo do
				if BaseAlgorithm.getValue(needInfo[i][1]) > typeData[1] then 
					table.insert(result,{needInfo[i][1]})
				end
			end
		end
	end
	return result
end

function ShuangKouTiShi.tiShiWithDuiZi_(handCards,typeData,bianPai)
	local resInfo,changeInfo = ShuangKouCardType.getCardData(handCards,bianPai)
	-- dump(resInfo,"resInfo")
	-- dump(changeInfo,"changeInfo")
	-- print("len",#changeInfo)
	local result = {}
	local resultLZ = {}
	for j = 1,3 do
		local needInfo = resInfo[j]
		if needInfo then
			for i = 1, #needInfo do
				local cardValue = needInfo[i][1]
				--not ShuangKouCardType.checkIsWang(cardValue) and 
				if BaseAlgorithm.getValue(cardValue) > typeData[1] then 
					if j == 1 then
						if #changeInfo > 0 then
							table.insert(resultLZ,{needInfo[i][1],changeInfo[1]})
						end
					end
					if j == 2 then
						table.insert(result,needInfo[i])
					end
					if j == 3 then
						table.insert(result,{needInfo[i][1],needInfo[i][2]})
					end
				end
			end
		end
	end
	if #result > 0 then
		return result
	else
		return resultLZ
	end
end

function ShuangKouTiShi.tiShiWithSanZhang_(handCards,typeData,bianPai)
	local resInfo,changeInfo = ShuangKouCardType.getCardData(handCards,bianPai)
	local result = {}
	local resultLZ = {}
	for j = 1,3 do
		local needInfo = resInfo[j]
		if needInfo then
			for i = 1, #needInfo do
				local cardValue = needInfo[i][1]
				if not ShuangKouCardType.checkIsWang(cardValue) and BaseAlgorithm.getValue(cardValue) > typeData[1] then 
					if j == 1 then
						if #changeInfo > 1 then
							table.insert(resultLZ,{needInfo[i][1],changeInfo[1],changeInfo[2]})
						end
					end
					if j == 2 then
						if #changeInfo > 0 then
							table.insert(resultLZ,{needInfo[i][1],needInfo[i][2],changeInfo[1]})
						end
					end
					if j == 3 then
						table.insert(result,needInfo[i])
					end
				end
			end
		end
	end
	if #result > 0 then
		return result
	else
		return resultLZ
	end
end

function ShuangKouTiShi.tiShiWithLian_(handCards,bianPai,findLen,findMin,signNum)
	if #handCards < findLen*signNum then
		return {}
	end
	local resInfo,changeInfo = ShuangKouCardType.getCardDataByValue(handCards,bianPai)
	-- dump(resInfo,"resInfo")
	-- dump(changeInfo,"changeInfo")
	local result = {}
	local resultLZ = {}
	local findValue = findMin
	while findValue+findLen-1 <= 14 do
		local needCount = 0
		local temp = {}
		for i = 0,findLen-1 do
			local aimValue = findValue + i
			if resInfo[aimValue] then
				for j = 1,signNum do
					if resInfo[aimValue][j] then
						table.insert(temp,resInfo[aimValue][j])
					else
						needCount = needCount + 1
					end
				end
			else
				needCount = needCount + signNum
			end
		end
		-- dump(temp,"temptemp")
		if needCount <= #changeInfo then
			for j = 1,needCount do
				table.insert(temp,changeInfo[j])
			end
		end
		if #temp == findLen*signNum then
			if needCount == 0 then
				table.insert(result,clone(temp))
			else
				table.insert(resultLZ,clone(temp))
			end
			
		end
		findValue = findValue + 1
	end

	if #result > 0 then
		return result
	else
		return resultLZ
	end
end

function ShuangKouTiShi.tiShiWithShunZi_(handCards,typeData,bianPai)
	local findLen = typeData[1]
	local findMin = typeData[2]+1
	return ShuangKouTiShi.tiShiWithLian_(handCards,bianPai,findLen,findMin,1)
end

function ShuangKouTiShi.tiShiWithLianDui_(handCards,typeData,bianPai)
	local findLen = typeData[1]
	local findMin = typeData[2]+1
	return ShuangKouTiShi.tiShiWithLian_(handCards,bianPai,findLen,findMin,2)
end

function ShuangKouTiShi.tiShiWithLianShanZhang_(handCards,typeData,bianPai)
	local findLen = typeData[1]
	local findMin = typeData[2]+1
	return ShuangKouTiShi.tiShiWithLian_(handCards,bianPai,findLen,findMin,3)
end

function ShuangKouTiShi.addValue(addInfo,oriInfo,result,num,isBigger)
	for i = 1,#addInfo do
		table.insert(oriInfo,addInfo[i])
		if num then
			if #oriInfo > num then
				table.insert(result,clone(oriInfo))
			elseif #oriInfo == num and isBigger then
				table.insert(result,clone(oriInfo))
			end 
		else
			table.insert(result,clone(oriInfo))
		end
	end
end

function ShuangKouTiShi.tiShiWithZhaDan_(handCards,typeData,bianPai)
	-- dump(typeData,"typeDatatypeData")
	local resInfo,changeInfo = ShuangKouCardType.getCardDataByValue(handCards,bianPai)
	local num = typeData[1]
	local minValue = typeData[2]
	-- dump(resInfo,"resInfo")
	-- dump(changeInfo,"changeInfo")
	local result = {}
	local resultLZ = {}
	for key,value in pairs(resInfo) do
		if key <= 16 then
			if #value == num then
				if key > minValue then
					table.insert(result,clone(value))
				end
				ShuangKouTiShi.addValue(changeInfo,clone(value),resultLZ)
			end
			if #value > num then
				table.insert(result,clone(value))
				ShuangKouTiShi.addValue(changeInfo,clone(value),resultLZ)
			end
			if #value < num then
				ShuangKouTiShi.addValue(changeInfo,clone(value),resultLZ,num,key>minValue)
			end
		end 
	end
	-- dump(result,"resultresultresult")
	-- dump(resultLZ,"resultLZresultLZ")
	if #result > 0 then
		return result
	else
		return resultLZ
	end
end

function ShuangKouTiShi.tiShiWithLianZhaDan_(handCards,typeData,bianPai)
	-- dump(typeData,"typeData")
	local findLen = typeData[1]--连
	local findMin = typeData[2]+1
	local cout = typeData[3]--星
	local result = {}
	--匹配相同连,相同星的
	local res = ShuangKouTiShi.tiShiWithLian_(handCards,bianPai,findLen,findMin,cout)
	if #res > 0 then
		table.insertto(result,res)
	end
	--匹配不同连,相同星的
	for i = findLen+1, 12 do
		res = ShuangKouTiShi.tiShiWithLian_(handCards,bianPai,i,2,cout)
		if #res > 0 then
			table.insertto(result,res)
		end
	end
	--匹配相同连,不同星的
	for i = cout+1, 12 do
		res = ShuangKouTiShi.tiShiWithLian_(handCards,bianPai,findLen,2,i)
		if #res > 0 then
			table.insertto(result,res)
		end
	end
	return result
end

function ShuangKouTiShi.getWangByNum(handCards,num)
	local result = {}
	local res = {}
	for i = #handCards,1,-1 do
		local cardValue = handCards[i] 
		if ShuangKouCardType.checkIsWang(cardValue) then
			table.insert(result,cardValue)
			if #result == num then
				table.insert(res,result)
				return res
			end
		else
			break
		end
	end
	return res
end

function ShuangKouTiShi.tiShiWithSanWangZha_(handCards,typeData,bianPai)
	return ShuangKouTiShi.getWangByNum(handCards,3)
end

function ShuangKouTiShi.tiShiWithTianWangZha_(handCards,typeData,bianPai)
	return ShuangKouTiShi.getWangByNum(handCards,4)
end

return ShuangKouTiShi
