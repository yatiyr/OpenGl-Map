#include "helper.h"

#include <vector>
#include <tuple>
#include "glm/gtc/matrix_transform.hpp"
#include "linmath.h"

#include <math.h>

static GLFWwindow * win = NULL;

// Shaders
GLuint idProgramShader;
GLuint idFragmentShader;
GLuint idVertexShader;
GLuint idJpegTexture;
GLuint idMVPMatrix;
GLuint idMVMatrix;

double pi = 3.14159265358979323846;

int widthTexture, heightTexture;

float speed = 0;
float pitch = 0;
float yaw = 0;
float height_factor = 10.0f;
bool fullscreen = false;

int window_pos[2];
int window_size[2];

float d_pitch = 2*pi*(pitch/360);
float d_yaw = 2*pi*(yaw/360);

glm::vec3 gaze(0,0,1);
glm::vec3 direction(0,0,1); 
glm::vec3 up_vector(0,1,0);

static void errorCallback(int error,
  const char * description) {
  fprintf(stderr, "Error: %s\n", description);
}

void framebuffer_size_callback(GLFWwindow* win, int width, int height) {
    
    glViewport(0, 0, width, height);
    
}

void take_input_from_user(GLFWwindow* win) {
    
    if(glfwGetKey(win,GLFW_KEY_W) == GLFW_PRESS) { 
        glm::mat4 r_matrix(1);
        glm::vec3 right = cross(gaze,up_vector);
        glm::normalize(right);
        std::cout<<gaze.y<<std::endl;
        r_matrix = glm::rotate(r_matrix,glm::radians(-0.06f),right);
        gaze = glm::vec3(r_matrix*glm::vec4(gaze.x,gaze.y,gaze.z,1.0f));
        glm::normalize(gaze);
    }
    if(glfwGetKey(win,GLFW_KEY_S) == GLFW_PRESS) {        
        glm::mat4 r_matrix(1);
        glm::vec3 right = cross(gaze,up_vector);
        glm::normalize(right);         
        r_matrix = glm::rotate(r_matrix,glm::radians(0.3f),right);
        gaze = glm::vec3(r_matrix*glm::vec4(gaze.x,gaze.y,gaze.z,1.0f));
        glm::normalize(gaze);        
    }
    if(glfwGetKey(win,GLFW_KEY_A) == GLFW_PRESS) {
        glm::mat4 r_matrix(1);
        r_matrix = glm::rotate(r_matrix,glm::radians(0.3f),glm::vec3(0.0f,1.0f,0.0f));
        gaze = glm::vec3(r_matrix*glm::vec4(gaze.x,gaze.y,gaze.z,1.0f));
        glm::normalize(gaze);           
    }
    if(glfwGetKey(win,GLFW_KEY_D) == GLFW_PRESS) {
        glm::mat4 r_matrix(1);
        r_matrix = glm::rotate(r_matrix,glm::radians(-0.3f),glm::vec3(0.0f,1.0f,0.0f));
        gaze = glm::vec3(r_matrix*glm::vec4(gaze.x,gaze.y,gaze.z,1.0f));
        glm::normalize(gaze);       
    }
    if(glfwGetKey(win,GLFW_KEY_U) == GLFW_PRESS) {        
        speed += 0.001;
    }
    if(glfwGetKey(win,GLFW_KEY_J) == GLFW_PRESS) {        
        speed -= 0.001;
    }    
    if(glfwGetKey(win,GLFW_KEY_O) == GLFW_PRESS) {        
        height_factor += 0.5;
    }
    if(glfwGetKey(win,GLFW_KEY_L) == GLFW_PRESS) {        
        height_factor -= 0.5;
    }      
    if(glfwGetKey(win,GLFW_KEY_F) == GLFW_PRESS) {
                       
        if(!fullscreen) {            
            
            glfwSetWindowMonitor( win, nullptr,  window_pos[0], window_pos[1], 600, 600, 0 ); 
            fullscreen = true;
            
        }
        else {
            glfwGetWindowPos(win, &window_pos[0], &window_pos[1]);
            glfwGetWindowSize(win, &window_size[0], &window_size[2]);
            
            const GLFWvidmode *mode = glfwGetVideoMode(glfwGetPrimaryMonitor());
            
            glfwSetWindowMonitor(win,glfwGetPrimaryMonitor(),0,0,mode->width,mode->height,0);  
            fullscreen = false;
        }
    }
}

void move_plane() {
    
    direction.x = gaze.x*speed;
    direction.y = gaze.y*speed;
    direction.z = gaze.z*speed;
    
}

int main(int argc, char * argv[]) {

  if (argc != 2) {
    printf("Only one texture image expected!\n");
    exit(-1);
  }
  glfwSetErrorCallback(errorCallback);

  if (!glfwInit()) {
    exit(-1);
  }

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_COMPAT_PROFILE);

  win = glfwCreateWindow(600, 600, "CENG477 - HW3", NULL, NULL);
  
  glfwSetWindowSizeCallback(win,framebuffer_size_callback);

  if (!win) {
    glfwTerminate();
    exit(-1);
  }
  glfwMakeContextCurrent(win);

  GLenum err = glewInit();
  
   //Deneme ucgen
  
  GLuint VertexArrayID;
  glGenVertexArrays(1, &VertexArrayID);
  glBindVertexArray(VertexArrayID);
  
  
  if (err != GLEW_OK) {
    fprintf(stderr, "Error: %s\n", glewGetErrorString(err));

    glfwTerminate();
    exit(-1);
  }

  initShaders();
  glUseProgram(idProgramShader);
  initTexture(argv[1], & widthTexture, & heightTexture);
   
  
  glm::mat4 Projection = glm::perspective(glm::radians(45.0f), 1.0f, 0.1f, 1000.0f);
  
  
  glm::vec3 cam_pos(widthTexture/2,widthTexture/10,-widthTexture/3);
  glm::vec3 target(cam_pos.x + gaze.x,cam_pos.y + gaze.y,cam_pos.z + gaze.z); 
  
  // Camera matrix
  glm::mat4 View = glm::lookAt(
    glm::vec3(widthTexture/2,widthTexture/10,-widthTexture/4), 
    glm::vec3(0,0,1),
    glm::vec3(0,1,0)  
  );
  
  View = glm::rotate(View,glm::radians(90.0f),glm::vec3(0,1,0));

  glm::mat4 Model = glm::mat4(1.0f);

  glm::mat4 mvp = Projection * View * Model;  
  
  
  GLuint MatrixID = glGetUniformLocation(idProgramShader, "MVP");  
  glUniformMatrix4fv(MatrixID, 1, GL_FALSE, &mvp[0][0]);
  
  
  GLfloat *g_vertex_buffer_data = new GLfloat[widthTexture*heightTexture*2*3*3];

  for(int i=0;i<heightTexture;i++) {
      
      for(int j=0;j<widthTexture;j++) {
          
          int line_offset = i*widthTexture*2*3*3;
          int two_triangle_offset = j*18; 
              
          g_vertex_buffer_data[line_offset + two_triangle_offset] = (GLfloat)j;
          g_vertex_buffer_data[line_offset + two_triangle_offset + 1] = 0.0f; //simdilik 0 olsun
          g_vertex_buffer_data[line_offset + two_triangle_offset + 2] = (GLfloat)i;
          
          g_vertex_buffer_data[line_offset + two_triangle_offset + 3] = (GLfloat)j;
          g_vertex_buffer_data[line_offset + two_triangle_offset + 4] = 0.0f; //simdilik 0 olsun
          g_vertex_buffer_data[line_offset + two_triangle_offset + 5] = (GLfloat)i+1;
          
          g_vertex_buffer_data[line_offset + two_triangle_offset + 6] = (GLfloat)j+1;
          g_vertex_buffer_data[line_offset + two_triangle_offset + 7] = 0.0f; //simdilik 0 olsun
          g_vertex_buffer_data[line_offset + two_triangle_offset + 8] = (GLfloat)i+1;  
          
          g_vertex_buffer_data[line_offset + two_triangle_offset + 9] = (GLfloat)j;
          g_vertex_buffer_data[line_offset + two_triangle_offset + 10] = 0.0f; //simdilik 0 olsun
          g_vertex_buffer_data[line_offset + two_triangle_offset + 11] = (GLfloat)i;   
          
          g_vertex_buffer_data[line_offset + two_triangle_offset + 12] = (GLfloat)j+1;
          g_vertex_buffer_data[line_offset + two_triangle_offset + 13] = 0.0f; //simdilik 0 olsun
          g_vertex_buffer_data[line_offset + two_triangle_offset + 14] = (GLfloat)i+1;   
          
          g_vertex_buffer_data[line_offset + two_triangle_offset + 15] = (GLfloat)j+1;
          g_vertex_buffer_data[line_offset + two_triangle_offset + 16] = 0.0f; //simdilik 0 olsun
          g_vertex_buffer_data[line_offset + two_triangle_offset + 17] = (GLfloat)i;              
      }
      
  }

  GLfloat *g_uv_buffer_data = new GLfloat[widthTexture*heightTexture*2*3*2];
  
  for(int i=0;i<heightTexture;i++) {
      for(int j=0;j<widthTexture;j++) {
          
          int line_offset = i*widthTexture*2*3*2;
          int two_triangle_offset = j*12;
          
          g_uv_buffer_data[line_offset + two_triangle_offset] = widthTexture - (GLfloat)j/widthTexture;
          g_uv_buffer_data[line_offset + two_triangle_offset + 1] = heightTexture - (GLfloat)i/heightTexture;
          
          g_uv_buffer_data[line_offset + two_triangle_offset + 2] = widthTexture -(GLfloat)j/widthTexture;
          g_uv_buffer_data[line_offset + two_triangle_offset + 3] = heightTexture - (GLfloat)(i+1)/heightTexture;
          
          g_uv_buffer_data[line_offset + two_triangle_offset + 4] = widthTexture - (GLfloat)(j+1)/widthTexture;
          g_uv_buffer_data[line_offset + two_triangle_offset + 5] = heightTexture - (GLfloat)(i+1)/heightTexture;  
          
          g_uv_buffer_data[line_offset + two_triangle_offset + 6] = widthTexture - (GLfloat)j/widthTexture;
          g_uv_buffer_data[line_offset + two_triangle_offset + 7] = heightTexture - (GLfloat)i/heightTexture;   
          
          g_uv_buffer_data[line_offset + two_triangle_offset + 8] = widthTexture - (GLfloat)(j+1)/widthTexture;
          g_uv_buffer_data[line_offset + two_triangle_offset + 9] = heightTexture - (GLfloat)(i+1)/heightTexture;   
          
          g_uv_buffer_data[line_offset + two_triangle_offset + 10] = widthTexture - (GLfloat)(j+1)/widthTexture;
          g_uv_buffer_data[line_offset + two_triangle_offset + 11] = heightTexture - (GLfloat)i/heightTexture;          
      }
  }
  
   
  GLuint uv_buffer;
  glGenBuffers(1,&uv_buffer);
  glBindBuffer(GL_ARRAY_BUFFER, uv_buffer);
  glBufferData(GL_ARRAY_BUFFER, widthTexture*heightTexture*2*3*2*sizeof(GLfloat), g_uv_buffer_data, GL_STATIC_DRAW);  
  glEnableVertexAttribArray(1);
  glBindBuffer(GL_ARRAY_BUFFER, uv_buffer);
  glVertexAttribPointer(
    1,                                // attribute. No particular reason for 1, but must match the layout in the shader.
    2,                                // size
    GL_FLOAT,                         // type
    GL_FALSE,                         // normalized?
    0,                                // stride
    (void*)0                          // array buffer offset
  );     
  
  
  GLuint vertexbuffer;
  glGenBuffers(1, &vertexbuffer);
  glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
  glBufferData(GL_ARRAY_BUFFER, widthTexture*heightTexture*2*3*3*sizeof(GLfloat), g_vertex_buffer_data, GL_STATIC_DRAW);
  
  glEnableVertexAttribArray(0);
  glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
  glVertexAttribPointer(
   0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
   3,                  // size
   GL_FLOAT,           // type
   GL_FALSE,           // normalized?
   0,                  // stride
   (void*)0            // array buffer offset
  );
  glDrawArrays(GL_TRIANGLES, 0, widthTexture*heightTexture*2*3); // Starting from vertex 0; 3 vertices total -> 1 triangle
  //glDisableVertexAttribArray(0);  
  
  
  GLuint tex_widthID = glGetUniformLocation(idProgramShader, "widthTexture");
  glUniform1i(tex_widthID,widthTexture);

  GLuint tex_heightID = glGetUniformLocation(idProgramShader, "heightTexture");
  glUniform1i(tex_heightID, heightTexture);
  //glm::vec3 cam_pos(widthTexture/2,widthTexture/10,-widthTexture/4);
  
  
  do {

      
      glClear(GL_DEPTH_BUFFER_BIT);
      glEnable(GL_DEPTH_TEST);
      glDepthFunc(GL_LESS);
      glEnable(GL_CULL_FACE);
      glCullFace(GL_BACK);
      float rat;
      int w,h;
      glfwGetFramebufferSize(win,&w,&h);
      rat = w / (float) h;
      glViewport(0,0,w,h);
      glClear(GL_COLOR_BUFFER_BIT);
      glm::mat4 Projection = glm::perspective(glm::radians(45.0f), 1.0f, 0.1f, 1000.0f);

      take_input_from_user(win);
      move_plane();
      cam_pos.x += direction.x;
      cam_pos.y += direction.y;
      cam_pos.z += direction.z;
      
      glm::vec3 target(cam_pos.x + gaze.x,cam_pos.y + gaze.y,cam_pos.z + gaze.z);

      // Camera matrix
      glm::mat4 View = glm::lookAt(
          cam_pos, 
          target,
          up_vector  
      );     

      glm::mat4 Model = glm::mat4(1.0f);

      glm::mat4 mvp = Projection * View * Model;  
      
      glm::mat4 mv = View*Model;

      GLuint height_factorID = glGetUniformLocation(idProgramShader, "heightFactor");  
      glUniform1f(height_factorID,height_factor); 
      
      GLfloat cam_pos_arr[] = {cam_pos.x,cam_pos.y,cam_pos.z,1.0f};
      
      GLuint camera_positionID = glGetUniformLocation(idProgramShader, "cameraPosition");
      glUniform4fv(camera_positionID,4*sizeof(GLfloat),&cam_pos_arr[0]);

      GLuint MatrixID = glGetUniformLocation(idProgramShader, "MVP");  
      glUniformMatrix4fv(MatrixID, 1, GL_FALSE, &mvp[0][0]);  
      GLuint MVID = glGetUniformLocation(idProgramShader, "MV");  
      glUniformMatrix4fv(MVID, 1, GL_FALSE, &mv[0][0]);       
      //glEnable(GL_CULL_FACE);
      glDrawArrays(GL_TRIANGLES, 0, widthTexture*heightTexture*2*3);
      glfwSwapBuffers(win);
      glfwPollEvents();    
        
      
  }
  while( glfwGetKey(win, GLFW_KEY_ESCAPE ) != GLFW_PRESS &&
       glfwWindowShouldClose(win) == 0 );
  
  glfwDestroyWindow(win);
  glfwTerminate();

  return 0;
}