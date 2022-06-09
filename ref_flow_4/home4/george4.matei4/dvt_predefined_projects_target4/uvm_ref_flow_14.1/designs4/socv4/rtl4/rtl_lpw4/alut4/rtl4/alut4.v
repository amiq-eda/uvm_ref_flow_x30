//File4 name   : alut4.v
//Title4       : ALUT4 top level
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
module alut4
(   
   // Inputs4
   pclk4,
   n_p_reset4,
   psel4,            
   penable4,       
   pwrite4,         
   paddr4,           
   pwdata4,          

   // Outputs4
   prdata4  
);

   parameter   DW4 = 83;          // width of data busses4
   parameter   DD4 = 256;         // depth of RAM4


   // APB4 Inputs4
   input             pclk4;               // APB4 clock4                          
   input             n_p_reset4;          // Reset4                              
   input             psel4;               // Module4 select4 signal4               
   input             penable4;            // Enable4 signal4                      
   input             pwrite4;             // Write when HIGH4 and read when LOW4  
   input [6:0]       paddr4;              // Address bus for read write         
   input [31:0]      pwdata4;             // APB4 write bus                      

   output [31:0]     prdata4;             // APB4 read bus                       

   wire              pclk4;               // APB4 clock4                           
   wire [7:0]        mem_addr_add4;       // hash4 address for R/W4 to memory     
   wire              mem_write_add4;      // R/W4 flag4 (write = high4)            
   wire [DW4-1:0]     mem_write_data_add4; // write data for memory             
   wire [7:0]        mem_addr_age4;       // hash4 address for R/W4 to memory     
   wire              mem_write_age4;      // R/W4 flag4 (write = high4)            
   wire [DW4-1:0]     mem_write_data_age4; // write data for memory             
   wire [DW4-1:0]     mem_read_data_add4;  // read data from mem                 
   wire [DW4-1:0]     mem_read_data_age4;  // read data from mem  
   wire [31:0]       curr_time4;          // current time
   wire              active;             // status[0] adress4 checker active
   wire              inval_in_prog4;      // status[1] 
   wire              reused4;             // status[2] ALUT4 location4 overwritten4
   wire [4:0]        d_port4;             // calculated4 destination4 port for tx4
   wire [47:0]       lst_inv_addr_nrm4;   // last invalidated4 addr normal4 op
   wire [1:0]        lst_inv_port_nrm4;   // last invalidated4 port normal4 op
   wire [47:0]       lst_inv_addr_cmd4;   // last invalidated4 addr via cmd4
   wire [1:0]        lst_inv_port_cmd4;   // last invalidated4 port via cmd4
   wire [47:0]       mac_addr4;           // address of the switch4
   wire [47:0]       d_addr4;             // address of frame4 to be checked4
   wire [47:0]       s_addr4;             // address of frame4 to be stored4
   wire [1:0]        s_port4;             // source4 port of current frame4
   wire [31:0]       best_bfr_age4;       // best4 before age4
   wire [7:0]        div_clk4;            // programmed4 clock4 divider4 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata4;             // APB4 read bus
   wire              age_confirmed4;      // valid flag4 from age4 checker        
   wire              age_ok4;             // result from age4 checker 
   wire              clear_reused4;       // read/clear flag4 for reused4 signal4           
   wire              check_age4;          // request flag4 for age4 check
   wire [31:0]       last_accessed4;      // time field sent4 for age4 check




alut_reg_bank4 i_alut_reg_bank4
(   
   // Inputs4
   .pclk4(pclk4),
   .n_p_reset4(n_p_reset4),
   .psel4(psel4),            
   .penable4(penable4),       
   .pwrite4(pwrite4),         
   .paddr4(paddr4),           
   .pwdata4(pwdata4),          
   .curr_time4(curr_time4),
   .add_check_active4(add_check_active4),
   .age_check_active4(age_check_active4),
   .inval_in_prog4(inval_in_prog4),
   .reused4(reused4),
   .d_port4(d_port4),
   .lst_inv_addr_nrm4(lst_inv_addr_nrm4),
   .lst_inv_port_nrm4(lst_inv_port_nrm4),
   .lst_inv_addr_cmd4(lst_inv_addr_cmd4),
   .lst_inv_port_cmd4(lst_inv_port_cmd4),

   // Outputs4
   .mac_addr4(mac_addr4),    
   .d_addr4(d_addr4),   
   .s_addr4(s_addr4),    
   .s_port4(s_port4),    
   .best_bfr_age4(best_bfr_age4),
   .div_clk4(div_clk4),     
   .command(command), 
   .prdata4(prdata4),  
   .clear_reused4(clear_reused4)           
);


alut_addr_checker4 i_alut_addr_checker4
(   
   // Inputs4
   .pclk4(pclk4),
   .n_p_reset4(n_p_reset4),
   .command(command),
   .mac_addr4(mac_addr4),
   .d_addr4(d_addr4),
   .s_addr4(s_addr4),
   .s_port4(s_port4),
   .curr_time4(curr_time4),
   .mem_read_data_add4(mem_read_data_add4),
   .age_confirmed4(age_confirmed4),
   .age_ok4(age_ok4),
   .clear_reused4(clear_reused4),

   //outputs4
   .d_port4(d_port4),
   .add_check_active4(add_check_active4),
   .mem_addr_add4(mem_addr_add4),
   .mem_write_add4(mem_write_add4),
   .mem_write_data_add4(mem_write_data_add4),
   .lst_inv_addr_nrm4(lst_inv_addr_nrm4),
   .lst_inv_port_nrm4(lst_inv_port_nrm4),
   .check_age4(check_age4),
   .last_accessed4(last_accessed4),
   .reused4(reused4)
);


alut_age_checker4 i_alut_age_checker4
(   
   // Inputs4
   .pclk4(pclk4),
   .n_p_reset4(n_p_reset4),
   .command(command),          
   .div_clk4(div_clk4),          
   .mem_read_data_age4(mem_read_data_age4),
   .check_age4(check_age4),        
   .last_accessed4(last_accessed4), 
   .best_bfr_age4(best_bfr_age4),   
   .add_check_active4(add_check_active4),

   // outputs4
   .curr_time4(curr_time4),         
   .mem_addr_age4(mem_addr_age4),      
   .mem_write_age4(mem_write_age4),     
   .mem_write_data_age4(mem_write_data_age4),
   .lst_inv_addr_cmd4(lst_inv_addr_cmd4),  
   .lst_inv_port_cmd4(lst_inv_port_cmd4),  
   .age_confirmed4(age_confirmed4),     
   .age_ok4(age_ok4),
   .inval_in_prog4(inval_in_prog4),            
   .age_check_active4(age_check_active4)
);   


alut_mem4 i_alut_mem4
(   
   // Inputs4
   .pclk4(pclk4),
   .mem_addr_add4(mem_addr_add4),
   .mem_write_add4(mem_write_add4),
   .mem_write_data_add4(mem_write_data_add4),
   .mem_addr_age4(mem_addr_age4),
   .mem_write_age4(mem_write_age4),
   .mem_write_data_age4(mem_write_data_age4),

   .mem_read_data_add4(mem_read_data_add4),  
   .mem_read_data_age4(mem_read_data_age4)
);   



`ifdef ABV_ON4
// psl4 default clock4 = (posedge pclk4);

// ASSUMPTIONS4

// ASSERTION4 CHECKS4
// the invalidate4 aged4 in progress4 flag4 and the active flag4 
// should never both be set.
// psl4 assert_inval_in_prog_active4 : assert never (inval_in_prog4 & active);

// it should never be possible4 for the destination4 port to indicate4 the MAC4
// switch4 address and one of the other 4 Ethernets4
// psl4 assert_valid_dest_port4 : assert never (d_port4[4] & |{d_port4[3:0]});

// COVER4 SANITY4 CHECKS4
// check all values of destination4 port can be returned.
// psl4 cover_d_port_04 : cover { d_port4 == 5'b0_0001 };
// psl4 cover_d_port_14 : cover { d_port4 == 5'b0_0010 };
// psl4 cover_d_port_24 : cover { d_port4 == 5'b0_0100 };
// psl4 cover_d_port_34 : cover { d_port4 == 5'b0_1000 };
// psl4 cover_d_port_44 : cover { d_port4 == 5'b1_0000 };
// psl4 cover_d_port_all4 : cover { d_port4 == 5'b0_1111 };

`endif


endmodule
