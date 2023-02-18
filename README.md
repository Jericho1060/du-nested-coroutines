# Project closed

This project is closed, I will not update it anymore.
It's not abandoned but replaced by a more clean and efficient version with more features. You can find it here: https://github.com/Jericho1060/du-lua-framework  

# du-nested-coroutines
 A small script for DU to avoid any CPU load error by using nested coroutines and adapt cycles on the FPS.

# Guilded Server (better than Discord)

You can join me on Guilded for help or suggestions or requests by following that link : https://guilded.jericho.dev

## How to Install

Copy the content of the file `config.json`.
In the game, right-click on the programming board, and select "Advanced" and "Paste Lua configuration from clipboard".

## How to use

Write your functions in the unit > start event, in the table `functions`.

You can use the standard `coroutine.yield` method in your function by always placing as parameter the table `self.functionName` replacing `functionName` with the name of your function (co1 or co2 in the example).

### example

```lua
local functions = {}
functions.co1 = function ()
    for i=0, 10 do
        system.print("coroutine 1 --- "..i)
        coroutine.yield(self.co1) -- pause the coroutine 1
    end
end
functions.co2 = function ()
    for i=0, 10 do
        system.print("coroutine 2 --- "..i)
        coroutine.yield(self.co2) -- pause the coroutine 2
    end
end
```

# Support or donation

if you like it, [<img src="https://github.com/Jericho1060/DU-Industry-HUD/blob/main/ressources/images/ko-fi.png?raw=true" width="150">](https://ko-fi.com/jericho1060)
