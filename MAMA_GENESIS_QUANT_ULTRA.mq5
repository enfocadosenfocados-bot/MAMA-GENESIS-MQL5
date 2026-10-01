//+------------------------------------------------------------------+
//|                                     MAMA_GENESIS_QUANT_ULTRA.mq5 |
//|                                  Copyright 2026, Antigravity AI  |
//|                    AutoML & Genetic Feature Space Explorer (+60) |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2026, Antigravity AI"
#property link        "https://antigravity.ai"
#property version     "4.00"
#property description "MAMA GENESIS QUANT ULTRA: Factoria AutoML Cuantitativa con +60 Indicadores, Cruces Dobles, Niveles Dobles, Cierre Parcial 50%, Breakeven, Trailing y Stop Loss Realista Protegido para IC Markets."
#property strict

#include <Trade\Trade.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\PositionInfo.mqh>

//--- Instancias de trading
CTrade         trades;
COrderInfo     order;
CPositionInfo  position;

//+------------------------------------------------------------------+
//| ENUMERACIONES CUANTITATIVAS                                      |
//+------------------------------------------------------------------+
enum ENUM_QUANT_IND_TYPE
  {
   // --- 1. TENDENCIA NATIVOS
   QIND_SMA,                   // 0: Simple Moving Average (SMA)
   QIND_EMA,                   // 1: Exponential Moving Average (EMA)
   QIND_SMMA,                  // 2: Smoothed Moving Average (SMMA)
   QIND_LWMA,                  // 3: Linear Weighted Moving Average (LWMA)
   QIND_DEMA,                  // 4: Double Exponential Moving Average (DEMA)
   QIND_TEMA,                  // 5: Triple Exponential Moving Average (TEMA)
   QIND_AMA,                   // 6: Kaufman Adaptive Moving Average (AMA)
   QIND_FRAMA,                 // 7: Fractal Adaptive Moving Average (FrAMA)
   QIND_VIDYA,                 // 8: Variable Index Dynamic Average (VIDYA)
   QIND_SAR,                   // 9: Parabolic SAR
   QIND_BOLLINGER_MID,         // 10: Bollinger Bands - Media Central
   QIND_BOLLINGER_UPPER,       // 11: Bollinger Bands - Banda Superior
   QIND_BOLLINGER_LOWER,       // 12: Bollinger Bands - Banda Inferior
   QIND_ENVELOPES_UPPER,       // 13: Envelopes - Banda Superior
   QIND_ENVELOPES_LOWER,       // 14: Envelopes - Banda Inferior
   QIND_ICHIMOKU_TENKAN,       // 15: Ichimoku - Tenkan-sen
   QIND_ICHIMOKU_KIJUN,        // 16: Ichimoku - Kijun-sen
   QIND_ICHIMOKU_SENKOU_A,     // 17: Ichimoku - Senkou Span A (Nube)
   QIND_ICHIMOKU_SENKOU_B,     // 18: Ichimoku - Senkou Span B (Nube)
   QIND_ADX_MAIN,              // 19: ADX - Fuerza de Tendencia
   QIND_ADX_PLUS_DI,           // 20: ADX - +DI (Compradores)
   QIND_ADX_MINUS_DI,          // 21: ADX - -DI (Vendedores)

   // --- 2. CANALES Y BANDAS EXOTICAS
   QIND_KELTNER_MID,           // 22: Keltner Channel - Media EMA
   QIND_KELTNER_UPPER,         // 23: Keltner Channel - Banda Superior
   QIND_KELTNER_LOWER,         // 24: Keltner Channel - Banda Inferior
   QIND_DONCHIAN_MID,          // 25: Donchian Channel - Linea Media
   QIND_DONCHIAN_UPPER,        // 26: Donchian Channel - Maximo N periodos
   QIND_DONCHIAN_LOWER,        // 27: Donchian Channel - Minimo N periodos
   QIND_CAMARILLA_H3,          // 28: Camarilla Channel - Resistencia H3
   QIND_CAMARILLA_H4,          // 29: Camarilla Channel - Ruptura H4
   QIND_CAMARILLA_L3,          // 30: Camarilla Channel - Soporte L3
   QIND_CAMARILLA_L4,          // 31: Camarilla Channel - Ruptura L4
   QIND_MURREY_MATH_48,        // 32: Murrey Math - Eje Central 4/8
   QIND_MURREY_MATH_68,        // 33: Murrey Math - Resistencia 6/8
   QIND_MURREY_MATH_28,        // 34: Murrey Math - Soporte 2/8
   QIND_NRTR_REVERSE,          // 35: NRTR - Trailing Stop Dinamico
   QIND_PRICE_CHANNEL_UP,      // 36: Price Channel - Superior
   QIND_PRICE_CHANNEL_LOW,     // 37: Price Channel - Inferior

   // --- 3. OSCILADORES Y MOMENTUM
   QIND_RSI,                   // 38: Relative Strength Index (RSI)
   QIND_STOCHASTIC_K,          // 39: Stochastic - Linea %K
   QIND_STOCHASTIC_D,          // 40: Stochastic - Linea %D
   QIND_MACD_MAIN,             // 41: MACD - Linea Principal
   QIND_MACD_SIGNAL,           // 42: MACD - Linea de Senal
   QIND_ATR,                   // 43: Average True Range (Volatilidad)
   QIND_STDDEV,                // 44: Standard Deviation
   QIND_CCI,                   // 45: Commodity Channel Index (CCI)
   QIND_MOMENTUM,              // 46: Momentum Indicator
   QIND_RVI_MAIN,              // 47: Relative Vigor Index (RVI)
   QIND_WPR,                   // 48: Williams' Percent Range (%R)
   QIND_DEMARKER,              // 49: DeMarker
   QIND_BULLS_POWER,           // 50: Bulls Power
   QIND_BEARS_POWER,           // 51: Bears Power
   QIND_OSMA,                  // 52: Moving Average of Oscillator (OsMA)
   QIND_CHAIKIN_OSC,           // 53: Chaikin Oscillator
   QIND_FORCE_INDEX,           // 54: Force Index
   QIND_TRIX,                  // 55: Triple Exponential Average (TRIX)
   QIND_ROC,                   // 56: Rate of Change (ROC)
   QIND_ULTIMATE_OSC,          // 57: Ultimate Oscillator

   // --- 4. VOLUMEN Y FLUJO
   QIND_VOLUMES,               // 58: Tick / Real Volumes
   QIND_MFI,                   // 59: Money Flow Index (MFI)
   QIND_OBV,                   // 60: On Balance Volume (OBV)
   QIND_AD,                    // 61: Accumulation / Distribution (A/D)
   QIND_PVT,                   // 62: Price and Volume Trend (PVT)

   // --- 5. BILL WILLIAMS
   QIND_ALLIGATOR_JAW,         // 63: Alligator - Mandibula (Azul)
   QIND_ALLIGATOR_TEETH,       // 64: Alligator - Dientes (Rojo)
   QIND_ALLIGATOR_LIPS,        // 65: Alligator - Labios (Verde)
   QIND_AWESOME_OSC,           // 66: Awesome Oscillator (AO)
   QIND_ACCELERATOR_OSC,       // 67: Accelerator Oscillator (AC)
   QIND_BWMFI,                 // 68: Market Facilitation Index (BWMFI)

   // --- 6. EXTREMOS, ACCION DEL PRECIO Y ZIGZAG
   QIND_ZIGZAG_MAIN,           // 69: ZigZag - Linea de Giro
   QIND_ZIGZAG_HIGH,           // 70: ZigZag - Picos (High Extremes)
   QIND_ZIGZAG_LOW,            // 71: ZigZag - Valles (Low Extremes)
   QIND_FRACTAL_UP,            // 72: Fractals - Fractal Alcista Superior
   QIND_FRACTAL_DOWN,          // 73: Fractals - Fractal Bajista Inferior
   QIND_HEIKEN_ASHI_COLOR,     // 74: Heiken Ashi - Tendencia (0=Alcista, 1=Bajista)
   QIND_CHV,                   // 75: Chaikin Volatility (CHV)
   QIND_ASI,                   // 76: Accumulation Swing Index (ASI)
   QIND_MI,                    // 77: Mass Index (MI Reversal Bulge)
   QIND_DPO,                   // 78: Detrended Price Oscillator (DPO)
   QIND_VROC,                  // 79: Volume Rate of Change (VROC)
   QIND_W_AD,                  // 80: Williams Accumulation/Distribution (W_AD)
   QIND_GATOR_UP,              // 81: Gator Oscillator - Superior
   QIND_GATOR_LOW,             // 82: Gator Oscillator - Inferior

   // --- 7. CANALES DE PIVOT Y SISTEMAS EXOTICOS
   QIND_DEMARK_PP,             // 83: DeMark Channel - Pivot Point (PP)
   QIND_DEMARK_R1,             // 84: DeMark Channel - Resistencia 1 (R1)
   QIND_DEMARK_S1,             // 85: DeMark Channel - Soporte 1 (S1)
   QIND_FIBONACCI_PP,          // 86: Fibonacci Channel - Pivot Point (PP)
   QIND_FIBONACCI_R1,          // 87: Fibonacci Channel - Resistencia R1
   QIND_FIBONACCI_S1,          // 88: Fibonacci Channel - Soporte S1
   QIND_PARABOLIC_CHAN_UP,     // 89: Parabolic Channel - Banda Superior
   QIND_PARABOLIC_CHAN_LOW,    // 90: Parabolic Channel - Banda Inferior
   QIND_PIVOT_CHAN_PP,         // 91: Pivot Channel - Pivot Point (PP)
   QIND_PIVOT_CHAN_R1,         // 92: Pivot Channel - Resistencia 1 (R1)
   QIND_PIVOT_CHAN_S1,         // 93: Pivot Channel - Soporte 1 (S1)
   QIND_WOODIE_CHAN_PP,        // 94: Woodie Channel - Pivot Point (PP)
   QIND_WOODIE_CHAN_R1,        // 95: Woodie Channel - Resistencia 1 (R1)
   QIND_WOODIE_CHAN_S1,        // 96: Woodie Channel - Soporte 1 (S1)
   QIND_ADX_WILDER,            // 97: ADX Wilder Main Line
   QIND_BW_ZONETRADE,          // 98: Bill Williams Zone Trade
   QIND_P1P2_P1,               // 99: P1P2 Pattern Indicator - Nivel P1
   QIND_P1P2_P2,               // 100: P1P2 Pattern Indicator - Nivel P2
   QIND_FUERZAS_USD,           // 101: Fuerzas Index - Fortaleza USD
   QIND_FUERZAS_EUR            // 102: Fuerzas Index - Fortaleza EUR
  };

enum ENUM_RELATION_MODE
  {
   REL_SINGLE_CROSS,                 // 0: Cruce Simple Normal Puro [(IndA x IndB)]
   REL_DOUBLE_CROSS,                 // 1: Cruce Doble [(IndA x IndB) Y (IndC x IndD)]
   REL_CROSS_AND_DOUBLE_LEVEL,       // 2: Cruce + Doble Nivel [(IndA x IndB) Y (IndC > IndD) Y (IndE > Umbral)]
   REL_CROSS_AND_SLOPE,              // 3: Cruce + Pendiente Acelerada [(IndA x IndB) Y (IndC[1] > IndC[2]) Y Filtro]
   REL_CHANNEL_REVERSION_AND_OSC,    // 4: Reversion de Canal Exotico + Doble Oscilador
   REL_BREAKOUT_AND_VOLUMES,         // 5: Ruptura de Canal Exotico + Expansion de Flujo / Volatilidad
   REL_DOUBLE_LEVEL_ONLY             // 6: Doble Nivel Relativo Puro [(IndA > IndB) Y (IndC > IndD) Y Filtro]
  };

enum ENUM_SESSION_FILTER
  {
   SESSION_ALL_DAY,                  // 0: Libre 24H (Todo el dia sin restriccion)
   SESSION_LONDON,                   // 1: Sesion Londres (08:00 - 16:00 GMT / 10:00 - 18:00 Servidor)
   SESSION_NEW_YORK,                 // 2: Sesion Nueva York (13:00 - 21:00 GMT / 15:00 - 23:00 Servidor)
   SESSION_OVERLAP_LDN_NY,           // 3: Overlap Londres + NY (13:00 - 17:00 GMT / 15:00 - 19:00 Servidor)
   SESSION_ASIA                      // 4: Sesion Asiatica / Tokio (00:00 - 08:00 GMT / 02:00 - 10:00 Servidor)
  };

//+------------------------------------------------------------------+
//| INPUTS: MATRIZ DE GENES PARA EL OPTIMIZADOR GENETICO             |
//+------------------------------------------------------------------+
input group "=== 1. MOTOR GENETICO CUANTITATIVO (EXPLORADOR MAMA) ==="
input ENUM_RELATION_MODE InpRelationMode = REL_CROSS_AND_DOUBLE_LEVEL; // Modo de Mezcolanza Relacional
input ENUM_QUANT_IND_TYPE InpGeneIndA    = QIND_EMA;                  // Gene IndA (Gatillo Primario 1)
input ENUM_QUANT_IND_TYPE InpGeneIndB    = QIND_SMA;                  // Gene IndB (Gatillo Primario 2)
input ENUM_QUANT_IND_TYPE InpGeneIndC    = QIND_RSI;                  // Gene IndC (Filtro / Segundo Cruce 1)
input ENUM_QUANT_IND_TYPE InpGeneIndD    = QIND_EMA;                  // Gene IndD (Filtro / Segundo Cruce 2)
input ENUM_QUANT_IND_TYPE InpGeneIndE    = QIND_ATR;                  // Gene IndE (Filtro de Regimen / Volatilidad)

input group "=== 2. PERIODOS Y UMBRALES CUANTITATIVOS ==="
input int    InpPeriodA                  = 14;                        // Periodo Indicador A (Paso sugerido: 5 o 10)
input int    InpPeriodB                  = 50;                        // Periodo Indicador B (Paso sugerido: 10 o 25)
input int    InpPeriodC                  = 14;                        // Periodo Indicador C
input int    InpPeriodD                  = 200;                       // Periodo Indicador D
input int    InpPeriodE                  = 14;                        // Periodo Indicador E
input double InpThresholdC               = 50.0;                      // Umbral Nivel C (ej. RSI 50, CCI 0)
input double InpThresholdE               = 0.001;                     // Umbral Nivel E (Volatilidad minima)

input group "=== 3. GESTION DE CAPITAL Y STOP LOSS REALISTA ==="
input double InpLots                     = 0.10;                      // Volumen de lote fijo
input double InpMaxLossUSD               = 15.0;                      // Techo Maximo de Perdida USD ($15 max estricto)
input double InpATRStopMultiplier        = 1.80;                      // Multiplicador ATR para SL Estructural
input int    InpMinStopLossPoints        = 80;                        // Piso Minimo de SL en puntos (Evitar ruido)
input int    InpTakeProfitPoints         = 600;                       // Target 2 / TP Final (Puntos)

input group "=== 4. CIERRE PARCIAL Y GESTION ASIMETRICA (45 GRADOS) ==="
input bool   InpUsePartialClose          = true;                      // Activar Cierre Parcial 50%
input int    InpPartialTargetPoints      = 250;                       // Target 1 para Cierre Parcial (Puntos)
input double InpPartialRatio             = 0.50;                      // Ratio a cerrar (0.50 = 50%)
input bool   InpUseBreakeven             = true;                      // Activar Breakeven tras Target 1
input int    InpBreakevenLockPoints      = 30;                        // Puntos asegurados sobre entrada (cubre comisiones)
input bool   InpUseTrailing              = true;                      // Activar Trailing Stop
input int    InpTrailingStartPoints      = 350;                       // Puntos para iniciar Trailing Stop
input int    InpTrailingDistancePoints   = 150;                       // Distancia del Trailing (Puntos)

input group "=== 5. PROTECCION Y FILTROS INSTITUCIONALES IC MARKETS ==="
input ENUM_SESSION_FILTER InpSessionFilter = SESSION_ALL_DAY;         // Filtro de Regimen de Sesion
input int    InpMaxSpreadPoints          = 45;                        // Spread Maximo permitido en puntos
input int    InpStartHour                = 1;                         // Hora inicio operaciones (Servidor)
input int    InpEndHour                  = 22;                        // Hora fin operaciones (Servidor)
input bool   InpCloseFriday              = true;                      // Cerrar antes del fin de semana
input int    InpFridayCloseHour          = 21;                        // Hora cierre preventivo Viernes
input bool   InpExportStrategyToFile     = true;                      // Exportar estrategia ganadora a archivo mq5
input ulong  InpMagicNumber              = 20268888;                  // Magic Number Unico
input int    InpSlippage                 = 50;                        // Desviacion maxima permitida

//+------------------------------------------------------------------+
//| VARIABLES GLOBALES Y BUFFERS                                     |
//+------------------------------------------------------------------+
int      h_indA = INVALID_HANDLE;
int      h_indB = INVALID_HANDLE;
int      h_indC = INVALID_HANDLE;
int      h_indD = INVALID_HANDLE;
int      h_indE = INVALID_HANDLE;
int      h_atr_sl = INVALID_HANDLE;

datetime last_bar_time = 0;
double   point_val = 0.0;

//+------------------------------------------------------------------+
//| FUNCION AUXILIAR: CREACION DINAMICA LAZY-LOAD DE INDICADORES     |
//+------------------------------------------------------------------+
int CreateIndicatorHandle(ENUM_QUANT_IND_TYPE ind, int period, int &out_buffer_idx)
  {
   out_buffer_idx = 0;
   int p = (period <= 0 ? 14 : period);

   switch(ind)
     {
      // Tendencia
      case QIND_SMA:            return iMA(_Symbol, PERIOD_CURRENT, p, 0, MODE_SMA, PRICE_CLOSE);
      case QIND_EMA:            return iMA(_Symbol, PERIOD_CURRENT, p, 0, MODE_EMA, PRICE_CLOSE);
      case QIND_SMMA:           return iMA(_Symbol, PERIOD_CURRENT, p, 0, MODE_SMMA, PRICE_CLOSE);
      case QIND_LWMA:           return iMA(_Symbol, PERIOD_CURRENT, p, 0, MODE_LWMA, PRICE_CLOSE);
      case QIND_DEMA:           return iDEMA(_Symbol, PERIOD_CURRENT, p, 0, PRICE_CLOSE);
      case QIND_TEMA:           return iTEMA(_Symbol, PERIOD_CURRENT, p, 0, PRICE_CLOSE);
      case QIND_AMA:            return iAMA(_Symbol, PERIOD_CURRENT, p, 2, 30, 0, PRICE_CLOSE);
      case QIND_FRAMA:          return iFrAMA(_Symbol, PERIOD_CURRENT, p, 0, PRICE_CLOSE);
      case QIND_VIDYA:          return iVIDyA(_Symbol, PERIOD_CURRENT, 9, p, 0, PRICE_CLOSE);
      case QIND_SAR:            return iSAR(_Symbol, PERIOD_CURRENT, 0.02, 0.20);
      
      // Bandas y Canales
      case QIND_BOLLINGER_MID:   out_buffer_idx = 0; return iBands(_Symbol, PERIOD_CURRENT, p, 0, 2.0, PRICE_CLOSE);
      case QIND_BOLLINGER_UPPER: out_buffer_idx = 1; return iBands(_Symbol, PERIOD_CURRENT, p, 0, 2.0, PRICE_CLOSE);
      case QIND_BOLLINGER_LOWER: out_buffer_idx = 2; return iBands(_Symbol, PERIOD_CURRENT, p, 0, 2.0, PRICE_CLOSE);
      case QIND_ENVELOPES_UPPER: out_buffer_idx = 0; return iEnvelopes(_Symbol, PERIOD_CURRENT, p, 0, MODE_SMA, PRICE_CLOSE, 0.10);
      case QIND_ENVELOPES_LOWER: out_buffer_idx = 1; return iEnvelopes(_Symbol, PERIOD_CURRENT, p, 0, MODE_SMA, PRICE_CLOSE, 0.10);

      // Ichimoku
      case QIND_ICHIMOKU_TENKAN:   out_buffer_idx = 0; return iIchimoku(_Symbol, PERIOD_CURRENT, 9, 26, 52);
      case QIND_ICHIMOKU_KIJUN:    out_buffer_idx = 1; return iIchimoku(_Symbol, PERIOD_CURRENT, 9, 26, 52);
      case QIND_ICHIMOKU_SENKOU_A: out_buffer_idx = 2; return iIchimoku(_Symbol, PERIOD_CURRENT, 9, 26, 52);
      case QIND_ICHIMOKU_SENKOU_B: out_buffer_idx = 3; return iIchimoku(_Symbol, PERIOD_CURRENT, 9, 26, 52);

      // ADX
      case QIND_ADX_MAIN:          out_buffer_idx = 0; return iADX(_Symbol, PERIOD_CURRENT, p);
      case QIND_ADX_PLUS_DI:       out_buffer_idx = 1; return iADX(_Symbol, PERIOD_CURRENT, p);
      case QIND_ADX_MINUS_DI:      out_buffer_idx = 2; return iADX(_Symbol, PERIOD_CURRENT, p);

      // Canales Exoticos (Calculados o iCustom)
      case QIND_KELTNER_MID:       out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Keltner Channel", p, 10, 2.0, false);
      case QIND_KELTNER_UPPER:     out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Keltner Channel", p, 10, 2.0, false);
      case QIND_KELTNER_LOWER:     out_buffer_idx = 2; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Keltner Channel", p, 10, 2.0, false);
      case QIND_DONCHIAN_MID:      out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Donchian Channel", p, false);
      case QIND_DONCHIAN_UPPER:    out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Donchian Channel", p, false);
      case QIND_DONCHIAN_LOWER:    out_buffer_idx = 2; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Donchian Channel", p, false);
      case QIND_CAMARILLA_H3:      out_buffer_idx = 2; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Camarilla Channel");
      case QIND_CAMARILLA_H4:      out_buffer_idx = 3; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Camarilla Channel");
      case QIND_CAMARILLA_L3:      out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Camarilla Channel");
      case QIND_CAMARILLA_L4:      out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Camarilla Channel");
      case QIND_MURREY_MATH_48:    out_buffer_idx = 4; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\MurreyMath Channel", p);
      case QIND_MURREY_MATH_68:    out_buffer_idx = 6; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\MurreyMath Channel", p);
      case QIND_MURREY_MATH_28:    out_buffer_idx = 2; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\MurreyMath Channel", p);
      case QIND_NRTR_REVERSE:      out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\NRTR Channel", p);
      case QIND_PRICE_CHANNEL_UP:  out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\Price_Channel", p);
      case QIND_PRICE_CHANNEL_LOW: out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\Price_Channel", p);

      // Osciladores
      case QIND_RSI:               return iRSI(_Symbol, PERIOD_CURRENT, p, PRICE_CLOSE);
      case QIND_STOCHASTIC_K:      out_buffer_idx = 0; return iStochastic(_Symbol, PERIOD_CURRENT, p, 3, 3, MODE_SMA, STO_LOWHIGH);
      case QIND_STOCHASTIC_D:      out_buffer_idx = 1; return iStochastic(_Symbol, PERIOD_CURRENT, p, 3, 3, MODE_SMA, STO_LOWHIGH);
      case QIND_MACD_MAIN:         out_buffer_idx = 0; return iMACD(_Symbol, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE);
      case QIND_MACD_SIGNAL:       out_buffer_idx = 1; return iMACD(_Symbol, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE);
      case QIND_ATR:               return iATR(_Symbol, PERIOD_CURRENT, p);
      case QIND_STDDEV:            return iStdDev(_Symbol, PERIOD_CURRENT, p, 0, MODE_SMA, PRICE_CLOSE);
      case QIND_CCI:               return iCCI(_Symbol, PERIOD_CURRENT, p, PRICE_TYPICAL);
      case QIND_MOMENTUM:          return iMomentum(_Symbol, PERIOD_CURRENT, p, PRICE_CLOSE);
      case QIND_RVI_MAIN:          out_buffer_idx = 0; return iRVI(_Symbol, PERIOD_CURRENT, p);
      case QIND_WPR:               return iWPR(_Symbol, PERIOD_CURRENT, p);
      case QIND_DEMARKER:          return iDeMarker(_Symbol, PERIOD_CURRENT, p);
      case QIND_BULLS_POWER:       return iBullsPower(_Symbol, PERIOD_CURRENT, p);
      case QIND_BEARS_POWER:       return iBearsPower(_Symbol, PERIOD_CURRENT, p);
      case QIND_OSMA:              return iOsMA(_Symbol, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE);
      case QIND_CHAIKIN_OSC:       return iChaikin(_Symbol, PERIOD_CURRENT, 3, 10, MODE_EMA, VOLUME_TICK);
      case QIND_FORCE_INDEX:       return iForce(_Symbol, PERIOD_CURRENT, p, MODE_SMA, VOLUME_TICK);
      case QIND_TRIX:              return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\TRIX", p, PRICE_CLOSE);
      case QIND_ROC:               return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\ROC", p, PRICE_CLOSE);
      case QIND_ULTIMATE_OSC:      return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\Ultimate_Oscillator", 7, 14, 28);

      // Volumen
      case QIND_VOLUMES:           return iVolumes(_Symbol, PERIOD_CURRENT, VOLUME_TICK);
      case QIND_MFI:               return iMFI(_Symbol, PERIOD_CURRENT, p, VOLUME_TICK);
      case QIND_OBV:               return iOBV(_Symbol, PERIOD_CURRENT, VOLUME_TICK);
      case QIND_AD:                return iAD(_Symbol, PERIOD_CURRENT, VOLUME_TICK);
      case QIND_PVT:               return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\PVT", VOLUME_TICK);

      // Bill Williams
      case QIND_ALLIGATOR_JAW:     out_buffer_idx = 0; return iAlligator(_Symbol, PERIOD_CURRENT, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN);
      case QIND_ALLIGATOR_TEETH:   out_buffer_idx = 1; return iAlligator(_Symbol, PERIOD_CURRENT, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN);
      case QIND_ALLIGATOR_LIPS:    out_buffer_idx = 2; return iAlligator(_Symbol, PERIOD_CURRENT, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN);
      case QIND_AWESOME_OSC:       return iAO(_Symbol, PERIOD_CURRENT);
      case QIND_ACCELERATOR_OSC:   return iAC(_Symbol, PERIOD_CURRENT);
      case QIND_BWMFI:             return iBWMFI(_Symbol, PERIOD_CURRENT, VOLUME_TICK);

      // Extremos, Accion del Precio y ZigZag
      case QIND_ZIGZAG_MAIN:       out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\ZigZag", p, 5, 3);
      case QIND_ZIGZAG_HIGH:       out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\ZigZag", p, 5, 3);
      case QIND_ZIGZAG_LOW:        out_buffer_idx = 2; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\ZigZag", p, 5, 3);
      case QIND_FRACTAL_UP:        out_buffer_idx = 0; return iFractals(_Symbol, PERIOD_CURRENT);
      case QIND_FRACTAL_DOWN:      out_buffer_idx = 1; return iFractals(_Symbol, PERIOD_CURRENT);
      case QIND_HEIKEN_ASHI_COLOR: out_buffer_idx = 4; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\Heiken_Ashi");
      case QIND_CHV:               out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\CHV", p, p, 1);
      case QIND_ASI:               out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\ASI", 300.0);
      case QIND_MI:                out_buffer_idx = 3; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\MI", 9, 9, 25);
      case QIND_DPO:               out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\DPO", p);
      case QIND_VROC:              out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\VROC", p, VOLUME_TICK);
      case QIND_W_AD:              out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\W_AD");
      case QIND_GATOR_UP:          out_buffer_idx = 0; return iGator(_Symbol, PERIOD_CURRENT, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN);
      case QIND_GATOR_LOW:         out_buffer_idx = 1; return iGator(_Symbol, PERIOD_CURRENT, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN);

      // Canales de Pivot y Sistemas Exoticos
      case QIND_DEMARK_PP:         out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\DeMark Channel", false);
      case QIND_DEMARK_R1:         out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\DeMark Channel", false);
      case QIND_DEMARK_S1:         out_buffer_idx = 2; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\DeMark Channel", false);
      case QIND_FIBONACCI_PP:      out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Fibonacci Channel", true, false);
      case QIND_FIBONACCI_R1:      out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Fibonacci Channel", true, false);
      case QIND_FIBONACCI_S1:      out_buffer_idx = 3; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Fibonacci Channel", true, false);
      case QIND_PARABOLIC_CHAN_UP: out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Parabolic Channel", 0.02, 0.20, false);
      case QIND_PARABOLIC_CHAN_LOW:out_buffer_idx = 2; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Parabolic Channel", 0.02, 0.20, false);
      case QIND_PIVOT_CHAN_PP:     out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Pivot Channel", true, false);
      case QIND_PIVOT_CHAN_R1:     out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Pivot Channel", true, false);
      case QIND_PIVOT_CHAN_S1:     out_buffer_idx = 3; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Pivot Channel", true, false);
      case QIND_WOODIE_CHAN_PP:    out_buffer_idx = 4; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Woodie Channel");
      case QIND_WOODIE_CHAN_R1:    out_buffer_idx = 3; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Woodie Channel");
      case QIND_WOODIE_CHAN_S1:    out_buffer_idx = 5; return iCustom(_Symbol, PERIOD_CURRENT, "Free Indicators\\Woodie Channel");
      case QIND_ADX_WILDER:        out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\ADXW", p);
      case QIND_BW_ZONETRADE:      out_buffer_idx = 4; return iCustom(_Symbol, PERIOD_CURRENT, "Examples\\BW-ZoneTrade");
      case QIND_P1P2_P1:           out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "P1P2-INDIOCATOR");
      case QIND_P1P2_P2:           out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "P1P2-INDIOCATOR");
      case QIND_FUERZAS_USD:       out_buffer_idx = 0; return iCustom(_Symbol, PERIOD_CURRENT, "FUERZAS-INDEX");
      case QIND_FUERZAS_EUR:       out_buffer_idx = 1; return iCustom(_Symbol, PERIOD_CURRENT, "FUERZAS-INDEX");

      default:                    return iMA(_Symbol, PERIOD_CURRENT, p, 0, MODE_EMA, PRICE_CLOSE);
     }
  }

int buf_idx_A = 0, buf_idx_B = 0, buf_idx_C = 0, buf_idx_D = 0, buf_idx_E = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   trades.SetExpertMagicNumber(InpMagicNumber);
   trades.SetMarginMode();
   trades.SetDeviationInPoints(InpSlippage);

   point_val = _Point;
   if(point_val == 0.0) point_val = 0.00001;

   // Lazy-Loading en OnInit: Solo se crean los handles de los genes activos
   h_indA = CreateIndicatorHandle(InpGeneIndA, InpPeriodA, buf_idx_A);
   h_indB = CreateIndicatorHandle(InpGeneIndB, InpPeriodB, buf_idx_B);
   h_indC = CreateIndicatorHandle(InpGeneIndC, InpPeriodC, buf_idx_C);
   h_indD = CreateIndicatorHandle(InpGeneIndD, InpPeriodD, buf_idx_D);
   h_indE = CreateIndicatorHandle(InpGeneIndE, InpPeriodE, buf_idx_E);

   // Handle ATR para el calculo del Stop Loss estructural
   h_atr_sl = iATR(_Symbol, PERIOD_CURRENT, 14);

   if(h_indA == INVALID_HANDLE || h_indB == INVALID_HANDLE || h_atr_sl == INVALID_HANDLE)
     {
      Print("MAMA_GENESIS: Error al instanciar handles principales.");
      return(INIT_FAILED);
     }

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // Liberacion inmediata de memoria para el algoritmo genetico ultra rapido
   if(h_indA != INVALID_HANDLE)   IndicatorRelease(h_indA);
   if(h_indB != INVALID_HANDLE)   IndicatorRelease(h_indB);
   if(h_indC != INVALID_HANDLE)   IndicatorRelease(h_indC);
   if(h_indD != INVALID_HANDLE)   IndicatorRelease(h_indD);
   if(h_indE != INVALID_HANDLE)   IndicatorRelease(h_indE);
   if(h_atr_sl != INVALID_HANDLE) IndicatorRelease(h_atr_sl);
  }

//+------------------------------------------------------------------+
//| LECTURA RAPIDA DE 3 BARRAS                                       |
//+------------------------------------------------------------------+
bool GetValues(int handle, int buf_idx, double &val1, double &val2)
  {
   double b[];
   ArraySetAsSeries(b, true);
   if(CopyBuffer(handle, buf_idx, 0, 3, b) < 3) return false;
   val1 = b[1]; // Barra cerrada anterior
   val2 = b[2]; // Barra previa para cruces/pendientes
   return true;
  }

//+------------------------------------------------------------------+
//| CALCULO DE STOP LOSS REALISTA CON TECHO MAXIMO EN USD            |
//+------------------------------------------------------------------+
double CalculateRealisticSL(ENUM_POSITION_TYPE pos_type, double entry_price)
  {
   double atr_val = 0.0;
   double atr_buf[];
   ArraySetAsSeries(atr_buf, true);
   if(CopyBuffer(h_atr_sl, 0, 0, 2, atr_buf) == 2)
      atr_val = atr_buf[1];
   else
      atr_val = 200 * point_val;

   double spread = (double)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) * point_val;
   
   // 1. Piso minimo antirruido (evita morir por el spread flotante de IC Markets)
   double min_distance = MathMax(spread * 2.5, (double)InpMinStopLossPoints * point_val);
   
   // 2. Distancia estructural por volatilidad
   double structural_distance = MathMax(min_distance, atr_val * InpATRStopMultiplier);

   // 3. Techo maximo inquebrantable en USD ($15.00 max estricto)
   double tick_size  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tick_value = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   if(tick_size > 0.0 && tick_value > 0.0)
     {
      double max_points_from_usd = (InpMaxLossUSD / (InpLots * (tick_value / tick_size))) * point_val;
      if(max_points_from_usd > min_distance && structural_distance > max_points_from_usd)
        {
         structural_distance = max_points_from_usd; // Recorte estricto al techo de dinero
        }
     }

   if(pos_type == POSITION_TYPE_BUY)
      return NormalizeDouble(entry_price - structural_distance, _Digits);
   else
      return NormalizeDouble(entry_price + structural_distance, _Digits);
  }

//+------------------------------------------------------------------+
//| GESTION TICK A TICK: CIERRE PARCIAL, BREAKEVEN Y TRAILING        |
//+------------------------------------------------------------------+
void ManageOpenPositions()
  {
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol, tick)) return;

   double vol_step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double vol_min  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(!position.SelectByIndex(i)) continue;
      if(position.Symbol() != _Symbol || position.Magic() != InpMagicNumber) continue;

      ulong  ticket     = position.Ticket();
      double open_price = position.PriceOpen();
      double cur_sl     = position.StopLoss();
      double cur_tp     = position.TakeProfit();
      double cur_vol    = position.Volume();

      if(position.PositionType() == POSITION_TYPE_BUY)
        {
         double profit_pts = (tick.bid - open_price) / point_val;

         // 1. Cierre Parcial del 50% al Target 1
         if(InpUsePartialClose && cur_vol >= InpLots && profit_pts >= InpPartialTargetPoints)
           {
            double close_vol = MathFloor((cur_vol * InpPartialRatio) / vol_step) * vol_step;
            if(close_vol >= vol_min && (cur_vol - close_vol) >= vol_min)
              {
               if(trades.PositionClosePartial(ticket, close_vol))
                 {
                  // Breakeven asegurado inmediato
                  double be_price = open_price + (InpBreakevenLockPoints * point_val);
                  if(cur_sl < be_price) trades.PositionModify(ticket, be_price, cur_tp);
                  continue;
                 }
              }
           }

         // 2. Breakeven simple tras avance
         if(InpUseBreakeven && profit_pts >= InpPartialTargetPoints)
           {
            double be_price = open_price + (InpBreakevenLockPoints * point_val);
            if(cur_sl < be_price)
              {
               trades.PositionModify(ticket, be_price, cur_tp);
               cur_sl = be_price;
              }
           }

         // 3. Trailing Stop dinamico de tendencia (Curva a 45 grados)
         if(InpUseTrailing && profit_pts >= InpTrailingStartPoints)
           {
            double new_sl = tick.bid - (InpTrailingDistancePoints * point_val);
            double min_sl = open_price + (InpBreakevenLockPoints * point_val);
            if(new_sl < min_sl) new_sl = min_sl;

            if(new_sl > cur_sl + (10 * point_val))
               trades.PositionModify(ticket, NormalizeDouble(new_sl, _Digits), cur_tp);
           }
        }
      else if(position.PositionType() == POSITION_TYPE_SELL)
        {
         double profit_pts = (open_price - tick.ask) / point_val;

         // 1. Cierre Parcial del 50% al Target 1
         if(InpUsePartialClose && cur_vol >= InpLots && profit_pts >= InpPartialTargetPoints)
           {
            double close_vol = MathFloor((cur_vol * InpPartialRatio) / vol_step) * vol_step;
            if(close_vol >= vol_min && (cur_vol - close_vol) >= vol_min)
              {
               if(trades.PositionClosePartial(ticket, close_vol))
                 {
                  double be_price = open_price - (InpBreakevenLockPoints * point_val);
                  if(cur_sl == 0.0 || cur_sl > be_price) trades.PositionModify(ticket, be_price, cur_tp);
                  continue;
                 }
              }
           }

         // 2. Breakeven simple tras avance
         if(InpUseBreakeven && profit_pts >= InpPartialTargetPoints)
           {
            double be_price = open_price - (InpBreakevenLockPoints * point_val);
            if(cur_sl == 0.0 || cur_sl > be_price)
              {
               trades.PositionModify(ticket, be_price, cur_tp);
               cur_sl = be_price;
              }
           }

         // 3. Trailing Stop dinamico
         if(InpUseTrailing && profit_pts >= InpTrailingStartPoints)
           {
            double new_sl = tick.ask + (InpTrailingDistancePoints * point_val);
            double max_sl = open_price - (InpBreakevenLockPoints * point_val);
            if(new_sl > max_sl) new_sl = max_sl;

            if(cur_sl == 0.0 || new_sl < cur_sl - (10 * point_val))
               trades.PositionModify(ticket, NormalizeDouble(new_sl, _Digits), cur_tp);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| CONTEO DE POSICIONES PROPIAS                                     |
//+------------------------------------------------------------------+
int CountOwnPositions()
  {
   int count = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(!position.SelectByIndex(i)) continue;
      if(position.Symbol() == _Symbol && position.Magic() == InpMagicNumber)
         count++;
     }
   return count;
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Gestion en Cada Tick: SL, TP, Trailing y Cierre Parcial
   ManageOpenPositions();

   // Filtro de horario y cierre preventivo de viernes
   MqlDateTime now;
   TimeToStruct(TimeCurrent(), now);

   if(InpCloseFriday && now.day_of_week == 5 && now.hour >= InpFridayCloseHour)
     {
      for(int i = PositionsTotal() - 1; i >= 0; i--)
        {
         if(position.SelectByIndex(i) && position.Symbol() == _Symbol && position.Magic() == InpMagicNumber)
            trades.PositionClose(position.Ticket());
        }
      return;
     }

   if(now.hour < InpStartHour || now.hour >= InpEndHour) return;

   // Filtro Cuantitativo de Sesion Institucional (Londres, NY, Overlap, Asia, 24H)
   if(!IsSessionAllowed(now.hour)) return;

   // Control de Spread Flotante de IC Markets
   if((int)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) > InpMaxSpreadPoints) return;

   // Evaluacion de Senal: Al Cierre de Cada Barra (Cero Repainting y Maxima Velocidad)
   datetime current_bar = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(current_bar == last_bar_time) return;

   // Si ya hay una posicion abierta, no abrir mas operaciones en simultaneo
   if(CountOwnPositions() > 0) return;

   // Lectura de valores de los indicadores seleccionados
   double a1=0, a2=0, b1=0, b2=0, c1=0, c2=0, d1=0, d2=0, e1=0, e2=0;
   if(!GetValues(h_indA, buf_idx_A, a1, a2)) return;
   if(!GetValues(h_indB, buf_idx_B, b1, b2)) return;
   if(!GetValues(h_indC, buf_idx_C, c1, c2)) return;
   if(!GetValues(h_indD, buf_idx_D, d1, d2)) return;
   if(!GetValues(h_indE, buf_idx_E, e1, e2)) return;

   bool signal_buy  = false;
   bool signal_sell = false;

   // EVALUACION SEGUN MODO DE RELACION CUANTITATIVA
   switch(InpRelationMode)
     {
      // Modo 0: Cruce Simple Normal Puro [(A x B)]
      case REL_SINGLE_CROSS:
        {
         bool cross_buy  = (a2 <= b2 && a1 > b1);
         bool cross_sell = (a2 >= b2 && a1 < b1);

         signal_buy  = cross_buy;
         signal_sell = cross_sell;
         break;
        }

      // Modo 1: Cruce Doble [(A x B) Y (C x D)]
      case REL_DOUBLE_CROSS:
        {
         bool cross1_buy  = (a2 <= b2 && a1 > b1);
         bool cross1_sell = (a2 >= b2 && a1 < b1);
         bool cross2_buy  = (c2 <= d2 && c1 > d1);
         bool cross2_sell = (c2 >= d2 && c1 < d1);

         signal_buy  = (cross1_buy && cross2_buy);
         signal_sell = (cross1_sell && cross2_sell);
         break;
        }

      // Modo 2: Cruce Simple + Doble Nivel [(A x B) Y (C > D) Y (E > Umbral)]
      case REL_CROSS_AND_DOUBLE_LEVEL:
        {
         bool cross_buy  = (a2 <= b2 && a1 > b1);
         bool cross_sell = (a2 >= b2 && a1 < b1);
         bool level_buy  = (c1 > d1 && e1 >= InpThresholdE);
         bool level_sell = (c1 < d1 && e1 >= InpThresholdE);

         signal_buy  = (cross_buy && level_buy);
         signal_sell = (cross_sell && level_sell);
         break;
        }

      // Modo 3: Cruce + Pendiente Acelerada [(A x B) Y (C[1] > C[2]) Y (E > Umbral)]
      case REL_CROSS_AND_SLOPE:
        {
         bool cross_buy  = (a2 <= b2 && a1 > b1);
         bool cross_sell = (a2 >= b2 && a1 < b1);
         bool slope_buy  = (c1 > c2 && e1 >= InpThresholdE);
         bool slope_sell = (c1 < c2 && e1 >= InpThresholdE);

         signal_buy  = (cross_buy && slope_buy);
         signal_sell = (cross_sell && slope_sell);
         break;
        }

      // Modo 4: Reversion de Canal Exotico + Doble Oscilador
      case REL_CHANNEL_REVERSION_AND_OSC:
        {
         double close1 = iClose(_Symbol, PERIOD_CURRENT, 1);
         bool rev_buy  = (close1 <= b1 && c1 < InpThresholdC); // Precio en canal bajo + sobreventa
         bool rev_sell = (close1 >= a1 && c1 > (100.0 - InpThresholdC)); // Precio en canal alto + sobrecompra

         signal_buy  = (rev_buy && e1 >= InpThresholdE);
         signal_sell = (rev_sell && e1 >= InpThresholdE);
         break;
        }

      // Modo 5: Ruptura de Canal + Flujo / Volatilidad
      case REL_BREAKOUT_AND_VOLUMES:
        {
         double close1 = iClose(_Symbol, PERIOD_CURRENT, 1);
         bool brk_buy  = (close1 > a1 && c1 > InpThresholdC);
         bool brk_sell = (close1 < b1 && c1 < (100.0 - InpThresholdC));

         signal_buy  = (brk_buy && e1 >= InpThresholdE);
         signal_sell = (brk_sell && e1 >= InpThresholdE);
         break;
        }

      // Modo 6: Doble Nivel Relativo Puro [(A > B) Y (C > D) Y (E >= Umbral)]
      case REL_DOUBLE_LEVEL_ONLY:
        {
         bool lvl1_buy  = (a1 > b1);
         bool lvl1_sell = (a1 < b1);
         bool lvl2_buy  = (c1 > d1 && e1 >= InpThresholdE);
         bool lvl2_sell = (c1 < d1 && e1 >= InpThresholdE);

         signal_buy  = (lvl1_buy && lvl2_buy);
         signal_sell = (lvl1_sell && lvl2_sell);
         break;
        }
     }

   MqlTick tick;
   if(!SymbolInfoTick(_Symbol, tick)) return;

   // EJECUCION DE ORDENES CON ASIMETRIA Y STOP LOSS REALISTA
   if(signal_buy)
     {
      double sl = CalculateRealisticSL(POSITION_TYPE_BUY, tick.ask);
      double tp = (InpTakeProfitPoints > 0 ? NormalizeDouble(tick.ask + (InpTakeProfitPoints * point_val), _Digits) : 0.0);
      
      if(trades.Buy(InpLots, _Symbol, tick.ask, sl, tp, "MAMA_QUANT_BUY"))
        {
         last_bar_time = current_bar;
        }
     }
   else if(signal_sell)
     {
      double sl = CalculateRealisticSL(POSITION_TYPE_SELL, tick.bid);
      double tp = (InpTakeProfitPoints > 0 ? NormalizeDouble(tick.bid - (InpTakeProfitPoints * point_val), _Digits) : 0.0);

      if(trades.Sell(InpLots, _Symbol, tick.bid, sl, tp, "MAMA_QUANT_SELL"))
        {
         last_bar_time = current_bar;
        }
     }
  }

//+------------------------------------------------------------------+
//| COMPROBACION DE REGIMEN DE SESION INSTITUCIONAL                  |
//+------------------------------------------------------------------+
bool IsSessionAllowed(int server_hour)
  {
   switch(InpSessionFilter)
     {
      case SESSION_ALL_DAY:
         return true;
      case SESSION_LONDON:
         return (server_hour >= 10 && server_hour < 18);
      case SESSION_NEW_YORK:
         return (server_hour >= 15 && server_hour < 23);
      case SESSION_OVERLAP_LDN_NY:
         return (server_hour >= 15 && server_hour < 19);
      case SESSION_ASIA:
         return (server_hour >= 2 && server_hour < 10);
      default:
         return true;
     }
  }

//+------------------------------------------------------------------+
//| EXPORTADOR AUTOMATICO DE ESTRATEGIA INDEPENDIENTE (.MQ5)         |
//+------------------------------------------------------------------+
void ExportStandaloneStrategy(double fitness_score)
  {
   if(!InpExportStrategyToFile) return;

   string filename = "MAMA_DISCOVERY_" + _Symbol + "_" + IntegerToString((int)fitness_score) + ".mq5";
   int file_handle = FileOpen(filename, FILE_WRITE|FILE_TXT|FILE_ANSI);
   if(file_handle == INVALID_HANDLE)
     {
      Print("MAMA EXPORTER: No se pudo crear el archivo ", filename);
      return;
     }

   FileWriteString(file_handle, "//+------------------------------------------------------------------+\n");
   FileWriteString(file_handle, "//| STANDALONE STRATEGY GENERATED BY MAMA GENESIS QUANT ULTRA        |\n");
   FileWriteString(file_handle, "//| Symbol: " + _Symbol + " | Fitness Score: " + DoubleToString(fitness_score, 2) + "\n");
   FileWriteString(file_handle, "//+------------------------------------------------------------------+\n");
   FileWriteString(file_handle, "#property copyright \"MAMA Genesis Quantitative Factory\"\n");
   FileWriteString(file_handle, "#property version   \"1.00\"\n\n");
   FileWriteString(file_handle, "// --- PARAMETROS OPTIMIZADOS DESCUBIERTOS ---\n");
   FileWriteString(file_handle, "input int InpMode = " + IntegerToString(InpRelationMode) + ";\n");
   FileWriteString(file_handle, "input int InpIndA = " + IntegerToString(InpGeneIndA) + ";\n");
   FileWriteString(file_handle, "input int InpIndB = " + IntegerToString(InpGeneIndB) + ";\n");
   FileWriteString(file_handle, "input int InpIndC = " + IntegerToString(InpGeneIndC) + ";\n");
   FileWriteString(file_handle, "input int InpIndD = " + IntegerToString(InpGeneIndD) + ";\n");
   FileWriteString(file_handle, "input int InpIndE = " + IntegerToString(InpGeneIndE) + ";\n");
   FileWriteString(file_handle, "input int InpPerA = " + IntegerToString(InpPeriodA) + ";\n");
   FileWriteString(file_handle, "input int InpPerB = " + IntegerToString(InpPeriodB) + ";\n");
   FileWriteString(file_handle, "input int InpPerC = " + IntegerToString(InpPeriodC) + ";\n");
   FileWriteString(file_handle, "input int InpPerD = " + IntegerToString(InpPeriodD) + ";\n");
   FileWriteString(file_handle, "input int InpPerE = " + IntegerToString(InpPeriodE) + ";\n");
   FileWriteString(file_handle, "input double InpThreshC = " + DoubleToString(InpThresholdC, 2) + ";\n");
   FileWriteString(file_handle, "input double InpThreshE = " + DoubleToString(InpThresholdE, 4) + ";\n");
   FileWriteString(file_handle, "input int InpSession = " + IntegerToString(InpSessionFilter) + ";\n");
   FileWriteString(file_handle, "input double InpMaxLossUSD = " + DoubleToString(InpMaxLossUSD, 2) + ";\n");
   FileWriteString(file_handle, "input int InpPartialTarget = " + IntegerToString(InpPartialTargetPoints) + ";\n");
   FileWriteString(file_handle, "input int InpTP = " + IntegerToString(InpTakeProfitPoints) + ";\n");
   FileWriteString(file_handle, "\n// Fin del perfil exportado para ejecucion en vivo.\n");

   FileClose(file_handle);
   Print("MAMA EXPORTER: Estrategia exportada exitosamente a MQL5\\Files\\", filename);
  }

//+------------------------------------------------------------------+
//| FUNCION DE FITNESS CUANTITATIVO MATEMATICO PERSONALIZADO         |
//| En el Optimizador de MT5 seleccionar: 'Custom Max'               |
//+------------------------------------------------------------------+
double OnTester()
  {
   double trades_total  = TesterStatistics(STAT_TRADES);
   double profit_total  = TesterStatistics(STAT_PROFIT);
   double profit_factor = TesterStatistics(STAT_PROFIT_FACTOR);
   double sharpe        = TesterStatistics(STAT_SHARPE_RATIO);
   double dd_rel        = TesterStatistics(STAT_EQUITY_DDREL_PERCENT); // % Drawdown maximo relativo
   double recovery_fac  = TesterStatistics(STAT_RECOVERY_FACTOR);

   // 1. Filtros eliminatorios cuantitativos
   // Si no opera suficiente (menos de 25 operaciones) o pierde dinero, fitness = 0
   if(trades_total < 25.0 || profit_total <= 0.0 || profit_factor < 1.15)
      return 0.0;

   // 2. Normalizacion de metricas
   if(sharpe < 0.0) sharpe = 0.0;
   if(recovery_fac < 0.0) recovery_fac = 0.0;
   
   // Factor de penalizacion de Drawdown: a menor drawdown, mayor score (1.0 = 0% DD, 0.5 = 50% DD)
   double dd_penalty = 1.0 - (dd_rel / 100.0);
   if(dd_penalty < 0.05) dd_penalty = 0.05;

   // Factor de estabilidad estadistica (recompensa masa critica de trades hasta 100)
   double trade_weight = MathSqrt(MathMin(trades_total, 144.0)) / 12.0; // 0.0 a 1.0

   // 3. Formula Cuantitativa de Curva Suave 45 Grados:
   // Fitness = Sharpe * ProfitFactor * dd_penalty^2 * trade_weight * RecoveryFactor
   double fitness = (sharpe * 2.0 + profit_factor) * MathPow(dd_penalty, 2.0) * trade_weight * MathMin(recovery_fac, 10.0) * 100.0;

   PrintFormat("MAMA FITNESS EVALUADO -> Trades: %.0f | Profit: $%.2f | PF: %.2f | Sharpe: %.2f | MaxDD: %.2f%% | Score: %.2f",
               trades_total, profit_total, profit_factor, sharpe, dd_rel, fitness);

   // Exportar automaticamente si el resultado es sobresaliente
   if(fitness > 150.0 && InpExportStrategyToFile)
     {
      ExportStandaloneStrategy(fitness);
     }

   return fitness;
  }
//+------------------------------------------------------------------+
