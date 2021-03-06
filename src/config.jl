# This file allows loading (and dynamically reloading) the configs from
# the configs file: configs.jl.

config_read_timer = Timer()
config_print_error_timer = Timer()

config_reload_time_s = 0.5  # seconds

"""
    reloadConfigsFile()

 Reload "configs.jl" and assign global variables for top-level keys.
 This should be called once for release build during compile time, and can be
 called as part of the run-loop for debug builds to allow on-the-fly editing of
 the configs file.
 """
 function reloadConfigsFile()
     if !started(config_read_timer) || elapsed(config_read_timer) > config_reload_time_s
         try
             include(joinpath(@__DIR__, "..", "assets/configs.jl"))
         catch e
             print_config_error("ERROR: Failed to reload Configs File!:\n '$(e)'")
         end
         start!(config_read_timer)
     end
end

function print_config_error(msg)
    if !started(config_print_error_timer) || elapsed(config_print_error_timer) > 5
        println(msg)
        start!(config_print_error_timer)
    end
end

# Run once during compile time.
reloadConfigsFile()
