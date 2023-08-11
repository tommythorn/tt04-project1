`default_nettype none

module tt_um_project1 #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

   wire		      latch1_d  = ui_in[0];
   wire		      latch1_we = ui_in[1];
   wire		      latch2_a  = ui_in[2];
   wire		      latch2_b  = ui_in[3];
   wire		      latch3_a  = ui_in[4];
   wire		      latch3_b  = ui_in[5];
   
   reg		      latch1_q;
   always @(*)
     if (latch1_we)
       latch1_q = latch1_d;

   wire		      latch2_q;
   wire		      latch2_qn;
   assign latch2_q = !(latch2_a & latch2_qn);
   assign latch2_qn = !(latch2_b & latch2_q);
   
   wire		      latch3_q;
   (* keep = "true" *) sky130_fd_sc_hd__maj3_1 maj(.X(latch3_q), .A(latch3_a), .B(latch3_b), .C(latch3_q));
   
   // Sanity checking
   wire		      dummy;
   (* keep = "true" *) sky130_fd_sc_hd__inv_1 CLKINV(.Y(dummy), .A(latch1_d));

   assign uo_out = {5'd0, latch3_q, latch2_q, latch1_q};
   assign uio_out = 8'd0;
   assign uio_oe = 8'd0;
endmodule

`ifdef SIM
module sky130_fd_sc_hd__maj3_1 (
    output X,
    input  A,
    input  B,
    input  C
);
   assign X = A & B | C & (A | B);
endmodule

module sky130_fd_sc_hd__inv_1 (
    output Y,
    input  A
);
   assign Y = !A;
endmodule
`endif
