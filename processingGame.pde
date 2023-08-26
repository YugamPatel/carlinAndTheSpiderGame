
/*
OVERVIEW
Carlin, the hero of our story, is going through an infinite number of halls looking for the light of
truth. This little champion (Carlin means little champion in Irish) faces a villainous giant spider in
each hall. The spider’s mission is to catch Carlin and trap her in its poisonous webs to avoid the
light of truth being revealed. Carlin tries to doge the spider and reach each hall’s door. But that’s
not all; Carlin is equipped with a specific ability too. She can make ice and freeze a particular
location of the hall. While she can only use her ability for a limited number of times, if Spider
touches the frozen surface of the hall path, it makes the spider much slower and buys more time
for Carlin to pass the hall(s).
In this assignment, you will create a game in which the hero character starts at a specific point,
passes some blocks in a series of halls, avoids hitting the evil character and tries to reach the hall
doors. The game levels up every time that the player reaches the door.
*/

//GLOBAL CONSTANTS AND VARIABLES

final int HALL_TOP = 100 ;  // The Size of Hall Top
final int  HALL_BOTTOM = 100 ;  // The Size of Hall Bottom
final int NUM_ROWS = 9 ;  // The Number Of Rows
final int NUM_COLS = 9 ;  // The Number of columns
final int DOOR_WIDTH = 240 ; // The Width of the Yellow door
final int DOOR_HEIGHT = 27 ;  // The Height of the Yellow Door
final int DOOR_Y = HALL_TOP - DOOR_HEIGHT ; // The y co-ordinate of the Yellow Door
final int SPACING = 600/NUM_COLS ;   //  The SPACING between the paths and the size of the Bricks
final int CARLIN_DIAM = SPACING - 10 ;   // The diameter of Carlins Body
final int SPIDER_WIDTH = 30 ;  //  The Width of the Spider OR the Horizontal Length of the Spider
final int SPIDER_HEIGHT = 50 ;  //  The Height of the Spider or The verticle Length of the Spider
final int MAX_SPEED = 30 ;  // The Max Speed of the Spider
float doorX = -1;  // The Initial X coordinate of the doorX (Before Random Delcaration)
int squareX  ;  // The X co-ordinate of the First Square
int hallBottomY;  // The Y - Coordinates of the bottom Black HAll
int pathX ;  // The X Coordinates of the Grey Path
int pathY ;   // The Y Coordinates of the Grey Path
int pathHeight ;   // The height of the Grey Path
int carlinX  = -1 ;  //The initial Value of Carlin X (Before Random Declaration)
int carlinY ;   // Y coordinate of carlin
int spiderX = -1  ;  //The initial Value of Spider X (Before Random Declaration)
int spiderY ;   // Y coordinate of Spider
int spiderLegOneX ;   // The X coordinate of the Spider leg one
int spiderLegOneXEnd ;  // The End X coordinate of the Spider leg one
int spiderLegOneY ; // The Y coordinate of the Spider leg one
int spiderLegOneYEnd ; // The End Y coordinate of the Spider leg one
int spiderLegTwoX ;  // The X coordinate of the Spider leg Two
int spiderLegTwoXEnd ;   // The End X coordinate of the Spider leg Two
int spiderLegTwoY ;  // The Y coordinate of the Spider leg Two
int spiderLegTwoYEnd ;  // The End Y coordinate of the Spider leg Two
float spiderSpeed = 10 ;  // The Initial Speed of the Spider
float increaseSpiderSpeed = 0 ; //By how much the speed of spider increases after each level
boolean goRightOrLeft ;  //  boolean expression for checking the obsticle and taking  the clearance so the right or left move is allowed
boolean goUPOrDown ;   // //  boolean expression for checking the obsticle and taking  the clearance so the Up or Down move is allowed

boolean dead = false ;    // boolean to check weather carlin is dead or got traped by the spider
int levelUpByOne = 1 ;   // Increase the speed of the spider by one
int levelNumber = 1 ;      // The level of the game
String level = "Level: " ;   // String to print at the top of the canvas


int carlinsMagicPowers = 3 ;   // The Total Magic powers of Carlin
boolean usedMagic = false ;  // boolean to know whether carlin used magic in a perticular level and also to make sure only one magic is used in one level
int frozenCol = -1 ;  // Initial value of frozenCol
int frozenRow ;  // frozenRow
int magicWidth  = SPACING ;  // size of the ice or the magic block
boolean pressed ;  // boolean to store the keyPressed() function

void setup() {  //Setup Start

  size(600, 800) ; // Size of the Canvas

  hallBottomY = height - HALL_BOTTOM ; // Calculation of the y Coordinates of the black hall at the bottom

  squareX = width/NUM_COLS ; // The X Coordinate of the brick

  pathX = 0 ;  // The X coordinates of the Grey Path

  pathY = HALL_TOP; // The Y coordinate of the Grey Path

  pathHeight = height - (HALL_TOP + HALL_BOTTOM)  ; // The height of the Grey Path

  carlinY = hallBottomY - SPACING/2 ;   // The Y coordinates of the carlin At the bottom
} // Setup End


void draw() {  // Draw Start
  /*
Calls the Functions  drawHall() , drawDoor() ,  drawSpider() , drawCarlin() .
   and initalize the value of carlinX , spiderX and doorX
   */

  drawHall() ;  // Draws top and bottom black hall by Calling drawHall()
  drawDoor() ;  // Draws the Yellow Door at the Top by Calling drawDoor()

  if (carlinX == -1) {  // Initializes the value of CarlinX only when carlinX is -1
    carlinX =   initialCalin( (int)random(1, 2*NUM_COLS) ) ;  // Initialize the Value of Carlin By calling initialCalin(int) that return a value
  }

  if (spiderX == -1) { // Initializes the value of SpiderX only when carlinX is -1
    spiderX =   initialSpider( (int)random(1, 2*NUM_COLS) ) ; // Initialize the Value of Spider By calling initialSpider(int) that return a value
  }

  if (doorX == -1) { // Initializes the value of doorX only when doorX is -1
    doorX = random(0, width-DOOR_WIDTH) ; // initialize a random value for the door between 0 and width-DOOR_WIDTH
  }

  drawSpider() ;  // Draws the spider at the top at the begining by calling drawSpider()
  drawCarlin() ;  // Draws carlin at the bottom at the begining by calling drawCarlin()
  moveSpider() ;  // move spider in Random Location

  showLevel() ;  // showing level at the top of the canvas
  levelUp() ;  // function to level up after carlin reached the door
  endGame() ;  // Ending the game once carlin is dead or traped by the spider

  speedAndMagic() ;   //Showing  speed and score at the bottom of the canvas
  spiderInsideMagic() ;   // funtion to decrase the speed of the spider , if the spider is inside the ice

  if (frozenCol != -1 && pressed && (carlinsMagicPowers >= 0)) {    //  drawing the ice if the condition are meet
    noStroke() ;
    fill(0, 140, 255, 170) ;      // Light Blue color with transparency
    rect(frozenCol, frozenRow, magicWidth, magicWidth) ;        // The ice or the Magic Block
  }
} // Draw End




void drawHall() { //drawHall() Start

  /*
*  This Function Draws the black hall at the top and Bottom , The Grey Path between the two black halls
   *   and the Brown Bricks using nested for loop
   */

  fill(0) ; // Black Color of the Halls
  noStroke() ;  // No Stroke for no borders
  rect(0, 0, width, HALL_TOP ) ;  // the top black hall
  rect(0, hallBottomY, width, HALL_BOTTOM ) ;  // The bottom black hall
  fill(180) ;  // Grey Color of the path
  rect( pathX, pathY, width, pathHeight) ;  // the grey path between the top and bottom halls
  fill(#9B6109) ; // brown Color for the Bricks
  for (int j = 1; j < NUM_ROWS; j+= 2) {  // for loop that controls the number of the rows
    for (int i = 1; i < NUM_COLS; i+=2 ) { // for loop that controls the number of columns
      square(  i*(squareX), (HALL_TOP + j*squareX), SPACING) ;  // the bricks that becomes obsticles for carlin are of spacing width
    } // Inner Loop End
  } // Outer Loop End
} // drawHall() End



void drawCarlin() { //drawCarlin Start
  /*
*  This Function Draws Carlin Under Certain Condition that is when carlinX is not -1
   *  And when this conditon is met it draws
   *  calins body,legs and eyes from the value of carlinX that we get from initialCalin(int randomNum)
   */


  if (carlinX != -1) {  // Only Draws Carlin when The value of carlin is initialised that is the value of carlinX is not -1

    fill(0, 180, 255) ; // Light Blue Color of Carlins body

    stroke(0) ;  // No Stroke for no borders

    circle(carlinX, carlinY, CARLIN_DIAM) ;  // Carlins Body

    fill(130, 250, 0) ;  // Light Green Color for Carlins Legs

    arc(carlinX - CARLIN_DIAM/2, carlinY + CARLIN_DIAM/2, CARLIN_DIAM/2, CARLIN_DIAM/2, PI, TWO_PI, OPEN ) ;  // Carlins Leg (Left)
    arc(carlinX + CARLIN_DIAM/2, carlinY + CARLIN_DIAM/2, CARLIN_DIAM/2, CARLIN_DIAM/2, PI, TWO_PI, OPEN) ;  // Carlin leg  (Right)

    fill(255, 255, 0) ;  // Carlins Yellow Eyes
    circle(carlinX - 10, carlinY - 10, 10) ;  // Carlin Left Eye
    circle(carlinX + 10, carlinY - 10, 10) ;  // Carlin Right Eye
  }  // If Statement Ends
}// drawCarlin Ends


int initialCalin(int randomNum) { // initialCalin()  Starts
  /*
this function initialize a random x location of carlin at the bottom by taking random numbers betweeen 1 and 17
   and taking the odd ones out and multiplies it with SPACING/2 and returns this value from where it is called.
   */


  if (randomNum%2 != 0) {  // This if statement checks if randomNum is even or odd (if it is odd then only it will work that is randomNum%2 != 0)
    carlinX = randomNum*SPACING/2 ;  // Initialise a Random value for carlinX
  }
  return  carlinX ; // Returns random value of carlinX if The number we get is odd or if its is not the it returns -1
} // initialCalin()  Ends



void drawSpider() { // drawSpider() Start

  /*
This Function Draws Spider Under Certain Condition that is when spiderX is not -1
   And when this conditon is met it draws
   Spiders body and legs from the value of spiderX that we get from initialSpider(int randomNum)
   */

  if (spiderX == -1) {  // Initializing the value of spiderY Only when SpiderX is -1
    spiderY = HALL_TOP + SPACING/2 ;   // The Value of SpiderY at The TOP OF THE PATH
  }

  if (spiderX != -1) {   // Drawing the spider only when a random value has been initialized

    drawSpiderLegs() ;  // Calling the Function that Draws the legs of the spider

    fill(255, 0, 0) ; // Red Color

    stroke(0) ;  // No stroke or stroke Zero

    ellipse(spiderX, spiderY, SPIDER_WIDTH, SPIDER_HEIGHT) ;  // The Spider Body that is of oval shape

    spiderY = HALL_TOP + SPACING/2 ;  // The value of spiderY when spiderY is not -1
  }
} // drawSpider End


int initialSpider(int randomNum) {  // initialSpider() Start
  /*
this function initialize a random x location of Spider at the Top by taking random numbers betweeen 1 and 17
   and taking the odd ones out and multiplies it with SPACING/2 and returns this value from where it is called.
   */

  if (randomNum%2 != 0) {   // This if statement checks if randomNum is even or odd (if it is odd then only it will work that is randomNum%2 != 0)
    spiderX = randomNum*SPACING/2 ;   // Initialise a Random value for spiderX
  }
  return spiderX ;  // Returns random value of spiderX if The number we get is odd or if its is not the it returns -1
} //  initialSpider() Ends

void drawSpiderLegs() {
  /*
This function Draws two lines that are spider legs of redish color
   */

  strokeWeight(3) ;  // Stroke of spider legs
  stroke(#833508) ;  // Stroke color of the spider legs
  spiderLegOneX = spiderX - SPACING/2 + 2 ;   // start X Coordinates of the spider leg one
  spiderLegOneXEnd =  spiderX + SPACING/2 - 5 ;  // End X Coordinates of the spider leg one
  spiderLegOneY = spiderY - SPACING/2 + 7 ;  // start Y Coordinates of the spider leg one
  spiderLegOneYEnd  = spiderY + SPACING/2 - 7 ;  // End Y Coordinates of the spider leg one

  spiderLegTwoX = spiderLegOneXEnd ;     // start X Coordinates of the spider leg two
  spiderLegTwoXEnd = spiderLegOneX;     // End X Coordinates of the spider leg two
  spiderLegTwoY = spiderLegOneY ;      // start Y Coordinates of the spider leg two
  spiderLegTwoYEnd = spiderLegOneYEnd;         // End Y Coordinates of the spider leg two


  line(spiderLegOneX, spiderLegOneY, spiderLegOneXEnd, spiderLegOneYEnd);  // Leg one
  line(spiderLegTwoX, spiderLegTwoY, spiderLegTwoXEnd, spiderLegTwoYEnd) ;  // leg two
}

void moveSpider() {  // movespider Start
  /*
this function moves the spider in random location using random integers
   */

  String TheDirectionToPass = "Start";  // The Direction that give the random direction to spider

  int randomDirection = (int)random(1, 5) ; // randomDirection gives random direction to the spider


  if (randomDirection == 1) {        // if randomDirection is 1 direction of the spider is right
    TheDirectionToPass = "right" ;           // Right Direction
  }

  if (randomDirection == 2) {          // if randomDirection is 2 direction of the spider is left
    TheDirectionToPass = "left" ;                // Left Direction
  }
  if (randomDirection == 3) {            // if randomDirection is 3 direction of the spider is up
    TheDirectionToPass = "up" ;                  // Up Direction
  }
  if (randomDirection == 4) {           //if randomDirection is 4 direction of the spider is down
    TheDirectionToPass = "down" ;     //Down Direction
  }


  spiderX += NextX(spiderX, spiderY, TheDirectionToPass, spiderSpeed) ;   // Passing the instructions to nextX and adding it to spiderX
  spiderY += NextY(spiderX, spiderY, TheDirectionToPass, spiderSpeed) ;    // Passing the instructions to nextY and adding it to spiderY
} // moveSpider End



void drawDoor() { // drawDoor() start
  /*
   This function Draws the door at random x location at the top hall
   for carlin to allow him to move to next level
   */

  if (doorX != -1) {      // if the value of doorX is intialized then only door will be drawn
    noStroke() ;         // No Stroke for no borders
    fill(255, 255, 0) ;         // Yellow color of the door
    rect(doorX, DOOR_Y, DOOR_WIDTH, DOOR_HEIGHT) ;   // The door
  }
}   // drawDoor() End


void keyPressed() {  //keyPressed() start
  /*
this function moves carlin according to key instructions
   */

  if (keyCode == RIGHT) {   // If key is right carlin moves right

    if (carlinX < (width-SPACING)) {        // So that carlin does not go out of canvas
      carlinX += NextX(carlinY) ;   //passing to nextX for new values of carlinX
    }
  }

  if (keyCode == LEFT) {   // If key is left carlin moves Left

    if (carlinX > (SPACING)) {  // So that carlin does not go out of canvas
      carlinX -= NextX(carlinY) ;  //passing to nextX for new values of carlinX
    }
  }

  if (keyCode == UP) {   // If key is up carlin moves Up

    if (carlinY > (HALL_TOP+SPACING)) {  // So that carlin does not go out of canvas
      carlinY -=  NextY( carlinX) ;          //passing to nextY for new values of carlinY
    }
  }

  if (keyCode == DOWN ) {    // If key is down carlin moves Down
    if (carlinY < (hallBottomY-SPACING)) {  // So that carlin does not go out of canvas
      carlinY += NextY( carlinX) ;           //passing to nextY for new values of carlinY
    }
  }

  if (key == ENTER) {   // If key is enter carlin will use its megical powers to slow down the spider if it comes inside the ice
    if (!usedMagic && (carlinsMagicPowers > 0)) {  // this if statement allows carlin to only use magic one time in one level and a total of three times
      carlinsMagicPowers -= 1 ;            //Decreasing the powers left after one use
      frozenCol = carlinX - SPACING/2 ;   // The column of the ice
      frozenRow = carlinY - SPACING/2 - 5 ;   // The row of the ice
      pressed = true ;  // boolean to draw a rectangle in draw function (else it will disappear after few sec if used in keypressed)
      usedMagic = true ;  // boolean to take cares that carlin only uses magic only one time in a perticular level
    }
  }
} // keyPressed() End




int NextX(int currentY) {  //NextX (carlin) start

  if (checkObstacleX(currentY)) {  // Checks obsticles in left and right direction before giving next direction to carlin
    return SPACING ;  // if true it returns SPACING
  } else {
    return 0  ;   // else it returns 0
  }
} //NextX (carlin) End




int NextY(int currentX) {  //NextY (carlin) start
  if (checkObstacleY(currentX)) {  // Checks obsticles in upward and downward direction before giving next direction to carlin
    return SPACING ;     // if true it returns SPACING
  } else {
    return 0  ;    // else it returns 0
  }
} //NextY (carlin) End



float NextX(int currentX, int currentY, String direction, float speed) {  // nextX(spider) start
  float iNeedFloat = 0 ;  // Wanted a temporary float variable
  if (currentX - SPIDER_WIDTH > 0) {   // So that spider Does not go out of canvas
    if (checkObstacleY(currentY)) {   // Checking obsticle above and below of spider before giving nextY direction
      if (direction.equals("left")) {  // if direction is left do the below stuff
        float iNeedFloatInside = -speed ;  // negative to move left
        return iNeedFloatInside ;  // return value
      }
    }
    if (currentX + SPIDER_WIDTH < width) {    // So that spider Does not go out of canvas
      if (direction.equals("right")) {       //if direction is Right do the below stuff
        float iNeedFloatInside = speed ;
        return iNeedFloatInside ;   //  return value
      }
    }
  }

  return iNeedFloat ;   //  return value
  
}   // nextX (spider) End



float NextY(int currentX, int currentY, String direction, float speed) {    // nextY(spider) start
  float iNeedFloatY = 0;     // Wanted a temporary float variable
  if (checkObstacleY(currentX)) {      // check obsticles in y direction
    if (direction.equals("up")) {       //  if direction is up
      if (currentY>HALL_TOP + SPIDER_HEIGHT/2) {          // So that spider Does not go out of canvas
        float iNeedFloatYInside =  (SPACING- speed) ;   
        return iNeedFloatYInside ;    // Return Value
      }
    }
    if (direction.equals("down")) {
      if (currentY < hallBottomY - SPIDER_HEIGHT/2) {     // So that spider Does not go out of canvas
        float iNeedFloatYInside = speed ;  // 
        return iNeedFloatYInside ;   // Return Value
      }
    }
  }
  return iNeedFloatY ;   // Return Value
}        // nextY(spider) Ends


boolean checkObstacleY(int x) {   // checkObstacleY() Starts
  /*
  This function checks for obsticles or bricks in Upward and downWard Direction
  */
  
  
  //The condition
  if (x < SPACING || (x > 2*SPACING && x < 3*SPACING) || (x > 4*SPACING && x < 5*SPACING) || (x > 6*SPACING && x < 7*SPACING) || (x > 8*SPACING )) {

    goUPOrDown  = true ; // if the condition is meet carlin or spider can go up and down  (Return value)
  } else {

    goUPOrDown  = false ;  // Else false
  }

  return goUPOrDown ;   // Return value
}  // checkObstacleY() Ends



boolean checkObstacleX(int y) {  // checkObstacleX() Starts
  /*
  This function checks for obsticles or bricks in Upward and downWard Direction
  */
  
  //The conditon
  if ( y < HALL_TOP+ SPACING || (y > HALL_TOP + 2*SPACING && y < HALL_TOP + 3*SPACING) || (y > HALL_TOP + 4*SPACING && y < HALL_TOP + 5*SPACING) || (y > HALL_TOP + 6*SPACING && y < HALL_TOP + 7*SPACING) || (y > HALL_TOP + 8*SPACING)) {

    goRightOrLeft = true ;  // Carlin and Spider can go right and left
  } else {
    goRightOrLeft = false ;  // else false
  }

  return goRightOrLeft ;  // Return Value
  
}  // checkObstacleX() Ends

void showLevel() { // showLevel() Starts
  /*
  this function shows the level at the top
  */

  fill(255);
  textSize(30) ;
  text(level + str(levelNumber), width/2 - textWidth(level + str(levelNumber))/2, HALL_TOP/2) ;
}        // showLevel() Ends

void spiderInsideMagic() {  // spiderInsideMagic() Starts

  if (frozenCol != -1) {
    if (spiderX < frozenCol && spiderY > frozenRow  && spiderSpeed > 9) {  // if the spider comes inside the magic ice or block
      float decSpiderSpeed = 25*spiderSpeed/100.0 ;
      spiderSpeed -= decSpiderSpeed ;  // Decrease the spider speed 
      magicWidth = 0 ;    // disappears after spider touches it
    }
  }
}                // spiderInsideMagic() Ends

boolean carlinAtTheDoor() {   // carlinAtTheDoor() Starts

  if (dist(carlinX, carlinY, doorX + DOOR_WIDTH/2, DOOR_Y ) < 3*SPACING/2) {   // if carlin reaches the door increase the level
    return true ;   // Return True
  } else {
    return false ;  // Return False
  }
}       // carlinAtTheDoor() Ends

void levelUp() {    // levelUp() Starts
  boolean isLevelUp = carlinAtTheDoor() ;  // if carlin reaches the door safely open the paths for the next level
  if (isLevelUp) {    // if carlin is allowed to the next level
    levelNumber += levelUpByOne ;  // increase the level
    if (spiderSpeed < MAX_SPEED) {  // increase the speed of the speeed of spider 
      increaseSpiderSpeed = 10*spiderSpeed/100.0 ;   // increase the spider speed by 10 percent after each level
      spiderSpeed += increaseSpiderSpeed ;        // increase the spider speed by 10 percent after each level
    }
    carlinX = -1 ;   // -1 So that a random location of carlin is initialized after every new level
    spiderX = -1 ;    // -1 So that a random location of Spider is initialized after every new level
    doorX = -1 ;        // -1 So that a random location of door is initialized after every new level
    carlinY = hallBottomY - SPACING/2 ;   // Putting carlin at the bottom again after each level
    frozenCol = -1 ;    // inializing magic another time after each level
    usedMagic = false ;   // used magic to false so it can be used in different levels
  }
}   //  levelUp()  Ends 


boolean isCarlinDead() {  // isCarlinDead() Starts
/*
This Function Checks whether carlin is trapped by the spider or is Carlin dead
*/

  if (dist(carlinX, carlinY, spiderX, spiderY )<SPACING/2) {  // Carlin is trapped by the spider if the distance between the spider and calin is less than SPACING/2
    dead = true ;  // Carlin is dead  (RIP carlin)
    return dead ;  // Return Value
  } else {
    return dead ;  // Return Value
  }
} // isCarlinDead() Ends

void speedAndMagic() {  // speedAndMagic() Starts
/*
This function shows the magic left and speed of carlin below in the canvas
*/

  if (!isCarlinDead()) {
    String speedAndMagic = " Spider Speed: " + str(spiderSpeed) + "  Remained Magic: " + str(carlinsMagicPowers) ; // The Text
    textSize(25) ;
    text(speedAndMagic, width/2 - textWidth(speedAndMagic)/2, height - HALL_BOTTOM/2) ;  // The text and text Coordinates
  }
}         // speedAndMagic() Ends

void endGame() {    // endGame() starts
/*
This Function ends the game if carlin is dead
*/
  if (isCarlinDead()) {
    levelUpByOne = 0 ;
    dead = true ;
    background(0) ;   // Game Ends
    textSize(90) ;
    fill(255, 0, 0) ;   // Red color
    text(level + str(levelNumber), width/2 - textWidth(level + str(levelNumber))/2, height/2) ;  // The text and text Coordinates
    frozenCol = -1 ;
  }
}        // endGame() Ends
