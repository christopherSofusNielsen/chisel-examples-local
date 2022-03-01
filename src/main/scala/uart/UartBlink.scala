package uart

import chisel3._



class UartBlink(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val ledg0 = Output(UInt(1.W))
    val txd = Output(UInt(1.W))
  })

  val tx = Module(new BufferedTx(frequency, baudRate))

  val CNT_MAX = (50000000 / 2 - 1).U;

  val cntReg = RegInit(0.U(32.W))
  val blkReg = RegInit(0.U(1.W))

  cntReg := cntReg + 1.U

  when(cntReg === CNT_MAX) {
    cntReg := 0.U
    blkReg := ~blkReg
   tx.io.channel.valid:=true.B
    when(blkReg===1.U){
      tx.io.channel.bits:=48.U(8.W)
    }.otherwise{
      tx.io.channel.bits:=49.U(8.W)
    }
  }.otherwise{
    tx.io.channel.valid:=false.B
    tx.io.channel.bits:=0.U(8.W)
  }
  io.ledg0 := blkReg
  io.txd := tx.io.txd

}

object UartBlink extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new UartBlink(50000000, 115200), Array("--target-dir", "generated"))
}