//in this file structs and necessary global variables are defined
//***************************************************************
#ifndef PINGPONG_H
#define PINGPONG_H

enum {
  AM_PINGPONG = 5, //type of message expected by motes
  TIMER_PERIOD_MILLI = 1000 //period of timer used
};
//this struct is used for message delivery in order to keep data serialized
typedef nx_struct PingPongMsg {
  nx_uint16_t nodeid;
  nx_uint8_t moteState;
} PingPongMsg;

#endif