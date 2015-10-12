/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/73691*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* 
MHIT603 S2 Assignment 3
Student: Omprakash - 87538553
This code is copied from /* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/73691*@* 
to adapt to the requirements of the assignment. 

On clicking a button the corresponding number will be written to the serial buffer
which is later processed by Arduino board. 
*/
import processing.serial.*;
String serialBuffer;
Serial serialPort;
String serialPortName = "/dev/cu.usbserial-A603B2E6";
String displayNumber="10";


Button startTimer = new Button(1,10,299,60,"Start 10 seconds countdown",0,0);
Button snooze = new Button(0,329,299,60,"Snooze",0,0);



ArrayList<Button> buttons = new ArrayList<Button>();


boolean reset = false;
boolean power = false;
String math = "";

PFont screenFont;
PFont buttonFont;

void setup()
{
  //Clear the serial buffer
  serialBuffer = "";
  //Open the serial port
  serialPort = new Serial(this, serialPortName, 9600);
  buttons.add(startTimer);
  buttons.add(snooze);
  
  //buttons.add(space);
  
  smooth();
  size(300,400);
}

void draw()
{
  //textFont(buttonFont);
  background(100);
  //drawScreen(30,20);
  for(Button b : buttons){
    b.d();
  }
  pushStyle();
  textSize(10);
  textSize(100);
  text(displayNumber, (width/2)-50,height/2); 
  popStyle();
}
void drawScreen(int x, int y)
{
    fill(245);
    //rect(x,y,285,60);
    
}

void mouseClicked() 
{
  for(Button b : buttons)
    {
      if(b.isOver())
      {
        String val = b.getVal();
        print(val);
        displayNumber = val;
        serialPort.write("<" + val + ">");
        //return (int(val));
      }
    } //<>//
}