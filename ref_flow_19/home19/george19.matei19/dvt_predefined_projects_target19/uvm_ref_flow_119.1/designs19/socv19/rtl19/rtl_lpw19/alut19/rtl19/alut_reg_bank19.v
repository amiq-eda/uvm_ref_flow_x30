//File19 name   : alut_reg_bank19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

// compiler19 directives19
`include "alut_defines19.v"


module alut_reg_bank19
(   
   // Inputs19
   pclk19,
   n_p_reset19,
   psel19,            
   penable19,       
   pwrite19,         
   paddr19,           
   pwdata19,          

   curr_time19,
   add_check_active19,
   age_check_active19,
   inval_in_prog19,
   reused19,
   d_port19,
   lst_inv_addr_nrm19,
   lst_inv_port_nrm19,
   lst_inv_addr_cmd19,
   lst_inv_port_cmd19,

   // Outputs19
   mac_addr19,    
   d_addr19,   
   s_addr19,    
   s_port19,    
   best_bfr_age19,
   div_clk19,     
   command, 
   prdata19,  
   clear_reused19           
);


   // APB19 Inputs19
   input                 pclk19;             // APB19 clock19
   input                 n_p_reset19;        // Reset19
   input                 psel19;             // Module19 select19 signal19
   input                 penable19;          // Enable19 signal19 
   input                 pwrite19;           // Write when HIGH19 and read when LOW19
   input [6:0]           paddr19;            // Address bus for read write
   input [31:0]          pwdata19;           // APB19 write bus

   // Inputs19 from other ALUT19 blocks
   input [31:0]          curr_time19;        // current time
   input                 add_check_active19; // used to calculate19 status[0]
   input                 age_check_active19; // used to calculate19 status[0]
   input                 inval_in_prog19;    // status[1]
   input                 reused19;           // status[2]
   input [4:0]           d_port19;           // calculated19 destination19 port for tx19
   input [47:0]          lst_inv_addr_nrm19; // last invalidated19 addr normal19 op
   input [1:0]           lst_inv_port_nrm19; // last invalidated19 port normal19 op
   input [47:0]          lst_inv_addr_cmd19; // last invalidated19 addr via cmd19
   input [1:0]           lst_inv_port_cmd19; // last invalidated19 port via cmd19
   

   output [47:0]         mac_addr19;         // address of the switch19
   output [47:0]         d_addr19;           // address of frame19 to be checked19
   output [47:0]         s_addr19;           // address of frame19 to be stored19
   output [1:0]          s_port19;           // source19 port of current frame19
   output [31:0]         best_bfr_age19;     // best19 before age19
   output [7:0]          div_clk19;          // programmed19 clock19 divider19 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata19;           // APB19 read bus
   output                clear_reused19;     // indicates19 status reg read 

   reg    [31:0]         prdata19;           //APB19 read bus   
   reg    [31:0]         frm_d_addr_l19;     
   reg    [15:0]         frm_d_addr_u19;     
   reg    [31:0]         frm_s_addr_l19;     
   reg    [15:0]         frm_s_addr_u19;     
   reg    [1:0]          s_port19;           
   reg    [31:0]         mac_addr_l19;       
   reg    [15:0]         mac_addr_u19;       
   reg    [31:0]         best_bfr_age19;     
   reg    [7:0]          div_clk19;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l19;   
   reg    [15:0]         lst_inv_addr_u19;   
   reg    [1:0]          lst_inv_port19;     


   // Internal Signal19 Declarations19
   wire                  read_enable19;      //APB19 read enable
   wire                  write_enable19;     //APB19 write enable
   wire   [47:0]         mac_addr19;        
   wire   [47:0]         d_addr19;          
   wire   [47:0]         src_addr19;        
   wire                  clear_reused19;    
   wire                  active;

   // ----------------------------
   // General19 Assignments19
   // ----------------------------

   assign read_enable19    = (psel19 & ~penable19 & ~pwrite19);
   assign write_enable19   = (psel19 & penable19 & pwrite19);

   assign mac_addr19  = {mac_addr_u19, mac_addr_l19}; 
   assign d_addr19 =    {frm_d_addr_u19, frm_d_addr_l19};
   assign s_addr19    = {frm_s_addr_u19, frm_s_addr_l19}; 

   assign clear_reused19 = read_enable19 & (paddr19 == `AL_STATUS19) & ~active;

   assign active = (add_check_active19 | age_check_active19);

// ------------------------------------------------------------------------
//   Read Mux19 Control19 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         prdata19 <= 32'h0000_0000;
      else if (read_enable19)
         begin
         case (paddr19)
            `AL_FRM_D_ADDR_L19   : prdata19 <= frm_d_addr_l19;
            `AL_FRM_D_ADDR_U19   : prdata19 <= {16'd0, frm_d_addr_u19};    
            `AL_FRM_S_ADDR_L19   : prdata19 <= frm_s_addr_l19; 
            `AL_FRM_S_ADDR_U19   : prdata19 <= {16'd0, frm_s_addr_u19}; 
            `AL_S_PORT19         : prdata19 <= {30'd0, s_port19}; 
            `AL_D_PORT19         : prdata19 <= {27'd0, d_port19}; 
            `AL_MAC_ADDR_L19     : prdata19 <= mac_addr_l19;
            `AL_MAC_ADDR_U19     : prdata19 <= {16'd0, mac_addr_u19};   
            `AL_CUR_TIME19       : prdata19 <= curr_time19; 
            `AL_BB_AGE19         : prdata19 <= best_bfr_age19;
            `AL_DIV_CLK19        : prdata19 <= {24'd0, div_clk19}; 
            `AL_STATUS19         : prdata19 <= {29'd0, reused19, inval_in_prog19,
                                           active};
            `AL_LST_INV_ADDR_L19 : prdata19 <= lst_inv_addr_l19; 
            `AL_LST_INV_ADDR_U19 : prdata19 <= {16'd0, lst_inv_addr_u19};
            `AL_LST_INV_PORT19   : prdata19 <= {30'd0, lst_inv_port19};

            default:   prdata19 <= 32'h0000_0000;
         endcase
         end
      else
         prdata19 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB19 writable19 registers
// ------------------------------------------------------------------------
// Lower19 destination19 frame19 address register  
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         frm_d_addr_l19 <= 32'h0000_0000;         
      else if (write_enable19 & (paddr19 == `AL_FRM_D_ADDR_L19))
         frm_d_addr_l19 <= pwdata19;
      else
         frm_d_addr_l19 <= frm_d_addr_l19;
      end   


// Upper19 destination19 frame19 address register  
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         frm_d_addr_u19 <= 16'h0000;         
      else if (write_enable19 & (paddr19 == `AL_FRM_D_ADDR_U19))
         frm_d_addr_u19 <= pwdata19[15:0];
      else
         frm_d_addr_u19 <= frm_d_addr_u19;
      end   


// Lower19 source19 frame19 address register  
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         frm_s_addr_l19 <= 32'h0000_0000;         
      else if (write_enable19 & (paddr19 == `AL_FRM_S_ADDR_L19))
         frm_s_addr_l19 <= pwdata19;
      else
         frm_s_addr_l19 <= frm_s_addr_l19;
      end   


// Upper19 source19 frame19 address register  
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         frm_s_addr_u19 <= 16'h0000;         
      else if (write_enable19 & (paddr19 == `AL_FRM_S_ADDR_U19))
         frm_s_addr_u19 <= pwdata19[15:0];
      else
         frm_s_addr_u19 <= frm_s_addr_u19;
      end   


// Source19 port  
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         s_port19 <= 2'b00;         
      else if (write_enable19 & (paddr19 == `AL_S_PORT19))
         s_port19 <= pwdata19[1:0];
      else
         s_port19 <= s_port19;
      end   


// Lower19 switch19 MAC19 address
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         mac_addr_l19 <= 32'h0000_0000;         
      else if (write_enable19 & (paddr19 == `AL_MAC_ADDR_L19))
         mac_addr_l19 <= pwdata19;
      else
         mac_addr_l19 <= mac_addr_l19;
      end   


// Upper19 switch19 MAC19 address 
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         mac_addr_u19 <= 16'h0000;         
      else if (write_enable19 & (paddr19 == `AL_MAC_ADDR_U19))
         mac_addr_u19 <= pwdata19[15:0];
      else
         mac_addr_u19 <= mac_addr_u19;
      end   


// Best19 before age19 
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         best_bfr_age19 <= 32'hffff_ffff;         
      else if (write_enable19 & (paddr19 == `AL_BB_AGE19))
         best_bfr_age19 <= pwdata19;
      else
         best_bfr_age19 <= best_bfr_age19;
      end   


// clock19 divider19
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         div_clk19 <= 8'h00;         
      else if (write_enable19 & (paddr19 == `AL_DIV_CLK19))
         div_clk19 <= pwdata19[7:0];
      else
         div_clk19 <= div_clk19;
      end   


// command.  Needs to be automatically19 cleared19 on following19 cycle
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable19 & (paddr19 == `AL_COMMAND19))
         command <= pwdata19[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last19 invalidated19 port and address values.  These19 can either19 be updated
//   by normal19 operation19 of address checker overwriting19 existing values or
//   by the age19 checker being commanded19 to invalidate19 out of date19 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk19 or negedge n_p_reset19)
      begin 
      if (~n_p_reset19)
      begin
         lst_inv_addr_l19 <= 32'd0;
         lst_inv_addr_u19 <= 16'd0;
         lst_inv_port19   <= 2'd0;
      end
      else if (reused19)        // reused19 flag19 from address checker
      begin
         lst_inv_addr_l19 <= lst_inv_addr_nrm19[31:0];
         lst_inv_addr_u19 <= lst_inv_addr_nrm19[47:32];
         lst_inv_port19   <= lst_inv_port_nrm19;
      end
//      else if (command == 2'b01)  // invalidate19 aged19 from age19 checker
      else if (inval_in_prog19)  // invalidate19 aged19 from age19 checker
      begin
         lst_inv_addr_l19 <= lst_inv_addr_cmd19[31:0];
         lst_inv_addr_u19 <= lst_inv_addr_cmd19[47:32];
         lst_inv_port19   <= lst_inv_port_cmd19;
      end
      else
      begin
         lst_inv_addr_l19 <= lst_inv_addr_l19;
         lst_inv_addr_u19 <= lst_inv_addr_u19;
         lst_inv_port19   <= lst_inv_port19;
      end
      end
 


`ifdef ABV_ON19

defparam i_apb_monitor19.ABUS_WIDTH19 = 7;

// APB19 ASSERTION19 VIP19
apb_monitor19 i_apb_monitor19(.pclk_i19(pclk19), 
                          .presetn_i19(n_p_reset19),
                          .penable_i19(penable19),
                          .psel_i19(psel19),
                          .paddr_i19(paddr19),
                          .pwrite_i19(pwrite19),
                          .pwdata_i19(pwdata19),
                          .prdata_i19(prdata19)); 

// psl19 default clock19 = (posedge pclk19);

// ASSUMPTIONS19
//// active (set by address checker) and invalidation19 in progress19 should never both be set
//// psl19 assume_never_active_inval_aged19 : assume never (active & inval_in_prog19);


// ASSERTION19 CHECKS19
// never read and write at the same time
// psl19 assert_never_rd_wr19 : assert never (read_enable19 & write_enable19);

// check apb19 writes, pick19 command reqister19 as arbitary19 example19
// psl19 assert_cmd_wr19 : assert always ((paddr19 == `AL_COMMAND19) & write_enable19) -> 
//                                    next(command == prev(pwdata19[1:0])) abort19(~n_p_reset19);


// check rw writes, pick19 clock19 divider19 reqister19 as arbitary19 example19.  It takes19 2 cycles19 to write
// then19 read back data, therefore19 need to store19 original write data for use in assertion19 check
reg [31:0] pwdata_d19;  // 1 cycle delayed19 
always @ (posedge pclk19) pwdata_d19 <= pwdata19;

// psl19 assert_rw_div_clk19 : 
// assert always {((paddr19 == `AL_DIV_CLK19) & write_enable19) ; ((paddr19 == `AL_DIV_CLK19) & read_enable19)} |=>
// {prev(pwdata_d19[7:0]) == prdata19[7:0]};



// COVER19 SANITY19 CHECKS19
// sanity19 read
// psl19 output_for_div_clk19 : cover {((paddr19 == `AL_DIV_CLK19) & read_enable19); prdata19[7:0] == 8'h55};


`endif


endmodule 


