# Cheat Engine RTTI Reverse Lookup script

find instances of the class 

## Demo

You picked FreeCameraOperator@@ 
Scanning for 157d0a0 
found 2 results 
140995da0 
140995df4 
after checking only 1 left 
Scanning for 140995da0 
1407ac518 
1 vtables found 
Scanning for 1407ac518 
The following instances of the class FreeCameraOperator@@ where found 
7fff235a0f0 

## Further actions

Insert in any ReClass

## References

https://florian0.wordpress.com/2017/12/21/using-runtime-type-information-rtti-to-extract-class-names-and-hierarchy/
https://www.framedsc.com/GeneralGuides/using_rtti.htm
https://badecho.com/index.php/2020/09/25/hacking-dark-souls-iii-part-1/

## Credits

99.9% DarkByte

---

# Technical Details

## Code Base

https://github.com/cheat-engine/cheat-engine/issues/1159
alt:
https://www.cheatengine.org/forum/viewtopic.php?t=613639

## Changes

add s=createMemScan() before each firstScan
fl=createFoundList(s) pre initialize
debug output

## Unoptimized scan

doesn't accounts page protection