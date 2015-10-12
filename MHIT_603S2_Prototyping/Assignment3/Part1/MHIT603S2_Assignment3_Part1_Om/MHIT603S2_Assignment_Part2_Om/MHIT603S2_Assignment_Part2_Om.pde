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
String displayNumber="0";


Button one = new Button(30,180,60,60,"1",0,0);
Button two = new Button(105,180,60,60,"2",0,0);
Button three = new Button(180,180,60,60,"3",0,0);
Button four = new Button(30,255,60,60,"4",0,0);
Button five = new Button(105,255,60,60,"5",0,0);
Button six = new Button(180,255,60,60,"6",0,0);
Button seven = new Button(30,330,60,60,"7",0,0);
Button pwr = new Button(30,405,60,60,"Pwr",-17,0);
Button zero = new Button(105,330,60,60,"0",0,0);


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
  buttons.add(one);
  buttons.add(two);
  buttons.add(three);
  //buttons.add(enter);
  buttons.add(four);
  buttons.add(five);
  buttons.add(six);
  buttons.add(seven);

  //buttons.add(clear);
  //buttons.add(pwr);
  buttons.add(zero);
  //buttons.add(space);
  
  smooth();
  //screenFont = loadFont("HP15C_Simulator_Font-30.vlw");
  //screenFont = loadFont("Segmental-30.vlw");
  //buttonFont = loadFont("LucidaSans-30.vlw");
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
  text("Click on any number to see the", 10,30); 
  text("binary equivalent on Arduino board", 10,50); 
  textSize(32);
  text(displayNumber, (width/2)-50,100); 
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