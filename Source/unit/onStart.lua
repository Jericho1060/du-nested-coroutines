--[[
    DU-Nested-Coroutines by Jericho
    Permit to easier avoid CPU Load Errors by using nested coroutines and adapt cycles on the FPS
    Source unminified available here: https://github.com/Jericho1060/du-nested-coroutines
]]--
local DU_Nested_Coroutines = {
    __index = {
        coroutines = {
            update = {},
            flush = {}
        },
        functions = {
            update = {},
            flush = {}
        },
        main = {
            update = coroutine.create(function() end),
            flush = coroutine.create(function() end),
        },
        update = function(self)
            local status = coroutine.status(self.main.update)
            if status == "dead" then
                self.main.update = coroutine.create(function() self:runUpdate() end)
            elseif status == "suspended" then
                assert(coroutine.resume(self.main.update))
            end
        end,
        flush = function(self)
            local status = coroutine.status(self.main.flush)
            if status == "dead" then
                self.main.flush = coroutine.create(function() self:runFlush() end)
            elseif status == "suspended" then
                assert(coroutine.resume(self.main.flush))
            end
        end,
        runUpdate = function(self)
            for k,co in pairs(self.coroutines.update) do
                local status = coroutine.status(co)
                if status == "dead" then
                    self.coroutines.update[k] = coroutine.create(self.functions.update[k])
                elseif status == "suspended" then
                    assert(coroutine.resume(co))
                end
            end
        end,
        runFlush = function(self)
            for k,co in pairs(self.coroutines.flush) do
                local status = coroutine.status(co)
                if status == "dead" then
                    self.coroutines.flush[k] = coroutine.create(self.functions.flush[k])
                elseif status == "suspended" then
                    assert(coroutine.resume(co))
                end
            end
        end,
        onUpdate = function(self, functions)
            for k,f in pairs(functions) do
                self.functions.update[k] = f
                self.coroutines.update[k] = coroutine.create(f)
            end
        end,
        onFlush = function(self, functions)
            for k,f in pairs(functions) do
                self.functions.flush[k] = f
                self.coroutines.flush[k] = coroutine.create(f)
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
local functions = {
    update = {},
    flush = {}
}

--Functions to load as coroutines that will be runned in system > onUpdate (based on FPS)
functions.update.co1 = function ()
    for i=0, 10 do
        system.print("coroutine 1 --- update --- "..i)
        coroutine.yield(self.co1) -- pause the coroutine 1
    end
end
functions.update.co2 = function ()
    for i=0, 10 do
        system.print("coroutine 2 --- update --- "..i)
        coroutine.yield(self.co2) -- pause the coroutine 2
    end
end

--Functions to load as coroutines that will be runned in system > onFlush (60 times / s)
functions.flush.co1 = function ()
    for i=0, 10 do
        system.print("coroutine 1 --- flush --- "..i)
        coroutine.yield(self.co1) -- pause the coroutine 1
    end
end
functions.flush.co2 = function ()
    for i=0, 10 do
        system.print("coroutine 2 --- flush --- "..i)
        coroutine.yield(self.co2) -- pause the coroutine 2
    end
end

--[[
    do not change the following
]]
NestCo:onUpdate(functions.update) --loading coroutines for system > onUpdate
NestCo:onFlush(functions.flush) --loading coroutines for system > onFlush
