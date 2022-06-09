//File8 name   : alut_reg_bank8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

// compiler8 directives8
`include "alut_defines8.v"


module alut_reg_bank8
(   
   // Inputs8
   pclk8,
   n_p_reset8,
   psel8,            
   penable8,       
   pwrite8,         
   paddr8,           
   pwdata8,          

   curr_time8,
   add_check_active8,
   age_check_active8,
   inval_in_prog8,
   reused8,
   d_port8,
   lst_inv_addr_nrm8,
   lst_inv_port_nrm8,
   lst_inv_addr_cmd8,
   lst_inv_port_cmd8,

   // Outputs8
   mac_addr8,    
   d_addr8,   
   s_addr8,    
   s_port8,    
   best_bfr_age8,
   div_clk8,     
   command, 
   prdata8,  
   clear_reused8           
);


   // APB8 Inputs8
   input                 pclk8;             // APB8 clock8
   input                 n_p_reset8;        // Reset8
   input                 psel8;             // Module8 select8 signal8
   input                 penable8;          // Enable8 signal8 
   input                 pwrite8;           // Write when HIGH8 and read when LOW8
   input [6:0]           paddr8;            // Address bus for read write
   input [31:0]          pwdata8;           // APB8 write bus

   // Inputs8 from other ALUT8 blocks
   input [31:0]          curr_time8;        // current time
   input                 add_check_active8; // used to calculate8 status[0]
   input                 age_check_active8; // used to calculate8 status[0]
   input                 inval_in_prog8;    // status[1]
   input                 reused8;           // status[2]
   input [4:0]           d_port8;           // calculated8 destination8 port for tx8
   input [47:0]          lst_inv_addr_nrm8; // last invalidated8 addr normal8 op
   input [1:0]           lst_inv_port_nrm8; // last invalidated8 port normal8 op
   input [47:0]          lst_inv_addr_cmd8; // last invalidated8 addr via cmd8
   input [1:0]           lst_inv_port_cmd8; // last invalidated8 port via cmd8
   

   output [47:0]         mac_addr8;         // address of the switch8
   output [47:0]         d_addr8;           // address of frame8 to be checked8
   output [47:0]         s_addr8;           // address of frame8 to be stored8
   output [1:0]          s_port8;           // source8 port of current frame8
   output [31:0]         best_bfr_age8;     // best8 before age8
   output [7:0]          div_clk8;          // programmed8 clock8 divider8 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata8;           // APB8 read bus
   output                clear_reused8;     // indicates8 status reg read 

   reg    [31:0]         prdata8;           //APB8 read bus   
   reg    [31:0]         frm_d_addr_l8;     
   reg    [15:0]         frm_d_addr_u8;     
   reg    [31:0]         frm_s_addr_l8;     
   reg    [15:0]         frm_s_addr_u8;     
   reg    [1:0]          s_port8;           
   reg    [31:0]         mac_addr_l8;       
   reg    [15:0]         mac_addr_u8;       
   reg    [31:0]         best_bfr_age8;     
   reg    [7:0]          div_clk8;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l8;   
   reg    [15:0]         lst_inv_addr_u8;   
   reg    [1:0]          lst_inv_port8;     


   // Internal Signal8 Declarations8
   wire                  read_enable8;      //APB8 read enable
   wire                  write_enable8;     //APB8 write enable
   wire   [47:0]         mac_addr8;        
   wire   [47:0]         d_addr8;          
   wire   [47:0]         src_addr8;        
   wire                  clear_reused8;    
   wire                  active;

   // ----------------------------
   // General8 Assignments8
   // ----------------------------

   assign read_enable8    = (psel8 & ~penable8 & ~pwrite8);
   assign write_enable8   = (psel8 & penable8 & pwrite8);

   assign mac_addr8  = {mac_addr_u8, mac_addr_l8}; 
   assign d_addr8 =    {frm_d_addr_u8, frm_d_addr_l8};
   assign s_addr8    = {frm_s_addr_u8, frm_s_addr_l8}; 

   assign clear_reused8 = read_enable8 & (paddr8 == `AL_STATUS8) & ~active;

   assign active = (add_check_active8 | age_check_active8);

// ------------------------------------------------------------------------
//   Read Mux8 Control8 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         prdata8 <= 32'h0000_0000;
      else if (read_enable8)
         begin
         case (paddr8)
            `AL_FRM_D_ADDR_L8   : prdata8 <= frm_d_addr_l8;
            `AL_FRM_D_ADDR_U8   : prdata8 <= {16'd0, frm_d_addr_u8};    
            `AL_FRM_S_ADDR_L8   : prdata8 <= frm_s_addr_l8; 
            `AL_FRM_S_ADDR_U8   : prdata8 <= {16'd0, frm_s_addr_u8}; 
            `AL_S_PORT8         : prdata8 <= {30'd0, s_port8}; 
            `AL_D_PORT8         : prdata8 <= {27'd0, d_port8}; 
            `AL_MAC_ADDR_L8     : prdata8 <= mac_addr_l8;
            `AL_MAC_ADDR_U8     : prdata8 <= {16'd0, mac_addr_u8};   
            `AL_CUR_TIME8       : prdata8 <= curr_time8; 
            `AL_BB_AGE8         : prdata8 <= best_bfr_age8;
            `AL_DIV_CLK8        : prdata8 <= {24'd0, div_clk8}; 
            `AL_STATUS8         : prdata8 <= {29'd0, reused8, inval_in_prog8,
                                           active};
            `AL_LST_INV_ADDR_L8 : prdata8 <= lst_inv_addr_l8; 
            `AL_LST_INV_ADDR_U8 : prdata8 <= {16'd0, lst_inv_addr_u8};
            `AL_LST_INV_PORT8   : prdata8 <= {30'd0, lst_inv_port8};

            default:   prdata8 <= 32'h0000_0000;
         endcase
         end
      else
         prdata8 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB8 writable8 registers
// ------------------------------------------------------------------------
// Lower8 destination8 frame8 address register  
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         frm_d_addr_l8 <= 32'h0000_0000;         
      else if (write_enable8 & (paddr8 == `AL_FRM_D_ADDR_L8))
         frm_d_addr_l8 <= pwdata8;
      else
         frm_d_addr_l8 <= frm_d_addr_l8;
      end   


// Upper8 destination8 frame8 address register  
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         frm_d_addr_u8 <= 16'h0000;         
      else if (write_enable8 & (paddr8 == `AL_FRM_D_ADDR_U8))
         frm_d_addr_u8 <= pwdata8[15:0];
      else
         frm_d_addr_u8 <= frm_d_addr_u8;
      end   


// Lower8 source8 frame8 address register  
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         frm_s_addr_l8 <= 32'h0000_0000;         
      else if (write_enable8 & (paddr8 == `AL_FRM_S_ADDR_L8))
         frm_s_addr_l8 <= pwdata8;
      else
         frm_s_addr_l8 <= frm_s_addr_l8;
      end   


// Upper8 source8 frame8 address register  
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         frm_s_addr_u8 <= 16'h0000;         
      else if (write_enable8 & (paddr8 == `AL_FRM_S_ADDR_U8))
         frm_s_addr_u8 <= pwdata8[15:0];
      else
         frm_s_addr_u8 <= frm_s_addr_u8;
      end   


// Source8 port  
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         s_port8 <= 2'b00;         
      else if (write_enable8 & (paddr8 == `AL_S_PORT8))
         s_port8 <= pwdata8[1:0];
      else
         s_port8 <= s_port8;
      end   


// Lower8 switch8 MAC8 address
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         mac_addr_l8 <= 32'h0000_0000;         
      else if (write_enable8 & (paddr8 == `AL_MAC_ADDR_L8))
         mac_addr_l8 <= pwdata8;
      else
         mac_addr_l8 <= mac_addr_l8;
      end   


// Upper8 switch8 MAC8 address 
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         mac_addr_u8 <= 16'h0000;         
      else if (write_enable8 & (paddr8 == `AL_MAC_ADDR_U8))
         mac_addr_u8 <= pwdata8[15:0];
      else
         mac_addr_u8 <= mac_addr_u8;
      end   


// Best8 before age8 
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         best_bfr_age8 <= 32'hffff_ffff;         
      else if (write_enable8 & (paddr8 == `AL_BB_AGE8))
         best_bfr_age8 <= pwdata8;
      else
         best_bfr_age8 <= best_bfr_age8;
      end   


// clock8 divider8
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         div_clk8 <= 8'h00;         
      else if (write_enable8 & (paddr8 == `AL_DIV_CLK8))
         div_clk8 <= pwdata8[7:0];
      else
         div_clk8 <= div_clk8;
      end   


// command.  Needs to be automatically8 cleared8 on following8 cycle
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable8 & (paddr8 == `AL_COMMAND8))
         command <= pwdata8[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last8 invalidated8 port and address values.  These8 can either8 be updated
//   by normal8 operation8 of address checker overwriting8 existing values or
//   by the age8 checker being commanded8 to invalidate8 out of date8 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk8 or negedge n_p_reset8)
      begin 
      if (~n_p_reset8)
      begin
         lst_inv_addr_l8 <= 32'd0;
         lst_inv_addr_u8 <= 16'd0;
         lst_inv_port8   <= 2'd0;
      end
      else if (reused8)        // reused8 flag8 from address checker
      begin
         lst_inv_addr_l8 <= lst_inv_addr_nrm8[31:0];
         lst_inv_addr_u8 <= lst_inv_addr_nrm8[47:32];
         lst_inv_port8   <= lst_inv_port_nrm8;
      end
//      else if (command == 2'b01)  // invalidate8 aged8 from age8 checker
      else if (inval_in_prog8)  // invalidate8 aged8 from age8 checker
      begin
         lst_inv_addr_l8 <= lst_inv_addr_cmd8[31:0];
         lst_inv_addr_u8 <= lst_inv_addr_cmd8[47:32];
         lst_inv_port8   <= lst_inv_port_cmd8;
      end
      else
      begin
         lst_inv_addr_l8 <= lst_inv_addr_l8;
         lst_inv_addr_u8 <= lst_inv_addr_u8;
         lst_inv_port8   <= lst_inv_port8;
      end
      end
 


`ifdef ABV_ON8

defparam i_apb_monitor8.ABUS_WIDTH8 = 7;

// APB8 ASSERTION8 VIP8
apb_monitor8 i_apb_monitor8(.pclk_i8(pclk8), 
                          .presetn_i8(n_p_reset8),
                          .penable_i8(penable8),
                          .psel_i8(psel8),
                          .paddr_i8(paddr8),
                          .pwrite_i8(pwrite8),
                          .pwdata_i8(pwdata8),
                          .prdata_i8(prdata8)); 

// psl8 default clock8 = (posedge pclk8);

// ASSUMPTIONS8
//// active (set by address checker) and invalidation8 in progress8 should never both be set
//// psl8 assume_never_active_inval_aged8 : assume never (active & inval_in_prog8);


// ASSERTION8 CHECKS8
// never read and write at the same time
// psl8 assert_never_rd_wr8 : assert never (read_enable8 & write_enable8);

// check apb8 writes, pick8 command reqister8 as arbitary8 example8
// psl8 assert_cmd_wr8 : assert always ((paddr8 == `AL_COMMAND8) & write_enable8) -> 
//                                    next(command == prev(pwdata8[1:0])) abort8(~n_p_reset8);


// check rw writes, pick8 clock8 divider8 reqister8 as arbitary8 example8.  It takes8 2 cycles8 to write
// then8 read back data, therefore8 need to store8 original write data for use in assertion8 check
reg [31:0] pwdata_d8;  // 1 cycle delayed8 
always @ (posedge pclk8) pwdata_d8 <= pwdata8;

// psl8 assert_rw_div_clk8 : 
// assert always {((paddr8 == `AL_DIV_CLK8) & write_enable8) ; ((paddr8 == `AL_DIV_CLK8) & read_enable8)} |=>
// {prev(pwdata_d8[7:0]) == prdata8[7:0]};



// COVER8 SANITY8 CHECKS8
// sanity8 read
// psl8 output_for_div_clk8 : cover {((paddr8 == `AL_DIV_CLK8) & read_enable8); prdata8[7:0] == 8'h55};


`endif


endmodule 


