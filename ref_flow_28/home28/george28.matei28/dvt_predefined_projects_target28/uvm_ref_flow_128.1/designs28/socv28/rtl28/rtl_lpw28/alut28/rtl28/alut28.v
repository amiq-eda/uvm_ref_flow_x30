//File28 name   : alut28.v
//Title28       : ALUT28 top level
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
module alut28
(   
   // Inputs28
   pclk28,
   n_p_reset28,
   psel28,            
   penable28,       
   pwrite28,         
   paddr28,           
   pwdata28,          

   // Outputs28
   prdata28  
);

   parameter   DW28 = 83;          // width of data busses28
   parameter   DD28 = 256;         // depth of RAM28


   // APB28 Inputs28
   input             pclk28;               // APB28 clock28                          
   input             n_p_reset28;          // Reset28                              
   input             psel28;               // Module28 select28 signal28               
   input             penable28;            // Enable28 signal28                      
   input             pwrite28;             // Write when HIGH28 and read when LOW28  
   input [6:0]       paddr28;              // Address bus for read write         
   input [31:0]      pwdata28;             // APB28 write bus                      

   output [31:0]     prdata28;             // APB28 read bus                       

   wire              pclk28;               // APB28 clock28                           
   wire [7:0]        mem_addr_add28;       // hash28 address for R/W28 to memory     
   wire              mem_write_add28;      // R/W28 flag28 (write = high28)            
   wire [DW28-1:0]     mem_write_data_add28; // write data for memory             
   wire [7:0]        mem_addr_age28;       // hash28 address for R/W28 to memory     
   wire              mem_write_age28;      // R/W28 flag28 (write = high28)            
   wire [DW28-1:0]     mem_write_data_age28; // write data for memory             
   wire [DW28-1:0]     mem_read_data_add28;  // read data from mem                 
   wire [DW28-1:0]     mem_read_data_age28;  // read data from mem  
   wire [31:0]       curr_time28;          // current time
   wire              active;             // status[0] adress28 checker active
   wire              inval_in_prog28;      // status[1] 
   wire              reused28;             // status[2] ALUT28 location28 overwritten28
   wire [4:0]        d_port28;             // calculated28 destination28 port for tx28
   wire [47:0]       lst_inv_addr_nrm28;   // last invalidated28 addr normal28 op
   wire [1:0]        lst_inv_port_nrm28;   // last invalidated28 port normal28 op
   wire [47:0]       lst_inv_addr_cmd28;   // last invalidated28 addr via cmd28
   wire [1:0]        lst_inv_port_cmd28;   // last invalidated28 port via cmd28
   wire [47:0]       mac_addr28;           // address of the switch28
   wire [47:0]       d_addr28;             // address of frame28 to be checked28
   wire [47:0]       s_addr28;             // address of frame28 to be stored28
   wire [1:0]        s_port28;             // source28 port of current frame28
   wire [31:0]       best_bfr_age28;       // best28 before age28
   wire [7:0]        div_clk28;            // programmed28 clock28 divider28 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata28;             // APB28 read bus
   wire              age_confirmed28;      // valid flag28 from age28 checker        
   wire              age_ok28;             // result from age28 checker 
   wire              clear_reused28;       // read/clear flag28 for reused28 signal28           
   wire              check_age28;          // request flag28 for age28 check
   wire [31:0]       last_accessed28;      // time field sent28 for age28 check




alut_reg_bank28 i_alut_reg_bank28
(   
   // Inputs28
   .pclk28(pclk28),
   .n_p_reset28(n_p_reset28),
   .psel28(psel28),            
   .penable28(penable28),       
   .pwrite28(pwrite28),         
   .paddr28(paddr28),           
   .pwdata28(pwdata28),          
   .curr_time28(curr_time28),
   .add_check_active28(add_check_active28),
   .age_check_active28(age_check_active28),
   .inval_in_prog28(inval_in_prog28),
   .reused28(reused28),
   .d_port28(d_port28),
   .lst_inv_addr_nrm28(lst_inv_addr_nrm28),
   .lst_inv_port_nrm28(lst_inv_port_nrm28),
   .lst_inv_addr_cmd28(lst_inv_addr_cmd28),
   .lst_inv_port_cmd28(lst_inv_port_cmd28),

   // Outputs28
   .mac_addr28(mac_addr28),    
   .d_addr28(d_addr28),   
   .s_addr28(s_addr28),    
   .s_port28(s_port28),    
   .best_bfr_age28(best_bfr_age28),
   .div_clk28(div_clk28),     
   .command(command), 
   .prdata28(prdata28),  
   .clear_reused28(clear_reused28)           
);


alut_addr_checker28 i_alut_addr_checker28
(   
   // Inputs28
   .pclk28(pclk28),
   .n_p_reset28(n_p_reset28),
   .command(command),
   .mac_addr28(mac_addr28),
   .d_addr28(d_addr28),
   .s_addr28(s_addr28),
   .s_port28(s_port28),
   .curr_time28(curr_time28),
   .mem_read_data_add28(mem_read_data_add28),
   .age_confirmed28(age_confirmed28),
   .age_ok28(age_ok28),
   .clear_reused28(clear_reused28),

   //outputs28
   .d_port28(d_port28),
   .add_check_active28(add_check_active28),
   .mem_addr_add28(mem_addr_add28),
   .mem_write_add28(mem_write_add28),
   .mem_write_data_add28(mem_write_data_add28),
   .lst_inv_addr_nrm28(lst_inv_addr_nrm28),
   .lst_inv_port_nrm28(lst_inv_port_nrm28),
   .check_age28(check_age28),
   .last_accessed28(last_accessed28),
   .reused28(reused28)
);


alut_age_checker28 i_alut_age_checker28
(   
   // Inputs28
   .pclk28(pclk28),
   .n_p_reset28(n_p_reset28),
   .command(command),          
   .div_clk28(div_clk28),          
   .mem_read_data_age28(mem_read_data_age28),
   .check_age28(check_age28),        
   .last_accessed28(last_accessed28), 
   .best_bfr_age28(best_bfr_age28),   
   .add_check_active28(add_check_active28),

   // outputs28
   .curr_time28(curr_time28),         
   .mem_addr_age28(mem_addr_age28),      
   .mem_write_age28(mem_write_age28),     
   .mem_write_data_age28(mem_write_data_age28),
   .lst_inv_addr_cmd28(lst_inv_addr_cmd28),  
   .lst_inv_port_cmd28(lst_inv_port_cmd28),  
   .age_confirmed28(age_confirmed28),     
   .age_ok28(age_ok28),
   .inval_in_prog28(inval_in_prog28),            
   .age_check_active28(age_check_active28)
);   


alut_mem28 i_alut_mem28
(   
   // Inputs28
   .pclk28(pclk28),
   .mem_addr_add28(mem_addr_add28),
   .mem_write_add28(mem_write_add28),
   .mem_write_data_add28(mem_write_data_add28),
   .mem_addr_age28(mem_addr_age28),
   .mem_write_age28(mem_write_age28),
   .mem_write_data_age28(mem_write_data_age28),

   .mem_read_data_add28(mem_read_data_add28),  
   .mem_read_data_age28(mem_read_data_age28)
);   



`ifdef ABV_ON28
// psl28 default clock28 = (posedge pclk28);

// ASSUMPTIONS28

// ASSERTION28 CHECKS28
// the invalidate28 aged28 in progress28 flag28 and the active flag28 
// should never both be set.
// psl28 assert_inval_in_prog_active28 : assert never (inval_in_prog28 & active);

// it should never be possible28 for the destination28 port to indicate28 the MAC28
// switch28 address and one of the other 4 Ethernets28
// psl28 assert_valid_dest_port28 : assert never (d_port28[4] & |{d_port28[3:0]});

// COVER28 SANITY28 CHECKS28
// check all values of destination28 port can be returned.
// psl28 cover_d_port_028 : cover { d_port28 == 5'b0_0001 };
// psl28 cover_d_port_128 : cover { d_port28 == 5'b0_0010 };
// psl28 cover_d_port_228 : cover { d_port28 == 5'b0_0100 };
// psl28 cover_d_port_328 : cover { d_port28 == 5'b0_1000 };
// psl28 cover_d_port_428 : cover { d_port28 == 5'b1_0000 };
// psl28 cover_d_port_all28 : cover { d_port28 == 5'b0_1111 };

`endif


endmodule
