# OpenGL makefile for Cygwin on Windows
.NULL: .exe

SOURCES = $(wildcard src/*.cpp)
OBJECTS = $(addprefix obj/,$(notdir $(SOURCES:.cpp=.o)))

CXX = g++
CXXOPTS =
CXXDEFS = -DFREEGLUT_STATIC -DGLEW_STATIC
CXXINCS = -Iinclude
CXXFLAGS = $(CXXOPTS) $(CXXDEFS) $(CXXINCS)

LDOPTS =
LDDIRS = -Llib
LDLIBS = -lglut -lGLU -lGL -lGLEW
LDFLAGS = $(LDOPTS) $(LDDIRS) $(LDLIBS)

#---------------------------------------------------------------------------

all: rubiks.out

rubiks.out: $(OBJECTS)
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

obj/%.o: src/%.cpp 
	$(CXX) $(CXXFLAGS) -c -o $@ $<

#---------------------------------------------------------------------------

clean:
	find . \( -name '*.out' -or -name '*.o' \) -delete

