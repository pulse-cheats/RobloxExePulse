#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

// Include ImGui core and backends
#include "imgui/imgui.h"
#include "imgui/imgui_impl_metal.h"
#include "imgui/imgui_impl_uikit.h" // If using UIKit specific backend

#include "ui.h"

// Global UI Instance
static UI* g_uiInstance = nullptr;

UI& getUI() {
    if (!g_uiInstance) {
        g_uiInstance = new UI();
    }
    return *g_uiInstance;
}

void initUI() {
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO();
    
    // Initialize Metal backend
    // Note: You need a valid MTLDevice here. 
    // In a real Roblox injection, this device is passed from the host app.
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    ImGui_ImplMetal_Init(device);
    
    // Initialize UIKit backend
    ImGui_ImplUIKit_Init(nil); // Pass UIWindow if available
    
    // Style
    ImGui::StyleColorsDark();
    ImVec4* colors = ImGui::GetStyle().Colors;
    colors[ImGuiCol_WindowBg] = ImVec4(0.1f, 0.1f, 0.1f, 0.9f);
    colors[ImGuiCol_Button] = ImVec4(0.2f, 0.6f, 0.2f, 1.0f);
    colors[ImGuiCol_ButtonHovered] = ImVec4(0.3f, 0.7f, 0.3f, 1.0f);
}

void renderUI() {
    if (!getUI().isOpen) return;
    
    ImGui_ImplMetal_NewFrame();
    ImGui_ImplUIKit_NewFrame();
    ImGui::NewFrame();
    
    // Render the main window
    ImGui::Begin("Roblox Executor", &getUI().isOpen, ImGuiWindowFlags_NoTitleBar);
    getUI().render();
    ImGui::End();
    
    ImGui::Render();
    
    // Render to Metal layer
    // In a real scenario, this is called from the render loop of the host app
    // For now, we assume the host app calls the render function.
    // ImGui_ImplMetal_RenderDrawData(ImGui::GetDrawData(), nil);
}

// --- UI Logic Implementation ---

void UI::render() {
    renderScriptEditor();
    renderButtonBar();
    renderLog();
}

void UI::renderScriptEditor() {
    ImGui::Text("Script Editor");
    ImGui::InputTextMultiline("##CodeEditor", 
                              const_cast<char*>(scriptCode.c_str()), 
                              ImVec2(-FLT_MIN, 200), 
                              ImGuiInputTextFlags_AllowTabInput);
    
    ImGui::Separator();
    ImGui::Text("Save Name:");
    ImGui::InputText("##ScriptName", const_cast<char*>(scriptName.c_str()), 64);
}

void UI::renderButtonBar() {
    if (ImGui::Button("📋 Paste Script")) {
        logMessage = "[Paste] Clipboard read.";
    }
    
    ImGui::SameLine();
    if (ImGui::Button("🗑️ Delete")) {
        scriptCode = "";
        logMessage = "[Clear] Script cleared.";
    }
    
    ImGui::SameLine();
    if (ImGui::Button("💾 Save")) {
        Script s;
        s.name = scriptName;
        s.content = scriptCode;
        savedScripts.push_back(s);
        logMessage = "[Save] Script '" + scriptName + "' saved.";
    }
    
    ImGui::SameLine();
    if (ImGui::Button("▶️ Execute")) {
        if (onExecute) onExecute();
        else logMessage = "[Execute] No executor bound.";
    }
}

void UI::renderLog() {
    ImGui::Separator();
    ImGui::Text("Log:");
    ImGui::TextWrapped("%s", logMessage.c_str());
}


NoTrack AI — https://notrack.ai/
