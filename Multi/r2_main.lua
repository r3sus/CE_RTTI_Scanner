--cfg

local flua = true
-- called from lua console => exec main routine immediately
-- set to false inside CT script

local gui = 1-- = 1 -- user interface

local w2f = 1 -- write to file

local adrec = 1 -- add records to cheat table

local p2c = 1 -- print to console

local stop = false -- use Alt + F3 to interrupt script

local Y = "" -- filter, any case
-- Y = "camerao"

-- instance scan limits
local locs
locs = {0x7ff00000000,0x8fff0000000} -- x64 Dark Souls 2 Scholar
-- a1,a2 = 0x0,0x00007fffffffffff -- scan all

local shk = createHotkey(
function() stop = true;
print("Script interrupted by user.")
return
end,
VK_MENU,VK_F3) -- Alt + F3

--.

local function main()

local nClock = os.clock()

GetLuaEngine().MenuItem5.doClick()
local AV2 = AV() -- na

if gui then
local Y1 = guif(AV2)
if Y1 and Y1 ~= "" then Y = Y1 end
end

if Y and Y ~= "" then AV2 = naf(AV2,Y) end

print(#AV2)

local RIC = FP(AV2)

print(#RIC)

local RI = rinfo_verif2(RIC)

print(#RI)

local scantype = vtDword

if targetIs64Bit() then scantype=vtQword end

local vt = FP(RI,scantype)

print(#vt)

local ps=4 -- pointersize
if targetIs64Bit() then ps=8 end

for i = 1,#vt do vt[i].a = vt[i].a + ps end

local inst = FP(vt,scantype,locs)

print(#inst)

if p2c then p2c_f(inst,Y) end

if adrec then adrec_f(inst,Y) end

if w2f then w2f_f(inst,Y) end

print("Elapsed time is: " .. os.clock()-nClock)

print('Done.');

return
end

if flua then main() end

shk.destroy()
shk = nil
