package uart

import chisel3._


class UartSpeed(frequency: Int, baudRate: Int) extends Module {
  val io = IO(new Bundle {
    val txd = Output(UInt(1.W))
  })

  val tx = Module(new BufferedTx(frequency, baudRate))


  val msg = "0123456789"
  val text = VecInit(msg.map(_.U))
  val len = msg.length.U

  val cntReg = RegInit(0.U(8.W))

  tx.io.channel.bits := text(cntReg)
  tx.io.channel.valid := cntReg =/= len

  when(tx.io.channel.ready && cntReg =/= len) {
    cntReg := cntReg + 1.U
  }.elsewhen(cntReg === len){
    cntReg:= 0.U
  }
  io.txd := tx.io.txd

}

object UartSpeed extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new UartSpeed(50000000, 115200), Array("--target-dir", "generated"))
}