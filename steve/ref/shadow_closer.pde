

import java.awt.Rectangle;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;


// you SHOULD NOT need to edit any of these variables
int margin = 0; // margin from sides of window
final int padding = 60; // padding between buttons and also their width/height
ArrayList trials = new ArrayList(); //contains the order of buttons that activate in the test
int marginE=3;

int currentBox=0;
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured.
int userX = mouseX; //stores the X position of the user's cursor
int userY = mouseY; //stores the Y position of the user's cursor
int finishTime = 0; //records the time of the final click
int hits = 0; //number of succesful clicks
int misses = 0; //number of missed clicks
int rightSpotX=0;
int rightSpotY=0;


// You can edit variables below here and also add new ones as you see fit
int numRepeats = 2; //sets the number of times each button repeats in the test (you can edit this)
int previous=0;
boolean setOnce=true;
void draw()
{
  //noCursor();
  margin = width/4; //scale the padding with the size of the window
  background(0); //set background to black

  if (trialNum >= trials.size()) //check to see if test is over
  {
    fill(255); //set fill color to white
    //write to screen
    text("Finished!", width / 2, height / 2);
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + (finishTime-startTime) / 1000f + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + ((finishTime-startTime) / 1000f)/(float)(hits+misses) + " sec", width / 2, height / 2 + 100);

    return; //return, nothing else to do now test is over
  }

  fill(255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on

  for (int i = 0; i < 16; i++)// for all button
    drawButton(i); //draw button

  // you shouldn't need to edit anything above this line! You can edit below this line as you see fit

  fill(255, 0, 0); // set fill color to red
  //System.out.println("Setonce "+setOnce);
  //if(setOnce==true){
    //ellipse(rightSpotX, rightSpotY, 20, 20);
    //setOnce=false;
  //}
  //else ellipse(circleX, circleY, 20, 20); //draw user cursor as a circle with a diameter of 20

}

void checkVal() // test to see if hit was in target!
{
  if (trialNum >= trials.size())
    return;

  if (trialNum == 0) //check if first click
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    //write to terminal
    System.out.println("Hits: " + hits);
    System.out.println("Misses: " + misses);
    System.out.println("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%");
    System.out.println("Total time taken: " + (finishTime-startTime) / 1000f + " sec");
    System.out.println("Average time for each button: " + ((finishTime-startTime) / 1000f)/(float)(hits+misses) + " sec");
  }

  Rectangle bounds = getButtonLocation((Integer)trials.get(trialNum));

  // YOU CAN EDIT BELOW HERE IF YOUR METHOD REQUIRES IT (shouldn't need to edit above this line)
  //System.out.println(userX+" " + bounds.x+" "+bounds.x + bounds.width);
  //System.out.println(userY+" " + bounds.y+" "+bounds.y + bounds.height);
  //System.out.println(trials.get(trialNum));
  if (currentBox==(Integer)trials.get(trialNum)) // test to see if hit was within bounds
  {
    System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hits++;
  }
  else
  {
    System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
  }

  //can manipulate cursor at the end of a trial if you wish
  //userX = width/2; //example manipulation
  //userY = height/2; //example manipulation

  trialNum++; // Increment trial number
  setOnce=true;
}

ArrayList<Rectangle> buttons = new ArrayList<Rectangle>();

void mousePressed(){
  checkVal();
}
void updateUserMouse() // YOU CAN EDIT THIS
{
  // you can do whatever you want to userX and userY (you shouldn't touch mouseX and mouseY)
  userX = (mouseX - pmouseX); //add to userX the difference between the current mouseX and the previous mouseX
  userY = (mouseY - pmouseY); //add to userY the difference between the current mouseY and the previous mouseY

  //System.out.println("User" +mouseX+", "+userY);
  //System.out.println("Mouse" + mouseY+", "+userY);

}

void findBox(){
  for (int i = 0; i < 16; i++){
        if(buttons.size()==16 && buttons.get(i)!=null && (buttons.get(i).x-marginE) <mouseX && (buttons.get(i).y-marginE)<mouseY && (buttons.get(i).x+marginE +buttons.get(i).width)>mouseX && (buttons.get(i).y+marginE +buttons.get(i).height)>mouseY){

      currentBox=i;
    }
  }
 
 }








// ===========================================================================
// =========SHOULDN'T NEED TO EDIT ANYTHING BELOW THIS LINE===================
// ===========================================================================

void setup()
{
  for (int i = 0; i < 16; i++){
    buttons.add(new Rectangle());
  }

  size(1000,800,P2D); // set the size of the window
  //noCursor(); // hides the system cursor (can turn on for debug, but should be off otherwise!)
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  noSmooth();
  textFont(createFont("Arial",16));
  textAlign(CENTER);
  frameRate(100);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  // ====create trial order======
  for (int i = 0; i < 16; i++)
    // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);

  Collections.shuffle(trials); // randomize the order of the buttons
  System.out.println("trial order: " + trials);
}

Rectangle getButtonLocation(int i)
{
  double x = (i % 4) * padding * 1.1 + margin;
  double y = (i / 4) * padding * 1.1 + margin+20;

  return new Rectangle((int)x, (int)y, padding, padding);
}

void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);

  if ((Integer)trials.get(trialNum) == i) {// see if current button is the target
    if(trialNum<trials.size()-2 && (Integer)trials.get(trialNum)==(Integer)trials.get(trialNum+1)){
      fill(200, 0, 0);
    }
    //else if(trialNum>1 && (Integer)trials.get(trialNum)==(Integer)trials.get(trialNum-2)) fill(0, 55, 255); // if so, fill cyan
    else fill(0, 255, 255);
    rightSpotX=(bounds.x+(bounds.width/2));
    rightSpotY=(bounds.y+(bounds.height/2));
    //System.out.println(rightSpotX+" , " + rightSpotY);

  }
  else if(currentBox == i)
    fill(40); // if not, fill gray
  else fill(50);
    
  buttons.set(i,bounds);

  rect(bounds.x, bounds.y, bounds.width, bounds.height);
  if ((Integer)trials.get(trialNum) == i) {
    if(i==currentBox){
      fill(100, 55, 200);
      rect(bounds.x+5, bounds.y+5, bounds.width-10, bounds.height-10);
    }
  }
}

void keyPressed() {
  checkVal();
}

void mouseMoved() // Don't edit this
{
  updateUserMouse();
  findBox();
  //System.out.println("Current Box"+currentBox);
}

void mouseDragged() // Don't edit this
{
  updateUserMouse();
}