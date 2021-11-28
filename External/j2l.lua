--[[
ERD:json -> lua dictionary in txt format:
[".?AVFreeCameraOperator@@"]=0x10ec510,
input for 
]]--


print("if required, input filter keyword. any case")
fi = io.read()


-- filter, any case
-- fi = "cam"
-- fi = ""

print()

json = require "json"
--filename="offsets_DarkSoulsII.exe.json"
local nx1 = io.popen("dir /b *json"):read("*all")
--local nx2 = nx1:read("*all")
local _, nx3 = nx1:gsub('\n', '\n')
if nx3 == 1 then fn = nx1:sub(1,-2)
else
print("drag and drop json, please")
fn = io.read()
end

--print(fn)
--os.exit()
if fn == nil then os.exit() end

local f = assert(io.open(fn, "r"))
local t = f:read("*all")
f:close()
t1 = json.decode(t)

fn_out = fi.."_"..fn..'.txt'
local f1 = assert(io.open(fn_out, "w"))

print("file: "..fn)
print("filter: "..fi)
print("output: "..fn_out)
print()

for i=1,#t1 do 
--print(i)
t2 = t1[i]
t3 = t2['name']
t4=t2['possible_matches'][1]
if t4 ~= nil and t3:lower():match(fi) then  
	t5 = '["'..t3..'"]='..t4..','..'\n'
	print(t3)
	f1:write(t5)
end
end

f1:close()
print('\n'..fn.." -> "..fn_out)

print("end")
--io.read()
