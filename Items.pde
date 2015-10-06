class Items {

  float x;
  float y;

  Items(float _x, float _y) {
    x = _x;
    y = _y;
  }

  float right() {
    return x + 40;
  }

  float left() {
    return x;
  }

  float top() {
    return y;
  }

  float bottom() {
    return y+40;
  }

  float yHalf() {
    return y+20;
  }


  void powerShot(Ball ball) {
    if (collisionL(ball)) {
      ball.xSpeed -= 30;
      ball.ySpeed += 30;
      dip();
    } else if (collisionR(ball)) {
      ball.xSpeed += 30;
      ball.ySpeed -= 30;
     dip();
    }
  }

  void freezer(Paddle npcPaddle, Paddle playerPaddle, Ball ball) {
    float npc = npcScore;
    float player = playerScore;
    if (collisionR(ball)) {
      dip();
      npcPaddle.speed = 0;
      playerPaddle.speed = 0;
      boolFreeze = true;
    } else if (collisionL(ball)) {
      dip();
      playerPaddle.speed = 0;
      npcPaddle.speed = 0;
      boolFreeze = true;
    }
  }

  void increaser(Paddle npcPaddle, Paddle playerPaddle, Ball ball) {
    collision(ball);
    if (collisionL(ball)) {
      dip();
      playerPaddle.paddleHeight*=2;
    } else if (collisionR(ball)) {
      dip();
      npcPaddle.paddleHeight*=2;
    }
  }

  void decreaser(Paddle npcPaddle, Paddle playerPaddle, Ball ball) {
    if (collisionL(ball)) {
      npcPaddle.paddleHeight -= 20;
      dip();
    } else if (collisionR(ball)) {
      playerPaddle.paddleHeight -=20; 
      dip();
    }
  }

  void slower(Paddle npcPaddle, Paddle playerPaddle, Ball ball) {
    if (collisionL(ball)) {
      dip();
      npcPaddle.speed *= 0.5;
    } else if (collisionR(ball)) {
      dip();
      playerPaddle.speed *= 0.5;
      boolFreeze = true;
    }
  }

  boolean collision(Ball ball) {
    float midx = x + 20;
    float midy = y + 20;
    float distance= dist(midx, midy, ball.x, ball.y);
    if (distance <= 40) return true;
    return false;
  }  


  boolean collisionL(Ball ball) {
    float midx = x + 20;
    if (collision(ball)) {
      if (midx < ball.x) return true;
    }
    return false;
  }

  boolean collisionR(Ball ball) {
    float midx = x + 20;
    if (collision(ball)) {
      if (midx > ball.x) return true;
    }
    return false;
  }

  void dip() {
    x += width + 100;
  }
}

