#version 410

layout(location = 0) in vec3 position;
layout(location = 1) in vec2 uv_vertex;

// Data from CPU 
uniform mat4 MVP; // ModelViewProjection Matrix
uniform mat4 MV; // ModelView idMVPMatrix
uniform vec4 cameraPosition;
uniform float heightFactor;

// Texture-related data
uniform sampler2D rgbTexture;
uniform int widthTexture;
uniform int heightTexture;


// Output to Fragment Shader
out vec2 textureCoordinate; // For texture-color
out vec3 vertexNormal; // For Lighting computation
out vec3 ToLightVector; // Vector from Vertex to Light;
out vec3 ToCameraVector; // Vector from Vertex to Camera;
out float distance_v;


void main()
{

    // get texture value, compute height
    // compute normal vector using also the heights of neighbor vertices

    // compute toLight vector vertex coordinate in VCS
   
   // set gl_Position variable correctly to give the transformed vertex position


   textureCoordinate = uv_vertex;
   vec4 tex_vert_colour = texture(rgbTexture, textureCoordinate);
   float y_position = heightFactor * (0.2126*tex_vert_colour.r + 0.7152*tex_vert_colour.g + 0.0722*tex_vert_colour.b);

	if(position.x == 0 && position.z == 0) {

		//sol altta ise

		//iki ucgen var



		//1. ucgen icin

		//tri1 vert1
		vec3 uc1_vert1 = vec3(position.x,y_position,position.z);

		//tr1 vert2
		vec2 uc1_vert2_tex_coor;
		uc1_vert2_tex_coor.x = textureCoordinate.x + 1/widthTexture;
		uc1_vert2_tex_coor.y = textureCoordinate.y;
		vec4 uc1_vert2_colour = texture(rgbTexture, uc1_vert2_tex_coor);

		float uc1_vert2_y = heightFactor * (0.2126*uc1_vert2_colour.r + 0.7152*uc1_vert2_colour.g + 0.0722*uc1_vert2_colour.b);

		vec3 uc1_vert2 = vec3(position.x+1,uc1_vert2_y,position.z);

		//tri1 vert3
		vec2 uc1_vert3_tex_coor;
		uc1_vert3_tex_coor.x = textureCoordinate.x + 1/widthTexture;
		uc1_vert3_tex_coor.y = textureCoordinate.y + 1/heightTexture;
		vec4 uc1_vert3_colour = texture(rgbTexture, uc1_vert3_tex_coor);

		float uc1_vert3_y = heightFactor * (0.2126*uc1_vert3_colour.r + 0.7152*uc1_vert3_colour.g + 0.0722*uc1_vert3_colour.b);

		vec3 uc1_vert3 = vec3(position.x+1,uc1_vert3_y,position.z+1);		

		//ucgen1 normal
		vec3 normal_uc1 = normalize(cross((uc1_vert2-uc1_vert1),(uc1_vert3-uc1_vert1)));



		//2. ucgen icin

		//tri2 vert1
		vec3 uc2_vert1 = vec3(position.x,y_position,position.z);


		vec3 uc2_vert2 = uc1_vert3;

		//tri1 vert3
		vec2 uc2_vert3_tex_coor;
		uc2_vert3_tex_coor.x = textureCoordinate.x;
		uc2_vert3_tex_coor.y = textureCoordinate.y + 1/heightTexture;
		vec4 uc2_vert3_colour = texture(rgbTexture, uc2_vert3_tex_coor);

		float uc2_vert3_y = heightFactor * (0.2126*uc2_vert3_colour.r + 0.7152*uc2_vert3_colour.g + 0.0722*uc2_vert3_colour.b);

		vec3 uc2_vert3 = vec3(position.x,uc1_vert3_y,position.z+1);		

		//ucgen1 normal
		vec3 normal_uc2 = normalize(cross((uc2_vert2-uc2_vert1),(uc2_vert3-uc2_vert1)));

		vec3 mean_norm = normalize((normal_uc1+normal_uc2)/2);		

		vertexNormal = mean_norm;

	}
	else if(position.x == widthTexture && position.z == heightTexture) {

		//sag ustte ise

		//iki ucgen var

		//1. ucgen icin

		//tri1 vert1
		vec3 uc1_vert1 = vec3(position.x,y_position,position.z);

		//tr1 vert2
		vec2 uc1_vert2_tex_coor;
		uc1_vert2_tex_coor.x = textureCoordinate.x - 1/widthTexture;
		uc1_vert2_tex_coor.y = textureCoordinate.y;
		vec4 uc1_vert2_colour = texture(rgbTexture, uc1_vert2_tex_coor);

		float uc1_vert2_y = heightFactor * (0.2126*uc1_vert2_colour.r + 0.7152*uc1_vert2_colour.g + 0.0722*uc1_vert2_colour.b);

		vec3 uc1_vert2 = vec3(position.x-1,uc1_vert2_y,position.z);

		//tri1 vert3
		vec2 uc1_vert3_tex_coor;
		uc1_vert3_tex_coor.x = textureCoordinate.x - 1/widthTexture;
		uc1_vert3_tex_coor.y = textureCoordinate.y - 1/heightTexture;
		vec4 uc1_vert3_colour = texture(rgbTexture, uc1_vert3_tex_coor);

		float uc1_vert3_y = heightFactor * (0.2126*uc1_vert3_colour.r + 0.7152*uc1_vert3_colour.g + 0.0722*uc1_vert3_colour.b);

		vec3 uc1_vert3 = vec3(position.x-1,uc1_vert3_y,position.z-1);		

		//ucgen1 normal
		vec3 normal_uc1 = normalize(cross((uc1_vert2-uc1_vert1),(uc1_vert3-uc1_vert1)));



		//2. ucgen icin

		//tri2 vert1
		vec3 uc2_vert1 = vec3(position.x,y_position,position.z);


		vec3 uc2_vert2 = uc1_vert3;

		//tri1 vert3
		vec2 uc2_vert3_tex_coor;
		uc2_vert3_tex_coor.x = textureCoordinate.x;
		uc2_vert3_tex_coor.y = textureCoordinate.y - 1/heightTexture;
		vec4 uc2_vert3_colour = texture(rgbTexture, uc2_vert3_tex_coor);

		float uc2_vert3_y = heightFactor * (0.2126*uc2_vert3_colour.r + 0.7152*uc2_vert3_colour.g + 0.0722*uc2_vert3_colour.b);

		vec3 uc2_vert3 = vec3(position.x,uc1_vert3_y,position.z-1);		

		//ucgen1 normal
		vec3 normal_uc2 = normalize(cross((uc2_vert2-uc2_vert1),(uc2_vert3-uc2_vert1)));

		vec3 mean_norm = normalize((normal_uc1+normal_uc2)/2);		

		vertexNormal = mean_norm;

	}
	else if(position.x == widthTexture && position.z == 0) {

		//sag altta ise

		//bir ucgen var

		//1. ucgen icin

		//tri1 vert1
		vec3 uc1_vert1 = vec3(position.x,y_position,position.z);

		//tr1 vert2
		vec2 uc1_vert2_tex_coor;
		uc1_vert2_tex_coor.x = textureCoordinate.x - 1/widthTexture;
		uc1_vert2_tex_coor.y = textureCoordinate.y;
		vec4 uc1_vert2_colour = texture(rgbTexture, uc1_vert2_tex_coor);

		float uc1_vert2_y = heightFactor * (0.2126*uc1_vert2_colour.r + 0.7152*uc1_vert2_colour.g + 0.0722*uc1_vert2_colour.b);

		vec3 uc1_vert2 = vec3(position.x-1,uc1_vert2_y,position.z);

		//tri1 vert3
		vec2 uc1_vert3_tex_coor;
		uc1_vert3_tex_coor.x = textureCoordinate.x;
		uc1_vert3_tex_coor.y = textureCoordinate.y + 1/heightTexture;
		vec4 uc1_vert3_colour = texture(rgbTexture, uc1_vert3_tex_coor);

		float uc1_vert3_y = heightFactor * (0.2126*uc1_vert3_colour.r + 0.7152*uc1_vert3_colour.g + 0.0722*uc1_vert3_colour.b);

		vec3 uc1_vert3 = vec3(position.x,uc1_vert3_y,position.z+1);		

		//ucgen1 normal
		vec3 normal_uc1 = normalize(cross((uc1_vert2-uc1_vert1),(uc1_vert3-uc1_vert1)));

		vertexNormal = normal_uc1;

	}
	else if(position.x == 0 && position.z == heightTexture) {

		//sol ustte ise

		//bir ucgen var

		//1. ucgen icin

		//tri1 vert1
		vec3 uc1_vert1 = vec3(position.x,y_position,position.z);

		//tr1 vert2
		vec2 uc1_vert2_tex_coor;
		uc1_vert2_tex_coor.x = textureCoordinate.x;
		uc1_vert2_tex_coor.y = textureCoordinate.y - 1/heightTexture;
		vec4 uc1_vert2_colour = texture(rgbTexture, uc1_vert2_tex_coor);

		float uc1_vert2_y = heightFactor * (0.2126*uc1_vert2_colour.r + 0.7152*uc1_vert2_colour.g + 0.0722*uc1_vert2_colour.b);

		vec3 uc1_vert2 = vec3(position.x,uc1_vert2_y,position.z-1);

		//tri1 vert3
		vec2 uc1_vert3_tex_coor;
		uc1_vert3_tex_coor.x = textureCoordinate.x + 1/widthTexture;
		uc1_vert3_tex_coor.y = textureCoordinate.y;
		vec4 uc1_vert3_colour = texture(rgbTexture, uc1_vert3_tex_coor);

		float uc1_vert3_y = heightFactor * (0.2126*uc1_vert3_colour.r + 0.7152*uc1_vert3_colour.g + 0.0722*uc1_vert3_colour.b);

		vec3 uc1_vert3 = vec3(position.x+1,uc1_vert3_y,position.z);		

		//ucgen1 normal
		vec3 normal_uc1 = normalize(cross((uc1_vert2-uc1_vert1),(uc1_vert3-uc1_vert1)));

		vertexNormal = normal_uc1;


	}
	else if(position.x == 0) {

		//sol taraf ortalarda

		//uc ucgen var

		//1. ucgen icin

		//tri1 vert1
		vec3 uc1_vert1 = vec3(position.x,y_position,position.z);

		//tr1 vert2
		vec2 uc1_vert2_tex_coor;
		uc1_vert2_tex_coor.x = textureCoordinate.x + 1/widthTexture;
		uc1_vert2_tex_coor.y = textureCoordinate.y + 1/heightTexture;
		vec4 uc1_vert2_colour = texture(rgbTexture, uc1_vert2_tex_coor);

		float uc1_vert2_y = heightFactor * (0.2126*uc1_vert2_colour.r + 0.7152*uc1_vert2_colour.g + 0.0722*uc1_vert2_colour.b);

		vec3 uc1_vert2 = vec3(position.x+1,uc1_vert2_y,position.z+1);

		//tr1 vert3
		vec2 uc1_vert3_tex_coor;
		uc1_vert3_tex_coor.x = textureCoordinate.x;
		uc1_vert3_tex_coor.y = textureCoordinate.y + 1/heightTexture;
		vec4 uc1_vert3_colour = texture(rgbTexture, uc1_vert3_tex_coor);

		float uc1_vert3_y = heightFactor * (0.2126*uc1_vert3_colour.r + 0.7152*uc1_vert3_colour.g + 0.0722*uc1_vert3_colour.b);

		vec3 uc1_vert3 = vec3(position.x,uc1_vert3_y,position.z+1);		

		//ucgen1 normal
		vec3 normal_uc1 = normalize(cross((uc1_vert2-uc1_vert1),(uc1_vert3-uc1_vert1)));


		//2. ucgen icin

		//tri2 vert1
		vec3 uc2_vert1 = vec3(position.x,y_position,position.z);

		//tr2 vert2
		vec2 uc2_vert2_tex_coor;
		uc2_vert2_tex_coor.x = textureCoordinate.x + 1/widthTexture;
		uc2_vert2_tex_coor.y = textureCoordinate.y;
		vec4 uc2_vert2_colour = texture(rgbTexture, uc2_vert2_tex_coor);

		float uc2_vert2_y = heightFactor * (0.2126*uc2_vert2_colour.r + 0.7152*uc2_vert2_colour.g + 0.0722*uc2_vert2_colour.b);

		vec3 uc2_vert2 = vec3(position.x+1,uc2_vert2_y,position.z);

		//tr2 vert3
		vec3 uc2_vert3 = uc1_vert2;		

		//ucgen1 normal
		vec3 normal_uc2 = normalize(cross((uc2_vert2-uc2_vert1),(uc2_vert3-uc2_vert1)));	

		//3. ucgen icin

		//tri3 vert1
		vec3 uc3_vert1 = vec3(position.x,y_position,position.z);

		//tr2 vert2
		vec2 uc3_vert2_tex_coor;
		uc3_vert2_tex_coor.x = textureCoordinate.x;
		uc3_vert2_tex_coor.y = textureCoordinate.y - 1/heightTexture;
		vec4 uc3_vert2_colour = texture(rgbTexture, uc3_vert2_tex_coor);

		float uc3_vert2_y = heightFactor * (0.2126*uc3_vert2_colour.r + 0.7152*uc3_vert2_colour.g + 0.0722*uc3_vert2_colour.b);

		vec3 uc3_vert2 = vec3(position.x,uc3_vert2_y,position.z-1);

		//tr2 vert3
		vec3 uc3_vert3 = uc2_vert2;		

		//ucgen1 normal
		vec3 normal_uc3 = normalize(cross((uc3_vert2-uc3_vert1),(uc3_vert3-uc3_vert1)));	



		vertexNormal = normalize((normal_uc1 + normal_uc2 + normal_uc3)/3);


	}
	else if(position.x == widthTexture) {

		//sag taraf ortalarda

		//uc ucgen var



		//1. ucgen icin

		//tri1 vert1
		vec3 uc1_vert1 = vec3(position.x,y_position,position.z);

		//tr1 vert2
		vec2 uc1_vert2_tex_coor;
		uc1_vert2_tex_coor.x = textureCoordinate.x;
		uc1_vert2_tex_coor.y = textureCoordinate.y + 1/heightTexture;
		vec4 uc1_vert2_colour = texture(rgbTexture, uc1_vert2_tex_coor);

		float uc1_vert2_y = heightFactor * (0.2126*uc1_vert2_colour.r + 0.7152*uc1_vert2_colour.g + 0.0722*uc1_vert2_colour.b);

		vec3 uc1_vert2 = vec3(position.x,uc1_vert2_y,position.z+1);

		//tr1 vert3
		vec2 uc1_vert3_tex_coor;
		uc1_vert3_tex_coor.x = textureCoordinate.x -1/widthTexture;
		uc1_vert3_tex_coor.y = textureCoordinate.y;
		vec4 uc1_vert3_colour = texture(rgbTexture, uc1_vert3_tex_coor);

		float uc1_vert3_y = heightFactor * (0.2126*uc1_vert3_colour.r + 0.7152*uc1_vert3_colour.g + 0.0722*uc1_vert3_colour.b);

		vec3 uc1_vert3 = vec3(position.x-1,uc1_vert3_y,position.z);		

		//ucgen1 normal
		vec3 normal_uc1 = normalize(cross((uc1_vert2-uc1_vert1),(uc1_vert3-uc1_vert1)));


		//2. ucgen icin

		//tri2 vert1
		vec3 uc2_vert1 = vec3(position.x,y_position,position.z);

		//tr2 vert2

		vec3 uc2_vert2 = uc1_vert3;

		//tr2 vert3
		vec2 uc2_vert3_tex_coor;
		uc2_vert3_tex_coor.x = textureCoordinate.x -1/widthTexture;
		uc2_vert3_tex_coor.y = textureCoordinate.y -1/heightTexture;
		vec4 uc2_vert3_colour = texture(rgbTexture, uc2_vert3_tex_coor);

		float uc2_vert3_y = heightFactor * (0.2126*uc2_vert3_colour.r + 0.7152*uc2_vert3_colour.g + 0.0722*uc2_vert3_colour.b);

		vec3 uc2_vert3 = vec3(position.x-1,uc2_vert3_y,position.z-1);		

		//ucgen1 normal
		vec3 normal_uc2 = normalize(cross((uc2_vert2-uc2_vert1),(uc2_vert3-uc2_vert1)));	

		//3. ucgen icin

		//tri3 vert1
		vec3 uc3_vert1 = vec3(position.x,y_position,position.z);

		//tr2 vert2

		vec3 uc3_vert2 = uc2_vert3;

		//tr2 vert3
		vec2 uc3_vert3_tex_coor;
		uc3_vert3_tex_coor.x = textureCoordinate.x;
		uc3_vert3_tex_coor.y = textureCoordinate.y -1/heightTexture;
		vec4 uc3_vert3_colour = texture(rgbTexture, uc3_vert3_tex_coor);

		float uc3_vert3_y = heightFactor * (0.2126*uc3_vert3_colour.r + 0.7152*uc3_vert3_colour.g + 0.0722*uc3_vert3_colour.b);

		vec3 uc3_vert3 = vec3(position.x,uc3_vert3_y,position.z-1);		

		//ucgen1 normal
		vec3 normal_uc3 = normalize(cross((uc3_vert2-uc3_vert1),(uc3_vert3-uc3_vert1)));	



		vertexNormal = normalize((normal_uc1 + normal_uc2 + normal_uc3)/3);

	}
	else if(position.z == 0) {

		//alt taraf ortalarda

		//uc ucgen var



		//1. ucgen icin

		//tri1 vert1
		vec3 uc1_vert1 = vec3(position.x,y_position,position.z);

		//tr1 vert2
		vec2 uc1_vert2_tex_coor;
		uc1_vert2_tex_coor.x = textureCoordinate.x;
		uc1_vert2_tex_coor.y = textureCoordinate.y + 1/heightTexture;
		vec4 uc1_vert2_colour = texture(rgbTexture, uc1_vert2_tex_coor);

		float uc1_vert2_y = heightFactor * (0.2126*uc1_vert2_colour.r + 0.7152*uc1_vert2_colour.g + 0.0722*uc1_vert2_colour.b);

		vec3 uc1_vert2 = vec3(position.x,uc1_vert2_y,position.z+1);

		//tr1 vert3
		vec2 uc1_vert3_tex_coor;
		uc1_vert3_tex_coor.x = textureCoordinate.x -1/widthTexture;
		uc1_vert3_tex_coor.y = textureCoordinate.y;
		vec4 uc1_vert3_colour = texture(rgbTexture, uc1_vert3_tex_coor);

		float uc1_vert3_y = heightFactor * (0.2126*uc1_vert3_colour.r + 0.7152*uc1_vert3_colour.g + 0.0722*uc1_vert3_colour.b);

		vec3 uc1_vert3 = vec3(position.x-1,uc1_vert3_y,position.z);		

		//ucgen1 normal
		vec3 normal_uc1 = normalize(cross((uc1_vert2-uc1_vert1),(uc1_vert3-uc1_vert1)));


		//2. ucgen icin

		//tri2 vert1
		vec3 uc2_vert1 = vec3(position.x,y_position,position.z);

		//tr2 vert2

		vec2 uc2_vert2_tex_coor;
		uc2_vert2_tex_coor.x = textureCoordinate.x + 1/widthTexture;
		uc2_vert2_tex_coor.y = textureCoordinate.y + 1/heightTexture;
		vec4 uc2_vert2_colour = texture(rgbTexture, uc2_vert2_tex_coor);

		float uc2_vert2_y = heightFactor * (0.2126*uc2_vert2_colour.r + 0.7152*uc2_vert2_colour.g + 0.0722*uc2_vert2_colour.b);

		vec3 uc2_vert2 = vec3(position.x+1,uc2_vert2_y,position.z+1);


		//tr2 vert3

		vec3 uc2_vert3 = uc1_vert2;		

		//ucgen1 normal
		vec3 normal_uc2 = normalize(cross((uc2_vert2-uc2_vert1),(uc2_vert3-uc2_vert1)));	

		//3. ucgen icin

		//tri3 vert1
		vec3 uc3_vert1 = vec3(position.x,y_position,position.z);

		//tr2 vert2

		vec2 uc3_vert2_tex_coor;
		uc3_vert2_tex_coor.x = textureCoordinate.x + 1/widthTexture;
		uc3_vert2_tex_coor.y = textureCoordinate.y;
		vec4 uc3_vert2_colour = texture(rgbTexture, uc3_vert2_tex_coor);

		float uc3_vert2_y = heightFactor * (0.2126*uc3_vert2_colour.r + 0.7152*uc3_vert2_colour.g + 0.0722*uc3_vert2_colour.b);

		vec3 uc3_vert2 = vec3(position.x+1,uc3_vert2_y,position.z);

		//tr2 vert3
		vec3 uc3_vert3 = uc2_vert2;		

		//ucgen1 normal
		vec3 normal_uc3 = normalize(cross((uc3_vert2-uc3_vert1),(uc3_vert3-uc3_vert1)));	



		vertexNormal = normalize((normal_uc1 + normal_uc2 + normal_uc3)/3);



	}
	else if(position.z == heightTexture) {

		//use taraf ortalarda

		//uc ucgen var

		//1. ucgen icin

		//tri1 vert1
		vec3 uc1_vert1 = vec3(position.x,y_position,position.z);

		//tr1 vert2
		vec2 uc1_vert2_tex_coor;
		uc1_vert2_tex_coor.x = textureCoordinate.x - 1/widthTexture;
		uc1_vert2_tex_coor.y = textureCoordinate.y;
		vec4 uc1_vert2_colour = texture(rgbTexture, uc1_vert2_tex_coor);

		float uc1_vert2_y = heightFactor * (0.2126*uc1_vert2_colour.r + 0.7152*uc1_vert2_colour.g + 0.0722*uc1_vert2_colour.b);

		vec3 uc1_vert2 = vec3(position.x-1,uc1_vert2_y,position.z);

		//tr1 vert3
		vec2 uc1_vert3_tex_coor;
		uc1_vert3_tex_coor.x = textureCoordinate.x -1/widthTexture;
		uc1_vert3_tex_coor.y = textureCoordinate.y -1/heightTexture;
		vec4 uc1_vert3_colour = texture(rgbTexture, uc1_vert3_tex_coor);

		float uc1_vert3_y = heightFactor * (0.2126*uc1_vert3_colour.r + 0.7152*uc1_vert3_colour.g + 0.0722*uc1_vert3_colour.b);

		vec3 uc1_vert3 = vec3(position.x-1,uc1_vert3_y,position.z-1);		

		//ucgen1 normal
		vec3 normal_uc1 = normalize(cross((uc1_vert2-uc1_vert1),(uc1_vert3-uc1_vert1)));


		//2. ucgen icin

		//tri2 vert1
		vec3 uc2_vert1 = vec3(position.x,y_position,position.z);

		//tr2 vert2

		vec3 uc2_vert2 = uc1_vert3;

		//tr2 vert3
		vec2 uc2_vert3_tex_coor;
		uc2_vert3_tex_coor.x = textureCoordinate.x;
		uc2_vert3_tex_coor.y = textureCoordinate.y -1/heightTexture;
		vec4 uc2_vert3_colour = texture(rgbTexture, uc2_vert3_tex_coor);

		float uc2_vert3_y = heightFactor * (0.2126*uc2_vert3_colour.r + 0.7152*uc2_vert3_colour.g + 0.0722*uc2_vert3_colour.b);

		vec3 uc2_vert3 = vec3(position.x,uc2_vert3_y,position.z-1);		

		//ucgen1 normal
		vec3 normal_uc2 = normalize(cross((uc2_vert2-uc2_vert1),(uc2_vert3-uc2_vert1)));	

		//3. ucgen icin

		//tri3 vert1
		vec3 uc3_vert1 = vec3(position.x,y_position,position.z);

		//tr2 vert2

		vec3 uc3_vert2 = uc2_vert3;

		//tr2 vert3
		vec2 uc3_vert3_tex_coor;
		uc3_vert3_tex_coor.x = textureCoordinate.x + 1/widthTexture;
		uc3_vert3_tex_coor.y = textureCoordinate.y;
		vec4 uc3_vert3_colour = texture(rgbTexture, uc3_vert3_tex_coor);

		float uc3_vert3_y = heightFactor * (0.2126*uc3_vert3_colour.r + 0.7152*uc3_vert3_colour.g + 0.0722*uc3_vert3_colour.b);

		vec3 uc3_vert3 = vec3(position.x+1,uc3_vert3_y,position.z);		

		//ucgen1 normal
		vec3 normal_uc3 = normalize(cross((uc3_vert2-uc3_vert1),(uc3_vert3-uc3_vert1)));	



		vertexNormal = normalize((normal_uc1 + normal_uc2 + normal_uc3)/3);		
	}
	else {

	    // get texture value, compute height
	    textureCoordinate = vec2( widthTexture-position.x/widthTexture, heightTexture-position.z/heightTexture );
	    vec4 textureColor = texture(rgbTexture, textureCoordinate);
	    float y = 0.2126 * textureColor.x + 0.7152 * textureColor.y + 0.0722 * textureColor.z;
	    

	    vec4 position = vec4(position.x, heightFactor * y,position.z, 1);


	    // compute normal vector using also the heights of neighbor vertices

	    vec2 texCoord;
	    vec4 texColor;
	    vec3 total_normal = vec3(0.0,0.0,0.0);
	    vec3 average_normal = vec3(0.0,0.0,0.0);	    

	    vec4 vert1 = vec4(position.x + 1, 0, position.z, 1);
	    vec4 vert2 = vec4(position.x + 1, 0, position.z + 1, 1);
	    vec4 vert3 = vec4(position.x, 0, position.z + 1, 1);
	    vec4 vert4 = vec4(position.x - 1, 0, position.z, 1);	
	    vec4 vert5 = vec4(position.x - 1, 0, position.z - 1, 1); 
	    vec4 vert6 = vec4(position.x , 0, position.z - 1, 1);   

	    vec2 texcoord1 = vec2(widthTexture - vert1.x / widthTexture, heightTexture - vert1.z / heightTexture);
	    vec2 texcoord2 = vec2(widthTexture - vert2.x / widthTexture, heightTexture - vert2.z / heightTexture);
	    vec2 texcoord3 = vec2(widthTexture - vert3.x / widthTexture, heightTexture - vert3.z / heightTexture);	    
	    vec2 texcoord4 = vec2(widthTexture - vert4.x / widthTexture, heightTexture - vert4.z / heightTexture);
	    vec2 texcoord5 = vec2(widthTexture - vert5.x / widthTexture, heightTexture - vert5.z / heightTexture);
	    vec2 texcoord6 = vec2(widthTexture - vert6.x / widthTexture, heightTexture - vert6.z / heightTexture);	    	    


	    vec4 texcolour1 = texture(rgbTexture, texcoord1);
	    vec4 texcolour2 = texture(rgbTexture, texcoord2);
	    vec4 texcolour3 = texture(rgbTexture, texcoord3);
	    vec4 texcolour4 = texture(rgbTexture, texcoord4);	    	    
	    vec4 texcolour5 = texture(rgbTexture, texcoord5);
	    vec4 texcolour6 = texture(rgbTexture, texcoord6);	    

	    vert1.y = heightFactor * (0.2126 * texcolour1.x + 0.7152 * texcolour1.y + 0.0722 * texcolour1.z);
	    vert2.y = heightFactor * (0.2126 * texcolour2.x + 0.7152 * texcolour2.y + 0.0722 * texcolour2.z);
	    vert3.y = heightFactor * (0.2126 * texcolour3.x + 0.7152 * texcolour3.y + 0.0722 * texcolour3.z);
	    vert4.y = heightFactor * (0.2126 * texcolour4.x + 0.7152 * texcolour4.y + 0.0722 * texcolour4.z);
	    vert5.y = heightFactor * (0.2126 * texcolour5.x + 0.7152 * texcolour5.y + 0.0722 * texcolour5.z);
	    vert6.y = heightFactor * (0.2126 * texcolour6.x + 0.7152 * texcolour6.y + 0.0722 * texcolour6.z);

	    vec3 normal1 = cross(vec3(vert2-position), vec3(vert1-position));
	    vec3 normal2 = cross(vec3(vert3-position), vec3(vert2-position));
	    vec3 normal3 = cross(vec3(vert4-position), vec3(vert3-position));
	    vec3 normal4 = cross(vec3(vert5-position), vec3(vert4-position));
	    vec3 normal5 = cross(vec3(vert6-position), vec3(vert5-position));
	    vec3 normal6 = cross(vec3(vert1-position), vec3(vert6-position));

	    total_normal = normal1+normal2+normal3+normal4+normal5+normal6;

	    average_normal = normalize(total_normal/6);
	    vertexNormal = normalize(vec3( inverse(transpose(MV)) * vec4(average_normal,0)));			

	}

	vec3 light_position = vec3(widthTexture/2,widthTexture+heightTexture,heightTexture/2);
   	
        vec3 pos = vec3(position.x,y_position,position.z);
        vec3 pos2 = vec3(MV * vec4(pos,1.0));
        ToLightVector = normalize(vec3(widthTexture/2.0, widthTexture + heightTexture, heightTexture/2.0) - pos2);
        ToCameraVector = normalize(vec3(MV * vec4(cameraPosition.x - position.x, cameraPosition.y - y_position, cameraPosition.z - position.z, 0)));

   	distance_v = distance(light_position,vec3(position.x,y_position,position.z));

   	gl_Position = MVP*vec4(position.x,y_position,position.z,1.0); // this is a placeholder. It does not correctly set the position 
   


}
