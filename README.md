# Snake-Game-on-Basys-3
[CS M152A Lab 4 Report.pdf](https://github.com/NhanNg52/Snake-Game-on-Basys-3/files/14826592/CS.M152A.Lab.4.Report.pdf)

Designing Snake Game on Basys-3 with VGA and Joystick Pmod
March 2024 ~ Julia Gu, Huu Nhan Nguyen ~

<I> INTRODUCTION AND REQUIREMENTS
Background information about the a snake game:
A snake game is a classic video game where the player(s) can control a snake that moves around a bounded area, such as a blue screen in this case. The objective is typically to eat food items that appear randomly on the screen. As the snake consumes food, it will grow longer, which will make it progressively more challenging to navigate without colliding with itself or hitting the boundaries.
The game ends when the snake collides with itself or a boundary. Unlike the typical version with a timer, our version will allow players to play until the body of the snake fills the screen, which means that if there are no pixels on the screen available for the food items, then the screen will show the number of food items collected. Players with more apples (red pixels) will be winners.
Required hardware components:
Our design requires a Basys 3 Board to map the Verilog code to the peripheral, a VGA Connector to display the game on a monitor that supports a resolution of 640x480, and a joystick Pmod in header JB to control the snake's movements. The input received by the joystick will be mapped onto one of four directions. Additionally, the on-board push buttons will aid in state transitions.
     
 <II> DESIGN DESCRIPTION
Overall Design:
The modules in our design can be categorized into one of two types. The first are those that interface with our peripherals, specifically the joystick Pmod and the VGA port. The second type are those that manage the internal logic of the program, the most important of which are Master_state_machine and Snake_control.
BREAKDOWN:
The Master_state_machine module determines which of the START, PLAY, and LOST states the program is in, and the Snake_control module stores the current length and position of the snake,
determines the color of a given cell of the grid, and updates the grid when the snake reaches a target. The random_num_gen and Navigation_state_machine modules support the Snake_control module by determining the location of the target and enforcing the directions that the snake is allowed to take given its current direction. All these modules are submodules of the top snake_wrapper module, as shown below.  The Master_state_machine module simply implements a Mealy FSM with three states controlled by two user inputs and one program flag:
  
The Snake_control module takes in the current state of the program from Master_state_machine, the current direction of the snake from Navigation_state_machine, the position of the target from random_num_gen, and the current cell being displayed from VGA_module.
Internally, the Snake_control module behaves differently according to the state of the program. The START state is the simplest, with static graphics. The PLAY state uses the position of the current cell to
determine the color that the VGA should display. It compares the positions of the snake’s head and the target and decides whether or not the length of the snake should be updated and a new target generated. It also uses the position of the head to detect collisions with the wall or itself. In the LOST state, Snake_control calculates from the final length the number of targets that should be displayed on the loss screen. In all states, the position of the snake is updated according to its direction with the following logic:
Although we did not write the random_num_gen module, it contains two sets of linear (XNOR) feedback shift registers, one to generate a value for the nine-bit horizontal coordinate and one to generate a value for the eight-bit vertical coordinate. It is enabled when the Snake_control module indicates that the snake has reached the target, and Snake_control uses the newly generated horizontal and vertical position as the new position of the target.
The Navigation_state_machine module is mentioned above. Like the Master_state_machine module, the Navigation_state_machine module is a Mealy FSM. It takes one-hot encoded user
direction input and determines whether to ignore it or act on it based on the current direction of the snake. If the snake is currently moving upwards, say, the FSM allows the snake to change direction from UP to LEFT or UP to RIGHT, but not from UP to DOWN. Similar logic applies to all other directions.
      
 These are the modules that determine the internal logic of the program, but we also have modules that allow input and output. For the majority of these, we adapted existing code to fit our needs. Analyzing the joystick Pmod on a high level, we have two clock dividers: one with a period of 50 ms to drive data transmission to and from the joystick, and one with a period of 15 μs to drive the serial clock of the SPI interface. We use the value produced in the x-axis and the value produced in the y-axis to determine the direction in which the snake should move. Although the joystick limits input to a circular region, the values along each axis are given between 0 and 1023. The priority encoder is as follows:
For VGA_module on the other hand, we see that it has several Generic_counter submodules: one to lower the refresh rate of the screen from 100MHz to 25MHz, one to determine the horizontal coordinate of the next pixel to be shown, and one to determine the vertical coordinate of the next pixel to be shown. The horizontal counter is enabled when the refresh counter overflows, and the vertical counter is enabled when the horizontal counter overflows. If the position of the next pixel is within bounds of the active display after some offsets, then the color determined by Snake_control is displayed. Otherwise, the pixel is left unilluminated.
   Here, the Generic_counter submodule is simply a counter that increments an internal count every time it is enabled and drives a trigger high when the count resets itself.

 <III> SIMULATION DOCUMENTATION
The design that the design description outlines is not the original design we proposed — it evolved as we implemented our design. Importantly, we struggled to correct the resolution of our VGA module. We were able to obtain working code, but we chose to consolidate all screens into the Snake_control module to reduce the number of modules that required VGA input.
→→
We could not display the game on the screen through the VGA connector as shown on the first picture above, which prevented us from testing the code logic. As a result, we had to delay the joystick Pmod to focus on the VGA. By testing step by step, including the color default setting between VGA and the monitor, we were eventually able to display some color blocks on the monitor.
Other challenges:
Most of the challenges we faced during the development process were related to synchronization. For one, we encountered an issue with clock synchronizations that only allowed the snake to turn every other cell. During the testing of our program, we found that we could not reproduce the error when we lowered the speed of the snake. After several more trials, we determined that the bug originated from the fact that the program updated the snake’s position faster than the joystick’s send/receive rate. The program thus did not consistently receive the joystick input in time to turn. To resolve this, we simply increased the send/receive rate to twice the speed of the snake to guarantee that the program is able to respond to directional input without a significant delay.
We also found in our testing that our program consistently incremented the length of the snake by two for every target that the snake reached, despite our code indicating that it should increment by one. We traced it back to the fact that the speed of our clock signal was several times faster than the speed of updates to the snake and corrected this error by ensuring that the TARGET_REACHED flag in Snake_control could only be driven high if it was previously low.
Other test cases:
- The snake dies when it collides with itself (Passed)
- The snake dies when it collides with the boundaries/walls (Passed)
- The snake is able to eat all the apples which randomly appear on the screen (Passed)
- The snake cannot go beyond the boundaries (Passed)
- The game displays the correct number of targets on the loss screen (Passed)
      
 <IV> CONCLUSION
In conclusion, the implementation was successful — the Verilog code displayed the game on the monitor as planned.
We created several modules to achieve this result. Many of those that determine the game logic are simple selectors. Master_state_machine selects the state of the program to display, VGA_module selects the specific pixel to display on the monitor, Navigation_state_machine selects the direction the snake is moving from the signals of Pmod_JSTK_demo, and random_num_gen selects the location of the target. Snake_controller modifies its behavior according to these selects. It uses the state of the game to determine the color of each pixel, with the additional responsibility of tracking the length and location of the snake and determining collision.
There are some bugs that occurred during the test cases such as VGA disconnection or joystick incompatibility. However, we were able to finish the demo on time with additional time and support from others.
Some ideas for improvement:
The demo could be made more appealing by implementing:
- A timer to pressure players,
- A scoreboard to display the current apple that the snake ate in real-time,
- A speaker to cheer winners, or to make a sound when the snake moves.
- The LED lights on Basys 3 board to keep track of different players, and
- Switches to set up different levels of the snake's speed.

  
<V> ACKNOWLEDGEMENTS
We would like to extend our gratitude to Melissa Chen for a reference to VGA starter code and Josh Sackos from Digilent for his joystick control code. We also drew design inspiration from many, including Vladislav Rumiantsev in his implementation of a variation of the game, and benefited from VGA resources created by Will Green on his site projectf.io. Most of all, we would like to thank our TA Daniel Smith for his support during this lab and beyond.
      
