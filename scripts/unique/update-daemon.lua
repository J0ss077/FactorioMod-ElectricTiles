local network_controller = require("scripts.controller.network-controller")

local nth_tick = require("__factory077-lib__.modules.nth_tick")

local daemon = {}

local base_subscription = nil
local long_subscription = nil

local function resubscribe(subscription, nth, handler, key)
    if subscription and subscription.nth_tick == nth then return subscription end

    if subscription then
        nth_tick.off(subscription.nth_tick, subscription)
    end

    return nth_tick.on(nth, handler, { key = key })
end

function daemon.apply_settings()
    base_subscription = resubscribe(
        base_subscription, settings.global["F077ET-base-update-delay"].value,
        network_controller.process_base_cached_chunks, "electric-tiles/base-timer"
    )
    long_subscription = resubscribe(
        long_subscription, settings.global["F077ET-long-update-delay"].value,
        network_controller.process_long_cached_chunks, "electric-tiles/long-timer"
    )
end

return daemon
