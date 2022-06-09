//File1 name   : alut_reg_bank1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

// compiler1 directives1
`include "alut_defines1.v"


module alut_reg_bank1
(   
   // Inputs1
   pclk1,
   n_p_reset1,
   psel1,            
   penable1,       
   pwrite1,         
   paddr1,           
   pwdata1,          

   curr_time1,
   add_check_active1,
   age_check_active1,
   inval_in_prog1,
   reused1,
   d_port1,
   lst_inv_addr_nrm1,
   lst_inv_port_nrm1,
   lst_inv_addr_cmd1,
   lst_inv_port_cmd1,

   // Outputs1
   mac_addr1,    
   d_addr1,   
   s_addr1,    
   s_port1,    
   best_bfr_age1,
   div_clk1,     
   command, 
   prdata1,  
   clear_reused1           
);


   // APB1 Inputs1
   input                 pclk1;             // APB1 clock1
   input                 n_p_reset1;        // Reset1
   input                 psel1;             // Module1 select1 signal1
   input                 penable1;          // Enable1 signal1 
   input                 pwrite1;           // Write when HIGH1 and read when LOW1
   input [6:0]           paddr1;            // Address bus for read write
   input [31:0]          pwdata1;           // APB1 write bus

   // Inputs1 from other ALUT1 blocks
   input [31:0]          curr_time1;        // current time
   input                 add_check_active1; // used to calculate1 status[0]
   input                 age_check_active1; // used to calculate1 status[0]
   input                 inval_in_prog1;    // status[1]
   input                 reused1;           // status[2]
   input [4:0]           d_port1;           // calculated1 destination1 port for tx1
   input [47:0]          lst_inv_addr_nrm1; // last invalidated1 addr normal1 op
   input [1:0]           lst_inv_port_nrm1; // last invalidated1 port normal1 op
   input [47:0]          lst_inv_addr_cmd1; // last invalidated1 addr via cmd1
   input [1:0]           lst_inv_port_cmd1; // last invalidated1 port via cmd1
   

   output [47:0]         mac_addr1;         // address of the switch1
   output [47:0]         d_addr1;           // address of frame1 to be checked1
   output [47:0]         s_addr1;           // address of frame1 to be stored1
   output [1:0]          s_port1;           // source1 port of current frame1
   output [31:0]         best_bfr_age1;     // best1 before age1
   output [7:0]          div_clk1;          // programmed1 clock1 divider1 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata1;           // APB1 read bus
   output                clear_reused1;     // indicates1 status reg read 

   reg    [31:0]         prdata1;           //APB1 read bus   
   reg    [31:0]         frm_d_addr_l1;     
   reg    [15:0]         frm_d_addr_u1;     
   reg    [31:0]         frm_s_addr_l1;     
   reg    [15:0]         frm_s_addr_u1;     
   reg    [1:0]          s_port1;           
   reg    [31:0]         mac_addr_l1;       
   reg    [15:0]         mac_addr_u1;       
   reg    [31:0]         best_bfr_age1;     
   reg    [7:0]          div_clk1;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l1;   
   reg    [15:0]         lst_inv_addr_u1;   
   reg    [1:0]          lst_inv_port1;     


   // Internal Signal1 Declarations1
   wire                  read_enable1;      //APB1 read enable
   wire                  write_enable1;     //APB1 write enable
   wire   [47:0]         mac_addr1;        
   wire   [47:0]         d_addr1;          
   wire   [47:0]         src_addr1;        
   wire                  clear_reused1;    
   wire                  active;

   // ----------------------------
   // General1 Assignments1
   // ----------------------------

   assign read_enable1    = (psel1 & ~penable1 & ~pwrite1);
   assign write_enable1   = (psel1 & penable1 & pwrite1);

   assign mac_addr1  = {mac_addr_u1, mac_addr_l1}; 
   assign d_addr1 =    {frm_d_addr_u1, frm_d_addr_l1};
   assign s_addr1    = {frm_s_addr_u1, frm_s_addr_l1}; 

   assign clear_reused1 = read_enable1 & (paddr1 == `AL_STATUS1) & ~active;

   assign active = (add_check_active1 | age_check_active1);

// ------------------------------------------------------------------------
//   Read Mux1 Control1 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         prdata1 <= 32'h0000_0000;
      else if (read_enable1)
         begin
         case (paddr1)
            `AL_FRM_D_ADDR_L1   : prdata1 <= frm_d_addr_l1;
            `AL_FRM_D_ADDR_U1   : prdata1 <= {16'd0, frm_d_addr_u1};    
            `AL_FRM_S_ADDR_L1   : prdata1 <= frm_s_addr_l1; 
            `AL_FRM_S_ADDR_U1   : prdata1 <= {16'd0, frm_s_addr_u1}; 
            `AL_S_PORT1         : prdata1 <= {30'd0, s_port1}; 
            `AL_D_PORT1         : prdata1 <= {27'd0, d_port1}; 
            `AL_MAC_ADDR_L1     : prdata1 <= mac_addr_l1;
            `AL_MAC_ADDR_U1     : prdata1 <= {16'd0, mac_addr_u1};   
            `AL_CUR_TIME1       : prdata1 <= curr_time1; 
            `AL_BB_AGE1         : prdata1 <= best_bfr_age1;
            `AL_DIV_CLK1        : prdata1 <= {24'd0, div_clk1}; 
            `AL_STATUS1         : prdata1 <= {29'd0, reused1, inval_in_prog1,
                                           active};
            `AL_LST_INV_ADDR_L1 : prdata1 <= lst_inv_addr_l1; 
            `AL_LST_INV_ADDR_U1 : prdata1 <= {16'd0, lst_inv_addr_u1};
            `AL_LST_INV_PORT1   : prdata1 <= {30'd0, lst_inv_port1};

            default:   prdata1 <= 32'h0000_0000;
         endcase
         end
      else
         prdata1 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB1 writable1 registers
// ------------------------------------------------------------------------
// Lower1 destination1 frame1 address register  
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         frm_d_addr_l1 <= 32'h0000_0000;         
      else if (write_enable1 & (paddr1 == `AL_FRM_D_ADDR_L1))
         frm_d_addr_l1 <= pwdata1;
      else
         frm_d_addr_l1 <= frm_d_addr_l1;
      end   


// Upper1 destination1 frame1 address register  
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         frm_d_addr_u1 <= 16'h0000;         
      else if (write_enable1 & (paddr1 == `AL_FRM_D_ADDR_U1))
         frm_d_addr_u1 <= pwdata1[15:0];
      else
         frm_d_addr_u1 <= frm_d_addr_u1;
      end   


// Lower1 source1 frame1 address register  
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         frm_s_addr_l1 <= 32'h0000_0000;         
      else if (write_enable1 & (paddr1 == `AL_FRM_S_ADDR_L1))
         frm_s_addr_l1 <= pwdata1;
      else
         frm_s_addr_l1 <= frm_s_addr_l1;
      end   


// Upper1 source1 frame1 address register  
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         frm_s_addr_u1 <= 16'h0000;         
      else if (write_enable1 & (paddr1 == `AL_FRM_S_ADDR_U1))
         frm_s_addr_u1 <= pwdata1[15:0];
      else
         frm_s_addr_u1 <= frm_s_addr_u1;
      end   


// Source1 port  
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         s_port1 <= 2'b00;         
      else if (write_enable1 & (paddr1 == `AL_S_PORT1))
         s_port1 <= pwdata1[1:0];
      else
         s_port1 <= s_port1;
      end   


// Lower1 switch1 MAC1 address
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         mac_addr_l1 <= 32'h0000_0000;         
      else if (write_enable1 & (paddr1 == `AL_MAC_ADDR_L1))
         mac_addr_l1 <= pwdata1;
      else
         mac_addr_l1 <= mac_addr_l1;
      end   


// Upper1 switch1 MAC1 address 
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         mac_addr_u1 <= 16'h0000;         
      else if (write_enable1 & (paddr1 == `AL_MAC_ADDR_U1))
         mac_addr_u1 <= pwdata1[15:0];
      else
         mac_addr_u1 <= mac_addr_u1;
      end   


// Best1 before age1 
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         best_bfr_age1 <= 32'hffff_ffff;         
      else if (write_enable1 & (paddr1 == `AL_BB_AGE1))
         best_bfr_age1 <= pwdata1;
      else
         best_bfr_age1 <= best_bfr_age1;
      end   


// clock1 divider1
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         div_clk1 <= 8'h00;         
      else if (write_enable1 & (paddr1 == `AL_DIV_CLK1))
         div_clk1 <= pwdata1[7:0];
      else
         div_clk1 <= div_clk1;
      end   


// command.  Needs to be automatically1 cleared1 on following1 cycle
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable1 & (paddr1 == `AL_COMMAND1))
         command <= pwdata1[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last1 invalidated1 port and address values.  These1 can either1 be updated
//   by normal1 operation1 of address checker overwriting1 existing values or
//   by the age1 checker being commanded1 to invalidate1 out of date1 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk1 or negedge n_p_reset1)
      begin 
      if (~n_p_reset1)
      begin
         lst_inv_addr_l1 <= 32'd0;
         lst_inv_addr_u1 <= 16'd0;
         lst_inv_port1   <= 2'd0;
      end
      else if (reused1)        // reused1 flag1 from address checker
      begin
         lst_inv_addr_l1 <= lst_inv_addr_nrm1[31:0];
         lst_inv_addr_u1 <= lst_inv_addr_nrm1[47:32];
         lst_inv_port1   <= lst_inv_port_nrm1;
      end
//      else if (command == 2'b01)  // invalidate1 aged1 from age1 checker
      else if (inval_in_prog1)  // invalidate1 aged1 from age1 checker
      begin
         lst_inv_addr_l1 <= lst_inv_addr_cmd1[31:0];
         lst_inv_addr_u1 <= lst_inv_addr_cmd1[47:32];
         lst_inv_port1   <= lst_inv_port_cmd1;
      end
      else
      begin
         lst_inv_addr_l1 <= lst_inv_addr_l1;
         lst_inv_addr_u1 <= lst_inv_addr_u1;
         lst_inv_port1   <= lst_inv_port1;
      end
      end
 


`ifdef ABV_ON1

defparam i_apb_monitor1.ABUS_WIDTH1 = 7;

// APB1 ASSERTION1 VIP1
apb_monitor1 i_apb_monitor1(.pclk_i1(pclk1), 
                          .presetn_i1(n_p_reset1),
                          .penable_i1(penable1),
                          .psel_i1(psel1),
                          .paddr_i1(paddr1),
                          .pwrite_i1(pwrite1),
                          .pwdata_i1(pwdata1),
                          .prdata_i1(prdata1)); 

// psl1 default clock1 = (posedge pclk1);

// ASSUMPTIONS1
//// active (set by address checker) and invalidation1 in progress1 should never both be set
//// psl1 assume_never_active_inval_aged1 : assume never (active & inval_in_prog1);


// ASSERTION1 CHECKS1
// never read and write at the same time
// psl1 assert_never_rd_wr1 : assert never (read_enable1 & write_enable1);

// check apb1 writes, pick1 command reqister1 as arbitary1 example1
// psl1 assert_cmd_wr1 : assert always ((paddr1 == `AL_COMMAND1) & write_enable1) -> 
//                                    next(command == prev(pwdata1[1:0])) abort1(~n_p_reset1);


// check rw writes, pick1 clock1 divider1 reqister1 as arbitary1 example1.  It takes1 2 cycles1 to write
// then1 read back data, therefore1 need to store1 original write data for use in assertion1 check
reg [31:0] pwdata_d1;  // 1 cycle delayed1 
always @ (posedge pclk1) pwdata_d1 <= pwdata1;

// psl1 assert_rw_div_clk1 : 
// assert always {((paddr1 == `AL_DIV_CLK1) & write_enable1) ; ((paddr1 == `AL_DIV_CLK1) & read_enable1)} |=>
// {prev(pwdata_d1[7:0]) == prdata1[7:0]};



// COVER1 SANITY1 CHECKS1
// sanity1 read
// psl1 output_for_div_clk1 : cover {((paddr1 == `AL_DIV_CLK1) & read_enable1); prdata1[7:0] == 8'h55};


`endif


endmodule 


