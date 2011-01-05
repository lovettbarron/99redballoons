void initBjork() {
  /*
  Ess.start(this);
   bjork=new AudioChannel("99balloons.mp3");
   bufferSize=bjork.buffer.length;
   bufferDuration=bjork.ms(bufferSize);
   */
  minim = new Minim(this);
  bjork = minim.loadFile("99balloons.mp3");
}

void playBjork() {
  try {
   // bjork.play();
  } 
  catch (NullPointerException e) {
    println(e);
  }
}

void stopBjork() {
  try {
  bjork.close();
    } 
  catch (NullPointerException e) {
    println(e);
  }
}

public void stop() {

  stopBjork();

  minim.stop();
  super.stop();
}

