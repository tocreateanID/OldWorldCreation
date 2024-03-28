local Trail = {}
local name="Trail"
Trail.Type = Isaac.GetEntityTypeByName(name);
Trail.Variant = Isaac.GetEntityVariantByName(name);
Trail.ID = Trail.Type;
Trail.Name = name;
Trail.SubType = 0;
Trail.DataName = name;

local function PostTrailUpdate(mod, trail)
    local frame = trail.FrameCount;
    local maxFrame = 75;
    local r=104/255*(1 - frame / maxFrame);
    local g=0;
    local b=1-106/255*(1 - frame / maxFrame);
    local a = 1 - frame / maxFrame;
    trail:GetSprite().Color = Color(r, g, b, a, 0, 0, 0);
    local dashtime= ModName.Item.Sandevistan.getDashTime();
    if (dashtime<=0) then
        print("dashtime=",dashtime);    
        trail:Remove();
    end
    if(frame>=maxFrame)then
        print("maxframe>",dashtime);
        trail:Remove();
    end
end
ModName:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, PostTrailUpdate, Trail.Variant)
ModName:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, PostTrailUpdate, Trail.Variant)

return Trail;