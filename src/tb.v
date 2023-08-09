`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb ();

    // wire up the inputs and outputs
    reg  clk;
    reg  rst_n;
    reg  ena;
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;

    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    tt_um_project1 tt_um_project1 (
    // include power ports for the Gate Level test
    `ifdef GL_TEST
        .VPWR( 1'b1),
        .VGND( 1'b0),
    `endif
        .ui_in      (ui_in),    // Dedicated inputs
        .uo_out     (uo_out),   // Dedicated outputs
        .uio_in     (uio_in),   // IOs: Input path
        .uio_out    (uio_out),  // IOs: Output path
        .uio_oe     (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
        .ena        (ena),      // enable - goes high when design is selected
        .clk        (clk),      // clock
        .rst_n      (rst_n)     // not reset
        );

   initial begin
      $dumpfile("tb.vcd");
      $dumpvars(0, tt_um_project1);
      // Flip latch 1 a couple of times.

      #10 ui_in[0] = 0; ui_in[1] = 0;
      #10 ui_in[0] = 1; // D = 1
      #10 ui_in[1] = 1; // toggle WE
      #10 ui_in[1] = 0;
      #10 ui_in[1] = 1; // second toggle of WE  (should be a no-op)
      #10 ui_in[1] = 0;
      #10 ui_in[0] = 0; // D = 0
      
      #20
      #10 ui_in[1] = 1; // toggle WE
      #10 ui_in[1] = 0;
      #10 ui_in[0] = 1; // D = 1
      #10 ui_in[1] = 1; // toggle WE
      #10 ui_in[1] = 0;
      #10 ui_in[1] = 1; // second toggle of WE  (should be a no-op)
      #10 ui_in[1] = 0;
      #10 ui_in[0] = 0; // D = 0

      // Flip latch 2 a couple of times.
      #10 ui_in[2] = 1; ui_in[3] = 0; // Initial clear
      #10 ui_in[3] = 1;

      #10 ui_in[2] = 0; // toggle A
      #10 ui_in[2] = 1;
      #10 ui_in[2] = 0; // 2nd toggle A should do nothing
      #10 ui_in[2] = 1;

      #10 ui_in[3] = 0; // toggle B
      #10 ui_in[3] = 1;
      #10 ui_in[3] = 0; // 2nd toggle B should do nothing
      #10 ui_in[3] = 1;

      // Flip latch 3 a couple of times.
      #10 ui_in[4] = 0; ui_in[5] = 0;
      #10 ui_in[4] = 1; // Set A (does nothing)
      #10 ui_in[5] = 1; // Set B (sets Q)
      #10 ui_in[5] = 0; // Revert B
      #10 ui_in[4] = 0; // Revert A (clears Q)

      #10 ui_in[5] = 1; // Set B (does nothing)
      #10 ui_in[4] = 1; // Set A (sets Q)
      #10 ui_in[5] = 0; // Revert B
      #10 ui_in[4] = 0; // Revert A (clears Q)

      #50 $finish;
   end
endmodule
