void initPhysics() { 
  physics=new VerletPhysics();
  physics.setGravity(new Vec3D(0,.8,0));
  //    physics.setGravity(Vec3D.Y_AXIS.scale(0.05));
//    physics.setGravity(Vec3D.Y_AXIS.scale(0.1));
  //spheres.add(new SphereConstraint(new Sphere(new Vec3D(0,-100,0),100),false));

  ground=new BoxConstraint(new AABB(new Vec3D(0,1000,0), new Vec3D(2000,101,2000)));
//  physics.setWorldBounds(new AABB(new Vec3D(), new Vec3D(2000,2000,2000)));
  ground.setRestitution(.8);
}

