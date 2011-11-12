    void setup() {
      size(200, 200);
      background(125,124,223);
      fill(255);
      noLoop();
      PFont fontA = loadFont("courier");
      textFont(fontA, 14);
    }

    void draw() {
      text("Hello Web!", 20, 20);
      println("Hello Error Log!");
    }


