// CONFIGURATION FILE:On this file,each component which is used or must be linked in our code is declared
//*******************************************************************************************************//
#define NEW_PRINTF_SEMANTICS //must be declared in order to use printf function for debbuging reasons
#include "printf.h"
#include "PingPong.h"
configuration PingPongAppC
{
}
implementation
{
  components MainC, PingPongC, LedsC, UserButtonC, PrintfC, SerialStartC, ActiveMessageC;
  components new TimerMilliC() as Timer0;
  components new AMSenderC(AM_PINGPONG);
  components new AMReceiverC(AM_PINGPONG);


  PingPongC -> MainC.Boot;

  PingPongC.Timer0 -> Timer0;
  PingPongC.Get -> UserButtonC;
  PingPongC.Notify -> UserButtonC;
  PingPongC.Leds -> LedsC;
  PingPongC.Packet -> AMSenderC;
  PingPongC.AMPacket -> AMSenderC;
  PingPongC.AMControl -> ActiveMessageC;
  PingPongC.AMSend -> AMSenderC;
  PingPongC.Receive -> AMReceiverC;
}