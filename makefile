CXX = clang++
CXXFLAGS = -std=c++17 -fPIC -shared
INCLUDES = -I./include -I./src
LIBS = -framework Foundation -framework UIKit -framework Metal -framework MetalKit

SRCS = src/main.cpp src/ui.mm src/luau_bridge.cpp
OBJS = $(SRCS:.cpp=.o)
TARGET = RobloxExecutor.dylib

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(LIBS) $^ -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

%.o: %.mm
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(LIBS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean
