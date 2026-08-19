#ifndef UI_H
#define UI_H

#include <vector>
#include <string>
#include <functional>

struct Script {
    std::string name;
    std::string content;
};

class UI {
public:
    void render();
    void init();
    
    // UI State
    bool isOpen = true;
    std::string scriptCode = "";
    std::string scriptName = "untitled.lua";
    std::vector<Script> savedScripts;
    std::string logMessage = "";
    
    // Callbacks
    std::function<void()> onExecute;
    std::function<void()> onPaste;
    std::function<void()> onDelete;
    std::function<void()> onSave;
    
private:
    void renderScriptEditor();
    void renderButtonBar();
    void renderLog();
};

// Global instance accessor
UI& getUI();

// Functions to call from main.cpp
void initUI();
void renderUI();

#endif // UI_H
