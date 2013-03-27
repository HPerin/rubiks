#ifndef RUBIKS_H
#define RUBIKS_H
#include <Angel.h>

#define VERT_PER_CUBE 36
#define UNIQUE_VERT_PER_CUBE 24
#define FACES_PER_CUBE 6
#define CUBES_PER_PLANE 9
#define NUM_CUBES 27
#define NUM_PLANES 9
#define ROTATION_DURATION 200

#define INITIAL_ROTATION 45.0, 45.0, -45.0
#define ROTATION_FACTOR  0.5

#define INITIAL_SCALE    0.5
#define MIN_SCALE        0.05
#define MAX_SCALE        0.75
#define SCALE_FACTOR     0.05

void display();
void init();
void reshape (int w, int h);
void display();
void keyboard(unsigned char key, int x, int y);
void mouseButton(int button, int state, int x, int y);
void mouseMotion(int x, int y);

void createVBO();
float calculateFPS();
void rotateSlice(int cubes[], int axis, int n, bool isClockwise=true);
void randomRotations(int numRotations);
void initColors();
void updateCubes();

void saveState(char *filename);
void loadState(char *filename);

extern int winWidth, winHeight;
extern GLint positions[NUM_CUBES];
extern GLint rotationAxes[NUM_CUBES];
extern GLfloat rotationProgress;
extern GLint colors[NUM_CUBES][FACES_PER_CUBE];
extern int rotationStartTime;
extern bool finishedRotating;

#define IS_ROTATING (rotationProgress < 1.0f)

#endif

