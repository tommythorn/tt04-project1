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

   wire		      A = ui_in[0];
   wire		      B = ui_in[1];
   wire		      C = ui_in[2];

   wire		      X;
   assign X = A & B & C  |  X & (A | B | C); // This should map to two gates

   assign uo_out = {7'd0, X};
   assign uio_out = 8'd0;
   assign uio_oe = 8'd0;
endmodule

/*
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
*/
