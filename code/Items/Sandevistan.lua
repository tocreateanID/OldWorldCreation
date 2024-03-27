Sandevistan = Sandevistan or {}
--Sandevistan = ModItem("Sandevistan","Sandevistan")
function Sandevistan:new(name)
	local new = setmetatable({}, {
		__index = self
	});
	new.Item = Isaac.GetItemIdByName(name);
end
if not Sandevistan then
	Sandevistan.new("Sandevistan")
end
local ItemID=ModName.itemId
function Sandevistan:EvaluateCache(caflag)
	player = Isaac.GetPlayer(0)
	if player:HasCollectible(ItemID.Sandevistan) then
		if caflag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 1
		end
		if caflag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + 1.2
		end
		if caflag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + 1.2
		end
		if caflag == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | 1 << 2
		end
	end
end
ModName:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Sandevistan.EvaluateCache)

function Sandevistan:UseItem()
	local player = Isaac.GetPlayer(0)
	local EntityList = Isaac.GetRoomEntities()
	if player:HasCollectible(ItemID.Sandevistan) then
		for i = 1,#EntityList do
			if(EntityList[i].Type~=EntityType.ENTITY_PLAYER) then
				EntityList[i]:AddFreeze(EntityRef(player), 75)
			end
		end
	end
end
ModName:AddCallback(ModCallbacks.MC_USE_ITEM,Sandevistan.UseItem,ItemID.Sandevistan)

function Sandevistan:PostUpdate()
	local player = Isaac.GetPlayer(0)
	player:AddCacheFlags(CacheFlag.CACHE_ALL)
	player:EvaluateItems()
end
ModName:AddCallback(ModCallbacks.MC_POST_UPDATE,Sandevistan.PostUpdate)

function Sandevistan:PlayerTakeDamage()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(ItemID.Sandevistan) then
		player:AddHearts(2)
		local charge=player:GetActiveCharge()
		player:SetActiveCharge(charge+1)
	end
end
ModName:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Sandevistan.PlayerTakeDamage,EntityType.ENTITY_PLAYER)

return Sandevistan