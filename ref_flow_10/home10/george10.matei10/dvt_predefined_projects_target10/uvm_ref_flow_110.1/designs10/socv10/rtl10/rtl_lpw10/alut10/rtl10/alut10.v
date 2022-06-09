//File10 name   : alut10.v
//Title10       : ALUT10 top level
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
module alut10
(   
   // Inputs10
   pclk10,
   n_p_reset10,
   psel10,            
   penable10,       
   pwrite10,         
   paddr10,           
   pwdata10,          

   // Outputs10
   prdata10  
);

   parameter   DW10 = 83;          // width of data busses10
   parameter   DD10 = 256;         // depth of RAM10


   // APB10 Inputs10
   input             pclk10;               // APB10 clock10                          
   input             n_p_reset10;          // Reset10                              
   input             psel10;               // Module10 select10 signal10               
   input             penable10;            // Enable10 signal10                      
   input             pwrite10;             // Write when HIGH10 and read when LOW10  
   input [6:0]       paddr10;              // Address bus for read write         
   input [31:0]      pwdata10;             // APB10 write bus                      

   output [31:0]     prdata10;             // APB10 read bus                       

   wire              pclk10;               // APB10 clock10                           
   wire [7:0]        mem_addr_add10;       // hash10 address for R/W10 to memory     
   wire              mem_write_add10;      // R/W10 flag10 (write = high10)            
   wire [DW10-1:0]     mem_write_data_add10; // write data for memory             
   wire [7:0]        mem_addr_age10;       // hash10 address for R/W10 to memory     
   wire              mem_write_age10;      // R/W10 flag10 (write = high10)            
   wire [DW10-1:0]     mem_write_data_age10; // write data for memory             
   wire [DW10-1:0]     mem_read_data_add10;  // read data from mem                 
   wire [DW10-1:0]     mem_read_data_age10;  // read data from mem  
   wire [31:0]       curr_time10;          // current time
   wire              active;             // status[0] adress10 checker active
   wire              inval_in_prog10;      // status[1] 
   wire              reused10;             // status[2] ALUT10 location10 overwritten10
   wire [4:0]        d_port10;             // calculated10 destination10 port for tx10
   wire [47:0]       lst_inv_addr_nrm10;   // last invalidated10 addr normal10 op
   wire [1:0]        lst_inv_port_nrm10;   // last invalidated10 port normal10 op
   wire [47:0]       lst_inv_addr_cmd10;   // last invalidated10 addr via cmd10
   wire [1:0]        lst_inv_port_cmd10;   // last invalidated10 port via cmd10
   wire [47:0]       mac_addr10;           // address of the switch10
   wire [47:0]       d_addr10;             // address of frame10 to be checked10
   wire [47:0]       s_addr10;             // address of frame10 to be stored10
   wire [1:0]        s_port10;             // source10 port of current frame10
   wire [31:0]       best_bfr_age10;       // best10 before age10
   wire [7:0]        div_clk10;            // programmed10 clock10 divider10 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata10;             // APB10 read bus
   wire              age_confirmed10;      // valid flag10 from age10 checker        
   wire              age_ok10;             // result from age10 checker 
   wire              clear_reused10;       // read/clear flag10 for reused10 signal10           
   wire              check_age10;          // request flag10 for age10 check
   wire [31:0]       last_accessed10;      // time field sent10 for age10 check




alut_reg_bank10 i_alut_reg_bank10
(   
   // Inputs10
   .pclk10(pclk10),
   .n_p_reset10(n_p_reset10),
   .psel10(psel10),            
   .penable10(penable10),       
   .pwrite10(pwrite10),         
   .paddr10(paddr10),           
   .pwdata10(pwdata10),          
   .curr_time10(curr_time10),
   .add_check_active10(add_check_active10),
   .age_check_active10(age_check_active10),
   .inval_in_prog10(inval_in_prog10),
   .reused10(reused10),
   .d_port10(d_port10),
   .lst_inv_addr_nrm10(lst_inv_addr_nrm10),
   .lst_inv_port_nrm10(lst_inv_port_nrm10),
   .lst_inv_addr_cmd10(lst_inv_addr_cmd10),
   .lst_inv_port_cmd10(lst_inv_port_cmd10),

   // Outputs10
   .mac_addr10(mac_addr10),    
   .d_addr10(d_addr10),   
   .s_addr10(s_addr10),    
   .s_port10(s_port10),    
   .best_bfr_age10(best_bfr_age10),
   .div_clk10(div_clk10),     
   .command(command), 
   .prdata10(prdata10),  
   .clear_reused10(clear_reused10)           
);


alut_addr_checker10 i_alut_addr_checker10
(   
   // Inputs10
   .pclk10(pclk10),
   .n_p_reset10(n_p_reset10),
   .command(command),
   .mac_addr10(mac_addr10),
   .d_addr10(d_addr10),
   .s_addr10(s_addr10),
   .s_port10(s_port10),
   .curr_time10(curr_time10),
   .mem_read_data_add10(mem_read_data_add10),
   .age_confirmed10(age_confirmed10),
   .age_ok10(age_ok10),
   .clear_reused10(clear_reused10),

   //outputs10
   .d_port10(d_port10),
   .add_check_active10(add_check_active10),
   .mem_addr_add10(mem_addr_add10),
   .mem_write_add10(mem_write_add10),
   .mem_write_data_add10(mem_write_data_add10),
   .lst_inv_addr_nrm10(lst_inv_addr_nrm10),
   .lst_inv_port_nrm10(lst_inv_port_nrm10),
   .check_age10(check_age10),
   .last_accessed10(last_accessed10),
   .reused10(reused10)
);


alut_age_checker10 i_alut_age_checker10
(   
   // Inputs10
   .pclk10(pclk10),
   .n_p_reset10(n_p_reset10),
   .command(command),          
   .div_clk10(div_clk10),          
   .mem_read_data_age10(mem_read_data_age10),
   .check_age10(check_age10),        
   .last_accessed10(last_accessed10), 
   .best_bfr_age10(best_bfr_age10),   
   .add_check_active10(add_check_active10),

   // outputs10
   .curr_time10(curr_time10),         
   .mem_addr_age10(mem_addr_age10),      
   .mem_write_age10(mem_write_age10),     
   .mem_write_data_age10(mem_write_data_age10),
   .lst_inv_addr_cmd10(lst_inv_addr_cmd10),  
   .lst_inv_port_cmd10(lst_inv_port_cmd10),  
   .age_confirmed10(age_confirmed10),     
   .age_ok10(age_ok10),
   .inval_in_prog10(inval_in_prog10),            
   .age_check_active10(age_check_active10)
);   


alut_mem10 i_alut_mem10
(   
   // Inputs10
   .pclk10(pclk10),
   .mem_addr_add10(mem_addr_add10),
   .mem_write_add10(mem_write_add10),
   .mem_write_data_add10(mem_write_data_add10),
   .mem_addr_age10(mem_addr_age10),
   .mem_write_age10(mem_write_age10),
   .mem_write_data_age10(mem_write_data_age10),

   .mem_read_data_add10(mem_read_data_add10),  
   .mem_read_data_age10(mem_read_data_age10)
);   



`ifdef ABV_ON10
// psl10 default clock10 = (posedge pclk10);

// ASSUMPTIONS10

// ASSERTION10 CHECKS10
// the invalidate10 aged10 in progress10 flag10 and the active flag10 
// should never both be set.
// psl10 assert_inval_in_prog_active10 : assert never (inval_in_prog10 & active);

// it should never be possible10 for the destination10 port to indicate10 the MAC10
// switch10 address and one of the other 4 Ethernets10
// psl10 assert_valid_dest_port10 : assert never (d_port10[4] & |{d_port10[3:0]});

// COVER10 SANITY10 CHECKS10
// check all values of destination10 port can be returned.
// psl10 cover_d_port_010 : cover { d_port10 == 5'b0_0001 };
// psl10 cover_d_port_110 : cover { d_port10 == 5'b0_0010 };
// psl10 cover_d_port_210 : cover { d_port10 == 5'b0_0100 };
// psl10 cover_d_port_310 : cover { d_port10 == 5'b0_1000 };
// psl10 cover_d_port_410 : cover { d_port10 == 5'b1_0000 };
// psl10 cover_d_port_all10 : cover { d_port10 == 5'b0_1111 };

`endif


endmodule
