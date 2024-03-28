local Sandevistan = {}
--Sandevistan = ModItem("Sandevistan","Sandevistan")
local dashTime=0;
local name="Sandevistan"
Sandevistan.ID = Isaac.GetItemIdByName(name);
Sandevistan.Item = Sandevistan.ID;
Sandevistan.Name = name;
Sandevistan.DataName = name;

function Sandevistan:EvaluateCache(caflag)
	player = Isaac.GetPlayer(0)
	if player:HasCollectible(Sandevistan.ID) then
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
	dashTime=75;
	print("UseItem")
	local EntityList = Isaac.GetRoomEntities()
	if player:HasCollectible(Sandevistan.ID) then
		for i = 1,#EntityList do
			if(EntityList[i].Type~=EntityType.ENTITY_PLAYER) then
				EntityList[i]:AddFreeze(EntityRef(player), 75)
			end
		end
	end
end
ModName:AddCallback(ModCallbacks.MC_USE_ITEM,Sandevistan.UseItem,Sandevistan.ID)

function Sandevistan:PostUpdate()
	local player = Isaac.GetPlayer(0)
	player:AddCacheFlags(CacheFlag.CACHE_ALL)
	player:EvaluateItems()
end
ModName:AddCallback(ModCallbacks.MC_POST_UPDATE,Sandevistan.PostUpdate)

function Sandevistan:PlayerTakeDamage()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(Sandevistan.ID) then
		player:AddHearts(2)--to do:delete here!
		local charge=player:GetActiveCharge()
		player:SetActiveCharge(charge+1)
	end
end
ModName:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Sandevistan.PlayerTakeDamage,EntityType.ENTITY_PLAYER)

function Sandevistan:PostPlayerUpdate()
	local player = Isaac.GetPlayer(0)
	if(dashTime>0)then
		dashTime=dashTime-1;
		if(dashTime%3==2)then
			local Trail=ModName.Effects.Trail;
			local trailInfo = Trail;
			local trail = Isaac.Spawn(trailInfo.Type, trailInfo.Variant, 0, player.Position, Vector(0, 0), player);
			trail.SpriteScale = player.SpriteScale;
		end
	else
		dashTime=0;
	end
end
ModName:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,Sandevistan.PostPlayerUpdate)

function  Sandevistan:getDashTime()
	return dashTime;
end

return Sandevistan