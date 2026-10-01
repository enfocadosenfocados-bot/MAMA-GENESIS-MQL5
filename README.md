# 🧬 MAMA GENESIS MQL5: AutoML & Genetic Feature Space Explorer (+103 Indicadores)

[![Platform](https://img.shields.io/badge/Platform-MetaTrader%205-blue.svg)](https://www.metatrader5.com)
[![Language](https://img.shields.io/badge/Language-MQL5-orange.svg)](https://www.mql5.com)
[![Architecture](https://img.shields.io/badge/Architecture-AutoML%20%2F%20Genetic%20Algorithm-green.svg)](#)
[![Status](https://img.shields.io/badge/Status-Production%20Ready%20(0%20Errors)-brightgreen.svg)](#)

Factoría Cuantitativa Institucional de Trading Algorítmico desarrollada para **MetaTrader 5 (MQL5)**. Su propósito es actuar como un **motor de AutoML (Feature Space Miner)** capaz de descubrir de forma autónoma combinaciones ganadoras de indicadores técnicos, relaciones cruzadas de alta dimensión y parámetros de riesgo óptimos para cualquier activo financiero (**Oro / XAUUSD, US30, USTEC, Forex, Criptomonedas**).

---

## 🎯 Visión y Fundamentos Cuantitativos

Los indicadores técnicos aislados suelen ser rezagados o inconsistentes cuando se usan en solitario. Sin embargo, cuando se combinan mediante **matrices relacionales multicapa** (Cruces Dobles, Niveles Relativos Dobles, Pendientes de Aceleración y Reversiones en Canales Exóticos), se genera un **edge estadístico** poderoso y robusto.

**MAMA GENESIS** permite:
1. Conectarse a cualquier activo y temporalidad (ej. M5).
2. Explorar un universo masivo de **103 indicadores técnicos y canales exóticos**.
3. Encontrar mediante el **Algoritmo Genético de MT5** la combinación que maximice el **Sharpe Ratio**, la **tasa de acierto asimétrica**, minimice el **Drawdown** y forme una **curva de balance ascendente a 45°**.
4. Proteger la operativa contra el slippage y ensanchamiento de spread de **IC Markets**.
5. Extraer la estrategia descubierta a un EA independiente (*standalone*) listo para producción.

---

## 📊 Catálogo de Indicadores Soportados (103 Genes)

Todos los indicadores están integrados en el enum `ENUM_QUANT_IND_TYPE` (`QIND_0` a `QIND_102`):

```
├── 1. Tendencia y Medias (0 - 21)
│   ├── Moving Averages: SMA, EMA, SMMA, LWMA, DEMA, TEMA
│   ├── Medias Adaptativas: Kaufman AMA, FrAMA, VIDYA
│   ├── Parabolic SAR
│   ├── Bollinger Bands: Media Central, Banda Superior, Banda Inferior
│   ├── Envelopes: Banda Superior, Banda Inferior
│   ├── Ichimoku Kinko Hyo: Tenkan-sen, Kijun-sen, Senkou Span A, Senkou Span B
│   └── ADX: Línea Principal, +DI, -DI
├── 2. Canales y Niveles Exóticos (22 - 37)
│   ├── Keltner Channel: Media EMA, Banda Superior, Banda Inferior
│   ├── Donchian Channel: Línea Media, Máximo Superior, Mínimo Inferior
│   ├── Camarilla Channel: H3, H4 (Ruptura), L3, L4 (Ruptura)
│   ├── Murrey Math: Eje Central 4/8, Resistencia 6/8, Soporte 2/8
│   ├── NRTR Channel (Nick Rypock Trailing Reverse)
│   └── Price Channel: Superior, Inferior
├── 3. Osciladores y Momentum (38 - 57)
│   ├── RSI, Stochastic (%K, %D), MACD (Main, Signal)
│   ├── ATR, Standard Deviation, CCI, Momentum
│   ├── RVI (Relative Vigor Index), Williams %R, DeMarker
│   ├── Bulls Power, Bears Power, OsMA
│   ├── Chaikin Oscillator (CHO), Force Index, TRIX
│   └── Rate of Change (ROC), Ultimate Oscillator
├── 4. Volumen y Flujo Institucional (58 - 62)
│   ├── Tick / Real Volumes, Money Flow Index (MFI)
│   ├── On Balance Volume (OBV), Accumulation/Distribution (A/D)
│   └── Price and Volume Trend (PVT)
├── 5. Bill Williams (63 - 68)
│   ├── Alligator: Mandíbula (Azul), Dientes (Rojo), Labios (Verde)
│   ├── Awesome Oscillator (AO), Accelerator Oscillator (AC)
│   └── Market Facilitation Index (BWMFI)
├── 6. Extremos, Acción del Precio y ZigZag (69 - 82)
│   ├── ZigZag: Línea Principal, Picos Superiores (Highs), Valles Inferiores (Lows)
│   ├── Fractals: Fractal Alcista Superior, Fractal Bajista Inferior
│   ├── Heiken Ashi: Tendencia de Color Suavizada (0=Bull, 1=Bear)
│   ├── Chaikin Volatility (CHV), Accumulation Swing Index (ASI)
│   ├── Mass Index (MI Reversal Bulge), Detrended Price Oscillator (DPO)
│   ├── Volume Rate of Change (VROC), Williams A/D (W_AD)
│   └── Gator Oscillator: Superior, Inferior
└── 7. Canales de Pivots y Custom Propios (83 - 102)
    ├── DeMark Channel: Pivot Point (PP), R1, S1
    ├── Fibonacci Channel: Pivot Point (PP), R1, S1
    ├── Parabolic Channel: Banda Superior, Banda Inferior
    ├── Pivot Channel: Pivot Point (PP), R1, S1
    ├── Woodie Channel: Pivot Point (PP), R1, S1
    ├── ADX Wilder (Main Line)
    ├── Bill Williams Zone Trade (BW-ZoneTrade)
    ├── P1P2 Pattern Indicator: Nivel P1, Nivel P2
    └── Fuerzas Index: Fortaleza Relativa USD, Fortaleza Relativa EUR
```

---

## 🔀 Modos de Combinatoria Relacional (`InpRelationMode`)

* **`REL_SINGLE_CROSS` (0):** **Cruce Simple Normal Puro** [(`IndA` cruza `IndB`)]. Ideal para evaluar cruces tradicionales de 2 medias o 2 osciladores.
* **`REL_DOUBLE_CROSS` (1):** **Cruces Dobles Simultáneos** [(`IndA` cruza `IndB`) Y (`IndC` cruza `IndD`)].
* **`REL_CROSS_AND_DOUBLE_LEVEL` (2):** **Cruce + Doble Nivel** [(`IndA` cruza `IndB`) Y (`IndC > IndD`) Y (`IndE >= Umbral`)].
* **`REL_CROSS_AND_SLOPE` (3):** **Cruce + Pendiente Acelerada** [(`IndA` cruza `IndB`) Y (`IndC[1] > IndC[2]`) Y Filtro de Volatilidad].
* **`REL_CHANNEL_REVERSION_AND_OSC` (4):** **Reversión en Bandas Exóticas** [Rebote en Keltner / Donchian / Camarilla + Sobreventa/Sobrecompra].
* **`REL_BREAKOUT_AND_VOLUMES` (5):** **Ruptura de Canal con Expansión de Volumen y Volatilidad**.
* **`REL_DOUBLE_LEVEL_ONLY` (6):** **Doble Nivel Relativo Puro** [(`IndA > IndB`) Y (`IndC > IndD`) Y Filtro de Régimen].

---

## 🛡️ Suite de Money Management Institucional (IC Markets Proof)

Para evitar la típica divergencia donde un bot gana en backtest y pierde en cuenta real:

1. **Stop Loss Realista con Techo Máximo en USD:**
   * **Piso Antirruido:** El Stop Loss nunca se sitúa a menos de $2.5 \times \text{Spread}$ o $80$ puntos de la entrada, evitando que el spread flotante de IC Markets liquide la orden prematuramente.
   * **SL Estructural:** Calculado mediante $1.8 \times \text{ATR(14)}$.
   * **Techo Inquebrantable en USD:** **Máximo \$15.00 USD por cada 0.10 lotes** (`InpMaxLossUSD = 15.0`). El EA calcula el valor del tick en tiempo real y recorta el SL automáticamente si excede los \$15 USD.
2. **Cierre Parcial del 50% al Target 1:**
   * En cuanto la posición alcanza el Target 1 (ej. +250 puntos), se liquida el 50% del volumen, ingresando ganancias netas al balance.
3. **Breakeven Inmediato con Colchón:**
   * Simultáneamente al cierre parcial, el Stop Loss se traslada al precio de entrada + 30 puntos asegurados (absorbiendo spread y comisiones de \$7/lote). **El riesgo financiero pasa a ser CERO.**
4. **Trailing Stop de Tendencia:**
   * El 50% restante acompaña el movimiento sin riesgo para capturar tendencias largas y crear la **curva ascendente a 45°**.
5. **Filtros Institucionales:**
   * Bloqueo si el spread supera los 45 puntos.
   * Filtro de horario y cierre preventivo de viernes a las 21:00 hs para evitar gaps de fin de semana.

---

## ⚡ Rendimiento y Optimización de Ultra-Alta Velocidad

* **Lazy-Loading de Memoria:** En cada iteración del Algoritmo Genético, el EA **únicamente crea los handles de los 5 indicadores activos** seleccionados en los genes (`OnInit`), y los libera inmediatamente en `OnDeinit`.
* **Cero Repainting:** La confirmación de las señales se valida con el cierre de la vela anterior (`barra [1]`), mientras que la gestión de SL/TP, Breakeven y Trailing corre al microtick.
* **Compatibilidad Multi-Core:** MetaTrader 5 distribuye las 27 dependencias de indicadores automáticamente a todos los núcleos de la CPU.

---

## 📈 Metodología de Validación: In-Sample vs Out-of-Sample

Para garantizar que los parámetros encontrados tienen ventaja estadística real y no sobreajuste (*curve-fitting*):

```
[==================== VENTANA IN-SAMPLE ====================] [========= VENTANA OUT-OF-SAMPLE =========]
Julio 01, 2025 ---------------------------------> Julio 01, 2026 | Julio 01, 2026 -----------------> Septiembre 30, 2026
           (Optimización Genética Every Tick)                    |          (Validación Ciega Real)
```

1. **In-Sample (1 Año):** Se corre el probador en modo **"Every tick based on real ticks"** cargando `MAMA_GENESIS_TEMPLATE.set`.
2. **Criterios de Aceptación In-Sample:**
   * Profit Factor $\ge 1.70$.
   * Operaciones mínimas $\ge 80$ trades/año.
   * Max Drawdown $\le 8\%$.
3. **Out-of-Sample (3 Meses Ciegos):** Se testean los parámetros ganadores en el periodo reciente sin modificar ningún valor.
   * Si mantiene Profit Factor $\ge 1.40$, la estrategia queda **certificada para operar en cuenta real**.

---

## 🚀 Instalación y Uso

1. Copiar los archivos `.mq5` y `.ex5` a la carpeta `MQL5\Experts\` de MetaTrader 5.
2. Asegurar que las carpetas `MQL5\Indicators\Free Indicators` y `MQL5\Indicators\Examples` contengan los indicadores auxiliares.
3. Abrir el **Probador de Estrategias (Ctrl + R)** en MT5.
4. Seleccionar `MAMA_GENESIS_QUANT_ULTRA.ex5`.
5. En la pestaña de parámetros, hacer clic derecho y seleccionar **Cargar**, eligiendo `MAMA_GENESIS_TEMPLATE.set`.
6. Seleccionar el activo deseado (**XAUUSD**, **US30**, **USTEC**, etc.) en temporalidad **M5**.
7. Seleccionar modelo: **Cada tick basado en ticks reales**.
8. Ejecutar la optimización genética.

---

## 👤 Autor
Desarrollado para **Enfocados Trading / Quantitative Systems**
GitHub: [@enfocadosenfocados-bot](https://github.com/enfocadosenfocados-bot)
Plataforma: MetaTrader 5 (MQL5)
Licencia: Propietario / Cuantitativo
