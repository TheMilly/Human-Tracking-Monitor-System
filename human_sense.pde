import processing.serial.*; // library for serial communication
import java.awt.event.KeyEvent; // library for reading the data from the serial port
import java.io.IOException; // library for io exceptions

Serial myPort; // Define the serial object
// Define variables
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
float xCoordinate, yCoordinate;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;
float x = 0;
float y = 0;
float spacing = 40;

void setup() {
  
 size (1366, 768); // Screen Resolution
 smooth();
 myPort = new Serial(this,"COM4", 9600); // Starting serial communications
 myPort.bufferUntil('.'); // reads the data from the serial port up to the character '.'. So actually it reads this: angle,distance.
 orcFont = loadFont("OCRAExtended-30.vlw");
}

void draw() {
  
  fill(98,245,31);
  textFont(orcFont);
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0,4); 
  rect(0, 0, width, height-height*0.065); 
  
  fill(98,245,31); // green color
  // calls the functions for drawing the radar
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

void serialEvent (Serial myPort) { // starts reading data from the Serial Port
  // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // find the character ',' and puts it into the variable "index1"
  angle= data.substring(0, index1); // read the data from position "0" to position of the variable index1 or thats the value of the angle the Arduino Board sent into the Serial Port
  distance= data.substring(index1+1, data.length()); // read the data from position "index1" to the end of the data pr thats the value of the distance
  
  // converts the String variables into Integer
  iAngle = int(angle);
  iDistance = int(distance);
  
  //declare as floats above - may have to declare in actual function??
  xCoordinate = iDistance*cos(radians(iAngle)); 
  yCoordinate = iDistance*sin(radians(iAngle));
}

void drawRadar() {
  
  stroke(255);
  strokeWeight(2);
  
  // creates horizontal lines for grid
  x = 83;
  while(x < width-80) {
    line(x, 0, x, height);
    x = x + spacing;
  }
  
  // creates vertical lines for grid
  y = 0;
  while (y < height){
    line(83,y,width-83,y);
    y = y + spacing;
  }
  
  strokeWeight(10);
  stroke(30,250,60);
  line(width/2,height-height*0.1190,width/2,0);
  
}

void drawObject() {
  pushMatrix();
  translate(width/2,height-height*0.1190); // moves the starting coordinats to new location
  strokeWeight(30);
  stroke(255,10,10); // red color
  pixsDistance = iDistance*((height-height*0.1666)*0.004); // covers the distance from the sensor from cm to pixels
  // limiting the range to 200 cms
  if(iDistance<200){
  // draws the point or dot
  point(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawText() { // draws the texts on the screen
  
  pushMatrix();
  if(iDistance>200) {
  noObject = "Out of Range";
  }
  else {
  noObject = "In Range";
  }
  
  fill(0,0,0);
  noStroke();
  rect(0, height-height*0.1125, width, height);
  fill(98,245,31);
  textSize(12);
  
  
  //first half of x axis label
  int count = 14;
  while(count>0){
    text((count*15) + "cm",((width/2) - (40*count) -10),height-height*0.0833);
    count-=2;
  }
  
  //second half of x axis label
  int count2 = 0;
  while(count2<16){
    text((count2*15) + "cm",((width/2) + (40*count2) -10),height-height*0.0833);
    count2+= 2;
  }
  
  // label of y axis
  int count3 = 0;
  while(count3 < 30){
    text((count3*15) + "cm",43,(height-height*0.1133)- (count3 *40));
    count3++;
  }
    
  textSize(20);
  
  text("Object: " + noObject, width-width*0.965, height-height*0.0477);
  //text("Angle: " + iAngle +" °", width-width*0.48, height-height*0.0277);
  text("Distance: ", width-width*0.26, height-height*0.0477);
  if(iDistance<200) {
  text("        " + iDistance +" cm", width-width*0.215, height-height*0.0477);
  }
  
  //Add text for xCoordinate and yCoordinate
  text("(X,Y) = (" + xCoordinate +", " + yCoordinate + ")", (width-width*0.75) + 160, height-height*0.0477);
  //text("Y Coordinate: " + yCoordinate +" cm", width-width*0.5, height-height*0.0477);
  
  
  textSize(25);
  fill(98,245,60);
  translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  //text("30°",0,0);
  resetMatrix();
  translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  //text("60°",0,0);
  resetMatrix();
  translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  //text("90°",0,0);
  resetMatrix();
  translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
  rotate(radians(-30));
  //text("120°",0,0);
  resetMatrix();
  translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
  rotate(radians(-60));
  //text("150°",0,0);
  popMatrix(); 
}
