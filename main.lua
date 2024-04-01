ModName = RegisterMod("OldWorldCreation",1)

local loaded = {};
function ModName.Require(path) 
    if (not loaded[path]) then
        loaded[path] = include(path);
    end
    return loaded[path];
end;
Require = ModName.Require;
--require("code.RequireData")
ModName.Effects={
    Trail=require("code.Effects.Trail"),
}
ModName.Item={
    Sandevistan = require("code.Items.Sandevistan"),
    HorrificNecktie = require("code.Items.HorrificNecktie"),
}
