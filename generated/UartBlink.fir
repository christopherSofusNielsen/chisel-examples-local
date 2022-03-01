;buildInfoPackage: chisel3, version: 3.4.1, scalaVersion: 2.12.12, sbtVersion: 1.3.10
circuit UartBlink : 
  module Tx : 
    input clock : Clock
    input reset : Reset
    output io : {txd : UInt<1>, flip channel : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg shiftReg : UInt, clock with : (reset => (reset, UInt<11>("h07ff"))) @[Uart.scala 30:25]
    reg cntReg : UInt<20>, clock with : (reset => (reset, UInt<20>("h00"))) @[Uart.scala 31:23]
    reg bitsReg : UInt<4>, clock with : (reset => (reset, UInt<4>("h00"))) @[Uart.scala 32:24]
    node _T = eq(cntReg, UInt<1>("h00")) @[Uart.scala 34:31]
    node _T_1 = eq(bitsReg, UInt<1>("h00")) @[Uart.scala 34:52]
    node _T_2 = and(_T, _T_1) @[Uart.scala 34:40]
    io.channel.ready <= _T_2 @[Uart.scala 34:20]
    node _T_3 = bits(shiftReg, 0, 0) @[Uart.scala 35:21]
    io.txd <= _T_3 @[Uart.scala 35:10]
    node _T_4 = eq(cntReg, UInt<1>("h00")) @[Uart.scala 37:15]
    when _T_4 : @[Uart.scala 37:24]
      cntReg <= UInt<9>("h01b1") @[Uart.scala 39:12]
      node _T_5 = neq(bitsReg, UInt<1>("h00")) @[Uart.scala 40:18]
      when _T_5 : @[Uart.scala 40:27]
        node _T_6 = shr(shiftReg, 1) @[Uart.scala 41:28]
        node lo = bits(_T_6, 9, 0) @[Uart.scala 42:33]
        node _T_7 = cat(UInt<1>("h01"), lo) @[Cat.scala 30:58]
        shiftReg <= _T_7 @[Uart.scala 42:16]
        node _T_8 = sub(bitsReg, UInt<1>("h01")) @[Uart.scala 43:26]
        node _T_9 = tail(_T_8, 1) @[Uart.scala 43:26]
        bitsReg <= _T_9 @[Uart.scala 43:15]
        skip @[Uart.scala 40:27]
      else : @[Uart.scala 44:17]
        when io.channel.valid : @[Uart.scala 45:30]
          node hi = cat(UInt<2>("h03"), io.channel.bits) @[Cat.scala 30:58]
          node _T_10 = cat(hi, UInt<1>("h00")) @[Cat.scala 30:58]
          shiftReg <= _T_10 @[Uart.scala 46:18]
          bitsReg <= UInt<4>("h0b") @[Uart.scala 47:17]
          skip @[Uart.scala 45:30]
        else : @[Uart.scala 48:19]
          shiftReg <= UInt<11>("h07ff") @[Uart.scala 49:18]
          skip @[Uart.scala 48:19]
        skip @[Uart.scala 44:17]
      skip @[Uart.scala 37:24]
    else : @[Uart.scala 53:15]
      node _T_11 = sub(cntReg, UInt<1>("h01")) @[Uart.scala 54:22]
      node _T_12 = tail(_T_11, 1) @[Uart.scala 54:22]
      cntReg <= _T_12 @[Uart.scala 54:12]
      skip @[Uart.scala 53:15]
    
  module Buffer : 
    input clock : Clock
    input reset : Reset
    output io : {flip in : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}, out : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    reg stateReg : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[Uart.scala 116:25]
    reg dataReg : UInt<8>, clock with : (reset => (reset, UInt<8>("h00"))) @[Uart.scala 117:24]
    node _T = eq(stateReg, UInt<1>("h00")) @[Uart.scala 119:27]
    io.in.ready <= _T @[Uart.scala 119:15]
    node _T_1 = eq(stateReg, UInt<1>("h01")) @[Uart.scala 120:28]
    io.out.valid <= _T_1 @[Uart.scala 120:16]
    node _T_2 = eq(stateReg, UInt<1>("h00")) @[Uart.scala 122:17]
    when _T_2 : @[Uart.scala 122:28]
      when io.in.valid : @[Uart.scala 123:23]
        dataReg <= io.in.bits @[Uart.scala 124:15]
        stateReg <= UInt<1>("h01") @[Uart.scala 125:16]
        skip @[Uart.scala 123:23]
      skip @[Uart.scala 122:28]
    else : @[Uart.scala 127:15]
      when io.out.ready : @[Uart.scala 128:24]
        stateReg <= UInt<1>("h00") @[Uart.scala 129:16]
        skip @[Uart.scala 128:24]
      skip @[Uart.scala 127:15]
    io.out.bits <= dataReg @[Uart.scala 132:15]
    
  module BufferedTx : 
    input clock : Clock
    input reset : Reset
    output io : {txd : UInt<1>, flip channel : {flip ready : UInt<1>, valid : UInt<1>, bits : UInt<8>}}
    
    inst tx of Tx @[Uart.scala 143:18]
    tx.clock <= clock
    tx.reset <= reset
    inst buf of Buffer @[Uart.scala 144:19]
    buf.clock <= clock
    buf.reset <= reset
    buf.io.in.bits <= io.channel.bits @[Uart.scala 146:13]
    buf.io.in.valid <= io.channel.valid @[Uart.scala 146:13]
    io.channel.ready <= buf.io.in.ready @[Uart.scala 146:13]
    tx.io.channel.bits <= buf.io.out.bits @[Uart.scala 147:17]
    tx.io.channel.valid <= buf.io.out.valid @[Uart.scala 147:17]
    buf.io.out.ready <= tx.io.channel.ready @[Uart.scala 147:17]
    io.txd <= tx.io.txd @[Uart.scala 148:10]
    
  module UartBlink : 
    input clock : Clock
    input reset : UInt<1>
    output io : {ledg0 : UInt<1>, txd : UInt<1>}
    
    inst tx of BufferedTx @[UartBlink.scala 13:18]
    tx.clock <= clock
    tx.reset <= reset
    reg cntReg : UInt<32>, clock with : (reset => (reset, UInt<32>("h00"))) @[UartBlink.scala 17:23]
    reg blkReg : UInt<1>, clock with : (reset => (reset, UInt<1>("h00"))) @[UartBlink.scala 18:23]
    node _T = add(cntReg, UInt<1>("h01")) @[UartBlink.scala 20:20]
    node _T_1 = tail(_T, 1) @[UartBlink.scala 20:20]
    cntReg <= _T_1 @[UartBlink.scala 20:10]
    node _T_2 = eq(cntReg, UInt<25>("h017d783f")) @[UartBlink.scala 22:15]
    when _T_2 : @[UartBlink.scala 22:28]
      cntReg <= UInt<1>("h00") @[UartBlink.scala 23:12]
      node _T_3 = not(blkReg) @[UartBlink.scala 24:15]
      blkReg <= _T_3 @[UartBlink.scala 24:12]
      tx.io.channel.valid <= UInt<1>("h01") @[UartBlink.scala 25:23]
      node _T_4 = eq(blkReg, UInt<1>("h01")) @[UartBlink.scala 26:16]
      when _T_4 : @[UartBlink.scala 26:23]
        tx.io.channel.bits <= UInt<8>("h030") @[UartBlink.scala 27:25]
        skip @[UartBlink.scala 26:23]
      else : @[UartBlink.scala 28:16]
        tx.io.channel.bits <= UInt<8>("h031") @[UartBlink.scala 29:25]
        skip @[UartBlink.scala 28:16]
      skip @[UartBlink.scala 22:28]
    else : @[UartBlink.scala 31:14]
      tx.io.channel.valid <= UInt<1>("h00") @[UartBlink.scala 32:24]
      tx.io.channel.bits <= UInt<8>("h00") @[UartBlink.scala 33:23]
      skip @[UartBlink.scala 31:14]
    io.ledg0 <= blkReg @[UartBlink.scala 35:12]
    io.txd <= tx.io.txd @[UartBlink.scala 36:10]
    
