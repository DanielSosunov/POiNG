class Paddle {

  float x;    // x pos of paddle
  float y;    // y pos of paddle

  float paddleHeight = 88;    
  float paddleWidth = 30;

  float speed = 10;

  Paddle(float padX, float padY) { // constructor for assigning paddle positions
    x = padX;
    y = padY;
  }
}

