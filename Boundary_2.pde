// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// Box2DProcessing example

// A fixed boundary class (now incorporates angle)

class Boundary_2 {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  int r;
  int g;
  int bl , posX , posY;

  // But we also have to make a body for box2d to know about it
  Body b;

 Boundary_2(float x_,float y_, float w_, float h_, float a, int r_, int g_, int bl_,int posX_,int posY_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    r = r_;
    g = g_;
    bl = bl_;
    posX = posX_;
    posY = posY_;
    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.angle = a;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
  }
  
  void killBody() {
    box2d.destroyBody(b);
  }
      boolean done() {
        
    // Let's find the screen position of the particle
    // Is it off the bottom of the screen?
    
   
    if (posX  >= 351 && posX <= 640 &&  posY >= 101 && posY <= 350 ) {
      killBody();
      return true;
    }
    return false;
  }

  // Draw the boundary, it doesn't move so we don't have to ask the Body for location
  void display() {
    fill(r,g,bl,50);
    noStroke();
    rectMode(CENTER);
    float a = b.getAngle();
    pushMatrix();
    translate(x,y);
    rotate(-a);
    rect(0,0,w,h);
    popMatrix();
  }

}