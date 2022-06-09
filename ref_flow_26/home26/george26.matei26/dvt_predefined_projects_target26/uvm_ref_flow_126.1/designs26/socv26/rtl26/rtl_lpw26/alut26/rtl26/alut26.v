//File26 name   : alut26.v
//Title26       : ALUT26 top level
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
module alut26
(   
   // Inputs26
   pclk26,
   n_p_reset26,
   psel26,            
   penable26,       
   pwrite26,         
   paddr26,           
   pwdata26,          

   // Outputs26
   prdata26  
);

   parameter   DW26 = 83;          // width of data busses26
   parameter   DD26 = 256;         // depth of RAM26


   // APB26 Inputs26
   input             pclk26;               // APB26 clock26                          
   input             n_p_reset26;          // Reset26                              
   input             psel26;               // Module26 select26 signal26               
   input             penable26;            // Enable26 signal26                      
   input             pwrite26;             // Write when HIGH26 and read when LOW26  
   input [6:0]       paddr26;              // Address bus for read write         
   input [31:0]      pwdata26;             // APB26 write bus                      

   output [31:0]     prdata26;             // APB26 read bus                       

   wire              pclk26;               // APB26 clock26                           
   wire [7:0]        mem_addr_add26;       // hash26 address for R/W26 to memory     
   wire              mem_write_add26;      // R/W26 flag26 (write = high26)            
   wire [DW26-1:0]     mem_write_data_add26; // write data for memory             
   wire [7:0]        mem_addr_age26;       // hash26 address for R/W26 to memory     
   wire              mem_write_age26;      // R/W26 flag26 (write = high26)            
   wire [DW26-1:0]     mem_write_data_age26; // write data for memory             
   wire [DW26-1:0]     mem_read_data_add26;  // read data from mem                 
   wire [DW26-1:0]     mem_read_data_age26;  // read data from mem  
   wire [31:0]       curr_time26;          // current time
   wire              active;             // status[0] adress26 checker active
   wire              inval_in_prog26;      // status[1] 
   wire              reused26;             // status[2] ALUT26 location26 overwritten26
   wire [4:0]        d_port26;             // calculated26 destination26 port for tx26
   wire [47:0]       lst_inv_addr_nrm26;   // last invalidated26 addr normal26 op
   wire [1:0]        lst_inv_port_nrm26;   // last invalidated26 port normal26 op
   wire [47:0]       lst_inv_addr_cmd26;   // last invalidated26 addr via cmd26
   wire [1:0]        lst_inv_port_cmd26;   // last invalidated26 port via cmd26
   wire [47:0]       mac_addr26;           // address of the switch26
   wire [47:0]       d_addr26;             // address of frame26 to be checked26
   wire [47:0]       s_addr26;             // address of frame26 to be stored26
   wire [1:0]        s_port26;             // source26 port of current frame26
   wire [31:0]       best_bfr_age26;       // best26 before age26
   wire [7:0]        div_clk26;            // programmed26 clock26 divider26 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata26;             // APB26 read bus
   wire              age_confirmed26;      // valid flag26 from age26 checker        
   wire              age_ok26;             // result from age26 checker 
   wire              clear_reused26;       // read/clear flag26 for reused26 signal26           
   wire              check_age26;          // request flag26 for age26 check
   wire [31:0]       last_accessed26;      // time field sent26 for age26 check




alut_reg_bank26 i_alut_reg_bank26
(   
   // Inputs26
   .pclk26(pclk26),
   .n_p_reset26(n_p_reset26),
   .psel26(psel26),            
   .penable26(penable26),       
   .pwrite26(pwrite26),         
   .paddr26(paddr26),           
   .pwdata26(pwdata26),          
   .curr_time26(curr_time26),
   .add_check_active26(add_check_active26),
   .age_check_active26(age_check_active26),
   .inval_in_prog26(inval_in_prog26),
   .reused26(reused26),
   .d_port26(d_port26),
   .lst_inv_addr_nrm26(lst_inv_addr_nrm26),
   .lst_inv_port_nrm26(lst_inv_port_nrm26),
   .lst_inv_addr_cmd26(lst_inv_addr_cmd26),
   .lst_inv_port_cmd26(lst_inv_port_cmd26),

   // Outputs26
   .mac_addr26(mac_addr26),    
   .d_addr26(d_addr26),   
   .s_addr26(s_addr26),    
   .s_port26(s_port26),    
   .best_bfr_age26(best_bfr_age26),
   .div_clk26(div_clk26),     
   .command(command), 
   .prdata26(prdata26),  
   .clear_reused26(clear_reused26)           
);


alut_addr_checker26 i_alut_addr_checker26
(   
   // Inputs26
   .pclk26(pclk26),
   .n_p_reset26(n_p_reset26),
   .command(command),
   .mac_addr26(mac_addr26),
   .d_addr26(d_addr26),
   .s_addr26(s_addr26),
   .s_port26(s_port26),
   .curr_time26(curr_time26),
   .mem_read_data_add26(mem_read_data_add26),
   .age_confirmed26(age_confirmed26),
   .age_ok26(age_ok26),
   .clear_reused26(clear_reused26),

   //outputs26
   .d_port26(d_port26),
   .add_check_active26(add_check_active26),
   .mem_addr_add26(mem_addr_add26),
   .mem_write_add26(mem_write_add26),
   .mem_write_data_add26(mem_write_data_add26),
   .lst_inv_addr_nrm26(lst_inv_addr_nrm26),
   .lst_inv_port_nrm26(lst_inv_port_nrm26),
   .check_age26(check_age26),
   .last_accessed26(last_accessed26),
   .reused26(reused26)
);


alut_age_checker26 i_alut_age_checker26
(   
   // Inputs26
   .pclk26(pclk26),
   .n_p_reset26(n_p_reset26),
   .command(command),          
   .div_clk26(div_clk26),          
   .mem_read_data_age26(mem_read_data_age26),
   .check_age26(check_age26),        
   .last_accessed26(last_accessed26), 
   .best_bfr_age26(best_bfr_age26),   
   .add_check_active26(add_check_active26),

   // outputs26
   .curr_time26(curr_time26),         
   .mem_addr_age26(mem_addr_age26),      
   .mem_write_age26(mem_write_age26),     
   .mem_write_data_age26(mem_write_data_age26),
   .lst_inv_addr_cmd26(lst_inv_addr_cmd26),  
   .lst_inv_port_cmd26(lst_inv_port_cmd26),  
   .age_confirmed26(age_confirmed26),     
   .age_ok26(age_ok26),
   .inval_in_prog26(inval_in_prog26),            
   .age_check_active26(age_check_active26)
);   


alut_mem26 i_alut_mem26
(   
   // Inputs26
   .pclk26(pclk26),
   .mem_addr_add26(mem_addr_add26),
   .mem_write_add26(mem_write_add26),
   .mem_write_data_add26(mem_write_data_add26),
   .mem_addr_age26(mem_addr_age26),
   .mem_write_age26(mem_write_age26),
   .mem_write_data_age26(mem_write_data_age26),

   .mem_read_data_add26(mem_read_data_add26),  
   .mem_read_data_age26(mem_read_data_age26)
);   



`ifdef ABV_ON26
// psl26 default clock26 = (posedge pclk26);

// ASSUMPTIONS26

// ASSERTION26 CHECKS26
// the invalidate26 aged26 in progress26 flag26 and the active flag26 
// should never both be set.
// psl26 assert_inval_in_prog_active26 : assert never (inval_in_prog26 & active);

// it should never be possible26 for the destination26 port to indicate26 the MAC26
// switch26 address and one of the other 4 Ethernets26
// psl26 assert_valid_dest_port26 : assert never (d_port26[4] & |{d_port26[3:0]});

// COVER26 SANITY26 CHECKS26
// check all values of destination26 port can be returned.
// psl26 cover_d_port_026 : cover { d_port26 == 5'b0_0001 };
// psl26 cover_d_port_126 : cover { d_port26 == 5'b0_0010 };
// psl26 cover_d_port_226 : cover { d_port26 == 5'b0_0100 };
// psl26 cover_d_port_326 : cover { d_port26 == 5'b0_1000 };
// psl26 cover_d_port_426 : cover { d_port26 == 5'b1_0000 };
// psl26 cover_d_port_all26 : cover { d_port26 == 5'b0_1111 };

`endif


endmodule
