function rscan()

s=createMemScan()

s.firstScan(soExactValue, vtString, rtRounded, '.?AV', '', getAddress(process) ,getAddress(process)+getAddress(getModuleSize(process)) ,"*W*X*C" ,fsmNotAligned ,'1' ,false ,true, false, true); --0 str F
s.waitTillDone()

fl=createFoundList(s)

names={}
fl.initialize()
--1
sll=createStringList()
for i=1,fl.Count do
  local a=tonumber(fl[i-1],16)
  names[i]={}
  names[i].name=readString(tonumber(fl[i-1],16)+4)
  names[i].address=a-0x10
  sll.add(names[i].name)
end --1 -0x10

r,selstring=showSelectionList('RTTI Classes','Select the class to find instances of',sll)
if (r==-1) then return end
sll.destroy()

print("You picked "..selstring)
a=names[r+1].address
if targetIs64Bit() then
  a=a-getAddress(process)
end --2 x64 ? -process 

s2=createMemScan()

print(string.format("Scanning for %x", a))
s2.firstScan(soExactValue, vtDword, rtRounded, string.format("%x",a), '', getAddress(process),getAddress(process)+getAddress(getModuleSize(process)) ,"*W*X*C" ,fsmNotAligned ,'1' ,true ,true, false, true); --3 scan4b

s2.waitTillDone()

fl=createFoundList(s2)

--fl.initialize()

print("found "..fl.Count.." results!")
end

function rscan2()

RTTIInfo={}
for i=1,fl.Count do
  local a=tonumber(fl[i-1],16)
  a=a-12 --4 -0xC = 12
  if readBytes(a,1)==1 then
    table.insert(RTTIInfo,a)
  end
end

print("after checking only "..#RTTIInfo.." left")

if targetIs64Bit() then
  scantype=vtQword
  pointersize=8
else
  scantype=vtDword
  pointersize=4
end

vtables={}

for i=1,#RTTIInfo do
  a=RTTIInfo[i]
  fl.deinitialize()
  print(string.format("Scanning for %x", a))
  s.firstScan(soExactValue, scantype, rtRounded, string.format("%x",a), '', getAddress(process) ,getAddress(process)+getAddress(getModuleSize(process)) ,"*W*X*C" ,fsmNotAligned ,'1' ,true ,true, false, true);
  s.waitTillDone()
  fl.initialize()

  for j=1,fl.Count do
    table.insert(vtables, tonumber(fl[j-1],16)+pointersize)
  end
end

print(#vtables.." vtables found")

--scan instances

instances={}

for i=1,#vtables do
  a=vtables[i]
  fl.deinitialize()
  print(string.format("Scanning for %x", a))
  s.firstScan(soExactValue, scantype, rtRounded, string.format("%x",a), '', 0 ,0xffffffffffffffff ,"*W*X*C" ,fsmNotAligned ,'1' ,true ,true, false, true);
  s.waitTillDone()
  fl.initialize()

  for j=1,fl.Count do
    table.insert(instances, tonumber(fl[j-1],16))
  end
end

print("The following instances of the class "..selstring.." where found")
for i=1,#instances do
  print(string.format("%x",instances[i]))
end 
end