import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Timer; 
import java.util.TimerTask; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Pong extends PApplet {

/*
Unique Pong - Term Project
 **** Asheer Tanveer **** 
 **** Daniel Sosunov *** 
 */



final Timer t = new Timer();

Paddle playerPaddle;
Paddle npcPaddle;
Ball ball;

int gameWindowx = 1000;
int gameWindowy = 500;

String start = "Press SpaceBar to START!";
String displayed = "";

PFont font;
PFont font2; 

PImage paddle1;
PImage paddle2;
PImage pwr;
PImage frz;
PImage inc;
PImage dec;
PImage slwr;

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

public void setup() {
  size(gameWindowx, gameWindowy);
 
  paddle1 = loadImage("p1.png");
  paddle2 = loadImage("p2.png");
  pwr = loadImage("powershot.png");
  frz = loadImage("freezer.png");
  inc = loadImage("increaser.png");
  dec = loadImage("decreaser.png");
  slwr = loadImage("slower.png");
  
  playerPaddle = new Paddle(width-40, height/2);
  ball = new Ball(playerPaddle.x - 10, playerPaddle.y + (playerPaddle.paddleHeight/2));
  npcPaddle = new Paddle(0, height/2);
  power= new Items(random(width - 800, width - 200 ),random(40 , height - 40));
  freezer = new Items(random(width - 800, width - 200 ),random(40 , height - 40));
  increaser = new Items(random(width - 800, width - 200 ),random(40 , height - 40));
  decreaser = new Items(random(width - 800, width - 200 ),random(40 , height - 40));
  slower = new Items(random(width - 800, width - 200 ),random(40 , height - 40));
  font = loadFont( "Jalane_light-48.vlw");
  font2 = loadFont("BookAntiqua-Bold-48.vlw");
}

public void draw() {

     if(!startClicked) {
      mainMenu();
      }
     if (mousePressed && (pmouseX >= 300) && (pmouseX <= 700) && (pmouseY >= 400) && (pmouseY <= 500))  
       startClicked = true;

       if(startClicked) {
       
       if(positionAfter == 0)  {
         ball.x = playerPaddle.x - 10;
         ball.y = playerPaddle.y + (playerPaddle.paddleHeight/2);
         if(key == ' '){
           hitSpace = true;
           positionAfter = 1;
         }
       }
       

       background(250, 250, 210);
       smooth();
       textFont(font, 30); 
       fill(0);      
       // text ( start, width/2, 400);
    
      image(pwr,power.x,power.y);
      image(inc,increaser.x,increaser.y);
      image(dec,decreaser.x, decreaser.y);         // ALL ITEMS
      image(frz, freezer.x, freezer.y);
      image(slwr,slower.x,slower.y);

      paddle2.resize(100, 100);
      image(paddle2, playerPaddle.x, playerPaddle.y, playerPaddle.paddleWidth, playerPaddle.paddleHeight); // player

      paddle1.resize(100, 100);
      image(paddle1, npcPaddle.x, npcPaddle.y, npcPaddle.paddleWidth, npcPaddle.paddleHeight); // NPC 

  
      textFont(font2, 25);  
      fill(255,0,0 );
      text("Computer Score: " + npcScore, 400, 25);
      fill(0,0,255 );
      text("Player Score: " + playerScore, 620, 25);
      fill(0, 102, 153);
      ellipse(ball.x, ball.y, 2 * ball.radius, 2 * ball.radius);
      
      if(hitSpace) startGame();
      //countDown();
      }

   if (key == ' ')
       start = displayed;
   if (key == 'R' || key == 'r' && startClicked == true) 
       resetGame();
  
   if (key == 'q' || key == 'Q')
        exit();
}

/*
void countDown() {
  if (hasFinished) {
    counter = 3;
    final float waitTime = 6;
    createScheduleTimer(waitTime);
 
    println("\n\nTimer scheduled for "
      + nf(waitTime, 0, 2) + " secs.\n");
  }
 
  if (frameCount % 60 == 0)
    if (counter>0) {
      fill(0);
      textFont(font,400);
      text(counter,width/2, height/2);
      counter = counter - 1;
      print(counter);
    }

    if(counter == 0){
       textFont(font,400);
       text("GO!", width/2, height/2);
      counter = -1;       
    }

    if(counter == -1)                                               // TIMER for starting game, 3, 2, 1 !
        startGame();
}
*/
 
public void createScheduleTimer(float sec) {
   hasFinished = false;
 
  t.schedule(new TimerTask() {
    public void run() {
    }
  }
  , (long) (sec*1e3f));
} 

public void startGame() {
    startGame = true;
    //power.powerShot(ball);                                        // BALL MOVEMENTS
    npcMovement(); 

    if (collisionDetected()) {
      println("Collision");
      ball.xSpeed = -ball.xSpeed;
    }  

    if (ball.leftBall() < 0)
      ball.xSpeed = -ball.xSpeed;

    if (ball.bottomBall() > height)
      ball.ySpeed = -ball.ySpeed;

    if (ball.rightBall()> width) {
      ball.xSpeed = -ball.xSpeed;
      npcScore++;
    }

    if (ball.leftBall() < 0) {
      playerScore++;
    }

    if (ball.topBall() < 0)
      ball.ySpeed = -ball.ySpeed;

    ball.x += ball.xSpeed; 
    ball.y += ball.ySpeed;
  
}

public void npcMovement() {
  if(npcPaddle.y < height - 80){
    if (npcPaddle.y < ball.y) {
      npcPaddle.y += npcPaddle.speed;
    }
    if (npcPaddle.y > ball.y)
      npcPaddle.y -= npcPaddle.speed;
  }
  else
    if (npcPaddle.y > ball.y)
      npcPaddle.y -= npcPaddle.speed;  
}

public void resetGame() {
  
  fill(0, 102, 153);
  playerScore = 0;
  npcScore = 0;

  textFont(font, 25);   
  textFont(font2, 25);  
  fill(255,0,0 );
  text("Computer Score: " + npcScore, 400, 25);
  text("Player Score: " + playerScore, 620, 25);   
  textFont(font, 30); 
  fill(0);
  start = "Press SpaceBar to START!";
  text ( start, width/2, 400);                                // RESET PLAYING FIELD

  ball.x = playerPaddle.x - 10;
  ball.y = playerPaddle.y;
  ball.radius = 10;
  ball.xSpeed = random(4, 12);  
  ball.ySpeed = random(4, 10);

  playerPaddle.y = 15 + (playerPaddle.paddleHeight/2);
  playerPaddle.x = width - 80;
  npcPaddle.x = gameWindowx - width + 35;
  npcPaddle.y = 20;
  npcPaddle.paddleHeight = 80;

  ellipse(ball.x, ball.y, 2 * ball.radius, 2 * ball.radius);
}

public void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (playerPaddle.y >=0)
        playerPaddle.y = playerPaddle.y - playerPaddle.paddleHeight * .4f;
    }
    else if (keyCode == DOWN) {
      if (playerPaddle.y <= height - playerPaddle.paddleHeight)
        playerPaddle.y = playerPaddle.y + playerPaddle.paddleHeight * .4f;
    }
  }
}

public void mouseMoved() {
  if(startClicked) {
   if(mouseY < height - 80)
      playerPaddle.y = mouseY;                     // Controlling PLAYER paddle via mouse
  }
}


public boolean collisionDetected() {
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

public void mainMenu() {
  println(pmouseX + " " + pmouseY);
  
  background(160,140,80);
  ellipse(ball.x, ball.y, 6 * random(6,20), 6 * random(6,20));
  menuBall();

  textFont(font,60);
  fill(random(0,255), random(0,255), random(0,255));
  textAlign(CENTER);                                                 // Main Menu
  rect(300,400,400,100,7,7,7,7);
  fill(0);
  text("CLICK TO START", 500, 465);
  fill(255,0,0);
  textFont(font,100);
  text("UNIQUE PONG", 480,80);
}

public void menuBall() {
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
class Ball {  							 // We'll change "Ball" to whatever we make it

    float x;
	float y;
	float radius = 10;
	float xSpeed = random(6, 12);  
	float ySpeed = random(6, 12);
    
    Ball(float ballx, float bally){
    	x = ballx;
    	y = bally;
    }

     public float topBall() {
  	 	return y - radius;
	}

	 public float bottomBall() {
     	return y + radius;
     }

	 public float leftBall() {
     	return x - radius;
	}

	public float rightBall() {
  		return x + radius;
	}
}
class Items {

  float x;
  float y;
   
  Items(float _x, float _y) {
    x = _x;
    y = _y;
  }

  public void powerShot(Ball ball){
  	if((ball.x + ball.radius >= x && ball.x + + ball.radius < x + 40) && (ball.y+ + ball.radius >= y && ball.y + ball.radius < y+40)){
     ball.xSpeed+=30;
     ball.ySpeed+=30;
    }
  }

  public void freezer(Paddle npcPaddle) {
    
   npcPaddle.speed = 0;

  }

  public void increaser() {


  }

  public void decreaser() {


    
  }

  public void slower() {


    
  }
}

class Paddle {
 
	float x;    // x pos of paddle
	float y;    // y pos of paddle

	float paddleHeight = 80;    
	float paddleWidth = 40;

 float speed = 10;

 
	Paddle(float padX, float padY) { // constructor for assigning paddle positions
 		x = padX;
 		y = padY;

	}

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Pong" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
