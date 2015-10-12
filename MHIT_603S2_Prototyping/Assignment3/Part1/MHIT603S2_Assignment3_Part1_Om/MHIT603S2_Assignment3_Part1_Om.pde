import processing.serial.*;

String serialBuffer;
Serial serialPort;
int[] serialInArray = new int[3]; // Where we'll put what we receive
int serialCount = 0;
int toggleValue = 0;
String serialPortName = "/dev/cu.usbserial-A603B2E6";
PImage img;
PImage tex;
int ptsW, ptsH;
int numPointsW;
int numPointsH_2pi; 
int numPointsH;
int buttonState;

float[] coorX;
float[] coorY;
float[] coorZ;
float[] multXZ;
int[] values;
float rotx = PI/4;
float roty = PI/4;

void setup() {
   //Clear the serial buffer
  serialBuffer = "";
  //Open the serial port
  serialPort = new Serial(this, serialPortName, 9600); 
  serialPort.clear();
  size(640, 360, P3D);
  background(0);
  noStroke();
  img=loadImage("world32k.jpg");
  tex = loadImage("berlin-1.jpg");
  ptsW=30;
  ptsH=30;
  // Parameters below are the number of vertices around the width and height
  initializeSphere(ptsW, ptsH);
  
  
}


void draw() {
  
  
    while (serialPort.available() > 0) {
    
    //Try grab a packet delimited by new line
    String data = serialPort.readStringUntil('\n');
    println ("Read data");
    //println(data);
    //println(Serial.list());
    //String portName = Serial.list()[0];
    //If we were successful
      if (data!=null) {
       //Split it based on the -, trim any space and convert to int
       values = int(trim(split(data, '-')));
       //If we have two integers
          if (values.length==2) {
          println(values[0] + ":" + values[1]);
          }
         /* values[0] = int(data);
          values[1] = 1;
          println(values[0]);*/
      }
     //end while
    
   
    
    background(0);
  camera(width/2+map(mouseX, 0, width, -2*width, 2*width), 
         height/2+map(mouseY, 0, height, -height, height),
         height/2/tan(PI*30.0 / 180.0), 
         width, height/2.0, 0, 
         0, 1, 0);
  /* camera(width/2+map(values[0], 0, width, -2*width, 2*width), 
         height/2+map(values[1], 0, height, -height, height),
         height/2/tan(PI*30.0 / 180.0), 
         width, height/2.0, 0, 
         0, 1, 0);*/
    pushMatrix();
    translate(width/2, height/2, 0);  
    rotateY((int)map(values[0], 0, 1023, 0, 360)*0.01);
    textureSphere(200, 200, 200, img);
    popMatrix();
    
    values[1]=1;
  if (values[1] == 1){
    pushStyle();
    fill(255);
    stroke(color(44,48,32));
    background(0);
    noStroke();
    translate(width/2.0, height/2.0, -100);
    //rotateX(rotx);
    rotateY((int)map(values[0], 0, 1023, 0, 360)*0.01);
    //rotateY(roty);
    scale(90);
    textureMode(NORMAL);
    fill(255);
    stroke(color(44,48,32));
    TexturedCube(tex);
    popStyle();
    }

}
}



void TexturedCube(PImage tex) {
  beginShape(QUADS);
  texture(tex);
  print(tex);
  // Given one texture and six faces, we can easily set up the uv coordinates
  // such that four of the faces tile "perfectly" along either u or v, but the other
  // two faces cannot be so aligned.  This code tiles "along" u, "around" the X/Z faces
  // and fudges the Y faces - the Y faces are arbitrarily aligned such that a
  // rotation along the X axis will put the "top" of either texture at the "top"
  // of the screen, but is not otherwised aligned with the X/Z faces. (This
  // just affects what type of symmetry is required if you need seamless
  // tiling all the way around the cube)
  
  // +Z "front" face
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);

  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1,  1, -1, 1, 1);
  vertex( 1,  1, -1, 0, 1);

  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1,  1, 1, 1);
  vertex(-1, -1,  1, 0, 1);

  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex( 1,  1,  1, 0, 1);

  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, 1, 0);
  vertex(-1,  1,  1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  endShape();
}

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void textureSphere(float rx, float ry, float rz, PImage t) { 
  // These are so we can map certain parts of the image on to the shape 
  float changeU=t.width/(float)(numPointsW-1); 
  float changeV=t.height/(float)(numPointsH-1); 
  float u=0;  // Width variable for the texture
  float v=0;  // Height variable for the texture

  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i=0; i<(numPointsH-1); i++) {  // For all the rings but top and bottom
    // Goes into the array here instead of loop to save time
    float coory=coorY[i];
    float cooryPlus=coorY[i+1];

    float multxz=multXZ[i];
    float multxzPlus=multXZ[i+1];

    for (int j=0; j<numPointsW; j++) { // For all the pts in the ring
      normal(-coorX[j]*multxz, -coory, -coorZ[j]*multxz);
      vertex(coorX[j]*multxz*rx, coory*ry, coorZ[j]*multxz*rz, u, v);
      normal(-coorX[j]*multxzPlus, -cooryPlus, -coorZ[j]*multxzPlus);
      vertex(coorX[j]*multxzPlus*rx, cooryPlus*ry, coorZ[j]*multxzPlus*rz, u, v+changeV);
      u+=changeU;
    }
    v+=changeV;
    u=0;
  }
  endShape();
}
void keyPressed() {
  println(keyCode);
  if (keyCode == ENTER) saveFrame();
  if (keyCode == UP) ptsH++;
  if (keyCode == DOWN) ptsH--;
  if (keyCode == LEFT) ptsW--;
  if (keyCode == RIGHT) ptsW++;
  
  
  if (ptsW == 0) ptsW = 1;
  if (ptsH == 0) ptsH = 2;
  // Parameters below are the number of vertices around the width and height
  initializeSphere(ptsW, ptsH);
}
void initializeSphere(int numPtsW, int numPtsH_2pi) {

  // The number of points around the width and height
  numPointsW=numPtsW+1;
  numPointsH_2pi=numPtsH_2pi;  // How many actual pts around the sphere (not just from top to bottom)
  numPointsH=ceil((float)numPointsH_2pi/2)+1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

  coorX=new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
  coorY=new float[numPointsH];   // All the y-coor in a vertical circle radius 1
  coorZ=new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
  multXZ=new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

  for (int i=0; i<numPointsW ;i++) {  // For all the points around the width
    float thetaW=i*2*PI/(numPointsW-1);
    coorX[i]=sin(thetaW);
    coorZ[i]=cos(thetaW);
  }
  
  for (int i=0; i<numPointsH; i++) {  // For all points from top to bottom
    if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
      float thetaH=(i-1)*2*PI/(numPointsH_2pi);
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=0;
    } 
    else {
      //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
      float thetaH=i*2*PI/(numPointsH_2pi);

      //PI+ below makes the top always the point instead of the bottom.
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=sin(thetaH);
    }
  }
}