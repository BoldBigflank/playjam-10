local pd <const> = playdate
local gfx <const> = playdate.graphics

---@class Events
---@field callbacks table<string, {callback: function, target: any}[]>
class('Events').extends()

---Initialize a new Events instance
function Events:init()
    self.callbacks = {}
    self.pc = 0
end

---Register a callback for an event
---@param event string The event name to listen for
---@param callback function The callback function to execute
---@param target? any The target object to bind the callback to (optional)
function Events:on(event, callback, target)
    assert(type(event) == "string", "Event name must be a string")
    assert(type(callback) == "function", "Callback must be a function")

    self.callbacks[event] = self.callbacks[event] or {}
    -- make a unique id for the callback
    local id = self.pc + 1
    self.pc = id
    table.insert(self.callbacks[event], { id = id, callback = callback, target = target })
    return id
end

---Unregister a callback for an event
---@param event string The event name to remove the callback from
---@param callback function The callback function to remove
---@param target? any The target object the callback was bound to (optional)
function Events:off(event, callback, target)
    if not self.callbacks[event] then return end

    for i = #self.callbacks[event], 1, -1 do
        local e = self.callbacks[event][i]
        if e.callback == callback and e.target == target then
            table.remove(self.callbacks[event], i)
            return
        end
    end
end

---Unregister a callback for an event by id
---@param id number The id of the callback to remove
function Events:offById(id)
    for event, callbacks in pairs(self.callbacks) do
        for i = #callbacks, 1, -1 do
            if callbacks[i].id == id then
                table.remove(callbacks, i)
                return
            end
        end
    end
end

---Emit an event to all registered callbacks
---@param event string The event name to emit
---@param ... any Additional arguments to pass to the callbacks
function Events:emit(event, ...)
    if not self.callbacks[event] then return end

    -- Create a copy to allow callbacks to modify the original list
    local callbacks = table.shallowcopy(self.callbacks[event])
    local args = { ... }

    for _, fn in ipairs(callbacks) do
        local success, err = pcall(function()
            if fn.target then
                fn.callback(fn.target, table.unpack(args))
            else
                fn.callback(table.unpack(args))
            end
        end)

        if not success then
            print(string.format("Error in event callback for '%s': %s", event, err))
        end
    end
end

-- Create singleton instance
Events = Events()
