/*MHIT603 S2 Assignment 3
Student: Omprakash - 87538553
This program will read the serial buffer and processes it to display LEDs. 

Processing program writes the potentiometer value and the button values to serial port

*/
const int buttonPin = 2; 
int potPin = 0;    // select the input pin for the potentiometer
int val = 0;       // variable to store the value coming from the sensor
int buttonState = LOW;
int outputStatus = LOW;
int reading; // initialinsing state as HIGH
int lastButtonState = HIGH; // initialising previous state as LOW
// the follow variables are long's because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long time = 0;         // the last time the output pin was toggled
long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay = 50;    // the debounce time; increase if the output flickers
void setup() {
  
  pinMode(buttonPin,INPUT);
  Serial.begin(9600);
}

void loop() {
  val = analogRead(potPin);    // read the value from the sensor
  reading = digitalRead(buttonPin);
  reading = digitalRead(buttonPin);
   if (reading != lastButtonState) {
      lastDebounceTime = millis();
      lastButtonState = reading;
   } 

   if ((millis() - lastDebounceTime) > debounceDelay) {
       if (buttonState != lastButtonState) {
           buttonState = lastButtonState;
           if (buttonState == HIGH) {
                 outputStatus = !outputStatus;
                 
           }
       }
   }
 
 
  //output = String(val) + String("-") + String(buttonState);
  Serial.print(val);
  Serial.print(" - ");
  Serial.println(outputStatus);
  
}
 
