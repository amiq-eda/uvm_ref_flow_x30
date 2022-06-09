//File5 name   : alut_reg_bank5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

// compiler5 directives5
`include "alut_defines5.v"


module alut_reg_bank5
(   
   // Inputs5
   pclk5,
   n_p_reset5,
   psel5,            
   penable5,       
   pwrite5,         
   paddr5,           
   pwdata5,          

   curr_time5,
   add_check_active5,
   age_check_active5,
   inval_in_prog5,
   reused5,
   d_port5,
   lst_inv_addr_nrm5,
   lst_inv_port_nrm5,
   lst_inv_addr_cmd5,
   lst_inv_port_cmd5,

   // Outputs5
   mac_addr5,    
   d_addr5,   
   s_addr5,    
   s_port5,    
   best_bfr_age5,
   div_clk5,     
   command, 
   prdata5,  
   clear_reused5           
);


   // APB5 Inputs5
   input                 pclk5;             // APB5 clock5
   input                 n_p_reset5;        // Reset5
   input                 psel5;             // Module5 select5 signal5
   input                 penable5;          // Enable5 signal5 
   input                 pwrite5;           // Write when HIGH5 and read when LOW5
   input [6:0]           paddr5;            // Address bus for read write
   input [31:0]          pwdata5;           // APB5 write bus

   // Inputs5 from other ALUT5 blocks
   input [31:0]          curr_time5;        // current time
   input                 add_check_active5; // used to calculate5 status[0]
   input                 age_check_active5; // used to calculate5 status[0]
   input                 inval_in_prog5;    // status[1]
   input                 reused5;           // status[2]
   input [4:0]           d_port5;           // calculated5 destination5 port for tx5
   input [47:0]          lst_inv_addr_nrm5; // last invalidated5 addr normal5 op
   input [1:0]           lst_inv_port_nrm5; // last invalidated5 port normal5 op
   input [47:0]          lst_inv_addr_cmd5; // last invalidated5 addr via cmd5
   input [1:0]           lst_inv_port_cmd5; // last invalidated5 port via cmd5
   

   output [47:0]         mac_addr5;         // address of the switch5
   output [47:0]         d_addr5;           // address of frame5 to be checked5
   output [47:0]         s_addr5;           // address of frame5 to be stored5
   output [1:0]          s_port5;           // source5 port of current frame5
   output [31:0]         best_bfr_age5;     // best5 before age5
   output [7:0]          div_clk5;          // programmed5 clock5 divider5 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata5;           // APB5 read bus
   output                clear_reused5;     // indicates5 status reg read 

   reg    [31:0]         prdata5;           //APB5 read bus   
   reg    [31:0]         frm_d_addr_l5;     
   reg    [15:0]         frm_d_addr_u5;     
   reg    [31:0]         frm_s_addr_l5;     
   reg    [15:0]         frm_s_addr_u5;     
   reg    [1:0]          s_port5;           
   reg    [31:0]         mac_addr_l5;       
   reg    [15:0]         mac_addr_u5;       
   reg    [31:0]         best_bfr_age5;     
   reg    [7:0]          div_clk5;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l5;   
   reg    [15:0]         lst_inv_addr_u5;   
   reg    [1:0]          lst_inv_port5;     


   // Internal Signal5 Declarations5
   wire                  read_enable5;      //APB5 read enable
   wire                  write_enable5;     //APB5 write enable
   wire   [47:0]         mac_addr5;        
   wire   [47:0]         d_addr5;          
   wire   [47:0]         src_addr5;        
   wire                  clear_reused5;    
   wire                  active;

   // ----------------------------
   // General5 Assignments5
   // ----------------------------

   assign read_enable5    = (psel5 & ~penable5 & ~pwrite5);
   assign write_enable5   = (psel5 & penable5 & pwrite5);

   assign mac_addr5  = {mac_addr_u5, mac_addr_l5}; 
   assign d_addr5 =    {frm_d_addr_u5, frm_d_addr_l5};
   assign s_addr5    = {frm_s_addr_u5, frm_s_addr_l5}; 

   assign clear_reused5 = read_enable5 & (paddr5 == `AL_STATUS5) & ~active;

   assign active = (add_check_active5 | age_check_active5);

// ------------------------------------------------------------------------
//   Read Mux5 Control5 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         prdata5 <= 32'h0000_0000;
      else if (read_enable5)
         begin
         case (paddr5)
            `AL_FRM_D_ADDR_L5   : prdata5 <= frm_d_addr_l5;
            `AL_FRM_D_ADDR_U5   : prdata5 <= {16'd0, frm_d_addr_u5};    
            `AL_FRM_S_ADDR_L5   : prdata5 <= frm_s_addr_l5; 
            `AL_FRM_S_ADDR_U5   : prdata5 <= {16'd0, frm_s_addr_u5}; 
            `AL_S_PORT5         : prdata5 <= {30'd0, s_port5}; 
            `AL_D_PORT5         : prdata5 <= {27'd0, d_port5}; 
            `AL_MAC_ADDR_L5     : prdata5 <= mac_addr_l5;
            `AL_MAC_ADDR_U5     : prdata5 <= {16'd0, mac_addr_u5};   
            `AL_CUR_TIME5       : prdata5 <= curr_time5; 
            `AL_BB_AGE5         : prdata5 <= best_bfr_age5;
            `AL_DIV_CLK5        : prdata5 <= {24'd0, div_clk5}; 
            `AL_STATUS5         : prdata5 <= {29'd0, reused5, inval_in_prog5,
                                           active};
            `AL_LST_INV_ADDR_L5 : prdata5 <= lst_inv_addr_l5; 
            `AL_LST_INV_ADDR_U5 : prdata5 <= {16'd0, lst_inv_addr_u5};
            `AL_LST_INV_PORT5   : prdata5 <= {30'd0, lst_inv_port5};

            default:   prdata5 <= 32'h0000_0000;
         endcase
         end
      else
         prdata5 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB5 writable5 registers
// ------------------------------------------------------------------------
// Lower5 destination5 frame5 address register  
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         frm_d_addr_l5 <= 32'h0000_0000;         
      else if (write_enable5 & (paddr5 == `AL_FRM_D_ADDR_L5))
         frm_d_addr_l5 <= pwdata5;
      else
         frm_d_addr_l5 <= frm_d_addr_l5;
      end   


// Upper5 destination5 frame5 address register  
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         frm_d_addr_u5 <= 16'h0000;         
      else if (write_enable5 & (paddr5 == `AL_FRM_D_ADDR_U5))
         frm_d_addr_u5 <= pwdata5[15:0];
      else
         frm_d_addr_u5 <= frm_d_addr_u5;
      end   


// Lower5 source5 frame5 address register  
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         frm_s_addr_l5 <= 32'h0000_0000;         
      else if (write_enable5 & (paddr5 == `AL_FRM_S_ADDR_L5))
         frm_s_addr_l5 <= pwdata5;
      else
         frm_s_addr_l5 <= frm_s_addr_l5;
      end   


// Upper5 source5 frame5 address register  
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         frm_s_addr_u5 <= 16'h0000;         
      else if (write_enable5 & (paddr5 == `AL_FRM_S_ADDR_U5))
         frm_s_addr_u5 <= pwdata5[15:0];
      else
         frm_s_addr_u5 <= frm_s_addr_u5;
      end   


// Source5 port  
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         s_port5 <= 2'b00;         
      else if (write_enable5 & (paddr5 == `AL_S_PORT5))
         s_port5 <= pwdata5[1:0];
      else
         s_port5 <= s_port5;
      end   


// Lower5 switch5 MAC5 address
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         mac_addr_l5 <= 32'h0000_0000;         
      else if (write_enable5 & (paddr5 == `AL_MAC_ADDR_L5))
         mac_addr_l5 <= pwdata5;
      else
         mac_addr_l5 <= mac_addr_l5;
      end   


// Upper5 switch5 MAC5 address 
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         mac_addr_u5 <= 16'h0000;         
      else if (write_enable5 & (paddr5 == `AL_MAC_ADDR_U5))
         mac_addr_u5 <= pwdata5[15:0];
      else
         mac_addr_u5 <= mac_addr_u5;
      end   


// Best5 before age5 
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         best_bfr_age5 <= 32'hffff_ffff;         
      else if (write_enable5 & (paddr5 == `AL_BB_AGE5))
         best_bfr_age5 <= pwdata5;
      else
         best_bfr_age5 <= best_bfr_age5;
      end   


// clock5 divider5
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         div_clk5 <= 8'h00;         
      else if (write_enable5 & (paddr5 == `AL_DIV_CLK5))
         div_clk5 <= pwdata5[7:0];
      else
         div_clk5 <= div_clk5;
      end   


// command.  Needs to be automatically5 cleared5 on following5 cycle
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable5 & (paddr5 == `AL_COMMAND5))
         command <= pwdata5[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last5 invalidated5 port and address values.  These5 can either5 be updated
//   by normal5 operation5 of address checker overwriting5 existing values or
//   by the age5 checker being commanded5 to invalidate5 out of date5 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk5 or negedge n_p_reset5)
      begin 
      if (~n_p_reset5)
      begin
         lst_inv_addr_l5 <= 32'd0;
         lst_inv_addr_u5 <= 16'd0;
         lst_inv_port5   <= 2'd0;
      end
      else if (reused5)        // reused5 flag5 from address checker
      begin
         lst_inv_addr_l5 <= lst_inv_addr_nrm5[31:0];
         lst_inv_addr_u5 <= lst_inv_addr_nrm5[47:32];
         lst_inv_port5   <= lst_inv_port_nrm5;
      end
//      else if (command == 2'b01)  // invalidate5 aged5 from age5 checker
      else if (inval_in_prog5)  // invalidate5 aged5 from age5 checker
      begin
         lst_inv_addr_l5 <= lst_inv_addr_cmd5[31:0];
         lst_inv_addr_u5 <= lst_inv_addr_cmd5[47:32];
         lst_inv_port5   <= lst_inv_port_cmd5;
      end
      else
      begin
         lst_inv_addr_l5 <= lst_inv_addr_l5;
         lst_inv_addr_u5 <= lst_inv_addr_u5;
         lst_inv_port5   <= lst_inv_port5;
      end
      end
 


`ifdef ABV_ON5

defparam i_apb_monitor5.ABUS_WIDTH5 = 7;

// APB5 ASSERTION5 VIP5
apb_monitor5 i_apb_monitor5(.pclk_i5(pclk5), 
                          .presetn_i5(n_p_reset5),
                          .penable_i5(penable5),
                          .psel_i5(psel5),
                          .paddr_i5(paddr5),
                          .pwrite_i5(pwrite5),
                          .pwdata_i5(pwdata5),
                          .prdata_i5(prdata5)); 

// psl5 default clock5 = (posedge pclk5);

// ASSUMPTIONS5
//// active (set by address checker) and invalidation5 in progress5 should never both be set
//// psl5 assume_never_active_inval_aged5 : assume never (active & inval_in_prog5);


// ASSERTION5 CHECKS5
// never read and write at the same time
// psl5 assert_never_rd_wr5 : assert never (read_enable5 & write_enable5);

// check apb5 writes, pick5 command reqister5 as arbitary5 example5
// psl5 assert_cmd_wr5 : assert always ((paddr5 == `AL_COMMAND5) & write_enable5) -> 
//                                    next(command == prev(pwdata5[1:0])) abort5(~n_p_reset5);


// check rw writes, pick5 clock5 divider5 reqister5 as arbitary5 example5.  It takes5 2 cycles5 to write
// then5 read back data, therefore5 need to store5 original write data for use in assertion5 check
reg [31:0] pwdata_d5;  // 1 cycle delayed5 
always @ (posedge pclk5) pwdata_d5 <= pwdata5;

// psl5 assert_rw_div_clk5 : 
// assert always {((paddr5 == `AL_DIV_CLK5) & write_enable5) ; ((paddr5 == `AL_DIV_CLK5) & read_enable5)} |=>
// {prev(pwdata_d5[7:0]) == prdata5[7:0]};



// COVER5 SANITY5 CHECKS5
// sanity5 read
// psl5 output_for_div_clk5 : cover {((paddr5 == `AL_DIV_CLK5) & read_enable5); prdata5[7:0] == 8'h55};


`endif


endmodule 


