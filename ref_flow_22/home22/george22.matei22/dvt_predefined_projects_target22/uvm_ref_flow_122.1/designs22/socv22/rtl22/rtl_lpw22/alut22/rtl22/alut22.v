//File22 name   : alut22.v
//Title22       : ALUT22 top level
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
module alut22
(   
   // Inputs22
   pclk22,
   n_p_reset22,
   psel22,            
   penable22,       
   pwrite22,         
   paddr22,           
   pwdata22,          

   // Outputs22
   prdata22  
);

   parameter   DW22 = 83;          // width of data busses22
   parameter   DD22 = 256;         // depth of RAM22


   // APB22 Inputs22
   input             pclk22;               // APB22 clock22                          
   input             n_p_reset22;          // Reset22                              
   input             psel22;               // Module22 select22 signal22               
   input             penable22;            // Enable22 signal22                      
   input             pwrite22;             // Write when HIGH22 and read when LOW22  
   input [6:0]       paddr22;              // Address bus for read write         
   input [31:0]      pwdata22;             // APB22 write bus                      

   output [31:0]     prdata22;             // APB22 read bus                       

   wire              pclk22;               // APB22 clock22                           
   wire [7:0]        mem_addr_add22;       // hash22 address for R/W22 to memory     
   wire              mem_write_add22;      // R/W22 flag22 (write = high22)            
   wire [DW22-1:0]     mem_write_data_add22; // write data for memory             
   wire [7:0]        mem_addr_age22;       // hash22 address for R/W22 to memory     
   wire              mem_write_age22;      // R/W22 flag22 (write = high22)            
   wire [DW22-1:0]     mem_write_data_age22; // write data for memory             
   wire [DW22-1:0]     mem_read_data_add22;  // read data from mem                 
   wire [DW22-1:0]     mem_read_data_age22;  // read data from mem  
   wire [31:0]       curr_time22;          // current time
   wire              active;             // status[0] adress22 checker active
   wire              inval_in_prog22;      // status[1] 
   wire              reused22;             // status[2] ALUT22 location22 overwritten22
   wire [4:0]        d_port22;             // calculated22 destination22 port for tx22
   wire [47:0]       lst_inv_addr_nrm22;   // last invalidated22 addr normal22 op
   wire [1:0]        lst_inv_port_nrm22;   // last invalidated22 port normal22 op
   wire [47:0]       lst_inv_addr_cmd22;   // last invalidated22 addr via cmd22
   wire [1:0]        lst_inv_port_cmd22;   // last invalidated22 port via cmd22
   wire [47:0]       mac_addr22;           // address of the switch22
   wire [47:0]       d_addr22;             // address of frame22 to be checked22
   wire [47:0]       s_addr22;             // address of frame22 to be stored22
   wire [1:0]        s_port22;             // source22 port of current frame22
   wire [31:0]       best_bfr_age22;       // best22 before age22
   wire [7:0]        div_clk22;            // programmed22 clock22 divider22 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata22;             // APB22 read bus
   wire              age_confirmed22;      // valid flag22 from age22 checker        
   wire              age_ok22;             // result from age22 checker 
   wire              clear_reused22;       // read/clear flag22 for reused22 signal22           
   wire              check_age22;          // request flag22 for age22 check
   wire [31:0]       last_accessed22;      // time field sent22 for age22 check




alut_reg_bank22 i_alut_reg_bank22
(   
   // Inputs22
   .pclk22(pclk22),
   .n_p_reset22(n_p_reset22),
   .psel22(psel22),            
   .penable22(penable22),       
   .pwrite22(pwrite22),         
   .paddr22(paddr22),           
   .pwdata22(pwdata22),          
   .curr_time22(curr_time22),
   .add_check_active22(add_check_active22),
   .age_check_active22(age_check_active22),
   .inval_in_prog22(inval_in_prog22),
   .reused22(reused22),
   .d_port22(d_port22),
   .lst_inv_addr_nrm22(lst_inv_addr_nrm22),
   .lst_inv_port_nrm22(lst_inv_port_nrm22),
   .lst_inv_addr_cmd22(lst_inv_addr_cmd22),
   .lst_inv_port_cmd22(lst_inv_port_cmd22),

   // Outputs22
   .mac_addr22(mac_addr22),    
   .d_addr22(d_addr22),   
   .s_addr22(s_addr22),    
   .s_port22(s_port22),    
   .best_bfr_age22(best_bfr_age22),
   .div_clk22(div_clk22),     
   .command(command), 
   .prdata22(prdata22),  
   .clear_reused22(clear_reused22)           
);


alut_addr_checker22 i_alut_addr_checker22
(   
   // Inputs22
   .pclk22(pclk22),
   .n_p_reset22(n_p_reset22),
   .command(command),
   .mac_addr22(mac_addr22),
   .d_addr22(d_addr22),
   .s_addr22(s_addr22),
   .s_port22(s_port22),
   .curr_time22(curr_time22),
   .mem_read_data_add22(mem_read_data_add22),
   .age_confirmed22(age_confirmed22),
   .age_ok22(age_ok22),
   .clear_reused22(clear_reused22),

   //outputs22
   .d_port22(d_port22),
   .add_check_active22(add_check_active22),
   .mem_addr_add22(mem_addr_add22),
   .mem_write_add22(mem_write_add22),
   .mem_write_data_add22(mem_write_data_add22),
   .lst_inv_addr_nrm22(lst_inv_addr_nrm22),
   .lst_inv_port_nrm22(lst_inv_port_nrm22),
   .check_age22(check_age22),
   .last_accessed22(last_accessed22),
   .reused22(reused22)
);


alut_age_checker22 i_alut_age_checker22
(   
   // Inputs22
   .pclk22(pclk22),
   .n_p_reset22(n_p_reset22),
   .command(command),          
   .div_clk22(div_clk22),          
   .mem_read_data_age22(mem_read_data_age22),
   .check_age22(check_age22),        
   .last_accessed22(last_accessed22), 
   .best_bfr_age22(best_bfr_age22),   
   .add_check_active22(add_check_active22),

   // outputs22
   .curr_time22(curr_time22),         
   .mem_addr_age22(mem_addr_age22),      
   .mem_write_age22(mem_write_age22),     
   .mem_write_data_age22(mem_write_data_age22),
   .lst_inv_addr_cmd22(lst_inv_addr_cmd22),  
   .lst_inv_port_cmd22(lst_inv_port_cmd22),  
   .age_confirmed22(age_confirmed22),     
   .age_ok22(age_ok22),
   .inval_in_prog22(inval_in_prog22),            
   .age_check_active22(age_check_active22)
);   


alut_mem22 i_alut_mem22
(   
   // Inputs22
   .pclk22(pclk22),
   .mem_addr_add22(mem_addr_add22),
   .mem_write_add22(mem_write_add22),
   .mem_write_data_add22(mem_write_data_add22),
   .mem_addr_age22(mem_addr_age22),
   .mem_write_age22(mem_write_age22),
   .mem_write_data_age22(mem_write_data_age22),

   .mem_read_data_add22(mem_read_data_add22),  
   .mem_read_data_age22(mem_read_data_age22)
);   



`ifdef ABV_ON22
// psl22 default clock22 = (posedge pclk22);

// ASSUMPTIONS22

// ASSERTION22 CHECKS22
// the invalidate22 aged22 in progress22 flag22 and the active flag22 
// should never both be set.
// psl22 assert_inval_in_prog_active22 : assert never (inval_in_prog22 & active);

// it should never be possible22 for the destination22 port to indicate22 the MAC22
// switch22 address and one of the other 4 Ethernets22
// psl22 assert_valid_dest_port22 : assert never (d_port22[4] & |{d_port22[3:0]});

// COVER22 SANITY22 CHECKS22
// check all values of destination22 port can be returned.
// psl22 cover_d_port_022 : cover { d_port22 == 5'b0_0001 };
// psl22 cover_d_port_122 : cover { d_port22 == 5'b0_0010 };
// psl22 cover_d_port_222 : cover { d_port22 == 5'b0_0100 };
// psl22 cover_d_port_322 : cover { d_port22 == 5'b0_1000 };
// psl22 cover_d_port_422 : cover { d_port22 == 5'b1_0000 };
// psl22 cover_d_port_all22 : cover { d_port22 == 5'b0_1111 };

`endif


endmodule
