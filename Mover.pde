// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Showing how to use applyForce() with box2d
class Mover {
  // We need to keep track of a Body and a radius
  Body body;
  float r;
  PVector col;
  Mover( float x, float y, float r_, PVector col_) {
    col = col_;
    r = r_;
    makeBody(new Vec2(x, y), r);
  }
  void killBody() {
    box2d.destroyBody(body);
  }
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2 || pos.x > width+r*2 || pos.x < 0-r*2 ) {
      killBody();
      return true;
    }
    return false;
  }
  void applyForce(Vec2 v) {
    body.applyForce(v, body.getWorldCenter());
  }
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    //Fixture f = body.getFixtureList();
    //  PolygonShape ps = (PolygonShape) f.getShape();
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    float rcol = col.x;
    float gcol = col.y;
    float bcol = col.z;
    fill(rcol, gcol, bcol);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, r*2, r*2);
    // Let's add a line so we can see the rotation
    //line(0,0,r,0);
    popMatrix();
  }
  void makeBody(Vec2 center, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    // Set its position
    bd.position = box2d.coordPixelsToWorld(center);
    body = box2d.world.createBody(bd);
    // PolygonShape sd = new PolygonShape();
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;
    body.createFixture(fd);
    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(-5, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}