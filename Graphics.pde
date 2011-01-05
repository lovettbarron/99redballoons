void drawTextOverlay() {
  fill(0);
  stroke(255,255,255);
  text("Cloud size: "+ points.size(),110,30);
  text("Luft Balloons:" + spheres.size(),110,50);
  text("Z Threshold: "+ZTHRESH,110,70);
  text("Point Size: "+pointSize,110,90);
}
void drawImageOverlay() {
  image(kdepth,0,0,100,80); 
  image(kimg,0,80,100,80);
  if(ksubtract != null) {
    image(ksubtract,0,160,100,80);
  }
}


void subtractBackground() {
  updateKinect();
  ksubtract.copy(kdepth,0,0,kdepth.width,kdepth.height,0,0,ksubtract.width,ksubtract.height);
  subBackground = true;
}


void drawMesh(TriangleMesh mesh) {
  beginShape(TRIANGLES);
  for(Iterator i=mesh.faces.iterator(); i.hasNext();) {
    TriangleMesh.Face f=(TriangleMesh.Face)i.next();
    Vec3D n=f.normal;
    normal(n.x,n.y,n.z);
    vertex(f.a.x,f.a.y,f.a.z);
    vertex(f.b.x,f.b.y,f.b.z);
    vertex(f.c.x,f.c.y,f.c.z);
  }
  endShape();
}



void genCloud() {
  //THIS IS FOR TESTING ONLY`
  //for( int i = 0; i < (dWidth * dHeight)/multi; i++) { points.add( new Vec3D( random(-1,1), random(-1,1), random(-1,1) ) ); }
  if(subBackground == true) {
    kdepth.blend( ksubtract, 0,0,kdepth.width,kdepth.height, 0,0,ksubtract.width,ksubtract.height, SUBTRACT);
  }
  for(int i = 0; i < dHeight; i = i+multi) {
    for(int j = 0; j < dWidth; j = j+multi) {
      kloc = j + i*dWidth;
      kz = brightness(kdepth.pixels[kloc]);
      if(kz>ZTHRESH) {
        //println("X: " + j + " Y: " + i);
        points.add(   new Vec3D( (j), (i+YDISPLACE), (kz*zmulti) ) );
        /*        points.add( 
         new BoxConstraint( 
         new AABB(
         new Vec3D( (j)-pointSize, (i+YDISPLACE)-pointSize, (kz*zmulti)-pointSize ),
         new Vec3D( (j), (i+YDISPLACE), (kz*zmulti) )
         ) 
         ) 
         );*/
        //      points.add( new Vec3D( (j-width/2), (i-height/2), (kz*zmulti) ) );
        //pointColor.add( color( red(kimg.pixels[kloc]),green(kimg.pixels[kloc]),blue(kimg.pixels[kloc]) ) );
        colorMode(RGB);
        //        strokeWeight(30);
        //stroke(red(kimg.pixels[kloc]),green(kimg.pixels[kloc]),blue(kimg.pixels[kloc]));
        noStroke();
        fill(red(kimg.pixels[kloc]),green(kimg.pixels[kloc]),blue(kimg.pixels[kloc]), 90);
        //drawObject( new Vec3D(j-width/2,i-height/2,(kz*zmulti)), false );
        drawObject( new Vec3D(j,i+YDISPLACE,(kz*zmulti)), false );
      }
    }
  }
  points.trimToSize();
  //pointColor.trimToSize();
}



/*
void updateCloud() {
 int j, i = 0;
 for(Iterator s=points.iterator(); s.hasNext();) { 
 j = j+multi;
 if(j >= dWidth) {
 i = i + multi;
 j = 0;
 }
 kloc = j + i*dWidth;
 kz = brightness(kdepth.pixels[kloc]);
 
 if(kz>ZTHRESH) {
 s.next().set( new Vec3D( (j), (i+YDISPLACE), (kz*zmulti) ) );
 colorMode(RGB);
 noStroke();
 fill(red(kimg.pixels[kloc]),green(kimg.pixels[kloc]),blue(kimg.pixels[kloc]), 90);
 drawObject( new Vec3D(j,i+YDISPLACE,(kz*zmulti)), false );
 }
 }
 } */


void updateKinect() {
  NativeKinect.update();
  //kimg.pixels = NativeKinect.getVideo();
  kimg.pixels = NativeKinect.getPixels();
  kimg.updatePixels();
  //  kimg.resize(160,120);
  kdepth.pixels = NativeKinect.getDepthMap();
  kdepth.updatePixels();
}

void cleanUp() {
  points.clear();
  for(Iterator i=spherePoints.iterator(); i.hasNext();) {
    // VerletPhysics.removeConstraintFromAll((SphereConstraint)i.next(),physics.particles);
    VerletPhysics.removeConstraintFromAll((SphereConstraint)i.next(),physics.particles);
    
  }
//  spherePoints.removeRange( firstIndex, lastIndex );
  spherePoints.clear();
  //pointColor.clear();
  //  grab.clear();
  //  if (spherePoints!=null) spherePoints.clear();
}

void drawObject(Vec3D p, boolean s, int d) {

  pushMatrix();
  translate(p.x,p.y,p.z);
  if(s) {
    sphere(d);
  } 
  else {
    box(d);
  }
  popMatrix();
}

void drawObject(Vec3D p, boolean s) {
  drawObject(p,s,pointSize);
}

void drawAxes(float l) {
  strokeWeight(1);
  stroke(255, 0, 0);
  line(0, 0, 0, l, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, l, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, l);
}

void enviro() {
  background(255);
  lights();
  shininess(16);
  directionalLight(255,255,255,0,-1,1);
  specular(255);
  rotateY(rot);
  if(mousePressed == true) {
    rotateX(mouseY * 0.01f);
    rotateY(mouseX * 0.01f);
  }
  translate(_X,_Y,_Z);
  if(showAxis) drawAxes(400);
}

void sceneView(float rot) {
}
