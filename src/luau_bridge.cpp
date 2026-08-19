#include <iostream>
#include "ui.h"

// Include Luau headers correctly
#include "luau/Lua.h"
#include "luau/LuaLib.h"
#include "luau/LuaAux.h"

// Bridge between C++ and Luau
extern "C" {
    // Luau uses standard Lua API compatibility
}

// You need to link against the Luau library
// This is a simplified example

int executeScript(const std::string& code) {
    // Create a new Lua state
    lua_State* L = lua_create();
    
    // Open standard libraries
    lua_openlibs(L);
    
    // Register Roblox API here (e.g., game, workspace, etc.)
    // pushRobloxAPI(L);
    
    // Execute the script
    int result = lua_dostring(L, code.c_str());
    
    if (result != LUA_OK) {
        std::string err = lua_tostring(L, -1);
        lua_pop(L, 1);
        std::cerr << "[Luau Error]: " << err << std::endl;
        lua_destroy(L);
        return 1;
    }
    
    lua_destroy(L);
    return 0;
}

// Expose this to UI
void onExecuteScript(const std::string& code) {
    int result = executeScript(code);
    if (result == 0) {
        // Success
    } else {
        // Error
    }
}
