local HorrificNecktie = {}
--HorrificNecktie = ModItem("HorrificNecktie","HorrificNecktie")

local name="HorrificNecktie"
HorrificNecktie.ID = Isaac.GetItemIdByName(name);
HorrificNecktie.Item = HorrificNecktie.ID;
HorrificNecktie.Name = name;
HorrificNecktie.DataName = name;
HorrificNecktie.roomCount=0;
HorrificNecktie.rate={
    textWeight=0.605;
    soulHeartWeight=0.24;
    cardWeight=0.12;
    trinketWeight=0.035;
}

function HorrificNecktie:PreSpawnCleanAward(rng, Position)
    local player = Isaac.GetPlayer(0)
    HorrificNecktie.roomCount=HorrificNecktie.roomCount+100;
    while HorrificNecktie.roomCount>=2 do
        if (player:HasCollectible(HorrificNecktie.ID)and HorrificNecktie.roomCount>=2) then
            HorrificNecktie.roomCount=HorrificNecktie.roomCount-2;
            local randomFloat=rng:RandomFloat();
            if(randomFloat<=HorrificNecktie.rate.textWeight) then
                --print("text here!");
                goto continue;
            end
            local game=Game();
            local room=game:GetRoom();
            randomFloat=randomFloat - HorrificNecktie.rate.textWeight;
            if(randomFloat<=HorrificNecktie.rate.soulHeartWeight) then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, room:FindFreePickupSpawnPosition(Position, 0, false), Vector(0,0), nil);
                goto continue;
            end
            randomFloat=randomFloat - HorrificNecktie.rate.soulHeartWeight;
            if(randomFloat<=HorrificNecktie.rate.cardWeight) then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_NULL, room:FindFreePickupSpawnPosition(Position, 0, false), Vector(0,0), nil);
                goto continue;
            end
            randomFloat=randomFloat - HorrificNecktie.rate.cardWeight;
            if(randomFloat<=HorrificNecktie.rate.trinketWeight) then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_NULL, room:FindFreePickupSpawnPosition(Position, 0, false), Vector(0,0), nil);
                goto continue;
            end
            print("error!");
            ::continue::
        end
    end
end
ModName:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, HorrificNecktie.PreSpawnCleanAward)