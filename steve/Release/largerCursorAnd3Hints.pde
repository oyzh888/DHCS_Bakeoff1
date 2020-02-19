import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

//when in doubt, consult the Processsing reference: https://processing.org/reference/

int margin = 200; //set the margin around the squares
final int padding = 50; // padding between buttons and also their width/height
final int buttonSize = 40; // padding between buttons and also their width/height
ArrayList<Integer> trials = new ArrayList<Integer>(); //contains the order of buttons that activate in the test
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
int hits = 0; //number of successful clicks
int misses = 0; //number of missed clicks
int hintInterval = 1;
int pointerSize = 50;
int pointerTransparent = 100;
int autoClickTimes = 16;
Robot robot; //initalized in setup 

int numRepeats = 1; //sets the number of times each button repeats in the test

void setup()
{
  size(700, 700); // set the size of the window
  //noCursor(); //hides the system cursor if you want
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  textFont(createFont("Arial", 16)); //sets the font to Arial size 16
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  //rectMode(CENTER); //enabling will break the scaffold code, but you might find it easier to work with centered rects

  try {
    robot = new Robot(); //create a "Java Robot" class that can move the system cursor
  } 
  catch (AWTException e) {
    e.printStackTrace();
  }

  //===DON'T MODIFY MY RANDOM ORDERING CODE==
  for (int i = 0; i < 16; i++) //generate list of targets and randomize the order
      // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);

  Collections.shuffle(trials); // randomize the order of the buttons
  System.out.println("trial order: " + trials);
  
  frame.setLocation(0,0); // put window in top left corner of screen (doesn't always work)
}

void arrow(int x1, int y1, int x2, int y2) {
  stroke(255, 0, 0);
  strokeWeight(3);
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
} 

void drawArrows(){
  // draw a red line to the next button
  Rectangle rec1 = getButtonLocation((Integer)trials.get(trialNum));
  Rectangle rec2 = getButtonLocation((Integer)trials.get(trialNum+1));
  Rectangle rec3 = getButtonLocation((Integer)trials.get(trialNum+2));

  arrow(rec1.x+rec1.width/2, rec1.y+rec1.height/2, rec2.x+rec2.width/2, rec2.y+rec2.height/2);
  arrow(rec2.x+rec2.width/2, rec2.y+rec2.height/2, rec3.x+rec3.width/2, rec3.y+rec3.height/2);
}

void draw()
{
  background(0); //set background to black

  if (trialNum >= trials.size()) //check to see if test is over
  {
    float timeTaken = (finishTime-startTime) / 1000f;
    float penalty = constrain(((95f-((float)hits*100f/(float)(hits+misses)))*.2f),0,100);
    fill(255); //set fill color to white
    //write to screen (not console)
    text("Finished!", width / 2, height / 2); 
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + timeTaken + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + nf((timeTaken)/(float)(hits+misses),0,3) + " sec", width / 2, height / 2 + 100);
    text("Average time for each button + penalty: " + nf(((timeTaken)/(float)(hits+misses) + penalty),0,3) + " sec", width / 2, height / 2 + 140);
    return; //return, nothing else to do now test is over
  }

  fill(255,255, 255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on

   
  for (int i = 0; i < 16; i++)// for all button
    drawButton(i); //draw button

  Rectangle bounds = getButtonLocation(trials.get(trialNum));
  boolean hit = circleRect(mouseX,mouseY,pointerSize/2, bounds.x,bounds.y,bounds.width,bounds.height);
  if(hit) fill(0, 255, 0, pointerTransparent); // set fill color to translucent red
  else fill(255, 0, 0, pointerTransparent);
  ellipse(mouseX, mouseY, pointerSize, pointerSize); //draw user cursor as a circle with a diameter of 20
  
  //drawArrows();
  if(trialNum >= trials.size()-2)
    return; //don't draw the line if no button to draw on.
  // draw a red line to the next button
  if(trialNum % hintInterval == 0)
  drawArrows();
  
 
}

boolean circleRect(float cx, float cy, float radius, float rx, float ry, float rw, float rh) {

  // temporary variables to set edges for testing
  float testX = cx;
  float testY = cy;

  // which edge is closest?
  if (cx < rx)         testX = rx;      // test left edge
  else if (cx > rx+rw) testX = rx+rw;   // right edge
  if (cy < ry)         testY = ry;      // top edge
  else if (cy > ry+rh) testY = ry+rh;   // bottom edge

  // get distance from closest edges
  float distX = cx-testX;
  float distY = cy-testY;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  // if the distance is less than the radius, collision!
  if (distance <= radius) {
    return true;
  }
  return false;
}

void updateHit()
{
   if (trialNum >= trials.size()) //if task is over, just return
    return;

  if (trialNum == 0) //check if first click, if so, start timer
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    //write to terminal some output. Useful for debugging too.
    println("we're done!");
  }

  Rectangle bounds = getButtonLocation(trials.get(trialNum));

 //check to see if mouse cursor is inside button 
  boolean hit = circleRect(mouseX,mouseY,pointerSize/2, bounds.x,bounds.y,bounds.width,bounds.height);
  if(hit)// test to see if hit was within bounds
  {
    System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hits++; 
  } 
  else
  {
    System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
  }

  trialNum++; //Increment trial number

  //in this example code, we move the mouse back to the middle
  //robot.mouseMove(width/2, (height)/2); //on click, move cursor to roughly center of window!
}
  
void mousePressed() // test to see if hit was in target!
{
  updateHit();
}  

//probably shouldn't have to edit this method
Rectangle getButtonLocation(int i) //for a given button ID, what is its location and size
{
   int x = (i % 4) * (padding + buttonSize) + margin;
   int y = (i / 4) * (padding + buttonSize) + margin;
   return new Rectangle(x, y, buttonSize, buttonSize);
}

//you can edit this method to change how buttons appear
void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);
  
  // Predict the next buttons
  int bias = -10;
  if (trials.get(trialNum) == i) // see if current button is the target
  {
    fill(0, 255, 255); // if so, fill cyan
    text("click", bounds.x, bounds.y+bias);
  }
  else if (trialNum < trials.size()-2 && (Integer)trials.get(trialNum+1) == i && trialNum%hintInterval==0)
  {
    fill(40, 159, 146); // fill next button yellow
    text("next 1", bounds.x, bounds.y+bias);
  }
  else if (trialNum < trials.size()-2 && (Integer)trials.get(trialNum+2) == i && trialNum%hintInterval==0)
  {
    fill(19, 68, 114); // fill next button yellow
    text("next 2", bounds.x, bounds.y+bias);
  }
  else
    fill(200); // if not, fill gray
  
  // reset stroke
  strokeWeight(0);
  rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
  
}

void mouseMoved()
{
   //can do stuff everytime the mouse is moved (i.e., not clicked)
   //https://processing.org/reference/mouseMoved_.html
}

void mouseDragged()
{
  //can do stuff everytime the mouse is dragged
  //https://processing.org/reference/mouseDragged_.html
}

void keyPressed() 
{
  // VK_NUMPAD0(96) - > VK_NUMPAD9(105)
  if(keyCode <= (int)'9' && keyCode >= (int)'1'){
    autoClickTimes = keyCode - (int)'1' + 1;
  }
  else if (keyCode == (int)'S' ){ // int('s')
    autoClickTimes = 16;
  }else {
    autoClickTimes = 1;
  }
  for(int i=0; i<autoClickTimes; i++)
    updateHit();
  //can use the keyboard if you wish
  //https://processing.org/reference/keyTyped_.html
  //https://processing.org/reference/keyCode.html
}
