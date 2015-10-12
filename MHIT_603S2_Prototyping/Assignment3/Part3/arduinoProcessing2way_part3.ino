/*
  Button

 Turns on and off a light emitting diode(LED) connected to digital
 pin 13, when pressing a pushbutton attached to pin 2.


 The circuit:
 * LED attached from pin 13 to ground
 * pushbutton attached to pin 2 from +5V
 * 10K resistor attached to pin 2 from ground

 * Note: on most Arduinos there is already an LED on the board
 attached to pin 13.


 created 2005
 by DojoDave <http://www.0j0.org>
 modified 30 Aug 2011
 by Tom Igoe

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/Button
 */

// constants won't change. They're used here to
// set pin numbers:
const int buttonPin = 4;     // the number of the pushbutton pin
const int ledPin =  7;      // the number of the LED pin
String getMostRecentValidSerialPacket();
String serialBuffer = "";
// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status

void setup() {
  Serial.begin(9600);
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
}

void loop() {
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);
  if (buttonState == 0)
  {
    //If Button is pressed 3 is passed to Processing
    Serial.println(3);
  }
  if (buttonState == 1)
  {
    //If Button is pressed 4 is passed to Processing
    Serial.println(4);
  }
  

  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  /*if (buttonState == HIGH) {
    // turn LED on:
    digitalWrite(ledPin, LOW);
  }
  else {
    // turn LED off:
    digitalWrite(ledPin, HIGH);
  }*/

  while (Serial.available() >0) {
    //If so read the byte, convert it to a char, 
    //and add it to the buffer
    int sByte = Serial.read();
    serialBuffer += char(sByte);
  }

  //Get the most recent valid serial packet in the buffer
  String packet = getMostRecentValidSerialPacket();
  //If it's not an empty string
  if (packet.length()>0) {
    //Convert it to an int
    int value = packet.toInt();
    //converting from decimal to binary and writing it to the LED pins.
    if (value== 0){
    digitalWrite(ledPin,LOW);
    }
    if (value== 1)
    {
      digitalWrite(ledPin,HIGH);
    }
    
  }
}


//This function gets the most recent valid packet from the serial buffer
//You shouldn't have to modify this
String getMostRecentValidSerialPacket() {

  //If our serial buffer has any data in it
  if (serialBuffer.length()>0) {
       
    //If so, grab the index of the last starting and last ending delimiters
    int lastStartDelimiter = serialBuffer.lastIndexOf('<');
    int lastEndDelimiter = serialBuffer.lastIndexOf('>');

    //If we've found both delimiters and the ending one is after the starting
    if (lastEndDelimiter>-1 && lastStartDelimiter>-1 && 
        lastEndDelimiter > lastStartDelimiter) {
    
          //Get the  packet data
          String packetData = serialBuffer.substring(lastStartDelimiter+1, lastEndDelimiter);
      
          //Remove that packet from the serial buffer
          serialBuffer = serialBuffer.substring(lastEndDelimiter+1);
          
          //Return the packet
          return packetData;
          
    }
          
  }
  delay(100);
  //If we haven't got any data, return an empty string
  return "";
}
