import shiffman.kinect.*;
import processing.opengl.*;
import toxi.processing.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.physics.constraints.*;
import toxi.physics.*;
import ddf.minim.*;

//audio
Minim minim;
AudioPlayer bjork;

//Objects
VerletPhysics physics;
ToxiclibsSupport gfx;
TriangleMesh mesh;
//VisibleOctree octree;
BoxConstraint ground;
AxisAlignedCylinder button;

//Arraylists
int[][] faces;
ArrayList points = null;
ArrayList pointColor = null;
ArrayList spherePoints = null;
ArrayList spheres=new ArrayList();

//Image
PImage kimg,kdepth,ksubtract;
int kx,ky,kloc;
float kz;

//Enviro
int screenW = 1280;
int screenH = 960;
int dWidth = 640;
int dHeight = 480;
int multi = 32;
int zmulti = 5;
int YDISPLACE = 520;
int ZTHRESH = 4;
int pointSize = 40;

//Balloon
int luftBalloons = 49;
boolean buttonActive = false;
int counter = 0;
int balloonSize = 40;

//Point cloud and enviro
float DIM = screenW/4;
float DIM2 = DIM/2;
int PART = 10;
int numParticles = 1;
float pntRad = 10.0;
boolean showGrid = true;
boolean showAxis = false  ;
boolean showGround = false;
boolean subBackground = false;
boolean showDebug = false;
Vec3D buttonPos;
int firstIndex, lastIndex;

//Viewport
float rot = 0;
int _Z = -300;
int _X = 300;
int _Y = -400;
int amnt = 100;
boolean setupComplete = false;

int totalIterations, numClipped = 0;


//////////////////////////////////////////////////////////////////////////////////
///////////////////////////   SETUP SETUP SETUP SETUP   ///////////////////////////
//////////////////////////////////////////////////////////////////////////////////

void setup() {
  size(screenW,screenH,OPENGL);
  frameRate(15);
  sphereDetail(2);
  textFont(createFont("SansSerif",18));
  gfx=new ToxiclibsSupport(this);
  initBjork();
  NativeKinect.init();
  //NativeKinect.start();

  kimg = createImage(dWidth,dHeight,RGB);
  kdepth = createImage(dWidth,dHeight,RGB);
  if(setupComplete == false) {
    ksubtract = createImage(dWidth,dHeight,RGB);
  }
  counter = -100;
  points = new ArrayList();
  spherePoints = new ArrayList();

  buttonPos = new Vec3D( 600, 600, 300);

  button = new XAxisCylinder( new Vec3D(), 150, 30);
  button.setPosition( new Vec3D( buttonPos ) );

  if(setupComplete == false) {
    for( int i = 0; i < 10; i++) {
      points.add( new Vec3D( random(-1,1), random(-1,1), random(-1,1) ) );
    }
  }
  initPhysics();

  setupComplete = true;
}


//////////////////////////////////////////////////////////////////////////////////
///////////////////////////   DRAW DRAW DRAW DRAW DRAW   ///////////////////////////
//////////////////////////////////////////////////////////////////////////////////
void draw() {
  pushMatrix();
  physics.update();
  updateKinect();
  enviro();
  sceneView(rot);
  genCloud();
  render();
  doPartyButton();
  updateBalloon();
  cleanUp();
  popMatrix();
  if( showDebug ) {
    drawTextOverlay();
    drawImageOverlay();
  }
  totalIterations++;
  //println( counter );
}


//////////////////////////////////////////////////////////////////////////////////
///////////////////////////   FUNC FUNC FUNC FUNC FUNC  //////////////////////////
//////////////////////////////////////////////////////////////////////////////////



void render() {

  partyButton();
  //fill(0,10);
  //stroke(0);
  //gfx.box( ground.getBox() );
}

void partyButton() {
  //  button.setPosition( buttonPos.x + 51, buttonPos.y, buttonPos.z + 120);
  if( buttonActive == true) {
    fill( 0,255,0);
  } 
  else { 
    fill( 255,0,0 );
  }
  noStroke();
  drawMesh( button.toMesh() );
  pushMatrix();
  translate( buttonPos.x-41, buttonPos.y+50, buttonPos.z-150);
  rotateY(-HALF_PI);
  fill( 255,255,0);
  scale(2,7);
  text("PARTY BUTTON",0,0);
  popMatrix();
}

void doPartyButton() {
  if( buttonActive == false) {
    for(Iterator i=points.iterator(); i.hasNext();) {
      if (button.containsPoint( (Vec3D)i.next() ) ) {
        resetButton();
        break;
      }
    }
  } 
  else {
    if( counter < luftBalloons && counter > 0) {
      makeBalloon();
    }
    else if( counter > 445 && counter < 1400 && counter % 8 == 1 ) {
      destroyBalloon();
      makeBalloon();
    }

    else if ( counter >= 1600) {
      stopBjork();
      setup();
      spheres.clear();
      resetButton();
    }
    else if( counter > 1500) {
      destroyBalloon();
    } 
    counter++;
  }
}




void resetButton () {
  if(buttonActive == false) {
    playBjork();
    buttonActive = true;
    counter = -100;
  } 
  else {
    stopBjork();
    buttonActive = false;
  }
}




void makeBalloon() {
  VerletParticle p = new VerletParticle( new Vec3D(random(0, 1000), random(0,1000 ), random(0,1000) ) );
  physics.addParticle( p);
  spheres.add(new SphereConstraint(new Sphere( p, balloonSize), false));
  VerletPhysics.addConstraintToAll(ground, physics.particles);
}



void updateBalloon() {
  fill( 255,0,0);
  noStroke();
  for(Iterator i=points.iterator(); i.hasNext();) {
    SphereConstraint s= new SphereConstraint( new Sphere( (Vec3D)i.next(), balloonSize), false );
    /*Vec3D ppp = (Vec3D)i.next();
     BoxConstraint s = new BoxConstraint( 
     new AABB( 
     ppp, 
     new Vec3D( ppp.x+pointSize, ppp.y+pointSize, ppp.z+pointSize) ) ); */
    spherePoints.add( s );
    //    spherePoints.get( spherePoints.size()-1).setRestitution(10);
    VerletPhysics.addConstraintToAll((SphereConstraint)spherePoints.get(spherePoints.size()-1),physics.particles);
    // VerletPhysics.addConstraintToAll((BoxConstraint)spherePoints.get(spherePoints.size()-1),physics.particles);
    //    println(spherePoints.size()-1);
  }
  for(Iterator i=physics.particles.iterator(); i.hasNext();) {
    //for(Iterator<SphereConstraint> i=spheres.iterator(); i.hasNext();) {
    VerletParticle s = (VerletParticle)i.next();
    //    VerletParticle t = (VerletParticle)s.getInverted();
    //    if( s.y > 0 ) {
    //     s.set( new Vec3D ( s.x, 1, s.z ) );
    //     s.removeConstraint( ground );
    //  }
    s.applyConstraints();
    //    gfx.sphere( new Sphere(new Vec3D( s.x, s.y, s.z ), (float)pointSize*5 ) );
    drawObject( (VerletParticle)s, true, balloonSize);
    //println("Particle position: " + s.x + ", " + s.y + ", " + s.z);
  }
}


void destroyBalloon() {
  for(Iterator i=physics.particles.iterator(); i.hasNext();) {
    physics.removeParticle( (VerletParticle)i.next() );
    break;
  }
}
