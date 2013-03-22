#version 150

in vec4 vPosition;
out vec4 color;
uniform mat4 rotationMat; // Rotate the entire Rubik's cube
uniform float scale;      // Scale the entire Rubik's cube
uniform float progress;   // In the middle of a rotation, 0.0 to 1.0

// Arrays of bit-packed ints with individual sub-cube rotation info
uniform int rotations[27];     
uniform int rotationsPrev[27];

/** Based on which sub-cube this is, determine color of this vertex */
vec4 getColor(vec4 cubeOffset) {
	const vec4 faceColors[6] = {
		vec4(1.0, 0.5, 0.0, 1.0), // Left   (-x) Orange
		vec4(1.0, 0.0, 0.0, 1.0), // Right  (+x) Red
		vec4(0.0, 1.0, 0.0, 1.0), // Bottom (-y) Green
		vec4(1.0, 1.0, 0.0, 1.0), // Top    (+y) Yellow
		vec4(0.0, 0.0, 1.0, 1.0), // Back   (-z) Blue
		vec4(1.0, 1.0, 1.0, 1.0), // Front  (+z) White
	};

	// Determine which face of the Rubik's cube this sub-cube is part of
	for (int i=0; i<6; i++) {
		if (cubeOffset[i/2] == i%2*2-1 && gl_VertexID/4 == i)
			return faceColors[i];
	}

	// No matches found: this vertex is black
	return vec4(0.0, 0.0, 0.0, 1.0);
}

/** Based on which sub-cube this is, and the uniform rotations/rotationsPrev 
    arrays, determine the angle of rotation of this vertex */
mat4 getRotation() {
	// Unpack the bits to determine rotation in x, y, and z axes
	int packed = rotations[gl_InstanceID];
	int packedPrev = rotationsPrev[gl_InstanceID];

	vec3 degreesPrev = 90 * vec3(
		packedPrev & 3,
		(packedPrev >> 2) & 3,
		(packedPrev >> 4) & 3
	);
	vec3 degreesNext = 90 * vec3(
		packed & 3,
		(packed >> 2) & 3,
		(packed >> 4) & 3
	);

	// Check if one of the degrees is 270 and the other 0
	// (necessary because `mix` is unaware that 0 degrees is also 360)
	vec3 degreeChange = degreesNext - degreesPrev;
	for (int i=0; i<3; i++) {
		if (degreeChange[i] > 90) // degreesPrev[i] is 0
			degreesPrev[i] = 360;
		else if (degreeChange[i] <= -90) // degreesNext[i] is 0
			degreesNext[i] = 360;
	}

	// Interpolate rotation based on progress
	vec3 radiansCurr = mix(
		radians(degreesPrev), 
		radians(degreesNext), 
		progress
	);

	// Calculate rotation matrices
	vec3 c = cos(radiansCurr);
	vec3 s = sin(radiansCurr);

	mat4 rx = mat4( 
		1.0,  0.0,  0.0,  0.0,
		0.0,  c.x,  s.x,  0.0,
		0.0, -s.x,  c.x,  0.0,
		0.0,  0.0,  0.0,  1.0 
	);
	mat4 ry = mat4( 
		c.y,  0.0, -s.y,  0.0,
		0.0,  1.0,  0.0,  0.0,
		s.y,  0.0,  c.y,  0.0,
		0.0,  0.0,  0.0,  1.0 
	);
	mat4 rz = mat4( 
		c.z, -s.z,  0.0,  0.0,
		s.z,  c.z,  0.0,  0.0,
		0.0,  0.0,  1.0,  0.0,
		0.0,  0.0,  0.0,  1.0 
	);

	// Workaround for bug in ATI driver (??)
	ry[1][0] = 0.0;
	ry[1][1] = 1.0;
	rz[2][2] = 1.0;

	return rz * ry * rx;
}

void main() {
	// Position the cube based on gl_InstanceID
	int x = gl_InstanceID%3 - 1;
	int y = (gl_InstanceID%9)/3 - 1;
	int z = gl_InstanceID/9 - 1;
	vec4 cubeOffset = vec4(x, y, z, 1.0);

	vPosition += cubeOffset*1.05; // Leave some space between sub-cubes
	vPosition.xyz *= scale;

	color = getColor(cubeOffset);
	gl_Position = rotationMat * getRotation() * vPosition;
} 

