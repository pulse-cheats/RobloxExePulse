#include <dlfcn.h>
#include <iostream>
#include "config.h"
#include "ui.h"

// Hook function that gets called when Roblox starts
void onRobloxStart() {
    std::cout << "[RobloxExecutor] Game started. Initializing UI..." << std::endl;
    
    // Initialize ImGui context
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO();
    
    // Initialize UI (this creates the overlay)
    initUI();
}

// Main entry point for the dylib
__attribute__((visibility("default")))
void* init() {
    std::cout << "[RobloxExecutor] Injected successfully!" << std::endl;
    
    // Call the hook
    onRobloxStart();
    
    return nullptr;
}

// Optional: Entry point if loaded via dlopen
__attribute__((constructor))
static void entry() {
    // This runs automatically when the dylib is loaded
    // You might want to wait for a specific symbol to be available
    // For now, we just init.
    init();
}
