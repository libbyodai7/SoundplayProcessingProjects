/**
 * Mirror 
 * by Daniel Shiffman.  
 *
 * Each pixel from the video source is drawn as a rectangle with rotation based on brightness.   
 */ 
 
import processing.video.*;


// Size of each cell in the grid
int cellSize = 20;
// Number of columns and rows in our system
int cols, rows;
// Variable for capture device
Capture video;

import processing.io.*;
int GPIO_TRIGGER = 18;
int GPIO_ECHO = 24;
float duration;


  float timeStart = 0;
 float timeStop = 0;
  float timeElapsed = 0;
  float distance = 0;



void setup() {
  size(640, 480);
  frameRate(30);
  cols = width / cellSize;
  rows = height / cellSize;
  colorMode(RGB, 255, 255, 255, 100);

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height);
  
  // Start capturing the images from the camera
  video.start();  
  
  background(0);
  
    GPIO.pinMode(GPIO_TRIGGER,GPIO.OUTPUT);
  GPIO.pinMode(GPIO_ECHO,GPIO.INPUT);
  thread("get_sensor");
  thread("digital_writing_loop");
}


void draw() { 
  if (video.available()) {
    video.read();
    video.loadPixels();
  
    // Begin loop for columns
    for (int i = 0; i < cols; i++) {
      // Begin loop for rows
      for (int j = 0; j < rows; j++) {
      
        // Where are we, pixel-wise?
        int x = i*cellSize;
        int y = j*cellSize;
        int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image
      
        float r = red(video.pixels[loc]);
        float g = green(video.pixels[loc]);
        float b = blue(video.pixels[loc]);
        // Make a new color with an alpha component
        color c = color(r, g, b, 75);
      
        // Code for drawing a single rect
        // Using translate in order for rotation to work properly
        pushMatrix();
        translate(x+cellSize/2, y+cellSize/2);
        // Rotation formula based on brightness
        rotate((2 * PI * brightness(c) / 255.0));
        rectMode(CENTER);
        fill(c);
        noStroke();
        // Rects are larger than the cell for some overlap
        rect(0, 0, cellSize+6, cellSize+6);
        popMatrix();
      }
    }
  }
  

    pushMatrix();
    translate(width/2, height/2);
    //rotate((2 * PI * (timeElapsed * 40) / 255.0));
    fill(255, 0, 255, 60);
    ellipse(0, 0, timeElapsed*20, timeElapsed*20);
     popMatrix();
  
  //ellipse(width/2, height/2, timeElapsed *10, timeElapsed *10);
}


void digital_writing_loop() {
  while ( true ) {
  while(GPIO.digitalRead(GPIO_ECHO) == GPIO.LOW) {
    timeStart = millis();
   // println(timeStart);
  }
  
    while(GPIO.digitalRead(GPIO_ECHO) == GPIO.HIGH) {
    timeStop = millis();
   // println(timeStop);
  }
 timeElapsed= timeStop - timeStart;
println(timeElapsed);

    
  }
 
  
}

void get_sensor() {
  
  while ( true ) {
   GPIO.digitalWrite(GPIO_TRIGGER, GPIO.LOW);
 delay(5); 
  GPIO.digitalWrite(GPIO_TRIGGER, GPIO.HIGH);
  delay(5);
  GPIO.digitalWrite(GPIO_TRIGGER, GPIO.LOW);
   
  
  }
  
}
