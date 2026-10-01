//+------------------------------------------------------------------+
//|                                                         Mama.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\DealInfo.mqh>
#include <Trade\PositionInfo.mqh>


//DESCRIPCION:MAMA  de compras y ventas con un trade por señal y un trade por barra.
CTrade trades;
CAccountInfo accountInfo;
CDealInfo deal;
CPositionInfo position;
input double current_lot = 0.1;
int Sells;
int Buys;
double Array_1[],Array_2[];
input int SL=20;
input int PRICES_1 = 0;
input int PRICES_2 = 0;
input int PRICES_3 = 0;
input int PRICES_4 = 0;
input int PRICES_5=0;
input int PRICES_6 = 0;
input int PRICES_7 = 0;
input int PRICES_8 = 0;
input int PRICES_9 = 0;
input int PRICES_10 = 0;
input int PRICES_11 = 0;

double  SL_MULT=0.5;
input int RSI_PER=14;
input int MOM_PER=14;
input int k_PER = 5;
input int D_PER = 3;
input int SLOW=3;
input int k_PER_CC = 5;
input int D_PER_CC = 3;
input int SLOW_CC=3;
input int MACD_FAST_EMA_PER = 12;
input int MACD_SLOW_EMA_PER = 26;
input int MACD_SIGAL_PER=9;
input int ATR_PER=14;
input double MOMENTUM_BUY_FILTRO=100;
input double MOMENTUM_SELL_FILTRO=100;
input double MACD_BUY_FILTRO=0.001;
input double MACD_SELL_FILTRO=0.001;
input double ATR_BUY_FILTRO = 0.01;
input double ATR_SELL_FILTRO = 0.01;

double sl_mama,tp_mama;
input int control_sell=0,control_buy=0;
input int Cont1=0,Cont2=0,Cont3=0,Cont4=0,Cont5=0,Cont6=0,Cont7=0,Cont8=0;
input int Length1=14,Length2=14,Length3=14,Length4=14,Length5=14,Length6=14,Length7=14,Length8=14,Length9=14,Length10=14,Length11=14,Length12=14;
input int ba1=2,ba2=2;
input int dev1=2,dev2=2,dev3=2,dev4=2,dev5=2,dev6=2,dev7=2,dev8=2,dev9=2,dev10=2,dev11=2,dev12=2;
input double double_dev1=2.0,double_dev2=2.0,double_dev3=2.0,double_dev4=2.0;
input double sar_period_1=0.02,sar_period_2=0.02,sar_period_3=0.02,sar_period_4=0.02;
input int price1=0,price2=0,price3=0,price4=0,price5=0,price6=0,price7=0,price8=0,price9=0,price10=0;
input ulong MagicNumber=20261099;
input int Slippage=150;
double Indicator;
double ranges[];
int indicator;
double ranges2_[];
int indicator2;
double ranges3_[];
int indicator3;
double ranges4_[];
int indicator4;
double ranges5_[];
int indicator5;
double ranges6_[];
int indicator6;
double ranges7_[];
int indicator7;
double ranges8_[];
int indicator8;
double ranges9_[];
int indicator9;
double ranges10_[];
int indicator10;
double ranges11_[];
int indicator11;
double ranges12_[];
int indicator12;
int period_buffer=100;


ulong Ticket;
double profit_trade;
datetime time1;
datetime Time[];

double ROC_ATR0,ROC_ATR1;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   trades.SetExpertMagicNumber(MagicNumber);
   trades.SetMarginMode();
   trades.SetDeviationInPoints(Slippage);
   ArraySetAsSeries(Time,true);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

  function_ranges(Cont1,PRICES_4,Length1,Length2,Length3,sar_period_1,dev1,dev2,dev3,double_dev1);
   function_ranges_2(Cont2,PRICES_5,Length4,Length5,Length6,sar_period_2,dev4,dev5,dev6,double_dev2);
   function_ranges_3(Cont3,PRICES_6,Length7,Length8,Length9,sar_period_3,dev7,dev8,dev9,double_dev3);
   function_ranges_4(Cont4,PRICES_7,Length10,Length11,Length12,sar_period_4,dev10,dev11,dev12,double_dev4);
  

function_ranges_5(Cont5,PRICES_8,Length5,Length2,Length3,sar_period_1,dev1,dev2,dev3,double_dev1);
   function_ranges_6(Cont6,PRICES_9,Length6,Length2,Length3,sar_period_1,dev1,dev2,dev3,double_dev1);
   function_ranges_7(Cont7,PRICES_10,Length7,Length2,Length3,sar_period_1,dev1,dev2,dev3,double_dev1);
   function_ranges_8(Cont8,PRICES_11,Length8,Length2,Length3,sar_period_1,dev1,dev2,dev3,double_dev1);
   /*function_ranges_9(Cont9,Length9,Length2,Length3,sar_period_1,dev1,dev2,dev3,double_dev1);
   function_ranges_10(Cont10,Length10,Length2,Length3,sar_period_1,dev1,dev2,dev3,double_dev1);
   function_ranges_11(Cont11,Length11,Length2,Length3,sar_period_1,dev1,dev2,dev3,double_dev1);
   function_ranges_12(Cont12,Length12,Length2,Length3,sar_period_1,dev1,dev2,dev3,double_dev1);*/
//RSI
   double rsi_array[];
   int MyRSI=iRSI(NULL,0,RSI_PER,PRICES_1);
   ArraySetAsSeries(rsi_array,true);
   CopyBuffer(MyRSI,0,0,3,rsi_array);
   double RSI_VALUE_1 = NormalizeDouble(rsi_array[1],2); //Current bar rsi value
   double RSI_VALUE_2 = NormalizeDouble(rsi_array[2],2); //Current bar rsi value

                                                         //MOMENTUM
   double pricearray[];
   int momentumdefinition=iMomentum(NULL,0,MOM_PER,PRICES_2);
   ArraySetAsSeries(pricearray,true);
   CopyBuffer(momentumdefinition,0,0,3,pricearray);
   double Momentum_Value_1 = NormalizeDouble(pricearray[1],2);
   double Momentum_Value_2 = NormalizeDouble(pricearray[2],2);

//STOCHASTICO_LH
   double KArray[];
   double DArray[];
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   int StochasticDEfinition=iStochastic(NULL,0,k_PER,D_PER,SLOW,MODE_EMA,STO_LOWHIGH);
   CopyBuffer(StochasticDEfinition,0,0,3,KArray);
   CopyBuffer(StochasticDEfinition,1,0,3,DArray);
   double KValue_1 = KArray[1];
   double DValue_1 = DArray[1];
   double KValue_2 = KArray[2];
   double DValue_2 = DArray[2];


//STOCHASTICO_CC
   double KArray_CC[];
   double DArray_CC[];
   ArraySetAsSeries(KArray_CC,true);
   ArraySetAsSeries(DArray_CC,true);
   int StochasticDEfinition_CC=iStochastic(NULL,0,k_PER_CC,D_PER_CC,SLOW_CC,MODE_EMA,STO_CLOSECLOSE);
   CopyBuffer(StochasticDEfinition_CC,0,0,3,KArray_CC);
   CopyBuffer(StochasticDEfinition_CC,1,0,3,DArray_CC);
   double KValue_CC_1 = KArray_CC[1];
   double DValue_CC_1 = DArray_CC[1];
   double KValue_CC_2 = KArray_CC[2];
   double DValue_CC_2 = DArray_CC[2];

//MACD
   double MACD_Array[];
   int macddefinition=iMACD(NULL,0,MACD_FAST_EMA_PER,MACD_SLOW_EMA_PER,MACD_SIGAL_PER,PRICES_3);
   ArraySetAsSeries(MACD_Array,true);
   CopyBuffer(macddefinition,0,0,3,MACD_Array);
   double MACD_VALUE_1=(MACD_Array[1]);
   double MACD_VALUE_2=(MACD_Array[2]);


//ATR
   double ATRArray[];
   int ATRdefinition=iATR(NULL,0,ATR_PER);
   ArraySetAsSeries(ATRArray,true);
   CopyBuffer(ATRdefinition,0,0,3,ATRArray);
   double ATR_VALUE_1 = ATRArray[1];
   double ATR_VALUE_2 = ATRArray[2];


/*
   HistorySelect(0,TimeCurrent());
   int count = 0;
   for(int i=HistoryDealsTotal()-1; i>=0; i--){
      Ticket= HistoryDealGetTicket(i);
      profit_trade= HistoryDealGetDouble(Ticket,DEAL_PROFIT);
       if(HistoryDealGetInteger(Ticket,DEAL_MAGIC)==MagicNumber) {
         if(profit_trade<0){*/
/*lots_trade=HistoryDealGetDouble(Ticket,DEAL_VOLUME);
            last_day_order = HistoryDealGetInteger(Ticket,DEAL_TIME);*/
/*    count = count +1;   
         }
         if(profit_trade > 0){
            break;
         }      
      }
   }
      if(count == 0){
         current_lot = 0.01;
      }else if(count == 1 ){
          current_lot = 0.01;
      }else if(count == 2){
         current_lot = 0.01;
      }else if(count == 3){
         current_lot = 0.01;
      }else if(count ==4 ){
         current_lot = 0.02;
      }else if(count ==5 ){
         current_lot = 0.03;
      }else if(count ==6 ){
         current_lot = 0.03;
      }else if(count == 7){
         current_lot = 0.05;
      }else if(count ==8 ){
         current_lot = 0.06;
      }else if(count == 9){
         current_lot = 0.08;
      }else if(count == 10){
         current_lot = 0.11;
      }else if(count ==11 ){
         current_lot = 0.15;
      }else if(count ==12 ){
         current_lot = 0.2;
      }else if(count ==13 ){
         current_lot = 0.26;
      }else if(count ==14 ){
         current_lot = 0.35;
      }else if(count >= 15){
         current_lot = 0.47;
      }*/
   CopyTime(_Symbol,0,0,10,Time);
   int ticket_b=-1;
   int ticket_s=-1;
   MqlTick last_tick;
   if(SymbolInfoTick(Symbol(),last_tick))
     {
      Count();
      switch(control_buy)
        {
         //sencillos
         /////////////////////////////////////
         case 1:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges[ba1])
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 2:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[1])
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 3:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[ba1])
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 4:
            if(time1!=Time[0] && Buys==0 && iClose(_Symbol,0,0)>NormalizeDouble(ranges[1],6))
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

            ////////////////////////////////ATR
         case 5:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges[ba1] && ATR_VALUE_1>ATR_VALUE_2 && ATR_VALUE_1>ATR_BUY_FILTRO)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 6:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[1] && ATR_VALUE_1>ATR_VALUE_2 && ATR_VALUE_1>ATR_BUY_FILTRO)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 7:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[ba1] && ATR_VALUE_1>ATR_VALUE_2 && ATR_VALUE_1>ATR_BUY_FILTRO)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 8:
            if(time1!=Time[0] && Buys==0 && iClose(_Symbol,0,0)>NormalizeDouble(ranges[1],6) && ATR_VALUE_1>ATR_VALUE_2 && ATR_VALUE_1>ATR_BUY_FILTRO)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //RSI
            /////////////////////////////////////
         case 9:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges[ba1] && RSI_VALUE_1>RSI_VALUE_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 10:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[1] && RSI_VALUE_1>RSI_VALUE_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 11:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[ba1] && RSI_VALUE_1>RSI_VALUE_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 12:
            if(time1!=Time[0] && Buys==0 && iClose(_Symbol,0,0)>NormalizeDouble(ranges[1],6) && RSI_VALUE_1>RSI_VALUE_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //MOMENTUM
            /////////////////////////////////////
         case 13:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges[ba1] && Momentum_Value_1>MOMENTUM_BUY_FILTRO && Momentum_Value_1>Momentum_Value_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 14:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[1] && Momentum_Value_1>MOMENTUM_BUY_FILTRO && Momentum_Value_1>Momentum_Value_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 15:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[ba1] && Momentum_Value_1>MOMENTUM_BUY_FILTRO && Momentum_Value_1>Momentum_Value_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 16:
            if(time1!=Time[0] && Buys==0 && iClose(_Symbol,0,0)>NormalizeDouble(ranges[1],6) && Momentum_Value_1>MOMENTUM_BUY_FILTRO && Momentum_Value_1>Momentum_Value_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //STOCHASTIC_HL  
            /////////////////////////////////////
         case 17:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges[ba1] && KValue_1>DValue_1 && KValue_1>KValue_2 && DValue_1>DValue_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 18:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[1] && KValue_1>DValue_1 && KValue_1>KValue_2 && DValue_1>DValue_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 19:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[ba1] && KValue_1>DValue_1 && KValue_1>KValue_2 && DValue_1>DValue_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 20:
            if(time1!=Time[0] && Buys==0 && iClose(_Symbol,0,0)>NormalizeDouble(ranges[1],6) && KValue_1>DValue_1 && KValue_1>KValue_2 && DValue_1>DValue_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

           /////////////////////////////////////
           //STOCH CH
           /////////////////////////////////////
         case 21:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges[ba1] && KValue_CC_1>DValue_CC_1 && KValue_CC_1>KValue_CC_2 && DValue_CC_1>DValue_CC_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 22:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[1] && KValue_CC_1>DValue_CC_1 && KValue_CC_1>KValue_CC_2 && DValue_CC_1>DValue_CC_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 23:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[ba1] && KValue_CC_1>DValue_CC_1 && KValue_CC_1>KValue_CC_2 && DValue_CC_1>DValue_CC_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 24:
            if(time1!=Time[0] && Buys==0 && iClose(_Symbol,0,0)>NormalizeDouble(ranges[1],6) && KValue_CC_1>DValue_CC_1 && KValue_CC_1>KValue_CC_2 && DValue_CC_1>DValue_CC_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //MACD
            /////////////////////////////////////
         case 25:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges[ba1] && MACD_VALUE_1>MACD_BUY_FILTRO && MACD_VALUE_1>MACD_VALUE_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 26:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[1] && MACD_VALUE_1>MACD_BUY_FILTRO && MACD_VALUE_1>MACD_VALUE_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 27:
            if(time1!=Time[0] && Buys==0 && ranges[1]>ranges2_[ba1] && MACD_VALUE_1>MACD_BUY_FILTRO && MACD_VALUE_1>MACD_VALUE_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 28:
            if(time1!=Time[0] && Buys==0 && iClose(_Symbol,0,0)>NormalizeDouble(ranges[1],6) && MACD_VALUE_1>MACD_BUY_FILTRO && MACD_VALUE_1>MACD_VALUE_2)
              {
               sl_mama = last_tick.ask-(SL)*Point();
               tp_mama = last_tick.ask+(SL*SL_MULT)*Point();
               ticket_b=trades.Buy(current_lot,Symbol(),last_tick.ask,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

        }

      
      switch(control_sell)
        {   /////////////////////////////////////
         case 1:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges3_[ba2])
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 2:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[1])
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 3:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[ba2])
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 4:
            if(time1!=Time[0] && Sells==0 && iClose(_Symbol,0,0)<NormalizeDouble(ranges3_[1],6))
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //ATR
            /////////////////////////////////////
         case 5:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges3_[ba2] && ATR_VALUE_1>ATR_SELL_FILTRO && ATR_VALUE_1>ATR_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 6:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[1] && ATR_VALUE_1>ATR_SELL_FILTRO && ATR_VALUE_1>ATR_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 7:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[ba2] && ATR_VALUE_1>ATR_SELL_FILTRO && ATR_VALUE_1>ATR_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 8:
            if(time1!=Time[0] && Sells==0 && iClose(_Symbol,0,0)<NormalizeDouble(ranges3_[1],6) && ATR_VALUE_1>ATR_SELL_FILTRO && ATR_VALUE_1>ATR_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //RSI
            /////////////////////////////////////
         case 9:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges3_[ba2] && RSI_VALUE_1<RSI_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 10:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[1] && RSI_VALUE_1<RSI_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 11:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[ba2] && RSI_VALUE_1<RSI_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 12:
            if(time1!=Time[0] && Sells==0 && iClose(_Symbol,0,0)<NormalizeDouble(ranges3_[1],6) && RSI_VALUE_1<RSI_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //MOMENTUM
            /////////////////////////////////////
         case 13:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges3_[ba2] && Momentum_Value_1<MOMENTUM_SELL_FILTRO && Momentum_Value_1<Momentum_Value_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 14:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[1] && Momentum_Value_1<MOMENTUM_SELL_FILTRO && Momentum_Value_1<Momentum_Value_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.bid-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 15:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[ba2] && Momentum_Value_1<MOMENTUM_SELL_FILTRO && Momentum_Value_1<Momentum_Value_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.bid-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 16:
            if(time1!=Time[0] && Sells==0 && iClose(_Symbol,0,0)<NormalizeDouble(ranges3_[1],6) && Momentum_Value_1<MOMENTUM_SELL_FILTRO && Momentum_Value_1<Momentum_Value_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.bid-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //STOCHASTIC_HL  
            /////////////////////////////////////
         case 17:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges3_[ba2] && KValue_1<DValue_1 && KValue_1<KValue_2 && DValue_1<DValue_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.bid-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 18:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[1] && KValue_1<DValue_1 && KValue_1<KValue_2 && DValue_1<DValue_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.bid-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 19:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[ba2] && KValue_1<DValue_1 && KValue_1<KValue_2 && DValue_1<DValue_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.bid-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 20:
            if(time1!=Time[0] && Sells==0 && iClose(_Symbol,0,0)<NormalizeDouble(ranges3_[1],6) && KValue_1<DValue_1 && KValue_1<KValue_2 && DValue_1<DValue_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //STOCH_CC
            /////////////////////////////////////
         case 21:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges3_[ba2] && KValue_CC_1<DValue_CC_1 && KValue_CC_1<KValue_CC_2 && DValue_CC_1<DValue_CC_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 22:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[1] && KValue_CC_1<DValue_CC_1 && KValue_CC_1<KValue_CC_2 && DValue_CC_1<DValue_CC_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 23:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[ba2] && KValue_CC_1<DValue_CC_1 && KValue_CC_1<KValue_CC_2 && DValue_CC_1<DValue_CC_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 24:
            if(time1!=Time[0] && Sells==0 && iClose(_Symbol,0,0)<NormalizeDouble(ranges3_[1],6) && KValue_CC_1<DValue_CC_1 && KValue_CC_1<KValue_CC_2 && DValue_CC_1<DValue_CC_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////
            //MACD
            /////////////////////////////////////
         case 25:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges3_[ba2] && MACD_VALUE_1<MACD_SELL_FILTRO && MACD_VALUE_1<MACD_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }

            break;

         case 26:
            if(time1!=Time[0] && Sells==0 && ranges3_[1] < ranges4_[1] && MACD_VALUE_1<MACD_SELL_FILTRO && MACD_VALUE_1<MACD_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];

              }
            break;

         case 27:
            if(time1!=Time[0] && Sells==0 && ranges3_[1]<ranges4_[ba2] && MACD_VALUE_1<MACD_SELL_FILTRO && MACD_VALUE_1<MACD_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;

         case 28:
            if(time1!=Time[0] && Sells==0 && iClose(_Symbol,0,0)<NormalizeDouble(ranges3_[1],6) && MACD_VALUE_1<MACD_SELL_FILTRO && MACD_VALUE_1<MACD_VALUE_2)
              {
               sl_mama = last_tick.ask+(SL)*Point();
               tp_mama = last_tick.ask-(SL*SL_MULT)*Point();
               ticket_s=trades.Sell(current_lot,Symbol(),last_tick.bid,sl_mama,tp_mama,NULL);
               time1=Time[0];
              }
            break;
            /////////////////////////////////////

        }
     }
  }
//+------------------------------------------------------------------+
bool function_ranges(int control_ranges,int priceConstant,int period_ranges_1,int period_ranges_2,int period_ranges_3,double period_sar_1,int desviation_1,int desviation_2,int desviation_3,double desviation_1_double)
  {
   switch(control_ranges)
     {
      case 0:
         indicator=iMA(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 1:
         indicator=iMA(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 2:
         indicator=iMA(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 3:
         indicator=iMA(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 4:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 5:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,1,0,period_buffer,ranges);
         break;
      case 6:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,2,0,period_buffer,ranges);
         break;
      case 7:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 8:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,1,0,period_buffer,ranges);
         break;
      case 9:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,2,0,period_buffer,ranges);
         break;
      case 10:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 11:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,1,0,period_buffer,ranges);
         break;
      case 12:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,2,0,period_buffer,ranges);
         break;
      case 13:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 14:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,1,0,period_buffer,ranges);
         break;
      case 15:
         indicator=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,2,0,period_buffer,ranges);
         break;
      case 16:
         indicator=iAMA(_Symbol,0,period_ranges_1,period_ranges_2,period_ranges_3,0,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 17:
         indicator=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 18:
         indicator=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,1,0,period_buffer,ranges);
         break;
      case 19:
         indicator=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,2,0,period_buffer,ranges);
         break;
      case 20:
         indicator=iDEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 21:
         indicator=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 22:
         indicator=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,1,0,period_buffer,ranges);
         break;
      case 23:
         indicator=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 24:
         indicator=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,1,0,period_buffer,ranges);
         break;
      case 25:
         indicator=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 26:
         indicator=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,1,0,period_buffer,ranges);
         break;
      case 27:
         indicator=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 28:
         indicator=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,1,0,period_buffer,ranges);
         break;
      case 29:
         indicator=iSAR(_Symbol,0,period_sar_1,0.2);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 30:
         indicator=iTEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
      case 31:
         indicator=iVIDyA(_Symbol,0,period_ranges_1,period_ranges_2,0,priceConstant);
         ArraySetAsSeries(ranges,true);
         CopyBuffer(indicator,0,0,period_buffer,ranges);
         break;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool function_ranges_2(int control_ranges,int priceConstant,int period_ranges_1,int period_ranges_2,int period_ranges_3,double period_sar_1,int desviation_1,int desviation_2,int desviation_3,double desviation_1_double)
  {
   switch(control_ranges)
     {
      case 0:
         indicator2=iMA(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 1:
         indicator2=iMA(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 2:
         indicator2=iMA(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 3:
         indicator2=iMA(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 4:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 5:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,1,0,period_buffer,ranges2_);
         break;
      case 6:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,2,0,period_buffer,ranges2_);
         break;
      case 7:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 8:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,1,0,period_buffer,ranges2_);
         break;
      case 9:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,2,0,period_buffer,ranges2_);
         break;
      case 10:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 11:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,1,0,period_buffer,ranges2_);
         break;
      case 12:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,2,0,period_buffer,ranges2_);
         break;
      case 13:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 14:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,1,0,period_buffer,ranges2_);
         break;
      case 15:
         indicator2=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,2,0,period_buffer,ranges2_);
         break;
      case 16:
         indicator2=iAMA(_Symbol,0,period_ranges_1,period_ranges_2,period_ranges_3,0,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 17:
         indicator2=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 18:
         indicator2=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,1,0,period_buffer,ranges2_);
         break;
      case 19:
         indicator2=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,2,0,period_buffer,ranges2_);
         break;
      case 20:
         indicator2=iDEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 21:
         indicator2=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 22:
         indicator2=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,1,0,period_buffer,ranges2_);
         break;
      case 23:
         indicator2=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 24:
         indicator2=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,1,0,period_buffer,ranges2_);
         break;
      case 25:
         indicator2=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 26:
         indicator2=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,1,0,period_buffer,ranges2_);
         break;
      case 27:
         indicator2=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 28:
         indicator2=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,1,0,period_buffer,ranges2_);
         break;
      case 29:
         indicator2=iSAR(_Symbol,0,period_sar_1,0.2);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 30:
         indicator2=iTEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
      case 31:
         indicator2=iVIDyA(_Symbol,0,period_ranges_1,period_ranges_2,0,priceConstant);
         ArraySetAsSeries(ranges2_,true);
         CopyBuffer(indicator2,0,0,period_buffer,ranges2_);
         break;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool function_ranges_3(int control_ranges,int priceConstant,int period_ranges_1,int period_ranges_2,int period_ranges_3,double period_sar_1,int desviation_1,int desviation_2,int desviation_3,double desviation_1_double)
  {
   switch(control_ranges)
     {
      case 0:
         indicator3=iMA(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 1:
         indicator3=iMA(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 2:
         indicator3=iMA(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 3:
         indicator3=iMA(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 4:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 5:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,1,0,period_buffer,ranges3_);
         break;
      case 6:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,2,0,period_buffer,ranges3_);
         break;
      case 7:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 8:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,1,0,period_buffer,ranges3_);
         break;
      case 9:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,2,0,period_buffer,ranges3_);
         break;
      case 10:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 11:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,1,0,period_buffer,ranges3_);
         break;
      case 12:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,2,0,period_buffer,ranges3_);
         break;
      case 13:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 14:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,1,0,period_buffer,ranges3_);
         break;
      case 15:
         indicator3=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,2,0,period_buffer,ranges3_);
         break;
      case 16:
         indicator3=iAMA(_Symbol,0,period_ranges_1,period_ranges_2,period_ranges_3,0,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 17:
         indicator3=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 18:
         indicator3=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,1,0,period_buffer,ranges3_);
         break;
      case 19:
         indicator3=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,2,0,period_buffer,ranges3_);
         break;
      case 20:
         indicator3=iDEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 21:
         indicator3=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 22:
         indicator3=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,1,0,period_buffer,ranges3_);
         break;
      case 23:
         indicator3=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 24:
         indicator3=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,1,0,period_buffer,ranges3_);
         break;
      case 25:
         indicator3=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 26:
         indicator3=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,1,0,period_buffer,ranges3_);
         break;
      case 27:
         indicator3=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 28:
         indicator3=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,1,0,period_buffer,ranges3_);
         break;
      case 29:
         indicator3=iSAR(_Symbol,0,period_sar_1,0.2);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 30:
         indicator3=iTEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
      case 31:
         indicator3=iVIDyA(_Symbol,0,period_ranges_1,period_ranges_2,0,priceConstant);
         ArraySetAsSeries(ranges3_,true);
         CopyBuffer(indicator3,0,0,period_buffer,ranges3_);
         break;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool function_ranges_4(int control_ranges,int priceConstant,int period_ranges_1,int period_ranges_2,int period_ranges_3,double period_sar_1,int desviation_1,int desviation_2,int desviation_3,double desviation_1_double)
  {
   switch(control_ranges)
     {
      case 0:
         indicator4=iMA(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 1:
         indicator4=iMA(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 2:
         indicator4=iMA(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 3:
         indicator4=iMA(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 4:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 5:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,1,0,period_buffer,ranges4_);
         break;
      case 6:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,2,0,period_buffer,ranges4_);
         break;
      case 7:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 8:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,1,0,period_buffer,ranges4_);
         break;
      case 9:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,2,0,period_buffer,ranges4_);
         break;
      case 10:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 11:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,1,0,period_buffer,ranges4_);
         break;
      case 12:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,2,0,period_buffer,ranges4_);
         break;
      case 13:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 14:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,1,0,period_buffer,ranges4_);
         break;
      case 15:
         indicator4=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,2,0,period_buffer,ranges4_);
         break;
      case 16:
         indicator4=iAMA(_Symbol,0,period_ranges_1,period_ranges_2,period_ranges_3,0,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 17:
         indicator4=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 18:
         indicator4=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,1,0,period_buffer,ranges4_);
         break;
      case 19:
         indicator4=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,2,0,period_buffer,ranges4_);
         break;
      case 20:
         indicator4=iDEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 21:
         indicator4=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 22:
         indicator4=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,1,0,period_buffer,ranges4_);
         break;
      case 23:
         indicator4=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 24:
         indicator4=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,1,0,period_buffer,ranges4_);
         break;
      case 25:
         indicator4=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 26:
         indicator4=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,1,0,period_buffer,ranges4_);
         break;
      case 27:
         indicator4=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 28:
         indicator4=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,1,0,period_buffer,ranges4_);
         break;
      case 29:
         indicator4=iSAR(_Symbol,0,period_sar_1,0.2);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 30:
         indicator4=iTEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
      case 31:
         indicator4=iVIDyA(_Symbol,0,period_ranges_1,period_ranges_2,0,priceConstant);
         ArraySetAsSeries(ranges4_,true);
         CopyBuffer(indicator4,0,0,period_buffer,ranges4_);
         break;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool function_ranges_5(int control_ranges,int priceConstant,int period_ranges_1,int period_ranges_2,int period_ranges_3,double period_sar_1,int desviation_1,int desviation_2,int desviation_3,double desviation_1_double)
  {
   switch(control_ranges)
     {
      case 0:
         indicator5=iMA(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 1:
         indicator5=iMA(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 2:
         indicator5=iMA(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 3:
         indicator5=iMA(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 4:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 5:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,1,0,period_buffer,ranges5_);
         break;
      case 6:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,2,0,period_buffer,ranges5_);
         break;
      case 7:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 8:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,1,0,period_buffer,ranges5_);
         break;
      case 9:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,2,0,period_buffer,ranges5_);
         break;
      case 10:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 11:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,1,0,period_buffer,ranges5_);
         break;
      case 12:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,2,0,period_buffer,ranges5_);
         break;
      case 13:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 14:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,1,0,period_buffer,ranges5_);
         break;
      case 15:
         indicator5=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,2,0,period_buffer,ranges5_);
         break;
      case 16:
         indicator5=iAMA(_Symbol,0,period_ranges_1,period_ranges_2,period_ranges_3,0,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 17:
         indicator5=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 18:
         indicator5=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,1,0,period_buffer,ranges5_);
         break;
      case 19:
         indicator5=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,2,0,period_buffer,ranges5_);
         break;
      case 20:
         indicator5=iDEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 21:
         indicator5=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 22:
         indicator5=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,1,0,period_buffer,ranges5_);
         break;
      case 23:
         indicator5=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 24:
         indicator5=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,1,0,period_buffer,ranges5_);
         break;
      case 25:
         indicator5=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 26:
         indicator5=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,1,0,period_buffer,ranges5_);
         break;
      case 27:
         indicator5=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 28:
         indicator5=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,1,0,period_buffer,ranges5_);
         break;
      case 29:
         indicator5=iSAR(_Symbol,0,period_sar_1,0.2);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 30:
         indicator5=iTEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
      case 31:
         indicator5=iVIDyA(_Symbol,0,period_ranges_1,period_ranges_2,0,priceConstant);
         ArraySetAsSeries(ranges5_,true);
         CopyBuffer(indicator5,0,0,period_buffer,ranges5_);
         break;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool function_ranges_6(int control_ranges,int priceConstant,int period_ranges_1,int period_ranges_2,int period_ranges_3,double period_sar_1,int desviation_1,int desviation_2,int desviation_3,double desviation_1_double)
  {
   switch(control_ranges)
     {
      case 0:
         indicator6=iMA(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 1:
         indicator6=iMA(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 2:
         indicator6=iMA(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 3:
         indicator6=iMA(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 4:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 5:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,1,0,period_buffer,ranges6_);
         break;
      case 6:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,2,0,period_buffer,ranges6_);
         break;
      case 7:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 8:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,1,0,period_buffer,ranges6_);
         break;
      case 9:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,2,0,period_buffer,ranges6_);
         break;
      case 10:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 11:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,1,0,period_buffer,ranges6_);
         break;
      case 12:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,2,0,period_buffer,ranges6_);
         break;
      case 13:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 14:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,1,0,period_buffer,ranges6_);
         break;
      case 15:
         indicator6=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,2,0,period_buffer,ranges6_);
         break;
      case 16:
         indicator6=iAMA(_Symbol,0,period_ranges_1,period_ranges_2,period_ranges_3,0,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 17:
         indicator6=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 18:
         indicator6=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,1,0,period_buffer,ranges6_);
         break;
      case 19:
         indicator6=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,2,0,period_buffer,ranges6_);
         break;
      case 20:
         indicator6=iDEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 21:
         indicator6=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 22:
         indicator6=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,1,0,period_buffer,ranges6_);
         break;
      case 23:
         indicator6=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 24:
         indicator6=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,1,0,period_buffer,ranges6_);
         break;
      case 25:
         indicator6=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 26:
         indicator6=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,1,0,period_buffer,ranges6_);
         break;
      case 27:
         indicator6=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 28:
         indicator6=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,1,0,period_buffer,ranges6_);
         break;
      case 29:
         indicator6=iSAR(_Symbol,0,period_sar_1,0.2);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 30:
         indicator6=iTEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
      case 31:
         indicator6=iVIDyA(_Symbol,0,period_ranges_1,period_ranges_2,0,priceConstant);
         ArraySetAsSeries(ranges6_,true);
         CopyBuffer(indicator6,0,0,period_buffer,ranges6_);
         break;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool function_ranges_7(int control_ranges,int priceConstant,int period_ranges_1,int period_ranges_2,int period_ranges_3,double period_sar_1,int desviation_1,int desviation_2,int desviation_3,double desviation_1_double)
  {
   switch(control_ranges)
     {
      case 0:
         indicator7=iMA(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 1:
         indicator7=iMA(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 2:
         indicator7=iMA(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 3:
         indicator7=iMA(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 4:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 5:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,1,0,period_buffer,ranges7_);
         break;
      case 6:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,2,0,period_buffer,ranges7_);
         break;
      case 7:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 8:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,1,0,period_buffer,ranges7_);
         break;
      case 9:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,2,0,period_buffer,ranges7_);
         break;
      case 10:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 11:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,1,0,period_buffer,ranges7_);
         break;
      case 12:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,2,0,period_buffer,ranges7_);
         break;
      case 13:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 14:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,1,0,period_buffer,ranges7_);
         break;
      case 15:
         indicator7=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,2,0,period_buffer,ranges7_);
         break;
      case 16:
         indicator7=iAMA(_Symbol,0,period_ranges_1,period_ranges_2,period_ranges_3,0,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 17:
         indicator7=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 18:
         indicator7=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,1,0,period_buffer,ranges7_);
         break;
      case 19:
         indicator7=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,2,0,period_buffer,ranges7_);
         break;
      case 20:
         indicator7=iDEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 21:
         indicator7=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 22:
         indicator7=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,1,0,period_buffer,ranges7_);
         break;
      case 23:
         indicator7=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 24:
         indicator7=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,1,0,period_buffer,ranges7_);
         break;
      case 25:
         indicator7=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 26:
         indicator7=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,1,0,period_buffer,ranges7_);
         break;
      case 27:
         indicator7=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 28:
         indicator7=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,1,0,period_buffer,ranges7_);
         break;
      case 29:
         indicator7=iSAR(_Symbol,0,period_sar_1,0.2);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 30:
         indicator7=iTEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
      case 31:
         indicator7=iVIDyA(_Symbol,0,period_ranges_1,period_ranges_2,0,priceConstant);
         ArraySetAsSeries(ranges7_,true);
         CopyBuffer(indicator7,0,0,period_buffer,ranges7_);
         break;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool function_ranges_8(int control_ranges,int priceConstant,int period_ranges_1,int period_ranges_2,int period_ranges_3,double period_sar_1,int desviation_1,int desviation_2,int desviation_3,double desviation_1_double)
  {
   switch(control_ranges)
     {
      case 0:
         indicator8=iMA(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 1:
         indicator8=iMA(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 2:
         indicator8=iMA(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 3:
         indicator8=iMA(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 4:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 5:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,1,0,period_buffer,ranges8_);
         break;
      case 6:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_EMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,2,0,period_buffer,ranges8_);
         break;
      case 7:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 8:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,1,0,period_buffer,ranges8_);
         break;
      case 9:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_LWMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,2,0,period_buffer,ranges8_);
         break;
      case 10:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 11:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,1,0,period_buffer,ranges8_);
         break;
      case 12:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,2,0,period_buffer,ranges8_);
         break;
      case 13:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 14:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,1,0,period_buffer,ranges8_);
         break;
      case 15:
         indicator8=iAlligator(_Symbol,0,period_ranges_1,desviation_1,period_ranges_2,desviation_2,period_ranges_3,desviation_3,MODE_SMMA,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,2,0,period_buffer,ranges8_);
         break;
      case 16:
         indicator8=iAMA(_Symbol,0,period_ranges_1,period_ranges_2,period_ranges_3,0,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 17:
         indicator8=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 18:
         indicator8=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,1,0,period_buffer,ranges8_);
         break;
      case 19:
         indicator8=iBands(_Symbol,0,period_ranges_1,0,desviation_1_double,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,2,0,period_buffer,ranges8_);
         break;
      case 20:
         indicator8=iDEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 21:
         indicator8=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 22:
         indicator8=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_EMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,1,0,period_buffer,ranges8_);
         break;
      case 23:
         indicator8=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 24:
         indicator8=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_LWMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,1,0,period_buffer,ranges8_);
         break;
      case 25:
         indicator8=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 26:
         indicator8=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,1,0,period_buffer,ranges8_);
         break;
      case 27:
         indicator8=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 28:
         indicator8=iEnvelopes(_Symbol,0,period_ranges_1,0,MODE_SMMA,priceConstant,desviation_1_double);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,1,0,period_buffer,ranges8_);
         break;
      case 29:
         indicator8=iSAR(_Symbol,0,period_sar_1,0.2);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 30:
         indicator8=iTEMA(_Symbol,0,period_ranges_1,0,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
      case 31:
         indicator8=iVIDyA(_Symbol,0,period_ranges_1,period_ranges_2,0,priceConstant);
         ArraySetAsSeries(ranges8_,true);
         CopyBuffer(indicator8,0,0,period_buffer,ranges8_);
         break;
     }
   return(true);
  }
///////////////////////////////////////shorts//////////////////////////////////////////////////////////////////////
void Count()
  {
   Buys=0; Sells=0;
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
        {
         if(PositionGetInteger(POSITION_MAGIC)==MagicNumber && PositionGetString(POSITION_SYMBOL)==_Symbol) 
           {
            if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) Buys++;
            if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) Sells++;
           }
        }
     }
  }
//+------------------------------------------------------------------+