--[[
    DU-Nested-Coroutines by Jericho
    Permit to easier avoid CPU Load Errors by using nested coroutines and adapt cycles on the FPS
    Source unminified available here: https://github.com/Jericho1060/du-nested-coroutines
]]--
local DU_Nested_Coroutines = {
    __index = {
        coroutines = {},
        functions = {},
        main = coroutine.create(function() end),
        update = function(self)
            local status = coroutine.status(self.main)
            if status == "dead" then
                self.main = coroutine.create(function() self:run() end)
            elseif status == "suspended" then
                assert(coroutine.resume(self.main))
            end
        end,
        run = function(self)
            for k,co in pairs(self.coroutines) do
                local status = coroutine.status(co)
                if status == "dead" then
                    self.coroutines[k] = coroutine.create(self.functions[k])
                elseif status == "suspended" then
                    assert(coroutine.resume(co))
                end
            end
        end,
        init = function(self, functions)
            for k,f in pairs(functions) do
                self.functions[k] = f
                self.coroutines[k] = coroutine.create(f)
            end
        end
    }
}
NestCo = {}
setmetatable(NestCo, DU_Nested_Coroutines)

--[[
    add the functions you want to run as coroutines here
    you can remove co1 and co2 that are given as example
]]
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

--[[
    do not change the following
]]
NestCo:init(functions)
