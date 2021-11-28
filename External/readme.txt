# j2i

json to instances

x64 only

process etra0/rtti_dumper output to find RTTI class instances 

https://github.com/etra0/rtti_dumper

ERD -> json -> j2i -> class instances

requires rxi/json.lua 

https://github.com/rxi/json.lua

## CT

launches j2l.lua

json -> CT -> class instances

batch process classes filtered by set name
all instances (if any) added to table and file

put the json in same folder or choose from dialog
recommended to set name filter as the only way to interrupt the script for now is close table

scan procedure by etra

## j2l

supplemental script, might be used to create lua dictionary in txt format
which then can be used as alternative (manual) input for CT

json -> j2l -> txt 

example:
[".?AVFeScenePlayerNetCurrentKeyword@@"]=17770104,
[".?AVFeScenePlayerVoiceChatIcon@@"]=17769952,
[".?AVFreeCameraOperator@@"]=0xbadf00d,
