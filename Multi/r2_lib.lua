function AV()

local AV_MS=createMemScan()

AV_MS.firstScan(soExactValue, vtString, rtRounded, '.?AV', '',
getAddress(process) ,getAddress(process)+getAddress(getModuleSize(process)) ,
"+W+X-C" ,fsmNotAligned ,'1' ,false ,true, false, true);

AV_MS.waitTillDone()

local AV_MS_List=createFoundList(AV_MS)

local AV_D = {}

AV_MS_List.initialize()
AV_MS.destroy()


for i=1,AV_MS_List.Count do

 local adr=tonumber(AV_MS_List[i-1],16)
 local nm = readString(adr+4)
 adr = adr-0x10
 if targetIs64Bit() then adr=adr-getAddress(process) end
 AV_D[i] = {}; AV_D[i].n = nm; AV_D[i].a = adr;

end

AV_MS_List.deinitialize()
AV_MS_List.destroy()

return AV_D
end -- AV

--.

function sfx(a)
return string.format("%x",a)
end

---

function naf(names,flt) -- filter array of n-a pair

local flt1 = flt:lower()

local flt_names={}

for i=1,#names do -- for

local name=names[i].n

 if name:lower():match(flt1) then

local a=names[i].a

local x ={}
x.n = name
x.a = a
table.insert(flt_names,x)

 end -- if

end -- for

return flt_names
end

---

function guif(names)

local sll=createStringList()

for i=1,#names do
 sll.add(names[i].n)
end

local r,s = showSelectionList('RTTI Classes','',sll)

sll.destroy()

local flt = inputQuery('Filter', "if required, input filter keyword.",s)

return flt
end

---

function cmp_NA_MSL(NA,MSL)

local NA2 = {}

for i = 1,#NA do -- loop thru n-a table
if stop then break end
 local trg = NA[i].a -- target number

 for j = 0,MSL.Count-1 do -- loop thru candidates MS_List
  local val,adr = MSL.Value[j],MSL.Address[j] --num,str
  -- if val - trg > 0 then break end
  if trg - val == 0 then
   local x = {}; x.n = NA[i].n; x.a = tonumber(adr,16)
   table.insert(NA2,x)
  end --if
 end -- MSL
end -- NA

return NA2
end

---

function rinfo_verif2(RI)

local RI2 = {}

for i = 1,#RI do
local x = RI[i]
local y = x.a - 12
local z = {}; z.n = x.n; z.a = y;
if readBytes(y,1)==1 then table.insert(RI2,z) end
end

return RI2
end

---

--[[
find pointers
'single scan & compare'
single scan for values in target limits
and extract matches
faster for low amount of target values
(caused by low range ?)
]]--

function FP(NA,typ,locs)

local lim = {NA[1].a,NA[#NA].a} -- val boundaries

local cpp = "+W-C-X"

if not typ then
typ = vtDword
end

if not locs then
local gap = getAddress(process)
locs = {gap, gap + getAddress(getModuleSize(process)) }
cpp = '+W-C+X'
end

local MS=createMemScan()
local hexInp = false -- isHexadecimalInput

MS.firstScan(soValueBetween, typ, rtRounded,
lim[1], lim[2],
locs[1], locs[2],
cpp, fsmAligned ,'4',
hexInp, true, false, true);

MS.waitTillDone()

local MSL = createFoundList(MS)
MSL.initialize()
MS.destroy()

local CL = cmp_NA_MSL(NA,MSL)

MSL.deinitialize()
MSL.destroy()

return CL
end

---

--[[
find pointers
multiple scans
faster if there are many target values
vs 'single scan & compare' version
(big range ? )
]]--

function FP(NA,typ,locs)

local cpp = "+W-C-X"

if not typ then
typ = vtDword
end

if not locs then
local gap = getAddress(process)
locs = {gap, gap + getAddress(getModuleSize(process)) }
cpp = '+W-C+X'
end

local NA2 = {}

for i = 1,#NA do

local e1 = NA[i]
local n1 = e1.n
local a1 = e1.a

local MS=createMemScan()
local hexInp = false -- isHexadecimalInput

MS.firstScan(soExactValue, typ, rtRounded,
a1, '',
locs[1], locs[2],
cpp, fsmAligned ,'4',
hexInp, true, false, true);

MS.waitTillDone()

local MSL = createFoundList(MS)
MSL.initialize()
MS.destroy()

for j = 0,MSL.Count-1 do
 local adr = MSL.Address[j]
 local x = {}; x.n = n1; x.a = tonumber(adr,16)
 table.insert(NA2,x)
end

MSL.deinitialize()
MSL.destroy()

end

return NA2
end

---

function adrec_f(NA,grN)

local al=getAddressList()

-- create group with hide option
grpMR=al.createMemoryRecord();
grpMR.Description = grN
grpMR.IsGroupHeader = true;
grpMR.Options = "[moHideChildren]"

for i = 1,#NA do
  local newMR=al.createMemoryRecord();
  newMR.Description= NA[i].n
  newMR.Address= NA[i].a
  newMR.IsAddressGroupHeader = true
  newMR.appendToEntry(grpMR)
end

end

---

function p2c_f(inst)

for i = 1,#inst do
local x = inst[i]
print(x.n, sfx(x.a) )
end

end

---

function w2f_f(inst,Y)

local ofn = 'z_'..Y..'.txt' -- out_file_name
local of = assert(io.open(ofn,'w+'))

for i = 1,#inst do
local x = inst[i]
of:write(x.n..'\t'..sfx(x.a)..'\n' )
end

of:close()

end

---
