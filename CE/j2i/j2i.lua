function rscan()

if not targetIs64Bit() then
print("only x64, soz")
return
end

-- clear console log
-- GetLuaEngine().MenuItem5.doClick()

-- filter, any case
local fi = ""
--fi = "freec"

if fi == "" or fi == nil then
fi = inputQuery('Filter', "if required, input filter keyword. \n any case",'cam')
end

if fi == nil then fi = "" end

print("reading json.lua")
json = require "json"
--fn = "offsets_*.exe.json"
local nx1 = io.popen("dir /b *json"):read("*all")
local _, nx3 = nx1:gsub('\n', '\n')
if nx3 == 1 then fn = nx1:sub(1,-2)
else
dialog = createOpenDialog()
dialog.Filter = "file name (*.json)|*.json"
x = dialog.execute()
fn = dialog.Filename
end

local f = assert(io.open(fn, "r"))
local t = f:read("*all")
f:close()

fn_out = "instances_"..fi..'.txt'
local f1 = assert(io.open(fn_out, "w"))

print("file: "..fn)
print("filter: "..fi)
print("output: "..fn_out)
print()

t1 = json.decode(t)

tA = {}

max = #t1
--max = 10

for i=1,max do
t2 = t1[i]
t3 = t2['name']
t4=t2['possible_matches'][1]
if t4 ~= nil and t3:lower():match(fi) then
--print(t3)
tA[t3]=t4
   end
end

values = tA

--[[ for manual input use j2l then fill in format:
values = {
[".?AVFreeCameraOperator@@"]=1234567,
[".?AVCameraRigidBody@@"]=0xbadf00d,
}
]]--

shouldBreak = false

function scanTable()
al=getAddressList()
  for key, value in pairs(values) do
      print("Scanning for " .. key)
      local ms  =  createMemScan()
      local addr = getAddress(process)
      local toScan = addr + value + 0x8
      ms.firstScan(soExactValue, vtQword, rtRounded,
          tostring(toScan), "", 0, 0xffffffffffffffff, "+W", fsmAligned, "4", false, true, false, false)
      ms.waitTillDone()
      local f = createFoundList(ms)
      f.initialize()
      if f.Count > 0 then
        for i=0,f.Count-1 do
            a = f.Address[i]
            print(a)
            f1:write(key..'\n'..a..'\n')
	    newMR=al.createMemoryRecord();
	    newMR.Description= key
	    newMR.Address=a
	    newMR.IsAddressGroupHeader = true
	    parentMR = al.getMemoryRecordByDescription(key)
	    if parentMR~=nil then newMR.appendToEntry(parentMR) end
        end
      else print("nope")
      end
      ms.destroy()
      f.destroy()
      if shouldBreak == true then
         break
      end
  end
f1:close()
print("end")
end

CreateThread(scanTable)

end