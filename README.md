# Brick Breaker
![Brick Breaker](https://github.com/shakedmeg/BrickBreaker/blob/master/ReadMeImages/Regular.png?raw=true)

## Overview
This is a small version of the classic Brick Breaker game.  
Written in lua with Löve engine 11.3.


## Installation
In order to run the game do the following:  
1. [Install Love 11.3](https://love2d.org/#download)
2. Download all the games files and put them into a zip file.  
3. Create the relevant execution file depending on your OS, this [link](https://love2d.org/wiki/Game_Distribution#Creating_a_Windows_Executable) covers it.  

## Design Layout
![Brick Breaker](https://github.com/shakedmeg/BrickBreaker/blob/master/ReadMeImages/designLayout.png?raw=true)
### Description
Upon running Main the game will load all scenes, and objects. It will initiate the MainPanel Scene and will wait for the player's Input (clicking on the Start Button).
Main's gotoScene is a quick way to delete the current scene and initiate a new one.
Once switched to a Level scene, the level will initiate a "blocksZone" which is a rectangle that its x and y bounds cover all of the game's block.  
Each level initializes its blocks in a 2D array under the variable blocks.  
#### Collisions  
Once switched to a Level scene, the level will initiate a "blocksZone" which is a rectangle that its x and y bounds cover all of the game's block.  
Each level initializes its blocks in a 2D array under the variable blocks.  
Every update the level's collision manager will check if a part of the ball is in the blocksZone, if it will look for collisions between the ball and the blocks.  
It does so by converting the ball's position into indexes. And checking whether there is a collision between the ball and the specific block.  
If a collision had occurred the ball will change either its x direction, y direction or both.  

#### Shooting
Upon a block's destruction the level's shooting manager will determine the fire rate.  
Fire rate will increase 3 times during a level - every time 25% of the blocks gets destroyed.  
If the player had died shooting will resume only after the block had been destroyed.  

## Game Features
1. Gameplay: Move the paddle with the mouse, left click to release the ball.
2. Objective: Destroy all bricks with the ball to move to the next level, drop the ball or get hit by a projectile and you'll lose a life (the game gives you three tries) 
3. Multiple Levels: The game has multi-level support (there are two sample levels, and a general main panel).
4. Difficulty: As the game Progresses and more bricks get destroyed, the bricks will fire projectiles at the player (fire rate increases as more bricks get destroyed).
    ![In game projectiles](https://github.com/shakedmeg/BrickBreaker/blob/master/ReadMeImages/GameWithProjectiles.png?raw=true)

## Libraries
I am using these external libraries under the Lib folder:
+ Oop - For basic object oriented design in lua
+ Timer - For scheduling the execution of functions
+ Input - For easier access of the player's input
