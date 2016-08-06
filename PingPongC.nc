// MODULE:This file contains the executable logic of our code
//
// Our implementation sets a "status" variable to check weather motes are in 
// state of exchanging messages or in idle state.
//
// Depending on which state motes are,1st and last leds are highlighted for the first case
// and second led is highlighted when motes are idle.  

#include "Timer.h"
#include "printf.h"
#include "PingPong.h"
#include <UserButton.h>

module PingPongC @safe()
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Leds;
  uses interface Boot;
  uses interface Notify<button_state_t>;
  uses interface Get<button_state_t>;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
}
implementation
{
  uint8_t status=0;
  uint8_t moteState;
  message_t pkt;
  bool busy = FALSE;
  bool onStop=FALSE;
  
  void sendMsg(uint8_t myState)//send message function.Message is encoded as a payload and gets transmitted to the other nodeid
								//each message contains the node id of sender mote and the status in which both motes should be.
  {
    if (!busy) {
        PingPongMsg* pipopkt = (PingPongMsg*)(call Packet.getPayload(&pkt, sizeof(PingPongMsg)));
        if (pipopkt == NULL) {
			return;
        }
        pipopkt->nodeid = TOS_NODE_ID;
        pipopkt->moteState = myState;
        printf("nodeid=%u moteState=%u\n", pipopkt->nodeid, pipopkt->moteState);
        printfflush();
        if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(PingPongMsg)) == SUCCESS) {
            busy = TRUE;
        }
    }
  }

  event void Boot.booted() //initial state
  {
	call Notify.enable();
    call AMControl.start();
	call Leds.led0Off();
	call Leds.led1On();
    call Leds.led2Off();
  }

  event void Notify.notify( button_state_t state ) //command to be called when button is pressed.It toggles mote status and depending
													//on status,the message which will be sent
  {
    if ( state == BUTTON_PRESSED ){
		if (status==0) status=1;
		else status=0;
		if (status==1){
			printf("Button Pressed!!\n");
			printfflush();
			sendMsg(1);
		}
		else 
		{
			call Leds.led0Off();
			call Leds.led1On();
			call Leds.led2Off();
			sendMsg(0);      
		}
	}
  }

	event void AMControl.startDone(error_t err) {
		if (err != SUCCESS) call AMControl.start();
  }

  event void AMControl.stopDone(error_t err) {}

//We want to simulate a sleep period of 1 sec.After it,both active leds are set to off and  "pong" message is sent.
  event void Timer0.fired()
  {
		printf("On timer status= %u\n",status);
		printfflush();
		call Leds.led0Off();
		call Leds.led2Off();
		if (status==1) sendMsg(1);
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      printf("Message Send OK\n");
      printfflush();
      busy = FALSE;
    }
  }
  //depending on the received message mote may continue being in previous state or toggle its state
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(PingPongMsg)) {
      PingPongMsg* pipopkt = (PingPongMsg*)payload;
      printf("Message %u Received Status= %u\n",pipopkt->moteState, status);
      if (pipopkt->moteState==1){
        call Leds.led0On();
	    call Leds.led1Off();
        call Leds.led2On();
        call Timer0.startOneShot(TIMER_PERIOD_MILLI); //fire a timer to simulate a sleep period of 1 second.
		status=1;      
		}
		else{
			call Leds.led0Off();
			call Leds.led1On();
			call Leds.led2Off();
			status=0;
		}
    }
    return msg;
  }

}
