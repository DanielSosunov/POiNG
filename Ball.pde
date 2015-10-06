class Ball {  							 

  float x ;
  float y;
  float radius = 10;
  float xSpeed = 10;  
  float ySpeed = 10;

  Ball(float ballx, float bally) {
    x = ballx;
    y = bally;
  }

  float topBall() {
    return y - radius;
  }

  float bottomBall() {
    return y + radius;
  }

  float leftBall() {
    return x - radius;
  }

  float rightBall() {
    return x + radius;
  }
}
