/* --------------------------------------------------------------------------
 * Wayang Motion
 * Toxiclibs + Kinect Puppetry
 * Based on SimpleOpenNI User Test by Max Rhener
 * and Nature of Code toxiclibs examples by Daniel Shiffman
 * --------------------------------------------------------------------------
 * by http://antoni.us
 * date:  6/5/2014 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;

import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;

// refer physics world
VerletPhysics2D physics;

// create arraylist of papos
ArrayList<Papo> papos;

int numPapos = 0;

PImage bg, eyetipi;

float perlin, perlin2, counter = 0;

boolean debug = false;

SimpleOpenNI  context;
color[]       userClr = new color[] { 
  color(255, 0, 0), 
  color(0, 255, 0), 
  color(0, 0, 255), 
  color(255, 255, 0), 
  color(255, 0, 255), 
  color(0, 255, 255)
};

// center of mass

PVector com = new PVector();                                   
PVector com2d = new PVector();                                   

void setup()
{
  size(displayWidth, displayHeight);
  
  bg = loadImage("fire.jpg");
  eyetipi = loadImage("eyetipi.png");

  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }
  
  // turn on mirror
  context.setMirror(true);

  // enable depthMap generation 
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();
  
  // no cursor
  noCursor();

  // initialize the physics world
  physics = new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.5)));  
  Vec2D center = new Vec2D(width/2, height/2);
  Vec2D extent = new Vec2D(width/2, height/2);
  physics.setWorldBounds(Rect.fromCenterExtent(center, extent));

  papos = new ArrayList<Papo>();  // Create an empty ArrayList of Papo

  background(200, 0, 0);

  stroke(0, 0, 255);
  strokeWeight(3);
  smooth();
}

void draw()
{
  background(255);
  imageMode(CENTER);
  image(bg,width/2,height/2);
  
  counter += 0.009;
  perlin = map(noise(counter),0,1,0,255);
  fill(0,0,0,perlin);
  noStroke();
  rect(0,0,width,height);
  
  setKinect();
  physics.update();
}

void setKinect() { // Set up the kinect stuff here.
  // update the cam
  context.update();

  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for (int i=0; i<userList.length; i++)
  {
    context.getCoM(userList[i],com);
    context.convertRealWorldToProjective(com,com2d);
    println("x: "+com2d.x+"y: "+com2d.y+"z: "+com2d.z);
    
    if (context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    }
    
    else if(context.getCoM(userList[i],com)) // draw the center of mass if there's no skeleton
    {
      context.convertRealWorldToProjective(com,com2d);
      imageMode(CENTER);
      image(eyetipi,com2d.x,com2d.y);
    }
  }
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{

     //0 = head
  if(numPapos > 0){
    for(int i = papos.size(); i > 0; i--){
      if(papos.get(i-1).id==userId){
        
        //this is the tedious part. Add the kinect skeleton location to toxiclibs.
        int jointNum = 0;

        // joint position and position converted to real world values        
        PVector jointPos = new PVector();
        PVector realJointPos = new PVector();
        
        //head 0
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);
        
        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Head";
        jointNum++;
//        println("Papo ID "+papos.get(i-1).id+" is at location "+papos.get(i-1).skel.get(0).x + " " + papos.get(i-1).skel.get(0).y);

        println("joint pos is "+jointPos.z);

        // neck 1
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);
        
        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Neck";
        jointNum++;
        
        // left shoulder 2
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);

        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Left Shoulder";
        jointNum++;
        
        // left elbow 3
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);

        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Left Elbow";
        jointNum++;
        
        // left hand 4
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);

        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Left Hand";
        jointNum++;
        
        // Right Shoulder 5
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);

        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Right Shoulder";
        jointNum++;
        
        // Right Elbow 6
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);

        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Right Elbow";
        jointNum++;
        
        // Right Hand 7
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);

        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Right Hand";
        jointNum++;
        
        // Torso 8
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);

        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Torso";
        jointNum++;

        // Left Hip 9
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);
 
        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);
 
        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Left Hip";
        jointNum++;

        // Left Knee 10
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_KNEE,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);

        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);

        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Left Knee";
        jointNum++;

        // Left Foot 11
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_FOOT,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);
  
        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);
  
        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Left Foot";
        jointNum++;
        
        // Right Hip 12
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);
 
        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);
 
        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Right Hip";
        jointNum++;
        
        // Right Knee 13
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_KNEE,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);
  
        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);
  
        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Right Knee";
        jointNum++;
        
        // Right Foot 14
        context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_FOOT,jointPos);        
        context.convertRealWorldToProjective(jointPos, realJointPos);
  
        // change it to the values of the screen size
        realJointPos.x = map(realJointPos.x,0,640,0,displayWidth);
        realJointPos.y = map(realJointPos.y,0,480,0,displayHeight);
        
        papos.get(i-1).skel.get(jointNum).x=realJointPos.x;
        papos.get(i-1).skel.get(jointNum).y=realJointPos.y;
        papos.get(i-1).skel.get(jointNum).bodyPart="Right Foot";
        
        println("joints = "+jointNum);
        
        if(debug){ 
          println("rendering puppet skeleton"+i);
          papos.get(i-1).drawSkel();
        } else {
          println("rendering puppet skin"+i);
          papos.get(i-1).drawPapo();
        }
      }
    }
  }
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
  
  // add a papo
  papos.add(new Papo(userId));
  numPapos++;
  println("added puppet" + numPapos);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  
  for(int i = papos.size(); i >= 0; i--){
    if(papos.get(i-1).id==userId){
      papos.remove(i-1);
      println("removed papo: " + i);
    }
  }
  numPapos--;
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());
    break;  
  case 'd':
    debug = !debug;
    break;
  }
}

//classes below here

class Particle extends VerletParticle2D {

  Particle(float x, float y, float w) {
    super(x, y);
    setWeight(w);
  }

  // All we're doing really is adding a display() function to a VerletParticle
  void display(float _fill, float _stroke) {
    fill(_fill);
    stroke(_stroke);
    ellipse(x, y, 16, 16);
  }
}

// extend VerletParticle2D to add a String for body part name
// and to add a display() function

class Joint extends VerletParticle2D {
  String bodyPart = "null";

  Joint(float x, float y, float w, String _bodyPart) {
    super(x, y);
    setWeight(w);
    bodyPart = _bodyPart;
  }

  void display(float _fill, float _stroke) {
    fill(_fill);
    stroke(_stroke);
    ellipse(x, y, 16, 16);
    text(bodyPart, x, y-20);
  }
}

class Spring extends VerletSpring2D {
  Spring(Joint p1, Particle p2, float len, float strength) {
    super(p1, p2, len, strength);
  }

  void display(color c) {
    stroke(c);
    line(a.x, a.y, b.x, b.y);
  }
}

class Conspring extends VerletConstrainedSpring2D {
  Conspring(Joint p1, Particle p2, float len, float strength, float num) {
    super(p1, p2, len, strength, num);
  }

  void display(color c) {
    stroke(c);
    line(a.x, a.y, b.x, b.y);
  }
}

class Minspring extends VerletMinDistanceSpring2D {
  Minspring(Joint p1, Particle p2, float len, float strength) {
    super(p1, p2, len, strength);
  }

  void display(color c) {
    stroke(c);
    line(a.x, a.y, b.x, b.y);
  }
}

class Papo {
  // We use this class as a structure to store the joint coordinates
  
  int id; //here we store the skeleton's ID as assigned by OpenNI

  ArrayList<Joint> skel = new ArrayList<Joint>(); // make an arraylist of particles for the skeleton
  
  // make the parts for the papo's skin
  Particle head;
  ArrayList<Conspring> headC = new ArrayList(); 
  ArrayList<Minspring> headM = new ArrayList();
  PImage headImg;

  Papo(int _id) {
    id = _id;
    skel = new ArrayList<Joint>();  // Create an empty ArrayList of joints for the skeleton.
    for(int i = 0; i < 15; i++){
      skel.add(new Joint(width/2, height/2, 1,"null"));
      headImg=loadImage("eyetipi.png");
      imageMode(CENTER);
    }
    setupSkin();
  }
  
  void drawSkel() {
    for (int i = 0; i < skel.size(); i++) {
      skel.get(i).display(255, 100);
    }
  }
  
  void setupSkin() {
    // this is the fun part! Attach the skin to the skeleton.
    head = new Particle(width/2,height/2,1);;
    
    // add the head and skeleton parts to the physics.
    physics.addParticle(head);
    physics.addParticle(skel.get(0));
    physics.addParticle(skel.get(1));
    
    //connect the head to the head skeleton
    headC.add(new Conspring (skel.get(0),head, 15., 1., 20.));
    //connect the head to the neck skeleton
    headC.add(new Conspring (skel.get(1),head, 15., 1.,20.));
    
    for(int i = 0;i < headC.size();i++) {
      physics.addSpring(headC.get(i));
    }

    for(int i = 0;i < headM.size();i++) {
      physics.addSpring(headC.get(i));
    } 
  }
  
  void drawPapo() {
    // draw the head image
    image(headImg,head.x,head.y);
    
    // set the stroke and stroke weight
    
    stroke(0,255,0);
    strokeWeight(2);
    
    // draw the body and limbs   
    // shoulder to shoulder
    drawLine(2,5);
    
    // left shoulder to left elbow
    drawLine(2,3);
    
    // left elbow to left hand
    drawLine(3,4);
    
    // right shoulder to right elbow
    drawLine(5,6);
    
    // right elbow to right hand
    drawLine(6,7);
    
    // neck to torso
    drawLine(1,8);
    
    // torso to left hip
    drawLine(8,9);
    
    // torso to right hip
    drawLine(8,12);
    
    // hip to hip
    drawLine(9,12);
    
    // left hip to left knee
    drawLine(9,10);
    
    // left knee to left foot
    drawLine(10,11);
    
    // right hip to right knee
    drawLine(12,13);
    
    // right hip to right foot
    drawLine(13,14);
  }
  
  // draw a from one joint to another
  void drawLine(int a, int b) {
    line(skel.get(a).x, skel.get(a).y, skel.get(b).x, skel.get(b).y);
  }
}
