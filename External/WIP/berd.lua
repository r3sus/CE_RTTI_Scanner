local function gui()

if fi == "" or fi == nil then
fi = inputQuery('Filter', "if required, input filter keyword. \n any case",'cam')
end

if fi == nil then fi = "" end

return
end

-- x

local function ijf() -- input json file

--fn = "offsets_*.exe.json"
local nx1 = io.popen("dir /b *json"):read("*all")
local _, nx3 = nx1:gsub('\n', '\n')
local fn

if nx3 == 1 then fn = nx1:sub(1,-2)
else -- ~= 1 json file
local dialog = createOpenDialog()
dialog.Filter = "file name (*.json)|*.json"
dialog.execute()
fn = dialog.Filename
end

return fn
end

-- x

local function jfr(fn) -- json file read

local f = assert(io.open(fn, "r"))
local t = f:read("*all")
f:close()

print("reading json.lua")
local json = require "json"

local t1 = json.decode(t)

local tA = {}

local max = #t1
--max = 10

local k = 0

 for i=1,max do
t2 = t1[i]
t3 = t2['name']
t4=t2['possible_matches'] -- loop, adjust name if > 1
 -- and t3:lower():match(fi) --print(t3)
for j = 1,#t4 do
k = k + 1
tA[k] = {}
local toScan = getAddress(process) + t4[j] + 0x8
tA[k].a = toScan
tA[k].n = t3
end
--if j>1 then print('#vt>1') end
 end
 -- if t4[j] ~= nil then  end
 -- assume for loop wouldn't enter empty array
 -- ensure unique name if >1 vtables
 -- end -- j

return tA
end

-- x

function filter(names,flt1)

local flt_names={}

for i=1,#names do -- for

local name=names[i].n

 if name:lower():match(flt1) then -- process

local a=names[i].a

local x ={}
x.n = name
x.a = a
table.insert(flt_names,x)
--print(name)

 end -- process

end -- for

return flt_names
end

-- x

-- setup output

local function set_out(values)

local fn_out = "instances_"..fi..'.txt'
local f1 = assert(io.open(fn_out, "w"))

print("file: "..fn)
print("filter: "..fi)
print("output: "..fn_out)

return
end

-- x
--todo: add limits as params
local function ins(value, a1, a2) -- instances
      local ms  =  createMemScan()
      local insL = {}
      ms.firstScan(soExactValue, vtQword, rtRounded,
          value, "", a1, a2, "+W-X-C",
          fsmAligned, "4",
          false, -- decimal number input (not hex string)
          true, false, false)
	  ms.waitTillDone()
      local f = createFoundList(ms)
      f.initialize()

      for i=1,f.Count do
      local a = f.Address[i-1];
      insL[i] = a;
      --print(a)
      end

      ms.destroy()
      f.destroy()
return insL
end

-- x

function guif(names)

local sll=createStringList()

for i=1,#names do
 sll.add(names[i].n)
end

local r,s = showSelectionList('RTTI Classes','',sll)

sll.destroy()

-- filter

local flt = inputQuery('Filter', "if required, input filter keyword.",s)

return flt
end

-- x

local function adrec_f(names,adrL)

local al=getAddressList()

  local newMR=al.createMemoryRecord();
  newMR.Description= n
  newMR.Address= a
  newMR.IsAddressGroupHeader = true
  newMR.appendToEntry(grpMR)

if #fro1>0 and adrec then -- create group with hide option
grpMR=al.createMemoryRecord();
grpMR.Description = flt
grpMR.IsGroupHeader = true;
grpMR.Options = "[moHideChildren]"
end

end

-- cfg

local adrec --= 1 -- add records to cheat table
local gui -- = 1 -- user interface
local w2f = 1 -- write to file

local p2c = 1 -- print to console

local outf = "vts\\" -- output folder

local shk = createHotkey( -- stop script hk
function() stop = true end,
VK_MENU,VK_F3) -- Alt + F3

local flt = "camerao" -- filter, any case
--fi = "freec"

-- instance scan limits
local a1,a2
a1,a2 = 0x7ff00000000,0x8fff0000000 -- x64 Dark Souls 2 Scholar
-- a1,a2 = 0x0,0x00007fffffffffff -- scan all

-- x cfg

-- x

local function main()

GetLuaEngine().MenuItem5.doClick() -- clear console log

print("Start")

if not targetIs64Bit() then
print("x32 not supported by ERD")
return
end

local ijf1 = ijf()

local vt_d = jfr(ijf1)

-- show list of names, gui
if gui then flt = guif(vt_d) end

if flt == nil then flt = "" end

local flt1 = flt:lower()

local fro1 = filter(vt_d,flt1) -- filtered object

local al=getAddressList()

local insL = {} -- List

 for i = 1, #fro1 do

if stop then break end

insL[i] = ins(fro1[i].a, a1, a2)

 end

 --[[

for i = 1, #fro1 do

 for j = 1,#insL[i] do

local n,a = fro1[i].n,insL[i][j]
--print(n..'\t'..a)

 end

end

]]-- x

-- if adrec then adrec_f(n,a) end


--[[
  for j = 1, #insL1 do

local n,a = fro1[i].n,insL1[j]

print(n..'\t'..a)

if adrec then adrec_f(n,a) end

  end
]]--

-- CreateThread(scanTable(values))

if stop then print("Script interrupted by user.") end

print("Done")

return
end

main()

