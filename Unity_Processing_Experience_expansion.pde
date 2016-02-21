import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
import netP5.*;
import oscP5.*;

Capture video;
OpenCV opencv;
int lengthofgridslists = 80;
PImage src, colorFilteredImage;
ArrayList<Contour> contours;
Contour[] relevantcontours = new Contour[80];
int[] gridlist = new int[lengthofgridslists];
int[] gridonofflist = new int[lengthofgridslists];
// <1> Set the range of Hue values for our filter
int rangeLow = 5;
int rangeHigh = 20;
int on = 1;
int count;
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  video = new Capture(this, 640, 480);
  video.start();
  opencv = new OpenCV(this, video.width, video.height);
  oscP5 = new OscP5(this,12000);
  
  myRemoteLocation = new NetAddress("127.0.0.1",3200);
  size(1300, 480, P2D);
  
  //Populate the lists.
  for(int i = 0; i < lengthofgridslists; i++){
    gridlist [i] = i;
  }
  for(int i = 0; i < lengthofgridslists; i++){
    gridonofflist [i] = 0;
  }

}

void draw() {
  // Read last captured frame
  if (video.available()) {
    video.read();
  }
  // <2> Load the new frame of our movie in to OpenCV
  opencv.loadImage(video);
  
  // Tell OpenCV to use color information
  opencv.useColor();
  src = opencv.getSnapshot();
  // <3> Tell OpenCV to work in HSV color space.
  opencv.useColor(HSB);
  
  // <4> Copy the Hue channel of our image into 
  //     the gray channel, which we process.
  opencv.setGray(opencv.getH().clone());
  //opencv.adaptiveThreshold(100, 1);

  // <5> Filter the image based on the range of 
  //     hue values that match the object we want to track.
  opencv.inRange(rangeLow, rangeHigh);
  
  // <6> Get the processed image for reference.
  colorFilteredImage = opencv.getSnapshot();

  // <7> Find contours in our range image.
  //     Passing 'true' sorts them by descending area.
  contours = opencv.findContours(true, true);
  
  // <8> Display background images
  image(src, 0, 0);
  image(colorFilteredImage, src.width, 0);
  
  // <9> Check to make sure we've found any contours
  if (contours.size() > 0) {    
    //place the relevant contours into an array, and then grab the necessary information from them: the coordinates
    for (int i=0; i < relevantcontours.length; i++){
      //println("Looking for contours " + i);
      relevantcontours[i] = contours.get(i);    
      Rectangle r = relevantcontours[i].getBoundingBox();
      
      //filters out the contours, abstaining from grabbing tiny contours(kind of works... it helps)
      if (r.width <10 & r.height <10){
        relevantcontours[i] = contours.get(i);
        break;
      }
      
      //Render the rectangles and ellipses that will show up around relevant contours
      noFill(); 
      strokeWeight(2); 
      stroke(0,255, 0) ;
      rect(r.x, r.y, r.width, r.height);
      noStroke(); 
      fill(0, 255, 0);
      ellipse(r.x + r.width/2, r.y + r.height/2, 10, 10);
      
      
      // Each of these individual if statements represents one of grids on top of the captures video.
      //The blocks read from left to right going from top to bottom. Each if statement will check if something
      //is occupying the space it is taking care of, and then writes a 1 if there is a color present, and a 0
      //if there isn't anything.
      if((r.x + r.width/2) > 0 & (r.x + r.width/2) < 64 & (r.y + r.height/2) < 60 & gridonofflist[0] == 0){
        gridonofflist[0] += 1;
      }    
      if((r.x + r.width/2) > 64 & (r.x + r.width/2) < 128 & (r.y + r.height/2) < 60 & gridonofflist[1] == 0){
        gridonofflist[1] += 1;
      }    
      if((r.x + r.width/2) > 128 & (r.x + r.width/2) < 192 & (r.y + r.height/2) < 60 & gridonofflist[2] == 0){
        gridonofflist[2] += 1;
      }
      if((r.x + r.width/2) > 192 & (r.x + r.width/2) < 256 & (r.y + r.height/2) < 60 & gridonofflist[3] == 0){
        gridonofflist[3] += 1;
      }    
      if((r.x + r.width/2) > 256 & (r.x + r.width/2) < 320 & (r.y + r.height/2) < 60 & gridonofflist[4] == 0){
        gridonofflist[4] += 1;
      }    
      if((r.x + r.width/2) > 320 & (r.x + r.width/2) < 384 & (r.y + r.height/2) < 60 & gridonofflist[5] == 0){
        gridonofflist[5] += 1;
      }    
      if((r.x + r.width/2) > 384 & (r.x + r.width/2) < 448 & (r.y + r.height/2) < 60 & gridonofflist[6] == 0){
        gridonofflist[6] += 1;
      }
      if((r.x + r.width/2) > 448 & (r.x + r.width/2) < 512 & (r.y + r.height/2) < 60 & gridonofflist[7] == 0){
        gridonofflist[7] += 1;
      }    
      if((r.x + r.width/2) > 512 & (r.x + r.width/2) < 576 & (r.y + r.height/2) < 60 & gridonofflist[8] == 0){
        gridonofflist[8] += 1;
      }
      if((r.x + r.width/2) > 576 & (r.x + r.width/2) < 640 & (r.y + r.height/2) < 60 & gridonofflist[9] == 0){
        gridonofflist[9] += 1;
      }
      if((r.x + r.width/2) > 0 & (r.x + r.width/2) < 64 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[10] == 0){
        gridonofflist[10] += 1;
      }    
      if((r.x + r.width/2) > 64 & (r.x + r.width/2) < 128 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[11] == 0){
        gridonofflist[11] += 1;
      }    
      if((r.x + r.width/2) > 128 & (r.x + r.width/2) < 192 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[12] == 0){
        gridonofflist[12] += 1;
      }
      if((r.x + r.width/2) > 192 & (r.x + r.width/2) < 256 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[13] == 0){
        gridonofflist[13] += 1;
      }    
      if((r.x + r.width/2) > 256 & (r.x + r.width/2) < 320 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[14] == 0){
        gridonofflist[14] += 1;
      }    
      if((r.x + r.width/2) > 320 & (r.x + r.width/2) < 384 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[15] == 0){
        gridonofflist[15] += 1;
      }    
      if((r.x + r.width/2) > 384 & (r.x + r.width/2) < 448 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[16] == 0){
        gridonofflist[16] += 1;
      }
      if((r.x + r.width/2) > 448 & (r.x + r.width/2) < 512 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[17] == 0){
        gridonofflist[17] += 1;
      }    
      if((r.x + r.width/2) > 512 & (r.x + r.width/2) < 576 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[18] == 0){
        gridonofflist[18] += 1;
      }
      if((r.x + r.width/2) > 576 & (r.x + r.width/2) < 640 & (r.y + r.height/2) > 60  & (r.y + r.height/2) < 120 & gridonofflist[19] == 0){
        gridonofflist[19] += 1;
      }
      if((r.x + r.width/2) > 0 & (r.x + r.width/2) < 64 & (r.y + r.height/2) > 120  & (r.y + r.height/2) < 180 & gridonofflist[20] == 0){
        gridonofflist[20] += 1;
      }    
      if((r.x + r.width/2) > 64 & (r.x + r.width/2) < 128 & (r.y + r.height/2) >120  & (r.y + r.height/2) < 180 & gridonofflist[21] == 0){
        gridonofflist[21] += 1;
      }    
      if((r.x + r.width/2) > 128 & (r.x + r.width/2) < 192 & (r.y + r.height/2) > 120  & (r.y + r.height/2) < 180 & gridonofflist[22] == 0){
        gridonofflist[22] += 1;
      }
      if((r.x + r.width/2) > 192 & (r.x + r.width/2) < 256 & (r.y + r.height/2) > 120  & (r.y + r.height/2) < 180 & gridonofflist[23] == 0){
        gridonofflist[23] += 1;
      }    
      if((r.x + r.width/2) > 256 & (r.x + r.width/2) < 320 & (r.y + r.height/2) > 120  & (r.y + r.height/2) < 180 & gridonofflist[24] == 0){
        gridonofflist[24] += 1;
      }    
      if((r.x + r.width/2) > 320 & (r.x + r.width/2) < 384 & (r.y + r.height/2) > 120  & (r.y + r.height/2) < 180 & gridonofflist[25] == 0){
        gridonofflist[25] += 1;
      }    
      if((r.x + r.width/2) > 384 & (r.x + r.width/2) < 448 & (r.y + r.height/2) > 120  & (r.y + r.height/2) < 180 & gridonofflist[26] == 0){
        gridonofflist[26] += 1;
      }
      if((r.x + r.width/2) > 448 & (r.x + r.width/2) < 512 & (r.y + r.height/2) > 120  & (r.y + r.height/2) < 180 & gridonofflist[27] == 0){
        gridonofflist[27] += 1;
      }    
      if((r.x + r.width/2) > 512 & (r.x + r.width/2) < 576 & (r.y + r.height/2) > 120  & (r.y + r.height/2) < 180 & gridonofflist[28] == 0){
        gridonofflist[28] += 1;
      }
      if((r.x + r.width/2) > 576 & (r.x + r.width/2) < 640 & (r.y + r.height/2) > 120  & (r.y + r.height/2) < 180 & gridonofflist[29] == 0){
        gridonofflist[29] += 1;
      }
      if((r.x + r.width/2) > 0 & (r.x + r.width/2) < 64 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[30] == 0){
        gridonofflist[30] += 1;
      }    
      if((r.x + r.width/2) > 64 & (r.x + r.width/2) < 128 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[31] == 0){
        gridonofflist[31] += 1;
      }    
      if((r.x + r.width/2) > 128 & (r.x + r.width/2) < 192 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[32] == 0){
        gridonofflist[32] += 1;
      }
      if((r.x + r.width/2) > 192 & (r.x + r.width/2) < 256 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[33] == 0){
        gridonofflist[33] += 1;
      }    
      if((r.x + r.width/2) > 256 & (r.x + r.width/2) < 320 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[34] == 0){
        gridonofflist[34] += 1;
      }    
      if((r.x + r.width/2) > 320 & (r.x + r.width/2) < 384 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[35] == 0){
        gridonofflist[35] += 1;
      }    
      if((r.x + r.width/2) > 384 & (r.x + r.width/2) < 448 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[36] == 0){
        gridonofflist[36] += 1;
      }
      if((r.x + r.width/2) > 448 & (r.x + r.width/2) < 512 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[37] == 0){
        gridonofflist[37] += 1;
      }    
      if((r.x + r.width/2) > 512 & (r.x + r.width/2) < 576 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[38] == 0){
        gridonofflist[38] += 1;
      }
      if((r.x + r.width/2) > 576 & (r.x + r.width/2) < 640 & (r.y + r.height/2) > 180  & (r.y + r.height/2) < 240 & gridonofflist[39] == 0){
        gridonofflist[39] += 1;
      }
      if((r.x + r.width/2) > 0 & (r.x + r.width/2) < 64 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[40] == 0){
        gridonofflist[40] += 1;
      }    
      if((r.x + r.width/2) > 64 & (r.x + r.width/2) < 128 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[41] == 0){
        gridonofflist[41] += 1;
      }    
      if((r.x + r.width/2) > 128 & (r.x + r.width/2) < 192 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[42] == 0){
        gridonofflist[42] += 1;
      }
      if((r.x + r.width/2) > 192 & (r.x + r.width/2) < 256 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[43] == 0){
        gridonofflist[43] += 1;
      }    
      if((r.x + r.width/2) > 256 & (r.x + r.width/2) < 320 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[44] == 0){
        gridonofflist[44] += 1;
      }    
      if((r.x + r.width/2) > 320 & (r.x + r.width/2) < 384 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[45] == 0){
        gridonofflist[45] += 1;
      }    
      if((r.x + r.width/2) > 384 & (r.x + r.width/2) < 448 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[46] == 0){
        gridonofflist[46] += 1;
      }
      if((r.x + r.width/2) > 448 & (r.x + r.width/2) < 512 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[47] == 0){
        gridonofflist[47] += 1;
      }    
      if((r.x + r.width/2) > 512 & (r.x + r.width/2) < 576 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[48] == 0){
        gridonofflist[48] += 1;
      }
      if((r.x + r.width/2) > 576 & (r.x + r.width/2) < 640 & (r.y + r.height/2) > 240  & (r.y + r.height/2) < 300 & gridonofflist[49] == 0){
        gridonofflist[49] += 1;
      }
      if((r.x + r.width/2) > 0 & (r.x + r.width/2) < 64 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[50] == 0){
        gridonofflist[50] += 1;
      }    
      if((r.x + r.width/2) > 64 & (r.x + r.width/2) < 128 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[51] == 0){
        gridonofflist[51] += 1;
      }    
      if((r.x + r.width/2) > 128 & (r.x + r.width/2) < 192 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[52] == 0){
        gridonofflist[52] += 1;
      }
      if((r.x + r.width/2) > 192 & (r.x + r.width/2) < 256 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[53] == 0){
        gridonofflist[53] += 1;
      }    
      if((r.x + r.width/2) > 256 & (r.x + r.width/2) < 320 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[54] == 0){
        gridonofflist[54] += 1;
      }    
      if((r.x + r.width/2) > 320 & (r.x + r.width/2) < 384 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[55] == 0){
        gridonofflist[55] += 1;
      }    
      if((r.x + r.width/2) > 384 & (r.x + r.width/2) < 448 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[56] == 0){
        gridonofflist[56] += 1;
      }
      if((r.x + r.width/2) > 448 & (r.x + r.width/2) < 512 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[57] == 0){
        gridonofflist[57] += 1;
      }    
      if((r.x + r.width/2) > 512 & (r.x + r.width/2) < 576 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[58] == 0){
        gridonofflist[58] += 1;
      }
      if((r.x + r.width/2) > 576 & (r.x + r.width/2) < 640 & (r.y + r.height/2) > 300  & (r.y + r.height/2) < 360 & gridonofflist[59] == 0){
        gridonofflist[59] += 1;
      }     
      if((r.x + r.width/2) > 0 & (r.x + r.width/2) < 64 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[60] == 0){
        gridonofflist[60] += 1;
      }    
      if((r.x + r.width/2) > 64 & (r.x + r.width/2) < 128 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[61] == 0){
        gridonofflist[61] += 1;
      }    
      if((r.x + r.width/2) > 128 & (r.x + r.width/2) < 192 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[62] == 0){
        gridonofflist[62] += 1;
      }
      if((r.x + r.width/2) > 192 & (r.x + r.width/2) < 256 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[63] == 0){
        gridonofflist[63] += 1;
      }    
      if((r.x + r.width/2) > 256 & (r.x + r.width/2) < 320 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[64] == 0){
        gridonofflist[64] += 1;
      }    
      if((r.x + r.width/2) > 320 & (r.x + r.width/2) < 384 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[65] == 0){
        gridonofflist[65] += 1;
      }    
      if((r.x + r.width/2) > 384 & (r.x + r.width/2) < 448 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[66] == 0){
        gridonofflist[66] += 1;
      }
      if((r.x + r.width/2) > 448 & (r.x + r.width/2) < 512 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[67] == 0){
        gridonofflist[67] += 1;
      }    
      if((r.x + r.width/2) > 512 & (r.x + r.width/2) < 576 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[68] == 0){
        gridonofflist[68] += 1;
      }
      if((r.x + r.width/2) > 576 & (r.x + r.width/2) < 640 & (r.y + r.height/2) > 360  & (r.y + r.height/2) < 420 & gridonofflist[69] == 0){
        gridonofflist[69] += 1;
      }      
      if((r.x + r.width/2) > 0 & (r.x + r.width/2) < 64 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[70] == 0){
        gridonofflist[70] += 1;
      }    
      if((r.x + r.width/2) > 64 & (r.x + r.width/2) < 128 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[71] == 0){
        gridonofflist[71] += 1;
      }    
      if((r.x + r.width/2) > 128 & (r.x + r.width/2) < 192 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[72] == 0){
        gridonofflist[72] += 1;
      }
      if((r.x + r.width/2) > 192 & (r.x + r.width/2) < 256 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[73] == 0){
        gridonofflist[73] += 1;
      }    
      if((r.x + r.width/2) > 256 & (r.x + r.width/2) < 320 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[74] == 0){
        gridonofflist[74] += 1;
      }    
      if((r.x + r.width/2) > 320 & (r.x + r.width/2) < 384 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[75] == 0){
        gridonofflist[75] += 1;
      }    
      if((r.x + r.width/2) > 384 & (r.x + r.width/2) < 448 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[76] == 0){
        gridonofflist[76] += 1;
      }
      if((r.x + r.width/2) > 448 & (r.x + r.width/2) < 512 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[77] == 0){
        gridonofflist[77] += 1;
      }    
      if((r.x + r.width/2) > 512 & (r.x + r.width/2) < 576 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[78] == 0){
        gridonofflist[78] += 1;
      }
      if((r.x + r.width/2) > 576 & (r.x + r.width/2) < 640 & (r.y + r.height/2) > 420  & (r.y + r.height/2) < 480 & gridonofflist[79] == 0){
        gridonofflist[79] += 1;
      }           
    }
    
    //the count variable is used here to limit the frequency of sending data over to unity, smaller count sizes in the if statement
    //will send the array information faster, but will cause framerate loss in unity and a higher chance for bugs to happen.
    //Find a sweet spot and then just leave it at that.
    count +=1;
    if (count ==5){
      //the information here for example is only sent once every 30 cycles, you can modify it to make it faster.
      //The for statement grabs the grid number, and whether it is on or off and sends the pair over to the sendValue function,
      //where it will be sent to Unity to be read. The gridonofflist[i] = 0 puts the list back to the 0 so that fresh data can be 
      //rewritten on top of a blank list as it cycles through everything again.
      for(int i = 0; i < lengthofgridslists; i++){
        sendValue(gridlist[i], gridonofflist[i]);
        gridonofflist[i] = 0;
      }
      count = 0;
      
    }  
  }
}



//This function takes care of choosing which color to track on the screen.
void mousePressed() {
  color c = get(mouseX, mouseY);
  println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
  int hue = int(map(hue(c), 0, 255, 0, 180));
  println("hue to detect: " + hue);
  rangeLow = hue - 5;
  rangeHigh = hue + 5;
}

//The sendValue function takes two parameters, the gridnumber(designated by a number between 0-80) and whether it is occupied or not(designated by a 1 or a 0).
void sendValue(int gridnumber, int gridoccupied)
{
  OscMessage oscMess = new OscMessage("onoff");
  oscMess.add(gridnumber);
  oscMess.add(gridoccupied);
  oscP5.send(oscMess, myRemoteLocation);
}