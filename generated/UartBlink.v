module Tx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [10:0] shiftReg; // @[Uart.scala 30:25]
  reg [19:0] cntReg; // @[Uart.scala 31:23]
  reg [3:0] bitsReg; // @[Uart.scala 32:24]
  wire  _T = cntReg == 20'h0; // @[Uart.scala 34:31]
  wire [9:0] lo = shiftReg[10:1]; // @[Uart.scala 41:28]
  wire [10:0] _T_7 = {1'h1,lo}; // @[Cat.scala 30:58]
  wire [3:0] _T_9 = bitsReg - 4'h1; // @[Uart.scala 43:26]
  wire [10:0] _T_10 = {2'h3,io_channel_bits,1'h0}; // @[Cat.scala 30:58]
  wire [19:0] _T_12 = cntReg - 20'h1; // @[Uart.scala 54:22]
  assign io_txd = shiftReg[0]; // @[Uart.scala 35:21]
  assign io_channel_ready = cntReg == 20'h0 & bitsReg == 4'h0; // @[Uart.scala 34:40]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 30:25]
      shiftReg <= 11'h7ff; // @[Uart.scala 30:25]
    end else if (_T) begin // @[Uart.scala 37:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 40:27]
        shiftReg <= _T_7; // @[Uart.scala 42:16]
      end else if (io_channel_valid) begin // @[Uart.scala 45:30]
        shiftReg <= _T_10; // @[Uart.scala 46:18]
      end else begin
        shiftReg <= 11'h7ff; // @[Uart.scala 49:18]
      end
    end
    if (reset) begin // @[Uart.scala 31:23]
      cntReg <= 20'h0; // @[Uart.scala 31:23]
    end else if (_T) begin // @[Uart.scala 37:24]
      cntReg <= 20'h1b1; // @[Uart.scala 39:12]
    end else begin
      cntReg <= _T_12; // @[Uart.scala 54:12]
    end
    if (reset) begin // @[Uart.scala 32:24]
      bitsReg <= 4'h0; // @[Uart.scala 32:24]
    end else if (_T) begin // @[Uart.scala 37:24]
      if (bitsReg != 4'h0) begin // @[Uart.scala 40:27]
        bitsReg <= _T_9; // @[Uart.scala 43:15]
      end else if (io_channel_valid) begin // @[Uart.scala 45:30]
        bitsReg <= 4'hb; // @[Uart.scala 47:17]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  shiftReg = _RAND_0[10:0];
  _RAND_1 = {1{`RANDOM}};
  cntReg = _RAND_1[19:0];
  _RAND_2 = {1{`RANDOM}};
  bitsReg = _RAND_2[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Buffer(
  input        clock,
  input        reset,
  input        io_in_valid,
  input  [7:0] io_in_bits,
  input        io_out_ready,
  output       io_out_valid,
  output [7:0] io_out_bits
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  stateReg; // @[Uart.scala 116:25]
  reg [7:0] dataReg; // @[Uart.scala 117:24]
  wire  _T = ~stateReg; // @[Uart.scala 119:27]
  wire  _GEN_1 = io_in_valid | stateReg; // @[Uart.scala 123:23 Uart.scala 125:16 Uart.scala 116:25]
  assign io_out_valid = stateReg; // @[Uart.scala 120:28]
  assign io_out_bits = dataReg; // @[Uart.scala 132:15]
  always @(posedge clock) begin
    if (reset) begin // @[Uart.scala 116:25]
      stateReg <= 1'h0; // @[Uart.scala 116:25]
    end else if (_T) begin // @[Uart.scala 122:28]
      stateReg <= _GEN_1;
    end else if (io_out_ready) begin // @[Uart.scala 128:24]
      stateReg <= 1'h0; // @[Uart.scala 129:16]
    end
    if (reset) begin // @[Uart.scala 117:24]
      dataReg <= 8'h0; // @[Uart.scala 117:24]
    end else if (_T) begin // @[Uart.scala 122:28]
      if (io_in_valid) begin // @[Uart.scala 123:23]
        dataReg <= io_in_bits; // @[Uart.scala 124:15]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  stateReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  dataReg = _RAND_1[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module BufferedTx(
  input        clock,
  input        reset,
  output       io_txd,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
  wire  tx_clock; // @[Uart.scala 143:18]
  wire  tx_reset; // @[Uart.scala 143:18]
  wire  tx_io_txd; // @[Uart.scala 143:18]
  wire  tx_io_channel_ready; // @[Uart.scala 143:18]
  wire  tx_io_channel_valid; // @[Uart.scala 143:18]
  wire [7:0] tx_io_channel_bits; // @[Uart.scala 143:18]
  wire  buf__clock; // @[Uart.scala 144:19]
  wire  buf__reset; // @[Uart.scala 144:19]
  wire  buf__io_in_valid; // @[Uart.scala 144:19]
  wire [7:0] buf__io_in_bits; // @[Uart.scala 144:19]
  wire  buf__io_out_ready; // @[Uart.scala 144:19]
  wire  buf__io_out_valid; // @[Uart.scala 144:19]
  wire [7:0] buf__io_out_bits; // @[Uart.scala 144:19]
  Tx tx ( // @[Uart.scala 143:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Buffer buf_ ( // @[Uart.scala 144:19]
    .clock(buf__clock),
    .reset(buf__reset),
    .io_in_valid(buf__io_in_valid),
    .io_in_bits(buf__io_in_bits),
    .io_out_ready(buf__io_out_ready),
    .io_out_valid(buf__io_out_valid),
    .io_out_bits(buf__io_out_bits)
  );
  assign io_txd = tx_io_txd; // @[Uart.scala 148:10]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf__io_out_valid; // @[Uart.scala 147:17]
  assign tx_io_channel_bits = buf__io_out_bits; // @[Uart.scala 147:17]
  assign buf__clock = clock;
  assign buf__reset = reset;
  assign buf__io_in_valid = io_channel_valid; // @[Uart.scala 146:13]
  assign buf__io_in_bits = io_channel_bits; // @[Uart.scala 146:13]
  assign buf__io_out_ready = tx_io_channel_ready; // @[Uart.scala 147:17]
endmodule
module UartBlink(
  input   clock,
  input   reset,
  output  io_ledg0,
  output  io_txd
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire  tx_clock; // @[UartBlink.scala 13:18]
  wire  tx_reset; // @[UartBlink.scala 13:18]
  wire  tx_io_txd; // @[UartBlink.scala 13:18]
  wire  tx_io_channel_valid; // @[UartBlink.scala 13:18]
  wire [7:0] tx_io_channel_bits; // @[UartBlink.scala 13:18]
  reg [31:0] cntReg; // @[UartBlink.scala 17:23]
  reg  blkReg; // @[UartBlink.scala 18:23]
  wire [31:0] _T_1 = cntReg + 32'h1; // @[UartBlink.scala 20:20]
  wire [7:0] _GEN_0 = blkReg ? 8'h30 : 8'h31; // @[UartBlink.scala 26:23 UartBlink.scala 27:25 UartBlink.scala 29:25]
  BufferedTx tx ( // @[UartBlink.scala 13:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  assign io_ledg0 = blkReg; // @[UartBlink.scala 35:12]
  assign io_txd = tx_io_txd; // @[UartBlink.scala 36:10]
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = cntReg == 32'h17d783f; // @[UartBlink.scala 22:15]
  assign tx_io_channel_bits = cntReg == 32'h17d783f ? _GEN_0 : 8'h0; // @[UartBlink.scala 22:28 UartBlink.scala 33:23]
  always @(posedge clock) begin
    if (reset) begin // @[UartBlink.scala 17:23]
      cntReg <= 32'h0; // @[UartBlink.scala 17:23]
    end else if (cntReg == 32'h17d783f) begin // @[UartBlink.scala 22:28]
      cntReg <= 32'h0; // @[UartBlink.scala 23:12]
    end else begin
      cntReg <= _T_1; // @[UartBlink.scala 20:10]
    end
    if (reset) begin // @[UartBlink.scala 18:23]
      blkReg <= 1'h0; // @[UartBlink.scala 18:23]
    end else if (cntReg == 32'h17d783f) begin // @[UartBlink.scala 22:28]
      blkReg <= ~blkReg; // @[UartBlink.scala 24:12]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cntReg = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  blkReg = _RAND_1[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
