#include "Angel.h"

#define WIN_WIDTH  640
#define WIN_HEIGHT 640
#define VERT_PER_CUBE 24

void createVBO();
extern GLuint vbo, ibo;
GLuint vao;

void init() {
	// Vertex Array Object
	glGenVertexArrays(1, &vao);
	glBindVertexArray(vao);
	createVBO();

	GLuint program = InitShader("vshader.glsl", "fshader.glsl");
	glUseProgram(program);

	size_t colorDataOffset = sizeof(float) * 4 * VERT_PER_CUBE;
	glBindBuffer(GL_ARRAY_BUFFER, vbo);

	GLuint vPosition = glGetAttribLocation(program, "vPosition");
	glEnableVertexAttribArray(vPosition);
	glVertexAttribPointer(vPosition, 4, GL_FLOAT, GL_FALSE, 0, 0);

	GLuint vColor = glGetAttribLocation(program, "vColor");
	glEnableVertexAttribArray(vColor);
	glVertexAttribPointer(vColor, 4, GL_FLOAT, GL_FALSE, 0, (void*)colorDataOffset);
	//glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
	//glBindVertexArray(vPosition);

	glEnable(GL_DEPTH_TEST);
	glDepthMask(GL_TRUE);
	glDepthFunc(GL_LEQUAL);
	glDepthRange(0.0f, 1.0f);
	glClearColor(1.0, 1.0, 1.0, 1.0);

	glBindVertexArray(vao);
}

void reshape (int w, int h) {
}

void display() {
/*
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glDrawArrays(GL_TRIANGLES, 0, VERT_PER_CUBE);
	glutSwapBuffers();
*/
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClearDepth(1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glBindVertexArray(vao);

	glDrawElements(GL_TRIANGLES, VERT_PER_CUBE, GL_UNSIGNED_SHORT, 0);

	glDrawElementsBaseVertex(GL_TRIANGLES, VERT_PER_CUBE,
			GL_UNSIGNED_SHORT, 0, VERT_PER_CUBE / 2);

	glBindVertexArray(0);

	glutSwapBuffers();
}

void keyboard(unsigned char key, int x, int y) {
	switch( key ) {
	case 033: // Esc
	case 'q': 
		exit( EXIT_SUCCESS );
		break;
	}
}

void mouse(int button, int state, int x, int y) {
}

void idle() {
}

int main(int argc, char *argv[]) {
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);
	glutInitWindowSize(WIN_WIDTH, WIN_HEIGHT);
	glutInitContextVersion(3, 2);
	glutInitContextProfile(GLUT_CORE_PROFILE);
	glutCreateWindow("Rubik's Cube");

	glewInit();
	init();

	glutDisplayFunc(display);
	glutKeyboardFunc(keyboard);
	glutMouseFunc(mouse);
	glutIdleFunc(idle);

	glutMainLoop();
	return 0;
}
