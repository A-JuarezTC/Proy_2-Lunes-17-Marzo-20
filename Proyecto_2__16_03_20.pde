import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing mundo;
Limite suelo;
LaGarra garra;
ArrayList<Limite>paredes;
ArrayList<Crear>pisos;

void setup() {
  size(400,400);
  smooth();
  
  mundo = new Box2DProcessing(this);
  mundo.createWorld();
  mundo.setGravity(0, -30);
  garra = new LaGarra();
  suelo = new Limite(200,370,400,60);
  paredes = new ArrayList<Limite>();
  paredes.add(new Limite(0,140,1,500));
  paredes.add(new Limite(400,140,1,500));
  pisos = new ArrayList<Crear>();
  pisos.add(new Crear()); //p1
  pisos.add(new Crear()); //p2
  pisos.add(new Crear()); //p3
  pisos.add(new Crear()); //p4
  pisos.add(new Crear()); //p5
  pisos.add(new Crear()); //p6
  pisos.add(new Crear()); //p7
  pisos.add(new Crear()); //p8
}

void draw() {
  background(255);
  mundo.step();
  fill(0);
  text("Tome caja con un click\nY mueva dejando presionado el botón",30,40);
  textSize(10);
  suelo.display();
  garra.update(mouseX,mouseY);
  for(Crear boxes : pisos){
  boxes.display();
  }
}

void mouseReleased() {
  garra.desligar();
}

void mousePressed() {
   for(Crear boxes : pisos){
  boxes.tomar();
  }
}

class Caja {
  float w;
  float h;
  Body b;

  Caja(float x_, float y_) {
    float x = x_;
    float y = y_;
    w = 40;
    h = 20;
    cuerpoCaja(new Vec2(x,y),w,h);
  }

  boolean area(float x, float y) {
    Vec2 worldPoint = mundo.coordPixelsToWorld(x, y);
    Fixture f = b.getFixtureList();
    boolean area = f.testPoint(worldPoint);
    return area;
  }

  void cuerpoCaja(Vec2 center, float w_, float h_) {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(mundo.coordPixelsToWorld(center));
    
    b = mundo.createBody(bd);
    b.setLinearVelocity(new Vec2(0,0));
    b.setAngularVelocity(0);

    PolygonShape sd = new PolygonShape();
    float box2dW = mundo.scalarPixelsToWorld(w_/2);
    float box2dH = mundo.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.friction = .5;
    fd.density = 1;
    fd.restitution = .1;
    b.createFixture(fd);
  }
  
  void display() {
    Vec2 pos = mundo.getBodyPixelCoord(b);
    float angulo = b.getAngle();
    pushMatrix();
      translate(pos.x,pos.y);
      rotate(-angulo); //SE VE MUY POCO NATURAL SIN LA ROTACIÓN, AHHHHHHHHHHHHHH
      rectMode(CENTER);
      fill(#F2e07A);
      stroke(#E3B160);
      rect(0,0,w,h);
    popMatrix();
  }
}

class LaGarra {
  MouseJoint mouseJoint;
  
  LaGarra() {
    mouseJoint = null;
  }

  void update(float x, float y) {
    if (mouseJoint != null) {
      Vec2 mouseWorld = mundo.coordPixelsToWorld(x,y);
      mouseJoint.setTarget(mouseWorld);
    }
  }

  void ligar(float x, float y, Caja box) {
    MouseJointDef md = new MouseJointDef();
    md.bodyA = mundo.getGroundBody();
    md.bodyB = box.b;
    Vec2 mp = mundo.coordPixelsToWorld(x,y);
    md.target.set(mp);
    md.maxForce = 1000*box.b.m_mass;
    mouseJoint = (MouseJoint) mundo.world.createJoint(md);
  }

  void desligar() {
    if (mouseJoint != null) {
      mundo.world.destroyJoint(mouseJoint);
      mouseJoint = null;
    }
  }
}

class Crear{
  Caja box;
  Caja box2;
  Caja box3;
  Caja box4;
  Caja box5;
  Caja box6;
 
 Crear(){
  box = new Caja(120,329);
  box2 = new Caja(160,329);
  box3 = new Caja(200,329);
  box4 = new Caja(240,329);
  box5 = new Caja(280,329);
 }
 
 void display(){
  box.display();
  box2.display();
  box3.display();
  box4.display();
  box5.display();
 }
 
 void tomar(){
     if (box.area(mouseX, mouseY)) {
    garra.ligar(mouseX,mouseY, box);
  }
  
  if (box2.area(mouseX, mouseY)) {
    garra.ligar(mouseX,mouseY, box2);
  }
  
  if (box3.area(mouseX, mouseY)) {
    garra.ligar(mouseX,mouseY, box3);
  }
  
  if (box4.area(mouseX, mouseY)) {
    garra.ligar(mouseX,mouseY, box4);
  }
  
  if (box5.area(mouseX, mouseY)) {
    garra.ligar(mouseX,mouseY, box5);
  }
}  
}

class Limite{
  float x,y;
  float w;
  float h;
  Body b;
  
  Limite( float x_, float y_, float w_, float h_){
    w = w_;
    h = h_;
    x = x_;
    y = y_;

    BodyDef bd = new BodyDef();
    Vec2 posicionInicial = new Vec2(x_,y_);
    Vec2 posicionEnMundo = mundo.coordPixelsToWorld(posicionInicial);
    bd.position.set(posicionEnMundo);
    bd.type = BodyType.STATIC; 

    b = mundo.createBody(bd);
    b.setLinearVelocity(new Vec2(0,0));
    b.setAngularVelocity(0);
    
    PolygonShape ps = new PolygonShape();
    float ancho = mundo.scalarPixelsToWorld(w_);
    float alto = mundo.scalarPixelsToWorld(h_);
    ps.setAsBox(ancho/2,alto/2);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    fd.friction = .5;
    fd.restitution = 0.4;
    fd.density = 1;
    
    b.createFixture(fd);
  }
  
  void display(){    
    pushMatrix();
      translate(x,y);
      rectMode(CENTER);
      noStroke();
      fill(150);
      rect(0,0,w,h);
    popMatrix();
  }
}
