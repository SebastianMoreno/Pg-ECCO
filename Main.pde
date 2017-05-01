// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example
// Showing how to use applyForce() with box2d
import netP5.*;
import oscP5.*;
import de.voidplus.leapmotion.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
//leap-osc-pd
LeapMotion leap;
Finger finger;
Hand hand;
NetAddress direccionRemota;
OscP5 oscP5;
KeyTapGesture g;
//Mensajes OSC
OscMessage mensajedO;
OscMessage mensajeMi;
OscMessage mensajeFa;
OscMessage mensajeLa;
OscMessage mensajeSi;
OscMessage mensajeSol;
OscMessage mensajeRe;
OscMessage mensajeOcta;
OscMessage mensajeOcta2;
OscMessage mensajeCua;
OscMessage mensajeRoll;
OscMessage mensaje2;
//Herxagonos secundarios
ArrayList<Mover> hexa2;
ArrayList<Boundary> panelC;
ArrayList<Boundary_2> panelD;
//-Variables de creacion de todo el entrono grafico
String ip;
PVector pointPosition1, pointPosition2, pointPosition3, pointPosition4, pointPosition0;
PVector colEllipse = new PVector(255, 255, 255);
PVector positionHand;
//Variables de las posiciones de los dedos
float dedo1X, dedo1Y, dedo1Z;
float dedo2X, dedo2Y, dedo2Z;
float dedo3X, dedo3Y, dedo3Z;
float dedo4X, dedo4Y, dedo4Z;
float dedo0X, dedo0Y, dedo0Z;
//variables de las dinamicas de lamano
float octaF,amp,pitch;
float manoX,manoY,pruebaX, pruebaY;
float roll;
float apretar;
int apretarR;
int valorX,valorY;
int puerto,id;
int cua = 0;
double octa;
boolean finger0, finger1, finger2, finger3, finger4 = false;
boolean gestos = false;
boolean si, dO, re, mi, fa, sol, la  = false;
//-Variables que se utilizan en las funciones de control
float abf;
float abg = 100;
float cuaOSC;
float octavaGlobal;
int colorR,colorG,colorB,cuadrante,cuadrante2,pX,pY;
//-Variables que se utilizan en los gestos para gestos
float  pruebaVector,pruebaVector2,numeroActualCua,notaGlobal;
boolean booleanMaster, activo8, activo9, activo10, activo11, activo12 = false;
boolean activo, activo2, activo3, activo4, activo5, activo6, activo7=false;
// A reference to our box2d world
Box2DProcessing box2d;
void setup() {
  size(640, 480, P3D);
  smooth();
  ip = "127.0.0.1"; //-->dirección ip a donde se envían los mensajes (en este caso localhost)
  puerto = 11112;
  //inicialización del objeto
  oscP5 = new OscP5(this, puerto); 
  //Entrada: mensajes de entrada por el puerto especificado
  direccionRemota = new NetAddress(ip, puerto); 
  leap = new LeapMotion(this).allowGestures(); 
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // No global gravity force
  box2d.setGravity(0, 0);
  //Crear el arreglo
  hexa2 = new ArrayList<Mover>();
  panelC = new ArrayList<Boundary>();
  panelD = new ArrayList<Boundary_2>();
  panelC.add(new Boundary(width/2, 15, width-1, 30, 0, 255, 255, 255));
}
void draw() {
  if (gestos == false) {
  }
  //Control de circulos si se salen de los margenes de la pantalla se eliminan
  for (int i = hexa2.size()-1; i >= 0; i--) {
    Mover p = hexa2.get(i);
    p.display();
    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    if (p.done()) {
      hexa2.remove(i);
    }
  }
  //Control de circulos si hay mas de 10 se eliminan
  if (hexa2.size() > 10) {
    hexa2.remove(0);
  }
//---------COMIENZO LEAP MOTION---------
  for ( Hand hand : leap.getHands()) {
    //Gesto amplitud
    float apreta = hand.getGrabStrength();
    apretar = apreta*100;
    apretarR = round(apretar);
    //Gesto de control ROLL(Tempo)
    PVector hand_dynamics    = hand.getDynamics();
    roll = round(hand_dynamics.x);
    //Gesto de control Pitch 
    pitch = round((hand_dynamics.y/10));
    if (pitch > 5 && pitch <10 ) {
      notaGlobal= notaGlobal+ 1;
    }
    if (pitch < -1 && pitch > -10) {
      notaGlobal= notaGlobal- 1;
    }
    octa = freq(notaGlobal, octavaGlobal);
    octaF = (float)octa;
    amp = -1 + apretarR;
    //Posiciones que se utiliza para diferenciar los cuadrantes
    PVector hand_position    = hand.getPosition();
    positionHand = hand_position;
    // Posicion X Mano 
    manoX = (hand_position.x);
    pruebaX = (manoX/700);
    valorX = round(pruebaX*640);
    //Posicion Y Mano
    manoY = (hand_position.y);
    pruebaY = (manoY/400);
    valorY = round(pruebaY*480);
    for (Finger finger : hand.getFingers()) {
      // Mensajes OSC
      mensajeCua = new OscMessage("/cua"); 
      mensajeRoll = new OscMessage("/rol"); 
      mensajeRoll.add(abf);
      oscP5.send(mensajeRoll, direccionRemota);  
      mensajeOcta = new OscMessage("/octa");
      mensajeOcta.add(octaF);
      oscP5.send(mensajeOcta, direccionRemota);
      mensajeOcta2 = new OscMessage("/octa2");
      OscMessage mensaje1 = new OscMessage("/pitch");
      mensaje1.add(pitch);
      OscMessage mensaje2 = new OscMessage("/vol");
      mensaje2.add(abg);
      oscP5.send(mensaje2, direccionRemota);
      mensajeRe = new OscMessage("/re");
      mensajeRe.add(re);
      mensajeSol = new OscMessage("/sol");
      mensajeSol.add(sol);
      mensajeSi = new OscMessage("/si");
      mensajeSi.add(si);
      mensajedO = new OscMessage("/dO");
      mensajedO.add(dO);
      mensajeMi = new OscMessage("/mi");
      mensajeMi.add(mi);
      mensajeFa = new OscMessage("/fa");
      mensajeFa.add(fa);
      mensajeLa = new OscMessage("/La");
      mensajeLa.add(la);
      oscP5.send(mensaje1, direccionRemota);
      switch(finger.getType()) {
      case 0:
        finger0 = finger.isExtended();
        pointPosition0 = finger.getPositionOfJointTip();
        dedo0X = pointPosition0.x;
        dedo0Y = pointPosition0.y;
        dedo0Z = pointPosition0.z;
        break;
      case 1:
        finger1 = finger.isExtended();
        pointPosition1 = finger.getPositionOfJointTip();
        dedo1X = pointPosition1.x;
        dedo1Y = pointPosition1.y;
        dedo1Z = pointPosition1.z;
        break;
      case 2:
        finger2 = finger.isExtended();
        pointPosition2 = finger.getPositionOfJointTip();
        dedo2X = pointPosition2.x;
        dedo2Y = pointPosition2.y;
        dedo2Z = pointPosition2.z;
        break;
      case 3:
        finger3 = finger.isExtended();
        pointPosition3 = finger.getPositionOfJointTip();
        dedo3X = pointPosition3.x;
        dedo3Y = pointPosition3.y;
        dedo3Z = pointPosition3.z;
        break;
      case 4:
        finger4 = finger.isExtended();
        pointPosition4 = finger.getPositionOfJointTip();
        dedo4X = pointPosition4.x;
        dedo4Y = pointPosition4.y;
        dedo4Z = pointPosition4.z;
        break;
      }
      gestoMaestro();
      if (booleanMaster == false) {
        gestoDo( dedo0X, dedo0Z, dedo1X, dedo1Z, dedo2X, dedo3X, dedo4X);
        gestoRe(dedo0X, dedo1X);
        gestoMi( dedo0X, dedo0Z, dedo1X, dedo1Z, dedo2X, dedo3X, dedo4X);
        gestoFa(dedo1X, dedo2X);
        gestoSol(dedo1X, dedo2X);
        gestoLa(dedo0X, dedo1X);
        gestoSi();
        positionHand2();
      } else {
        gestoPaneles();
      }
    }
  }
//--------FIN LEAP MOTION----------
//-------COMIENZO INTERFAZ---------
  background(0);
  for (Boundary wall : panelC) {
    wall.display();
  }
  for (Boundary_2 wall : panelD) {
    wall.display();
  }
  panelC.add(new Boundary(width-16, 15, 30, 30, 0, colorR, colorG, colorB));
  box2d.step();
  for (Mover cs : hexa2) {
    cs.display();
  }
  for (Boundary_2 gf : panelD) {
    gf.display();
  }
  accionCuadrante();
  textSize(25);
  fill(255);
  text(abg+"%", 520, 25);
  textSize(25);
  fill(255);
  text(abf+"bpm", 20, 25);
  colorCua();
}//--- End Draw
//---------FIN INTERFAZ-------------
//--------COMIENZO METODOS----------

//--Metodos dedicados a funciones de control del software
//Metodo dedicado a la posicion de la mano y la creacion de los cuadrantes principales
void positionHand() {
  pX = valorX;
  pY = valorY;
  if (pX >= 100 && pX <= 540 && pY >= 101 && pY <= 350) {
    cuadrante = 1;
  } else if (pX >= 0 && pX < 213 && pY >= 350 && pY < 450) {
    cuadrante = 2;
  } else if (pX >= 214 && pX < 427 && pY >= 350 && pY < 450) {
    cuadrante = 3;
  } else if (pX >= 428 && pX < 640 && pY >= 350 && pY < 450) {
    cuadrante = 4;
  } else if (pX >= 0 && pX <= 100 && pY >= 101 && pY <= 350) {
    cuadrante = 5;
  } else if (pX >= 351 && pX <= 640 && pY >= 101 && pY <= 350) {
    cuadrante = 6;
  }
}
//Metodo dedicado ala posicion de la mano y la creacion de los cuadrantes verticales 
void positionHand2() {
  pY = valorY;
  if (pY <160 && pY > 0) {
    cuadrante2 = 1;
  } else if (pY >160 && pY < 320) {
    cuadrante2 = 2;
  } else if (pY >320 && pY < width) {
    cuadrante2 = 3;
  }
}
//Se le asgina acciones a los cuadrantes con respecto a la posicion de la mano
void accionCuadrante() {
  positionHand();
  if (cuadrante == 5) {
    textoTempo();
    textSize(25);
    fill(255);
    text(abf+"bpm", 20, 25);
  }
  if (cuadrante == 6) {
    textoAmplitud();
    textSize(25);
    fill(255);
    text(abg+"%", 520, 25);
  }
  if (cuadrante2 == 1) {
    octavaGlobal = 5;
  }
  if (cuadrante2 == 2) {
    octavaGlobal = 4;
  }
  if (cuadrante2 == 3) {
    octavaGlobal = 3;
  }
}
// Tempo
void textoTempo() {
  abf = roll;
}
// Amplitud
void textoAmplitud() {
  abg= apretarR;
}
// Color representativo para los cuadrantes
void colorCua() {
  if (cuadrante == 1) {
    colorR = 255;
    colorG = 0;
    colorB = 0;
  } else if (cuadrante == 2) {
    colorR = 0;
    colorG = 255;
    colorB = 0;
  } else if (cuadrante == 3) {
    colorR = 0;
    colorG = 255;
    colorB = 255;
  } else if (cuadrante == 4) {
    colorR = 255;
    colorG = 0;
    colorB = 255;
  } else if (cuadrante == 5) {
    colorR = 200;
    colorG = 150;
    colorB = 100;
  } else {
    colorR = 255;
    colorG = 100;
    colorB = 50;
  }
}
//-- Metodos dedicados a los gestos
//Gesto Do 
void gestoDo(float dedo0XP, float dedo0ZP, float dedo1XP, float dedo1ZP, float dedo2XP, float dedo3XP, float dedo4XP) {
  float prueba3, prueba4;
  prueba3 = dedo1XP - dedo0XP;
  prueba4 = dedo1ZP - dedo0ZP;    
  boolean pI = false; 
  if (finger0 == true && finger1 == true && finger2 == false && finger3 == false && finger4 == false ) {
    pI= true;
  } else {
    pI = false;
  }    
  if ( prueba3 <15 && prueba4 >=15 && pI == true) {
    dO = true;
    oscP5.send(mensajedO, direccionRemota);
    println("Gesto letra C ºº nota DO");
    if (!activo) {
      notaGlobal = 1;
      colEllipse = new PVector(218, 218, 218);
      gestos = true;
      Mover cs = new Mover(positionHand.x, positionHand.y, 20, colEllipse);
      hexa2.add(cs);
      activo=true;
    }
  } else {
    gestos = false;
    activo=false;
  }
}
//Gesto Re
void gestoRe (float thumb_x, float indx_x) {
  float tx = thumb_x;
  float ix = indx_x;
  boolean pIC = false ;
  if (finger0 == true && finger1 == true && finger2 == false && finger3 == false && finger4 == false) {
    pIC = true;
  } else {
    pIC = false;
  }
  if (tx < ix && pIC == true) {
    println("Gesto letra L ºº nota re");
    //println(notaGlobal);
    re = true;
    oscP5.send(mensajeRe, direccionRemota);
    if (!activo2) { 
      colEllipse = new PVector(249, 247, 0);
      gestos = true;
      Mover cs = new Mover(positionHand.x, positionHand.y, 20, colEllipse);
      hexa2.add(cs);    
      activo2=true; 
      notaGlobal = 3;
    }
  } else {
    gestos = false;
    activo2 = false;
    // re = 2;
  }
}
//Gesto Mi 
void gestoMi(float dedo0XP, float dedo0ZP, float dedo1XP, float dedo1ZP, float dedo2XP, float dedo3XP, float dedo4XP) {
  float gesto3R1, gesto3R2, gesto3R3, gesto3R4;
  gesto3R1 = dedo0XP - dedo1XP;
  gesto3R2 = dedo0XP - dedo2XP;
  gesto3R3 = dedo4XP - dedo3XP;
  gesto3R4 = dedo1ZP  - dedo0ZP;
  boolean idx ;
  if (finger0 == false && finger1 == true && finger2 == false && finger3 == false && finger4 == false) {
    idx = true;
  } else {
    idx = false;
  }
  if (gesto3R1<60 && gesto3R2<50 && gesto3R3<50 && gesto3R4<20 && idx == true) {
    println("Gesto letra D ºº nota MI");
    mi = true;
    oscP5.send(mensajeMi, direccionRemota);
    if (!activo3) { 
      colEllipse = new PVector(19, 30, 255);
      gestos = true;
      Mover cs = new Mover(positionHand.x, positionHand.y, 20, colEllipse);
      hexa2.add(cs);
      activo3=true; 
      notaGlobal = 5;
    }
  } else {
    activo3 = false;
    gestos = false;
  }
}
//Gesto FA
void gestoFa(float dedo1XP, float dedo2XP) {
  boolean iCfa = false;
  if (finger0 == false && finger1 == true && finger2 == true && finger3 == false && finger4 == false) {
    iCfa = true;
  } else {
    iCfa = false;
  }
  if (dedo2XP > dedo1XP &&iCfa == true) {  
    fa = true;
    oscP5.send(mensajeFa, direccionRemota);
    println("Gesto letra H ºº nota FA"); 
    if (!activo4) { 
      colEllipse = new PVector(52, 157, 47);
      gestos = true;
      Mover cs = new Mover(positionHand.x, positionHand.y, 20, colEllipse);
      hexa2.add(cs);
      activo4 = true; 
      notaGlobal = 6;
    }
  } else {
    activo4 = false;
    gestos = false;
  }
}
//Gesto Sol
void gestoSol(float dedo1XP, float dedo2XP) {
  boolean iC = false;
  if (finger0 == false && finger1 == true && finger2 == true && finger3 == false && finger4 == false) {
    iC = true;
  } else {
    iC = false;
  }
  if (dedo2XP < dedo1XP && iC== true) {
    gestos = true;
    println("Gesto letra R ºº nota SOL");
    sol = true;
    oscP5.send(mensajeSol, direccionRemota);
    if (!activo5) { 
      colEllipse = new PVector(164, 88, 28);
      gestos = true;
      Mover cs = new Mover(positionHand.x, positionHand.y, 20, colEllipse);
      hexa2.add(cs);
      activo5 = true; 
      notaGlobal = 8;
    }
  } else {
    activo5 = false;
    gestos = false;
  }
}
//Gesto La
void gestoLa(float dedo0XP, float dedo1XP) {
  boolean cAM = false;
  if (finger0 == false && finger1 == false && finger2 == true && finger3 == true && finger4 == true) {
    cAM = true;
  } else {
    cAM = false;
  }
  if (dedo0XP > dedo1XP && cAM == true) {
    println("Gesto letra T ºº nota LA");
    la = true;
    oscP5.send(mensajeLa, direccionRemota);
    if (!activo6) { 
      colEllipse = new PVector(204, 112, 231);
      gestos = true;
      Mover cs = new Mover(positionHand.x, positionHand.y, 20, colEllipse);
      hexa2.add(cs);
      activo6 = true; 
      notaGlobal = 10;
    }
  } else {
    activo6 = false;
    gestos = false;
  }
}
// Gesto Si
void gestoSi() {
  boolean iCAM = false;
  if (finger0 == false && finger1 == true && finger2 == true && finger3 == true && finger4 == true) {
    iCAM = true;
  } else {
    iCAM = false;
  }
  if (iCAM == true) {
    si = true;
    oscP5.send(mensajeSi, direccionRemota);
    println("Gesto letra B ºº nota SI");
    if (!activo7) { 
      colEllipse = new PVector(38, 89, 132);
      gestos = true;
      Mover cs = new Mover(positionHand.x, positionHand.y, 20, colEllipse);
      hexa2.add(cs);
      activo7 = true; 
      notaGlobal = 12;
    }
  } else {
    gestos = false;
    activo7 = false;
  }
}
void gestoMaestro() {
  boolean allFingers = false;
  if (finger0 == true && finger1 == true && finger2 == true && finger3 == true && finger4 == true) {    
    allFingers = true;
  } else {
    allFingers = false;
  }
  if (allFingers == true) {
    booleanMaster = true;
  } else {
    booleanMaster = false;
  }
}
void gestoPaneles() {
  if (booleanMaster == true && cuadrante == 5) {
    if (panelD.size() == 2) {
      Boundary_2 a = panelD.get(0);
      a.killBody();
      panelD.remove(0);
    }
    if (!activo8) {
      Boundary_2 gf = new Boundary_2(50, 257, 100, 250, 0, 0, 255, 255, valorX, valorY);
      panelD.add(gf);
      activo8=true;
    }
  } else {
    activo8=false;
  }
  if (booleanMaster == true && cuadrante == 6) {
    if (panelD.size() == 2) {
      Boundary_2 a = panelD.get(0);
      a.killBody();
      panelD.remove(0);
    }
    if (!activo9) {
      Boundary_2 gf = new Boundary_2(590, 257, 100, 250, 0, 0, 255, 255, valorX, valorY);
      panelD.add(gf);
      activo9=true;
    }
  } else {
    activo9=false;
  } 
  if (booleanMaster == true && cuadrante == 2) {
    numeroActualCua = octaF;
    cuaOSC = 0;
    if (panelD.size() == 2) {
      Boundary_2 a = panelD.get(0);
      a.killBody();
      panelD.remove(0);
    }
    if (!activo10) {
      mensajeOcta2.add(numeroActualCua);
      oscP5.send(mensajeOcta2, direccionRemota);
      mensajeCua.add(cuaOSC);
      oscP5.send(mensajeCua, direccionRemota);  
      Boundary_2 af = new Boundary_2(108, 430, 214, 100, 0, 255, 255, 100, valorX, valorY);
      panelD.add(af);
      activo10=true;
    }
  } else {
    activo10=false;
  }
  if (booleanMaster == true && cuadrante == 3) {
    numeroActualCua = octaF;    
    cuaOSC = 1;
    if (panelD.size() == 2) {
      Boundary_2 a = panelD.get(0);
      a.killBody();
      panelD.remove(0);
    }
    if (!activo11) {
      mensajeOcta2.add(numeroActualCua);
      oscP5.send(mensajeOcta2, direccionRemota);
      mensajeCua.add(cuaOSC);
      oscP5.send(mensajeCua, direccionRemota);  
      Boundary_2 as = new Boundary_2(321, 430, 214, 100, 0, 255, 100, 255, valorX, valorY);
      panelD.add(as);
      activo11=true;
    }
  } else {
    activo11=false;
  }
  if (booleanMaster == true && cuadrante == 4) {
    numeroActualCua = octaF;   
    cuaOSC = 2;
    if (panelD.size() == 2) {
      Boundary_2 a = panelD.get(0);
      a.killBody();
      panelD.remove(0);
    }
    if (!activo12) {
      mensajeOcta2.add(numeroActualCua);
      oscP5.send(mensajeOcta2, direccionRemota);
      mensajeCua.add(cuaOSC);
      oscP5.send(mensajeCua, direccionRemota); 
      Boundary_2 ad = new Boundary_2(534, 430, 214, 100, 0, 0, 255, 255, valorX, valorY);
      panelD.add(ad);
      activo12=true;
    }
  } else {
    activo12=false;
  }
  if (booleanMaster == true && cuadrante == 1 && panelD.size() == 1) {
    Boundary_2 a = panelD.get(0);
    a.killBody();
    panelD.remove(0);
  }
}
//Metodo que altera la octava co respecto al cuadrante de la mano
double freq(float nota, float octava) {
  return 440.0*Math.exp(((octava-4)+(nota-10)/12.0)*Math.log(2.0));
}
//--------------FIN METODOS------------