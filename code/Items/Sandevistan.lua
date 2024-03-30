local Sandevistan = {}
--Sandevistan = ModItem("Sandevistan","Sandevistan")

local name="Sandevistan"
Sandevistan.ID = Isaac.GetItemIdByName(name);
Sandevistan.Item = Sandevistan.ID;
Sandevistan.Name = name;
Sandevistan.DataName = name;
Sandevistan.dashTime=0;
Sandevistan.preFrameCount=0;
Sandevistan.bCanUseItem=false;
Sandevistan.bTemporaryAttributes=false;
Sandevistan.bFirstGetItem=false;

function Sandevistan:EvaluateCache(player,caflag)
	if player:HasCollectible(Sandevistan.ID) then
		if(Sandevistan.bFirstGetItem)then
			player:AddBrokenHearts(1);
			Sandevistan.bFirstGetItem=false;
		end
	end
	if (player:HasCollectible(Sandevistan.ID)and Sandevistan.bTemporaryAttributes) then
		if(Sandevistan.bFirstGetItem)then
			player:AddBrokenHearts(1);
			Sandevistan.bFirstGetItem=false;
		end
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
			player.TearFlags = player.TearFlags | ((1 << 2))
		end
	end
end
ModName:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Sandevistan.EvaluateCache)

function Sandevistan:UseItem()
	local player = Isaac.GetPlayer(0)
	Sandevistan.dashTime=75;
	local EntityList = Isaac.GetRoomEntities()
	if player:HasCollectible(Sandevistan.ID) then
		for i = 1,#EntityList do
			if(EntityList[i].Type~=EntityType.ENTITY_PLAYER) then
				EntityList[i]:AddFreeze(EntityRef(player), 75)
			end
		end
	end
end

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
--ModName:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Sandevistan.PlayerTakeDamage,EntityType.ENTITY_PLAYER)

function Sandevistan:PostPlayerUpdate()
	local player = Isaac.GetPlayer(0)
	if not player:HasCollectible(Sandevistan.ID) then
		Sandevistan.bFirstGetItem=true;
	end
	if player:HasCollectible(Sandevistan.ID) then
		if(Sandevistan.dashTime>0)then
			if(Sandevistan.preFrameCount~=player.FrameCount)then
				Sandevistan.preFrameCount=player.FrameCount
				Sandevistan.dashTime=Sandevistan.dashTime-1;
				if(Sandevistan.dashTime%3==2)then
					local Trail=ModName.Effects.Trail;
					local trailInfo = Trail;
					local trail = Isaac.Spawn(trailInfo.Type, trailInfo.Variant, 0, player.Position, Vector(0, 0), player);
					trail.SpriteScale = player.SpriteScale;
				end
			end
		else
			if Sandevistan.bTemporaryAttributes then
				Sandevistan.dashTime=0;
				Sandevistan.bTemporaryAttributes=false;
				player:AddHearts(-1);
			end
		end

		local controllerIndex = player.ControllerIndex;
		local shiftPressed = Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT, controllerIndex);
		local directionPressed = Input.IsActionPressed(ButtonAction.ACTION_LEFT,controllerIndex) or
									Input.IsActionPressed(ButtonAction.ACTION_RIGHT,controllerIndex) or
									Input.IsActionPressed(ButtonAction.ACTION_UP,controllerIndex) or
									Input.IsActionPressed(ButtonAction.ACTION_DOWN,controllerIndex)
		if(Sandevistan.bCanUseItem and shiftPressed and directionPressed)then
			Sandevistan.bCanUseItem=false;
			Sandevistan:UseItem();
			Sandevistan.bTemporaryAttributes=true;
		end
	end
end
ModName:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,Sandevistan.PostPlayerUpdate)


function Sandevistan:CanUseItem()
	local player = Isaac.GetPlayer(0)
		if player:HasCollectible(Sandevistan.ID) then
			Sandevistan.bCanUseItem=true;
		end
end
ModName:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,Sandevistan.CanUseItem)

function  Sandevistan:getDashTime()
	return Sandevistan.dashTime;
end

return Sandevistan