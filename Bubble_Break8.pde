//The MIT License (MIT) - See Licence.txt for details

// audio stuff
Maxim maxim;
AudioPlayer wallSound, paddleSound, steelSound, steelthroughSound, ballfallSound, gameoverSound;
AudioPlayer[] popSound;
AudioPlayer menuSong, gameSong;


Boolean isPlay;             

int paddleprev;
Boolean startballvel;

int choice = 0;             //To store the choice on the menu
int lives = 3;             
int level = 1;
int score = 0;

//Images
PImage RockImage, PaddleImage, SteelImage, splash, back1, backmenu, back3, back4, BlockedImage;
PImage [] BubbleImage;
PImage b0, b1, b2, b3;

//Rock's positions and velocities
int RockX, RockY;
float velX, velY;

float xratio = 0.25;
int yratio = 7;

int [] poptime;
int popdelay=100;
float countdown=200.0;
int countstart;
int steeltime;
int lasthit;

Boolean [] bubhit;
Boolean [] justpop;
Boolean levelzone, clicked, go, clicked2, go2;
Boolean steelpermit;
Boolean steelpass;

void setup() {

  //bubhit=false;

  size(900, 600);
  frameRate(60);

  //Setup images
  RockImage=loadImage("Rock.png");
  PaddleImage=loadImage("Paddle.png");
  SteelImage=loadImage("steel2.png"); 
  back1=loadImage("back1.jpg");
  backmenu=loadImage("back5.jpg");
  backhelp=loadImage("back6ab.jpg");
  back3=loadImage("back3.jpg");
  back4=loadImage("back4ab.jpg");
  b0=loadImage("button0.png");
  b1=loadImage("button1.png");
  b2=loadImage("button2.png");
  b3=loadImage("button3.png");
  back=loadImage("back.png");
  splash=loadImage("splash.png");
  BlockedImage=loadImage("steelblocked.png");


  BubbleImage = new PImage[9];
  BubbleImage[0] = loadImage("bubble2.png");
  BubbleImage[1] = loadImage("bubbledb.png");
  BubbleImage[2] = loadImage("bubbleg.png");
  BubbleImage[3] = loadImage("bubbleo.png");
  BubbleImage[4] = loadImage("bubblep.png");
  BubbleImage[5] = loadImage("bubblepi.png");
  BubbleImage[6] = loadImage("bubbler.png");
  BubbleImage[7] = loadImage("bubbley.png");
  BubbleImage[8] = loadImage("bubbleyg.png");

  bubhit = new Boolean[10];
  justpop = new Boolean[10];
  poptime = new int[10];
  for (int i=0;i<10;i++)
  {
    bubhit[i]=false;
    justpop[i]=false;
  }
  imageMode(CENTER);

  //Audio initializations
  maxim = new Maxim(this);

  menuSong = maxim.loadFile("menumusic2.wav");
  gameSong = maxim.loadFile("gamemusic.wav");
  menuSong.setLooping(true);
  menuSong.volume(1.0);
  gameSong.setLooping(true);
  gameSong.volume(0.085);

  wallSound = maxim.loadFile("wall.wav");
  paddleSound = maxim.loadFile("paddle2.wav");
  steelSound = maxim.loadFile("steel.wav");
  steelthroughSound = maxim.loadFile("throughsteel.wav");
  ballfallSound = maxim.loadFile("ballfall.wav");
  gameoverSound = maxim.loadFile("gameover.wav");  


  wallSound.setLooping(false);
  wallSound.volume(1.0);
  paddleSound.setLooping(false);
  paddleSound.volume(1.0);
  steelSound.setLooping(false);
  steelSound.volume(1.0);
  steelthroughSound.setLooping(false);
  steelthroughSound.volume(1.0);
  ballfallSound.setLooping(false);
  ballfallSound.volume(1.0);
  gameoverSound.setLooping(false);
  gameoverSound.volume(1.0);



  // now an array of bubble sounds
  popSound = new AudioPlayer[10];
  for (int i=0;i<popSound.length;i++) {
    popSound[i] = maxim.loadFile("pop.wav");
    popSound[i].setLooping(false);
    popSound[i].volume(1);
  }

  //Rock's initial state
  velX = 0;
  velY = 0;
  RockX = constrain(mouseX, width/10, width-width/10); //For Rock to be in the center of Plat initially
  RockY = height-25;

  isPlay =false;
  startballvel=false;
  levelzone=false;
  clicked=false;
  clicked2=false;
  go=false;
  steelpermit=false;
  steelpass=false;
  go2=false;
  frameRate(60);
}

void draw() {


  switch(choice)
  {
  case 0:          //Draws menu
    image(backmenu, 0, 0, backmenu.width/2, backmenu.height/2);
    imageMode(CORNER);
    image(b0, 2/5*width, (3/13+3/40)*height);
    image(b1, 2/5*width, (3/13+1/100+3/40)*height+b0.height); 
    image(b2, 2/5*width, (3/13+1/50+3/40)*height+2*b0.height);
    image(b3, 2/5*width, (3/13+1/30+3/40)*height+3*b0.height); 
    menuSong.play();
    break;
  case 1:         //Keep it Simple
    imageMode(CORNER);
    image(back1, 0, 0, 5000/5, 3750/6); 
    image(back, width-back.width-20, 20);
    common();
    break;
  case 2:        //Bounce over the Wall
    imageMode(CORNER);
    image(back3, 0, 0, 5000/5.5, 3750/6); 
    image(back, width-back.width-20, 20);
    common();
    wallrender();
    break;
  case 3:         //Inside an atom
    imageMode(CORNER);
    image(back4, 0, 0, 900, 600); 
    image(back, width-back.width-20, 20);
    common();
    steelrender();
    break;
  case 4:         //Help menu
    image(backhelp, 0, 0, 900, 600); 
    image(back, width-back.width-20, height-back.height-20);
    menuSong.play();
    break;
  }
}


void mousePressed()
{

  switch(choice)
  {
  case 0:                    //Change choice as and when each button is clicked
    if (dist(mouseX, mouseY, (2/5*width)+(b0.width/2), ((3/13+3/40)*height)+(b0.height/2))<b0.width/2 && mouseY<(((3/13+3/40)*height)+(b0.height)) && mouseY>(((3/13+3/40)*height)))
      choice=1;
    if (dist(mouseX, mouseY, (2/5*width)+(b1.width/2), ((3/13+1/100+3/40)*height)+(b0.height)+(b3.height/2))<b1.width/2 && mouseY<(((3/13+1/100+3/40)*height)+(b0.height)+(b3.height)) && mouseY>(((3/13+1/100+3/40)*height)+(b0.height)))
      choice=2;
    if (dist(mouseX, mouseY, (2/5*width)+(b2.width/2), ((3/13+1/50+3/40)*height)+(2*b0.height)+(b3.height/2))<b2.width/2 && mouseY<(((3/13+1/50+3/40)*height)+(2*b0.height)+(b3.height)) && mouseY>(((3/13+1/50+3/40)*height)+(2*b0.height)))
    {
      choice=3;
      steeltime=millis();
    }
    if (dist(mouseX, mouseY, (2/5*width)+(b3.width/2), ((3/13+1/30+3/40)*height)+(3*b0.height)+(b3.height/2))<b3.width/2 && mouseY<(((3/13+1/30+3/40)*height)+(3*b0.height)+(b3.height)) && mouseY>(((3/13+1/30+3/40)*height)+(3*b0.height)))
      choice=4;
    menuSong.stop();
    break;
  case 1:
  case 2:
  case 3:     

    if (!isPlay && !levelzone)              //Before the game has begun, and when level up screen is not being displayed, prepare to start game if clicked
    {
      isPlay = !isPlay;
      paddleprev = mouseX;                 //To know what Plat's position was when mouse was clicked
      startballvel = true;                
      fill(255);
    }

    if (levelzone)        //To know that user has "clicked to continue" on level up screen
      clicked=true;

    if (go || go2)       //To know that user has "clicked to continue" on game over/ victory screen
      clicked2=true;

    if (dist(mouseX, mouseY, width-back.width-20+(back.width/2), 20+(back.height/2))<back.width/2)  //Back button
    {
      choice=0;
      gameSong.stop();
      reset2();
    }
    break;
  case 4:    
    if (dist(mouseX, mouseY, width-back.width-20+(back.width/2), height-back.height-20+(back.height/2))<back.width/2) //Back button
      choice=0;
    break;
  }
}
void mouseReleased()
{
  switch(choice) {
  case 1:
  case 2:
  case 3:
    if (startballvel)                                //If mouse has been clicked when Rock is on Plat
    { 
      startballvel = !startballvel;
      velX = int(xratio*(paddleprev-mouseX));       //Make Rock's x velocity proportional to distance by which Plat was dragged after clicking the mouse
      velY = yratio+yratio*(level-1)/3;             //Make y velocity proportional to the level, so higher levels are slightly harder
      fill(255);
      countstart=millis();
    }
  }
}

void reset()           //To reset the screen, change score and lives, etc. when Plat misses Rock
{
  startballvel=false;
  lives -=1;
  velX = 0;
  velY=0;
  isPlay=false;
  steelpermit=false;
  steelpass=false;
  RockX = constrain(mouseX, width/10, width-width/10);
  RockY = height-25;
  if (level==1)                //To set number of seconds for timer
  {              
    countdown = 200.0;
  }
  else
    countdown = 200 - (level-1)*20;
}

void reset2()      //To reset the game after a game over, victory, or when the back button has been pressed
{
  reset();
  score = 0;
  level=1;
  lives=3;
  for (int i=0;i<10;i++)
  {
    bubhit[i]=false;
    justpop[i]=false;
  }
  countdown=200.0;
  go=false;
  clicked2=false;
  go2=false;
}

void bubbledraw() {     //To draw each bubble if it has not been hit yet
  imageMode(CENTER);
  switch(choice)
  {
  case 1:
    if (!bubhit[0]) 
    {        
      image(BubbleImage[int(random(9))], 475, 300);
    }
    if (!bubhit[1]) {        
      image(BubbleImage[int(random(9))], 475-BubbleImage[0].width, 300);
    }  
    if (!bubhit[2]) {        
      image(BubbleImage[int(random(9))], 475+BubbleImage[0].width, 300);
    }  
    if (!bubhit[3]) {    
      image(BubbleImage[int(random(9))], 475+2*BubbleImage[0].width, 300);
    }  
    if (!bubhit[4]) {    
      image(BubbleImage[int(random(9))], 475-BubbleImage[0].width/2, 300+BubbleImage[0].height);
    }  
    if (!bubhit[5]) {    
      image(BubbleImage[int(random(9))], 475+BubbleImage[0].width/2, 300+BubbleImage[0].height);
    }  
    if (!bubhit[6]) {    
      image(BubbleImage[int(random(9))], 475+3*BubbleImage[0].width/2, 300+BubbleImage[0].height);
    }  
    if (!bubhit[7]) {    
      image(BubbleImage[int(random(9))], 475-BubbleImage[0].width/2, 300-BubbleImage[0].height);
    }  
    if (!bubhit[8]) {    
      image(BubbleImage[int(random(9))], 475+BubbleImage[0].width/2, 300-BubbleImage[0].height);
    }  
    if (!bubhit[9]) {    
      image(BubbleImage[int(random(9))], 475+3*BubbleImage[0].width/2, 300-BubbleImage[0].height);
    }
    break;
  case 2:   
    if (!bubhit[0]) {        
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2, 300-2*BubbleImage[0].height);
    }
    if (!bubhit[1]) {        
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2-BubbleImage[0].width, 300-2*BubbleImage[0].height);
    }  
    if (!bubhit[2]) {        
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2+BubbleImage[0].width, 300-2*BubbleImage[0].height);
    }  
    if (!bubhit[3]) {    
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2+2*BubbleImage[0].width, 300-2*BubbleImage[0].height);
    }  
    if (!bubhit[4]) {    
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2-BubbleImage[0].width/2, 300-1*BubbleImage[0].height);
    }  
    if (!bubhit[5]) {    
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2+BubbleImage[0].width/2, 300-1*BubbleImage[0].height);
    }  
    if (!bubhit[6]) {    
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2+3*BubbleImage[0].width/2, 300-1*BubbleImage[0].height);
    }  
    if (!bubhit[7]) {    
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2-BubbleImage[0].width/2, 300-3*BubbleImage[0].height);
    }  
    if (!bubhit[8]) {    
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2+BubbleImage[0].width/2, 300-3*BubbleImage[0].height);
    }  
    if (!bubhit[9]) {    
      image(BubbleImage[int(random(9))], 450-BubbleImage[0].width/2+3*BubbleImage[0].width/2, 300-3*BubbleImage[0].height);
    }
    break;

  case 3:    
    if (!bubhit[0]) {        
      image(BubbleImage[int(random(9))], 475, 300-SteelImage.height);
    }
    if (!bubhit[1]) {        
      image(BubbleImage[int(random(9))], 475-BubbleImage[0].width, 300-SteelImage.height);
    }  
    if (!bubhit[2]) {        
      image(BubbleImage[int(random(9))], 475+BubbleImage[0].width, 300-SteelImage.height);
    }  
    if (!bubhit[3]) {    
      image(BubbleImage[int(random(9))], 475+2*BubbleImage[0].width, 300-SteelImage.height);
    }  
    if (!bubhit[4]) {    
      image(BubbleImage[int(random(9))], 475-BubbleImage[0].width/2, 300+BubbleImage[0].height-SteelImage.height);
    }  
    if (!bubhit[5]) {    
      image(BubbleImage[int(random(9))], 475+BubbleImage[0].width/2, 300+BubbleImage[0].height-SteelImage.height);
    }  
    if (!bubhit[6]) {    
      image(BubbleImage[int(random(9))], 475+3*BubbleImage[0].width/2, 300+BubbleImage[0].height-SteelImage.height);
    }  
    if (!bubhit[7]) {    
      image(BubbleImage[int(random(9))], 475-BubbleImage[0].width/2, 300-BubbleImage[0].height-SteelImage.height);
    }  
    if (!bubhit[8]) {    
      image(BubbleImage[int(random(9))], 475+BubbleImage[0].width/2, 300-BubbleImage[0].height-SteelImage.height);
    }  
    if (!bubhit[9]) {    
      image(BubbleImage[int(random(9))], 475+3*BubbleImage[0].width/2, 300-BubbleImage[0].height-SteelImage.height);
    }
    break;
  }
}

void bubblepop()   //To call simplebubble() function for each bubble, thus effectively creating all the "pop"s
{
  switch(choice) {
  case 1:
    simplebubble(475, 300, 0);
    simplebubble(475-BubbleImage[0].width, 300, 1);
    simplebubble(475+BubbleImage[0].width, 300, 2);
    simplebubble(475+2*BubbleImage[0].width, 300, 3);
    simplebubble(475-BubbleImage[0].width/2, 300+BubbleImage[0].height, 4);
    simplebubble(475+BubbleImage[0].width/2, 300+BubbleImage[0].height, 5);
    simplebubble(475+3*BubbleImage[0].width/2, 300+BubbleImage[0].height, 6);
    simplebubble(475-BubbleImage[0].width/2, 300-BubbleImage[0].height, 7);
    simplebubble(475+BubbleImage[0].width/2, 300-BubbleImage[0].height, 8);
    simplebubble(475+3*BubbleImage[0].width/2, 300-BubbleImage[0].height, 9);
    break;
  case 2:
    simplebubble(450-BubbleImage[0].width/2, 300-1.5*BubbleImage[0].height, 0);
    simplebubble(450-BubbleImage[0].width/2-BubbleImage[0].width, 300-2*BubbleImage[0].height, 1);
    simplebubble(450-BubbleImage[0].width/2+BubbleImage[0].width, 300-2*BubbleImage[0].height, 2);
    simplebubble(450-BubbleImage[0].width/2+2*BubbleImage[0].width, 300-2*BubbleImage[0].height, 3);
    simplebubble(450-BubbleImage[0].width/2-BubbleImage[0].width/2, 300-1*BubbleImage[0].height, 4);
    simplebubble(450-BubbleImage[0].width/2+BubbleImage[0].width/2, 300-1*BubbleImage[0].height, 5);
    simplebubble(450-BubbleImage[0].width/2+3*BubbleImage[0].width/2, 300-1*BubbleImage[0].height, 6);
    simplebubble(450-BubbleImage[0].width/2-BubbleImage[0].width/2, 300-3*BubbleImage[0].height, 7);
    simplebubble(450-BubbleImage[0].width/2+BubbleImage[0].width/2, 300-3*BubbleImage[0].height, 8);
    simplebubble(450-BubbleImage[0].width/2+3*BubbleImage[0].width/2, 300-3*BubbleImage[0].height, 9);
    break;
  case 3:
    simplebubble(475, 300-SteelImage.height, 0);
    simplebubble(475-BubbleImage[0].width, 300-SteelImage.height, 1);
    simplebubble(475+BubbleImage[0].width, 300-SteelImage.height, 2);
    simplebubble(475+2*BubbleImage[0].width, 300-SteelImage.height, 3);
    simplebubble(475-BubbleImage[0].width/2, 300+BubbleImage[0].height-SteelImage.height, 4);
    simplebubble(475+BubbleImage[0].width/2, 300+BubbleImage[0].height-SteelImage.height, 5);
    simplebubble(475+3*BubbleImage[0].width/2, 300+BubbleImage[0].height-SteelImage.height, 6);
    simplebubble(475-BubbleImage[0].width/2, 300-BubbleImage[0].height-SteelImage.height, 7);
    simplebubble(475+BubbleImage[0].width/2, 300-BubbleImage[0].height-SteelImage.height, 8);
    simplebubble(475+3*BubbleImage[0].width/2, 300-BubbleImage[0].height-SteelImage.height, 9);
    break;
  }
}



void simplebubble(int x, int y, int i)      //To describe what happens when each bubble is popped
{
  imageMode(CENTER);
  if ((dist(x, y, RockX, RockY-10)<BubbleImage[0].width/2+10) && bubhit[i]==false)  //To pop the bubble if it hasn't a;ready been popped
  {
    bubhit[i]=true;
    justpop[i] = true;
    //popSound[i].cue(0);
    //popSound[i].play();
    poptime[i]=millis();
    score += 100;
    if ((abs(atan2(y-RockY-10, x-RockX)) < (3*PI/4)) && (abs(atan2(y-RockY-10, x-RockX)) > (PI/4)))  //To bounce Rock off the bubble (he is surprisingly light!!!) fairly realistically
      velY = -velY;
    else
      velX = -velX;
  }
  if (justpop[i] && bubhit[i])         //Sets justpop[i] false after "popdelay" millisecs, thereby causing the splash image to be displayed for that time
  { 
    if (millis()-poptime[i]>popdelay)
      justpop[i]=false;
  }
  if (justpop[i])            //Cause a splash to appear in the bubble's postion if justpop[i] is true
  {     
    image(splash, x, y);
  }
}

void levelup()
{ 
  text("Level: " + level, 20, 40);
  for (int i=0;i<10;i++)
    if (!bubhit[i])              //Stops levelup() from proceeding further unless all bubbles have been popped
      return;
  if (!go2) {                   //If user isn't on victory screen
    levelzone=true;

    if (!clicked) {            //If user hasn't clicked to continue
      lives++;

      if (choice==2)
        fill(200);   
      textSize(height/10);
      textAlign(CENTER, CENTER);
      text("LEVEL UP!", width/2, height/2);
      textAlign(LEFT, LEFT);
      textSize(12);
      text("Click anywhere to continue...", 2*width/3-width/8, height/2+height/20+20);
      reset();
      fill(140);
    }
    else {
      levelzone=false;
      clicked=false;
      for (int i=0;i<10;i++)
      {
        bubhit[i]=false;
        justpop[i]=false;
      }
      score += level*(lives+1)*100 + 10*countdown;
      lives ++;
      level+=1;
      countdown = 200 - (level-1)*20;
      if (choice==2 || choice==3)          //To give 2 lives in 2nd and 3rd gameplay modes
        lives++;
      steeltime=millis();
    }
  }
}


void gameover()          //Gameover screen
{ 
  if ((lives<0 || countdown==0) && clicked2==false)  //If time is up, or lives are over, and user hasn't yet clicked to continue
  {  
    for (int i=0;i<10;i++)                           //To remove all bubbles when displaying
    {
      bubhit[i]=true;
      justpop[i]=false;
    }
    go =true;
    textSize(height/10);
    textAlign(CENTER, CENTER);
    if (choice==2)
      fill(200);

    text("GAME OVER :(", width/2, height/2);
    textAlign(LEFT, LEFT);
    textSize(12);
    text("Click anywhere to continue...", 2*width/3-width/8, height/2+height/20+20);
    fill(140);
  }
  else if (clicked2)
  {
    reset2();
    steeltime=millis();
  }
}

void common() 
{
  fill(56);
  rect(constrain(mouseX, width/10, width-width/10)-width/10, height-25, width/5, 20);
  gameSong.play();

  bubbledraw();  

  imageMode(CORNER);
  fill(140);
  ellipseMode(CENTER);

  bubblepop();

  winner();
  if (!go2)            //Calls gameover function if user hasn't won the game
    gameover();
  if (!go) 
  {          //Calls level up function if user hasn't lost the game
    levelup();
  }

  if (isPlay)        //If user has already clicked to launch Rock    
  {

    if (!startballvel) //If user has already released to launch Rock 
    {
      countdown = countdown- ((millis()-countstart)/1000);  //Update timer
      countstart=millis();
    }
    if (RockX<=10 || RockX>=(width-10))  //If Rock hits a wall
    {
      velX = -velX;

      steelpermit=true;

      //wallSound.cue(0);
      //wallSound.play();
    }
    if (RockY<=10)             //If Rock hits the roof
    {
      velY = -velY;

      //wallSound.cue(0);
      //wallSound.play();
    }
    if ((RockY) > (height-30) && ((RockX>= (mouseX-(width/10)))&&(RockX <= (mouseX+(width/10)))))  //If Rock hits Plat
    {
      if (isPlay && !startballvel) {
        //paddleSound.cue(0);
        //paddleSound.play();
        score+=10;
      }

      velY = -velY;
      if (velX != 0)
      {
        velX = velX*random(0.5, 1.2); //Slightly affects the X velocity randomly
        velX += (RockX-mouseX)/15 ;   //Affects the speed of X velocity depending on where Rock hits Plat
      }
      else if (isPlay && !startballvel)
      {
        velX += (RockX-mouseX)/15;
      }
    }

    if ((RockY>(height-5))  && ((RockX<= (mouseX-(width/10)))||(RockX >= (mouseX+(width/10)))) )  //If Plat misses Rock
    {
      reset();
      //ballfallSound.cue(0);
      //ballfallSound.play();
      score -= 250;
    }
    RockX += velX;
    RockY += velY;
  }
  else   //If Rock hasn't been launched off Plat
  {  
    RockX = constrain(mouseX, width/10, width-width/10);
    RockY = height-25;
  }
  ellipse(RockX, RockY-10, 20, 20);  //Draws Rock!!!
  text("Score: " + score, 20, 20);
  text("Lives: " + lives, width-50, 20);
  text("Time: "+ int(countdown), 20, 60);
}

void wallrender()   //To deal with the steel wall
{  
  if (!levelzone && !go && !go2) //Draws the wall only if it is not the levelup, game over or victory screens
  {
    if (steelpermit)   //If Rock has already bounced off the wall after he last jumped over the steel wall, show it as 1 colour, else display the image with angular bars
    {
      fill(190);
      rect(0, 300-0.1*BubbleImage[0].height, width, 20);
    }
    else
    {
      imageMode(CORNER);
      image(BlockedImage, 0, 300-0.1*BubbleImage[0].height);
    }
  }
  if (RockY-10<=320-0.1*BubbleImage[0].height)  //If Rock is within the steel wall
  {
    if (velY<0)    //If Rock is moving upwards
    {
      if (steelpermit) //If Rock has already bounced off the wall after he last jumped over the steel wall
      { 
        if (!steelpass) //If Rock has just passed through the wall
        {
          steelpass=true;
          //steelthroughSound.cue(0);
          //steelthroughSound.play();
        }
      }
      else      
      { 
        score-=20;
        //steelSound.cue(0);
        //steelSound.play();
        velY = -velY;
      }
    }
  }
  else if (velY>0) //If Rock is moving downwards
  {
    if (RockY-10>=320-0.1*BubbleImage[0].height && steelpass) //As soon as he exits
    {
      steelpass=false;
      steelpermit=false;
    }
  }
}


void steelrender() //Draws the steel balls and calls steelhit() for each of them
{
  if (!levelzone && !go && !go2) //If it is not level up, game over or victory screens
  {
    imageMode(CENTER);
    image(SteelImage, 475+BubbleImage[0].width/2+(200*cos((2*PI/7.5)*(millis()-steeltime)/1000)), 300-SteelImage.height+(200*sin((2*PI/7.5)*(millis()-steeltime)/1000)));               //The positions are for uniform circular motion about a point not at the origin 
    image(SteelImage, 475+BubbleImage[0].width/2+(200*cos(((2*PI/7.5)*(millis()-steeltime)/1000)+PI/2)), 300-SteelImage.height+(200*sin(((2*PI/7.5)*(millis()-steeltime)/1000)+PI/2))); //and the phase angles PI/2, PI, 3*PI/2 corrsepond to the balls starting at different
    image(SteelImage, 475+BubbleImage[0].width/2+(200*cos(((2*PI/7.5)*(millis()-steeltime)/1000)+PI)), 300-SteelImage.height+(200*sin(((2*PI/7.5)*(millis()-steeltime)/1000)+PI)));     //points on the circle
    image(SteelImage, 475+BubbleImage[0].width/2+(200*cos(((2*PI/7.5)*(millis()-steeltime)/1000)+3*PI/2)), 300-SteelImage.height+(200*sin(((2*PI/7.5)*(millis()-steeltime)/1000)+3*PI/2)));
    steelhit(475+BubbleImage[0].width/2+(200*cos((2*PI/7.5)*(millis()-steeltime)/1000)), 300-SteelImage.height+(200*sin((2*PI/7.5)*(millis()-steeltime)/1000)));
    steelhit(475+BubbleImage[0].width/2+(200*cos(((2*PI/7.5)*(millis()-steeltime)/1000)+PI/2)), 300-SteelImage.height+(200*sin(((2*PI/7.5)*(millis()-steeltime)/1000)+PI/2)));
    steelhit(475+BubbleImage[0].width/2+(200*cos(((2*PI/7.5)*(millis()-steeltime)/1000)+PI)), 300-SteelImage.height+(200*sin(((2*PI/7.5)*(millis()-steeltime)/1000)+PI)));  
    steelhit(475+BubbleImage[0].width/2+(200*cos(((2*PI/7.5)*(millis()-steeltime)/1000)+3*PI/2)), 300-SteelImage.height+(200*sin(((2*PI/7.5)*(millis()-steeltime)/1000)+3*PI/2)));
  }
}

void steelhit(int x, int y)  //For deciding collision of Rock with the stel balls
{
  imageMode(CENTER);
  if (dist(x, y, RockX, RockY-10)<SteelImage.width/2+10 && (millis()-lasthit)>150)
  {
    //steelSound.cue(0);
    //steelSound.play();
    score -= 10;
    if ((abs(atan2(y-RockY-10, x-RockX)) < (3*PI/4)) && (abs(atan2(y-RockY-10, x-RockX)) > (PI/4)))
      velY = -velY;
    else
      velX = -velX;
    lasthit = millis();
  }
}

void winner()  //Victory screen
{
  for (int i=0;i<10;i++)  //Stop winner() function from proceeding unless each bubble has been popped
    if (!bubhit[i])
      return;

  if (level==10 && clicked2==false) //Only if level 10 has been cleared (i.e, all bubbles of level 10 have been popped and user hasn't clicked to continue
  {    
    for (int i=0;i<10;i++) //Stop display of bubbles when writing about victory
    {
      bubhit[i]=true;
      justpop[i]=false;
    }
    go2 =true;
    textSize(height/10);
    textAlign(CENTER, CENTER);
    if (choice==2)
      fill(200);


    text("YOU WIN! :D", width/2, height/2);
    textAlign(LEFT, LEFT);
    textSize(12);
    text("Click anywhere to continue...", 2*width/3-width/8, height/2+height/20+20);
    fill(140);
    reset();
  }
  else if (clicked2)       //If user has clicked to continue, start game over
  {
    reset2();
    steeltime=millis();
  }
}

