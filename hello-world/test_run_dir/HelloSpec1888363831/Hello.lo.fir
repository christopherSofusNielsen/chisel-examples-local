circuit Hello :
  module Hello :
    input clock : Clock
    input reset : UInt<1>
    output io_led : UInt<1>
  
    reg cntReg : UInt<32>, clock with :
      reset => (UInt<1>("h0"), cntReg) @[Hello.scala 20:23]
    reg blkReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), blkReg) @[Hello.scala 21:23]
    node _T = add(cntReg, UInt<1>("h1")) @[Hello.scala 23:20]
    node _T_1 = tail(_T, 1) @[Hello.scala 23:20]
    node _T_2 = eq(cntReg, UInt<25>("h17d783f")) @[Hello.scala 24:15]
    node _T_3 = not(blkReg) @[Hello.scala 26:15]
    node _GEN_0 = mux(_T_2, UInt<1>("h0"), _T_1) @[Hello.scala 24:28]
    node _GEN_1 = mux(_T_2, _T_3, blkReg) @[Hello.scala 24:28]
    io_led <= blkReg @[Hello.scala 28:10]
    cntReg <= mux(reset, UInt<32>("h0"), _GEN_0) @[Hello.scala 23:10 Hello.scala 25:12]
    blkReg <= mux(reset, UInt<1>("h0"), _GEN_1) @[Hello.scala 26:12]
