# du-nested-coroutines
 A small script for DU to avoid any CPU load error

# Guilded Server (better than Discord)

You can join me on Guilded for help or suggestions or requests by following that link : https://guilded.jericho.dev

## How to Install

Copy the content of the file `config.json`
In the game, right click on the programming board, and select "Advanced" and "Paste Lua configuration from clipboard".

## How to use

Write your functions in the unit > start event, in the table `MyCoroutines`.

You can use the stardard coroutine.yield method in your function by always placing as parameter the table `coroutinesTable[index]` replacing `index` with the index of your function (1 for the 1st function, 2 for the second and so on)

### example

```lua
MyCoroutines = {
    function()
        for i=0, 10 do
            system.print("function 1 --- "..i)
            coroutine.yield(coroutinesTable[1])--start with index 1 and so on
        end
    end,
    function()
        for i=0, 10 do
            system.print("function 2 --- "..i)
            coroutine.yield(coroutinesTable[2])--the second fonction yiel is with index 2
        end
    end
}
```

# Support or donation

if you like it, [<img src="https://github.com/Jericho1060/DU-Industry-HUD/blob/main/ressources/images/ko-fi.png?raw=true" width="150">](https://ko-fi.com/jericho1060)
