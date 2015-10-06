/*
POiNG - Term Project
 **** Asheer Tanveer **** 
 **** Daniel Sosunov *** 
 */

Paddle playerPaddle;
Paddle npcPaddle;
Ball ball;

String start= "Press Spacebar To Shoot!";

int gameWindowx = 1000;
int gameWindowy = 500;

PFont font;
PFont font2; 

PImage paddle1;
PImage paddle2;
PImage pwr;
PImage frz;
PImage inc;
PImage dec;
PImage slwr;
PImage electro;
PImage playerBolt;
PImage enemyBolt;
PImage p1score;
PImage p2score;
PImage instructions;


boolean ins = false;

boolean shootE = false;
boolean shootP = false;

int powers = 1;
int freezers = 2;
int increasers = 3;
int decreasers = 4;
int slowers = 5;

float boltxP;
float boltyP;

float boltxE;
float boltyE;

boolean reverse = false;


Items power;
Items freezer;
Items increaser;
Items decreaser;
Items slower;

int playerScore = 0;
int npcScore = 0;
int positionAfter = 0;
int counter = 3;

boolean startClicked = false;
boolean startGame = false;
boolean hasFinished = true;
boolean hitSpace = false;
boolean boolOver = false;
boolean boolFreeze = false;

void setup() {
  size(gameWindowx, gameWindowy);
  instructions= loadImage("instructions.png");
  p1score = loadImage("p1score.png");
  p2score = loadImage("p2score.png");
  playerBolt = loadImage("playerBolt.png");
  enemyBolt = loadImage("enemyBolt.png");
  electro = loadImage("electro.png");
  pwr = loadImage("powershot.png"); 
  frz = loadImage("freezer.png");
  inc = loadImage("increaser.png");
  dec = loadImage("decreaser.png");
  slwr = loadImage("slower.png");
  paddle1 = loadImage("p1.png");
  paddle2 = loadImage("p2.png");
  playerPaddle = new Paddle(width-30, height/2);
  npcPaddle = new Paddle(0, height/2);
  boltxP = playerPaddle.x;
  boltyP = playerPaddle.y;
  boltxE = npcPaddle.x;
  boltyE = npcPaddle.y;
  ball = new Ball(playerPaddle.x - 10, playerPaddle.y + (playerPaddle.paddleHeight/2));
  power= new Items(random(width - 800, width - 200 ), random(40, height - 40));
  freezer = new Items(random(width - 800, width - 200 ), random(40, height - 40));
  increaser = new Items(random(width - 800, width - 200 ), npcPaddle.y);
  decreaser = new Items(random(width - 800, width - 200 ), npcPaddle.y);
  slower = new Items(random(width - 800, width - 200 ), random(40, height - 40));
  font = loadFont( "Jalane_light-48.vlw");
  font2 = loadFont("BookAntiqua-Bold-48.vlw");
}


void draw() {
  if (!startClicked) {
    mainMenu();
  }
  if (mousePressed && (pmouseX >= 300) && (pmouseX <= 700) && (pmouseY >= 400) && (pmouseY <= 500))  
    startClicked = true;

  if (startClicked) {
    if (positionAfter == 0) {
      ball.x = playerPaddle.x - 20;
      ball.y = playerPaddle.y + (playerPaddle.paddleHeight/2);
      if (key == ' ') {
        hitSpace = true;
        positionAfter = 1;
        start = "";
      }
    }


    background(250, 250, 210);
    smooth();
    textFont(font, 30); 
    fill(0);      
    image(paddle2, playerPaddle.x, playerPaddle.y, playerPaddle.paddleWidth, playerPaddle.paddleHeight); // player
    image(paddle1, npcPaddle.x, npcPaddle.y, npcPaddle.paddleWidth, npcPaddle.paddleHeight); // NPC 

    textFont(font, 60);
    fill(0, 0, 255);
    text(start, 500, 250);

    image(electro, ball.x - ball.radius, ball.y - ball.radius);

    image(p1score, 500, 0);
    image(p2score, 280, 0);
    textFont(font2, 25);  
    fill(255, 0, 0 );
    text(npcScore, 420, 30);
    fill(0, 0, 255 );
    text(playerScore, 640, 30);
    fill(0, 0, 0, 0);
    ellipse(ball.x, ball.y, 2 * ball.radius, 2 * ball.radius);
    if (hitSpace) startGame();
    if (boolFreeze) playerSlower();
    if (npcScore >= 11 || playerScore >= 11) gameOver();
    if (shootE) shootEnemy();
    if (shootP) shootPlayer();
  }

  if (key == 'R' || key == 'r' && startClicked == true) 
    resetGame();

  if (key == 'q' || key == 'Q')
    exit();
}
void shootPlayer() {
  boltxE += 60;
  image(playerBolt, boltxE, boltyE);
  if (boltyE > playerPaddle.y) {
    boltyE -= 30;
  }
  if (boltyP < playerPaddle.y) {
    boltyE += 30;
  }
}

void shootEnemy() {
  boltxP -= 60;
  image(playerBolt, boltxP, boltyP);
  if (boltyP > npcPaddle.y) {
    boltyP -= 30;
  }
  if (boltyP < npcPaddle.y) {
    boltyP += 30;
  }
}

void equalize() { //WORKS WITH ITEMLOGIC TO MAKE THE SPEED AND SIZE OF BOTH PADDLES BACK TO NORMAL, AND BOOLEAN boolFreeze 
  playerPaddle.speed = 10;
  npcPaddle.speed = 10;
  boolFreeze = false;
  playerPaddle.paddleHeight = 88;
  playerPaddle.paddleWidth  = 30;
  npcPaddle.paddleHeight = 88;
  npcPaddle.paddleWidth = 30;
  ball.xSpeed = 10;
  ball.ySpeed = 10;
}

boolean nextPoint () {
  float playerS = playerScore;
  float npcS = npcScore;
  if (npcS != npcScore || playerS != playerScore) {
    return true;
  }
  return false;
}

void printCollision(String itemName) {
  if (itemName == "decreaser") {
    if (decreaser.collisionL(ball)) println("COLLISION L");
    if (decreaser.collisionR(ball)) println("COLLISION R");
  }
  if (itemName == "freezer") {
    if (freezer.collisionL(ball)) println("COLLISION L");
    if (freezer.collisionR(ball)) println("COLLISION R");
  }
  if (itemName == "increaser") {
    if (increaser.collisionL(ball)) println("COLLISION L");
    if (increaser.collisionR(ball)) println("COLLISION R");
  }
  if (itemName == "slower") {
    if (slower.collisionL(ball)) println("COLLISION L");
    if (slower.collisionR(ball)) println("COLLISION R");
  }
  if (itemName == "power") {
    if (power.collisionL(ball)) println("COLLISION L");
    if (power.collisionR(ball)) println("COLLISION R");
  }
}


void tester(String itemName) {
  if (itemName == "increaser") {
    if ((playerScore == 2 || npcScore == 2)) {
      image(inc, increaser.x, increaser.y);
      increaser.increaser(npcPaddle, playerPaddle, ball);
      changePosition(increaser);
      fill(0, 102, 153);
      text("Increaser Activated!", 870, 30  );
    } else {
      increaser.x = 500;
      increaser.y = 250;
    }
  }
  if (itemName == "decreaser") {
    if ((playerScore == 4 || npcScore == 4)) {
      image(dec, decreaser.x, decreaser.y);
      if (decreaser.collisionL(ball)) shootE = true;
      if (decreaser.collisionR(ball)) shootP = true;
      decreaser.decreaser(npcPaddle, playerPaddle, ball);
      changePosition(decreaser);
      fill(0, 102, 153);
      text("Decreaser Activated!", 870, 30  );
    } else {
      decreaser.x = 500;
      decreaser.y = 250;
      boltxP = playerPaddle.x;
      boltyP = playerPaddle.y;
      boltxE = npcPaddle.x;
      boltyE = npcPaddle.y;
      shootE= false;
      shootP = false;
    }
  }  
  if (itemName == "freezer") {
    if ((playerScore == 10 && npcScore == 10)) {
      image(frz, freezer.x, freezer.y);
      freezer.freezer(npcPaddle, playerPaddle, ball);
      changePosition(freezer);
      fill(0, 102, 153);
      text("Freezer Activated!", 870, 30  );
    } else {
      freezer.x = 500;
      freezer.y = 250;
    }
  } 
  if (itemName == "power") {
    if ((playerScore == 5 || npcScore == 5) || (playerScore == 10 && npcScore == 10) || (playerScore == 8 || npcScore == 8)) {
      image(pwr, power.x, power.y);
      power.powerShot(ball);
      changePosition(power);
      fill(0, 102, 153);
      text("PowerShot Activated!", 870, 30  );
    } else {
      power.x = 500;
      power.y = 250;
    }
  }
  if (itemName == "slower") {
    if ((playerScore == 6 || npcScore == 6) ||  (playerScore == 9 || npcScore == 9) ) {
      image(slwr, slower.x, slower.y);
      slower.slower(npcPaddle, playerPaddle, ball);
      changePosition(slower);
      fill(0, 102, 153);
      text("Slower Activated!", 870, 30  );
    } else {
      slower.x = 500;
      slower.y = 250;
    }
  }
}  
void itemLogic() {
  tester("decreaser");
  tester("increaser");
  tester("freezer");
  tester("slower");
  tester("power");
}

float decideMovement () {
  float north = 0;
  float east = 1;
  float south = 2;
  float west = 3;

  int c = int(random(4));
  return c;
}

void changePosition(Items item) {
  float decide = decideMovement();
  if ( item.x > 100 && item.x < 800) {
    if (decide == 1)
      item.x+=20;
    if (decide == 3)
      item.x-=20;
  }
  if (item.y > 100 && item.y < 400) {
    if (decide == 2)
      item.y+=20;
    if (decide == 0)
      item.y-=20;
  }
}  


void startGame() {
  startGame = true;                               
  npcMovement(); 

  if (collisionDetected()) {
    ball.xSpeed = -ball.xSpeed;
  }  


  if (ball.bottomBall() > height)
    ball.ySpeed = -ball.ySpeed;

  if (ball.rightBall()> width) {
    ball.xSpeed = -ball.xSpeed;
    npcScore++;
    pointReset();
  }

  if (ball.leftBall() < 0) {
    ball.xSpeed = -ball.xSpeed;
    playerScore++;
    pointReset();
  }

  if (ball.topBall() < 0)
    ball.ySpeed = -ball.ySpeed;

  ball.x += ball.xSpeed; 
  ball.y += ball.ySpeed;

  itemLogic();
}

void npcMovement() {
  if (npcPaddle.y < height - npcPaddle.paddleHeight) {
    if (npcPaddle.y < ball.y) {
      npcPaddle.y += npcPaddle.speed;
    }
    if (npcPaddle.y > ball.y)
      npcPaddle.y -= npcPaddle.speed;
  } else
    if (npcPaddle.y > ball.y)
    npcPaddle.y -= npcPaddle.speed;
}    
void playerSlower() {
  if (playerPaddle.y < height-playerPaddle.paddleHeight && playerPaddle.y >= 0) {
    if (mouseY > playerPaddle.y) {
      playerPaddle.y += playerPaddle.speed;
    }
    if (mouseY < playerPaddle.y) {
      playerPaddle.y -= playerPaddle.speed;
    }
  }
  if (playerPaddle.y >= height-playerPaddle.paddleHeight) {
    playerPaddle.y -= 1;
  }
  if (playerPaddle.y <= 0) {
    playerPaddle.y += 1;
  }
}

void pointReset() {
  equalize();
  if (npcScore < playerScore) { 
    ball.x = npcPaddle.x + 40;
    ball.y = npcPaddle.y + (npcPaddle.y + npcPaddle.paddleHeight/2);
  } else if (playerScore <= npcScore) {
    ball.x = playerPaddle.x - 20;
    ball.y = playerPaddle.y + (playerPaddle.paddleHeight/2);
  }
}


void resetGame() {
  equalize();
  playerScore = 0;
  npcScore = 0;
  hitSpace = true;
  ball.x = playerPaddle.x - 20;
  ball.y = playerPaddle.y + (playerPaddle.paddleHeight/2);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (playerPaddle.y >=0)
        playerPaddle.y = playerPaddle.y - playerPaddle.paddleHeight * .4;
    } else if (keyCode == DOWN) {
      if (playerPaddle.y <= height - playerPaddle.paddleHeight)
        playerPaddle.y = playerPaddle.y + playerPaddle.paddleHeight * .4;
    }
  }
}

void mouseMoved() {
  if (startClicked) {
    if ((mouseY < height - playerPaddle.paddleHeight) && !boolFreeze)
      playerPaddle.y = mouseY;                     // Controlling PLAYER paddle via mouse
  }
}


boolean collisionDetected() {
  boolean collide = false;

  if ((ball.rightBall() > playerPaddle.x) && (ball.leftBall() <= playerPaddle.x + playerPaddle.paddleWidth)) {
    if ( (ball.topBall() <= playerPaddle.y + playerPaddle.paddleHeight) && (ball.bottomBall() >= playerPaddle.y)) {     // ball & paddle collision
      collide = true;
    }
  }

  if ( (ball.rightBall() > npcPaddle.x) && (ball.leftBall() <= npcPaddle.x + npcPaddle.paddleWidth)) {
    if ( (ball.topBall() <= npcPaddle.y + npcPaddle.paddleHeight) &&  (ball.bottomBall() >= npcPaddle.y)) {
      collide = true;
    }
  }

  return collide;
}

void mainMenu() {

  if (!ins) {
    background(160, 140, 80);
    ellipse(ball.x, ball.y, 6 * random(6, 20), 6 * random(6, 20));
    menuBall();

    textFont(font, 60);
    fill(random(0, 255), random(0, 255), random(0, 255));
    textAlign(CENTER);                                                 
    rect(300, 400, 400, 100, 7, 7, 7, 7);
    fill(0);
    text("CLICK TO START", 500, 465);
    fill(255, 255, 0);
    textFont(font, 100);
    text("POiNG", 480, 80);
    fill(255, 0, 0);
    text("Instructions", 500, 200);
  }
  if (mousePressed && (pmouseX >= 290) && (pmouseX <= 700) && (pmouseY >= 120) && (pmouseY <= 200))
    ins = true;
  if (ins) {
    background(instructions);
    if (mousePressed && (pmouseX >= 780) && (pmouseX <= width) && (pmouseY >= 0) && (pmouseY <= 80))
      ins=false;
  }
}
void gameOver() {
  PImage gameOver = loadImage("gameover.png");
  background(gameOver);
  if (mousePressed && (pmouseX >= 405) && (pmouseX <= 620) && (pmouseY >= 290) && (pmouseY <= 360)) {
    resetGame();
  }
}

void menuBall() {
  if (ball.leftBall() < 0)              // Ball effect in the menu
    ball.xSpeed = -ball.xSpeed;

  if (ball.bottomBall() > height)
    ball.ySpeed = -ball.ySpeed;

  if (ball.rightBall()> width) {
    ball.xSpeed = -ball.xSpeed;
  }
  if (ball.topBall() < 0)
    ball.ySpeed = -ball.ySpeed;

  ball.x += ball.xSpeed; 
  ball.y += ball.ySpeed;
}
