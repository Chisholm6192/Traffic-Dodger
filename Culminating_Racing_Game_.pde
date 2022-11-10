/*
Ryan Chisholm
June 15th 2022

Street Racing Traffic Dodging Game
Drive along the road and avoid oncoming cars, there is a self updating highscore 
as well as the ability to change the colors of the car and the control's you use
there is also interactive graphics and menu's, restart, pause and quit functions,
and also a game over menu when the player crashes
*/

//players x and y coordinates
int carx = 240;
int cary = 760;

//road x and y coordinates
int r = 190;//x
int l = -50;//y

int sy = -5;
int h = 40;//starting y coordinate when the road tiles are spawned in
int score = 0;

int screen = 0;
int height = 1000;
int width = 600;

int ControlScheme = 1;

float nums = random(width);
int number;
//these all have a default/starting value of false
boolean paused = false;
boolean crashed = false;
boolean highscore = false;

String UserCar = "Blue Car";//User's default car
String[] numbers;
String scores;

ArrayList<Cars> Car = new ArrayList<Cars>();//arraylist for printing cars
ArrayList<Road> road = new ArrayList<Road>();//arraylist for printing the road/background

//Images
PImage Close,Restart,Settings,Back,GameOver,StartOver,Quit,MainScreen,ObstacleCar,Title;
PImage Player,Blue,Orange,Green,DarkGreen,LightGreen,DarkGray,LightGray,Turquoise,HighScore;

void setup(){
  size(600,1000);
  noSmooth();
  //Image loading
  Close = loadImage("Close.jpg");
  Restart = loadImage("Restart.jpg");
  Settings = loadImage("Setting.jpg");
  Back = loadImage("BackButton.jpg");
  GameOver = loadImage("GameOver.jpg");
  StartOver = loadImage("Restart Button.PNG");
  Quit = loadImage("QuitButton.PNG");
  MainScreen = loadImage("RacingScreen.jpg");
  Player = loadImage("BlueCar.jpg");
  Blue = loadImage("BlueCar.jpg");
  Orange = loadImage("OrangeCar.jpg");
  DarkGray = loadImage("DarkGrayCar.jpg");
  LightGray = loadImage("LightGrayCar.jpg");
  DarkGreen = loadImage("DarkGreenCar.jpg");
  Green = loadImage("GreenCar.jpg");
  LightGreen = loadImage("LightGreenCar.jpg");
  Turquoise = loadImage("TurquoiseCar.jpg");
  ObstacleCar = loadImage("ObstacleCar.jpg");
  HighScore = loadImage("highscore.jpg");
  Title = loadImage("title.png");
  //to acess text document
  numbers = loadStrings("Score.txt");
}

void draw(){
  int[] high = int(numbers);//converts the strings from text doc to an integer
  
  for(int i=0; i<high.length; i++){
    if((score/20) > high[i]){//if the current score is a highscore
      scores = str(score/20);//convert the value to a string
      numbers = split(scores, ' ');
      saveStrings("Score.txt",numbers);//save the value to the text doc
      highscore = true;
    }
    else if((score/20) <= high[i]){//if the current score isn't a highscore
      number = high[i];
    }
  }  
  if(screen == 0){//main menu
  image(MainScreen,0,0,600,1000);
  image(Close,550,0,50,40);
  image(Settings,515,0,40,40);
  image(Title,130,140,400,150);
  }
  else if(screen == 1){
    background(100);
    //movement of road and cars
    l -= sy;
    h -= sy;
    Car.add(new Cars());
    for(int i=0; i<20; i++){//road movement loop
      road.add(new Road());
      road.get(i).b = l +(i*80);
      road.get(i).Render();
      if(road.get(i).b == 1000) l = -40;//reset once it hits bottom of screen
      Car.get(i).physics();
    }
    
    //paused
    if(paused == true){
      sy = 0;
      textSize(120);
      text("[PAUSED]",50,490);
      textSize(20);
      text("Press ENTER to Resume",200,520);
    }
    else if(paused == false) sy = -5;
    
    if(highscore == true){
      image(HighScore,400,40,200,30);
    }
    
    //graphics
    image(Player,carx,cary,120,200);//player car
    rect(0,-2,width,42);//graphic at top of screen
    fill(0);
    textSize(20);
    text("SCORE: " + score/20,30,30);
    text("ENTER = PAUSE/RESUME",140,30);
    fill(255);
    image(Close,550,0,50,40);
    image(Restart,515,0,40,40);
    image(Settings,480,0,40,40);
    
    if((score/20) == 20){//becuase of the for loop, the number is 20 times what it should be
      h = 0;
      l = 0;
      score = 20*21;
    }
  }
  else if(screen == 2){//crashed screen
    paused = true;
    crashed = true;
    image(GameOver,100,375,400,250);
    image(StartOver,90,630,200,60);
    image(Quit,360,630,140,60);
    textSize(40);
    if(highscore == false){
      fill(0);
      rect(145,310,340,50);
      rect(145,250,320,50);
      fill(255);
      text("HIGHSCORE: " + number,150,290);
      text("YOUR SCORE: " + score/20,150,350);
    }
    else if(highscore == true){
      fill(0);
      rect(110,310,420,50);
      rect(60,250,520,50);
      fill(255);
      text("PREVIOUS HIGHSCORE: " + number,65,290);
      text("NEW HIGHSCORE: " + score/20,120,350);
    }
  }
  else if(screen == 3){//settings screen
  background(0);
  fill(255);
  paused = true;//automatically pauses game
  image(Close,550,0,50,40);
  image(Back,500,0,40,40);
  textSize(40);
  text("SETTINGS",20,40);
  textSize(30);
  text("Car Settings",20,150);
  textSize(25);
  text("Color",20,200);
  textSize(30);
  text("Control's",20,400);
  textSize(25);
  
  //Control Scheme
  text("Control Scheme",20,440);
  textSize(15);
  text("Current Active Control Scheme: " + ControlScheme,250,440);
  textSize(20);
  text("Control Scheme 1: ",20,480);
  rect(200,460,20,20);
  text("Control Scheme 2: ",20,560);
  rect(200,540,20,20);
  textSize(15);
  text("LEFT ARROW = MOVE LEFT",20,520);
  text("RIGHT ARROW = MOVE RIGHT",250,520);
  text("A = MOVE LEFT",20,600);
  text("D = MOVE RIGHT",180,600);
  
  //color changes
  textSize(15);
  text("Current Car: " + UserCar,120,200);
  text("Orange",60,240);
  rect(70,250,20,20);
  text("Blue",160,240);
  rect(160,250,20,20);
  text("Dark Gray",230,240);
  rect(250,250,20,20);
  text("Light Gray",340,240);
  rect(360,250,20,20);
  text("Dark Green",60,300);
  rect(70,310,20,20);
  text("Green",160,300);
  rect(160,310,20,20);
  text("Light Green",230,300);
  rect(250,310,20,20);
  text("Turquoise",340,300);
  rect(360,310,20,20);
  
  //HighScore
  textSize(30);
  text("LOCAL HIGHSCORE: " + number, 10,700);
  }
  
  //car color changing
  //changes the image that the 'player' variable displays
  if(UserCar == "Blue Car") Player = Blue;
  else if(UserCar == "Orange Car") Player = Orange;
  else if(UserCar == "Dark Gray Car") Player = DarkGray;
  else if(UserCar == "Light Gray Car") Player = LightGray;
  else if(UserCar == "Dark Green Car") Player = DarkGreen;
  else if(UserCar == "Green Car") Player = Green;
  else if(UserCar == "Light Green Car") Player = LightGreen;
  else if(UserCar == "Turquoise Car") Player = Turquoise;
}

class Cars{
  int x,y,z;
  Cars(){
    super();
    //random number generator for x coordinate of oncoming cars
    float nums = random(600);
     if(nums >= 0 && nums <= 267) this.x = 40;
     else if(nums > 267 && nums <= 500) this.x = 240;
     else if(nums > 500 && nums <= 800) this.x = 440;
  }
  void render(int a){
    this.y = a;//a is the integer that the cars will reset to when they spawn new ones
    image(ObstacleCar,this.x,this.y,120,200);//oncoming cars
  }
  void physics(){
    this.y = h;//starting point
    for(int i=0; i<20; i++){
      Car.add(new Cars());
      if(Car.get(i).y > 40) Car.get(i).render(h -(440*i));//spawn a new car every 40 units
      //increases score
      if((Car.get(i).y > cary && Car.get(i).y < cary + 10) && ((h - (440*i)) > cary)) score += 1;
      //collision
      if((Car.get(i).y >= cary - 200 && Car.get(i).y <= cary + 200) && Car.get(i).x == carx) screen = 2;
    }
  }
}

class Road extends Cars{
  int b;
  Road(){
  }
  void Render(){
    //road tiles
    rect(r,b,20,60);
    rect(r*2,b,20,60);
  }
}

void Restart(){
  score = 0;
  h = 0;
  l = 0;
  paused = true;
  crashed = false;
  screen = 1;
}

void keyPressed(){
  if(screen == 1){
    //different key inputs for each control scheme
    if(ControlScheme == 1){
      if(keyCode == LEFT){
        if(paused == false){
          carx -= 200;
          if(carx < 40) carx = 40;//cannot move car off screen
        }
        else if(paused == true) carx += 0;//cannot move car while paused
      }
      if(keyCode == RIGHT){
        if(paused == false){
          carx += 200;
          if(carx > 440) carx = 440;//cannot move car off screen
        }
        else if(paused == true) carx += 0;
      }
      if(keyCode == ENTER){
        if(paused == true) paused = false;
        else if(paused == false) paused = true;
      }
    }
    else if(ControlScheme == 2){
      if(key == 'a'){
        if(paused == false){
          carx -= 200;
          if(carx < 40) carx = 40;//cannot move car off screen
        }
        else if(paused == true) carx += 0;//cannot move car while paused
      }
      if(key == 'd'){
        if(paused == false){
          carx += 200;
          if(carx > 440) carx = 440;//cannot move car off screen
        }
        else if(paused == true) carx += 0;
      }
      else if(keyCode == ENTER){
        if(paused == true) paused = false;
        else if(paused == false) paused = true;
      }
    }
  }
}

void mousePressed(){
  if(screen == 0){//Main Menu Screen
    if(mouseX > 0 && mouseX < 515 && mouseY > 40 && mouseY < 1000 || mouseX > 515 && mouseX < 600 && mouseY > 40 && mouseY < 1000 || mouseX > 0 && mouseX < 515 && mouseY > 0 && mouseY < 40) screen = 1;
    else if(mouseX >= 555 && mouseX < 600 && mouseY > 0 && mouseY < 40) exit();
    else if(mouseX > 515 && mouseX <= 555 && mouseY > 0 && mouseY < 40) screen = 3;//settings
  }
  else if(screen == 1){//Main Game Screen
    if(mouseX >= 555 && mouseX < 600 && mouseY > 0 && mouseY < 40) exit();
    else if(mouseX > 515 && mouseX < 555 && mouseY > 0 && mouseY < 40) Restart();
    else if(mouseX > 480 && mouseX <= 515 && mouseY > 0 && mouseY < 40) screen = 3;//settings
  }
  else if(screen == 2){//Game Over Screen
    if(mouseX >= 555 && mouseX < 600 && mouseY > 0 && mouseY < 40) exit();//close symbol in top right corner
    else if(mouseX > 515 && mouseX < 555 && mouseY > 0 && mouseY < 40) Restart();//restart symbol in top right corner
    else if(mouseX > 90 && mouseX < 290 && mouseY > 630 && mouseY < 690) Restart();//restart button on screen
    else if(mouseX > 360 && mouseX < 500 && mouseY > 630 && mouseY < 690) exit();//quit button on screen
    else if(mouseX > 480 && mouseX <= 515 && mouseY > 0 && mouseY < 40) screen = 3;
  }
  else if(screen == 3){//settings screen
    if(mouseX >= 555 && mouseX < 600 && mouseY > 0 && mouseY < 40) exit();
    else if(mouseX > 500 && mouseX < 540 && mouseY > 0 && mouseY < 40){
      if(crashed == true) screen = 2;//prevents game from being restarted by going to the settings menu
      else if(crashed == false) screen = 1;//return to game
    }
    //change car color in settings menu
    if(mouseX > 70 && mouseX < 90 && mouseY > 250 && mouseY < 270) UserCar = "Orange Car";
    else if(mouseX > 160 && mouseX < 180 && mouseY > 250 && mouseY < 270) UserCar = "Blue Car";
    else if(mouseX > 250 && mouseX < 270 && mouseY > 250 && mouseY < 270) UserCar = "Dark Gray Car";
    else if(mouseX > 360 && mouseX < 380 && mouseY > 250 && mouseY < 270) UserCar = "Light Gray Car";
    else if(mouseX > 70 && mouseX < 90 && mouseY > 310 && mouseY < 330) UserCar = "Dark Green Car";
    else if(mouseX > 160 && mouseX < 180 && mouseY > 310 && mouseY < 330) UserCar = "Green Car";
    else if(mouseX > 250 && mouseX < 270 && mouseY > 310 && mouseY < 330) UserCar = "Light Green Car";
    else if(mouseX > 360 && mouseX < 380 && mouseY > 310 && mouseY < 330) UserCar = "Turquoise Car";
    
    //change control scheme in settings menu
    if(mouseX > 200 && mouseX < 220 && mouseY > 460 && mouseY < 480) ControlScheme = 1;
    else if(mouseX > 200 && mouseX < 220 && mouseY > 540 && mouseY < 560) ControlScheme = 2;
  }
}
