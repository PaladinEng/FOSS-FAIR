// PRUSS program to trigger 4 output pins in sequence for a calculated time
// Written by Alwyn Smith for Firefighting Drone Challenge

.setcallreg   r15.w0    // set a register for CALL/RET
.origin 0               // offset of start of program in PRU memory
.entrypoint START       // program entry point used by the debugger

#define PRU0_R31_VEC_VALID  32;
#define PRU_EVTOUT_0        3
#define PRU_EVTOUT_1        4
#define DELAY               200000000 //#instructions for 1 second

// Using register 0 for time-counter storage (reused multiple times)
// Using register 1 to count the number of triggering cycles
// Using register 30 for pin outputs
// Using register 31 for inputs


START:
   // Read number of samples to read and inter-sample delay
   LDI    r1, 30                //set the number of blink cycles

REDON:
   SET    r30.t0                //set P8_45 pin high (RED LED ON)
   MOV    r0, DELAY             //move the 1 second count into R0
   CALL   DELAYON               //start a 1 second delay

REDOFF:
   CLR    r30.t0                //set P8_45 low

WHITEON:
   SET   r30.t1                 //set P8_46 high (WHITE LED ON)
   MOV   r0, DELAY              //move the 1 second count into R0
   CALL  DELAYON                //start a 1 second delay

WHITEOFF:
   CLR   r30.t1                 //set P8_46 low

BLUEON:
   SET   r30.t2                 //set P8_43 high (BLUE LED ON)
   MOV   r0, DELAY              //move the 1 second count into R0
   CALL  DELAYON                //start a 1 second delay

BLUEOFF:
   CLR   r30.t2                 //set P8_43 low

YELLOWON:
   SET   r30.t3                 //set P8_44 high (YELLOW LED ON)
   MOV   r0, DELAY              //move the 1 second count into R0
   CALL  DELAYON                //start a 1 second delay

YELLOWOFF:
   CLR   r30.t3                 //set P8_44 low

CHECK:                          //check to see if loop should continue
   SUB   r1, r1, 1              //reduce the cycle count by 1
   QBNE  REDON, r1, 0           //if cycle count != 0, then start new cycle
   QBEQ  END, r1, 0             //if r1 == 0, then end the program

DELAYON:                        //start a 1 second counter
   SUB    r0, r0, 1             //decrement the counter by 1
   QBNE   DELAYON, r0 , 0       //while count !=0, continue counting
   RET                          //return to calling procedure

END:
   MOV R31.b0, PRU0_R31_VEC_VALID | PRU_EVTOUT_0
   HALT
