--[[
    DU-Nested-Coroutines by Jericho
    Permit to easier avoid CPU Load Errors
    Source available here: https://github.com/Jericho1060/du-nested-coroutines
]]--

nestco = {}

function nestco:new(functions)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.functions = functions or {}
    o.coroutines = {} --coroutines containers


    function o.update() return o:_update() end
    function o.init() return o:_init() end
    function o.run() return o:_run() end
    function o.update() return o:_update() end

    o.init()
    o.main = coroutine.create(o.run)
    return o
end

function nestco:_init()
    for k,f in pairs(self.functions) do
        self.coroutines[k] = coroutine.create(f)
    end
end

function nestco:_run()
    for k,co in pairs(self.coroutines) do
        local status = coroutine.status(co)
        if status == "dead" then
            self.coroutines[k] = coroutine.create(self.functions[k])
        elseif status == "suspended" then
            assert(coroutine.resume(co))
        end
    end
end

function nestco:_update()
    local status = coroutine.status(self.main)
    if status == "dead" then
        self.main = coroutine.create(self.run)
    elseif status == "suspended" then
        assert(coroutine.resume(self.main))
    end
end

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
NestCo = nestco:new(functions)
