//File5 name   : alut5.v
//Title5       : ALUT5 top level
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
module alut5
(   
   // Inputs5
   pclk5,
   n_p_reset5,
   psel5,            
   penable5,       
   pwrite5,         
   paddr5,           
   pwdata5,          

   // Outputs5
   prdata5  
);

   parameter   DW5 = 83;          // width of data busses5
   parameter   DD5 = 256;         // depth of RAM5


   // APB5 Inputs5
   input             pclk5;               // APB5 clock5                          
   input             n_p_reset5;          // Reset5                              
   input             psel5;               // Module5 select5 signal5               
   input             penable5;            // Enable5 signal5                      
   input             pwrite5;             // Write when HIGH5 and read when LOW5  
   input [6:0]       paddr5;              // Address bus for read write         
   input [31:0]      pwdata5;             // APB5 write bus                      

   output [31:0]     prdata5;             // APB5 read bus                       

   wire              pclk5;               // APB5 clock5                           
   wire [7:0]        mem_addr_add5;       // hash5 address for R/W5 to memory     
   wire              mem_write_add5;      // R/W5 flag5 (write = high5)            
   wire [DW5-1:0]     mem_write_data_add5; // write data for memory             
   wire [7:0]        mem_addr_age5;       // hash5 address for R/W5 to memory     
   wire              mem_write_age5;      // R/W5 flag5 (write = high5)            
   wire [DW5-1:0]     mem_write_data_age5; // write data for memory             
   wire [DW5-1:0]     mem_read_data_add5;  // read data from mem                 
   wire [DW5-1:0]     mem_read_data_age5;  // read data from mem  
   wire [31:0]       curr_time5;          // current time
   wire              active;             // status[0] adress5 checker active
   wire              inval_in_prog5;      // status[1] 
   wire              reused5;             // status[2] ALUT5 location5 overwritten5
   wire [4:0]        d_port5;             // calculated5 destination5 port for tx5
   wire [47:0]       lst_inv_addr_nrm5;   // last invalidated5 addr normal5 op
   wire [1:0]        lst_inv_port_nrm5;   // last invalidated5 port normal5 op
   wire [47:0]       lst_inv_addr_cmd5;   // last invalidated5 addr via cmd5
   wire [1:0]        lst_inv_port_cmd5;   // last invalidated5 port via cmd5
   wire [47:0]       mac_addr5;           // address of the switch5
   wire [47:0]       d_addr5;             // address of frame5 to be checked5
   wire [47:0]       s_addr5;             // address of frame5 to be stored5
   wire [1:0]        s_port5;             // source5 port of current frame5
   wire [31:0]       best_bfr_age5;       // best5 before age5
   wire [7:0]        div_clk5;            // programmed5 clock5 divider5 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata5;             // APB5 read bus
   wire              age_confirmed5;      // valid flag5 from age5 checker        
   wire              age_ok5;             // result from age5 checker 
   wire              clear_reused5;       // read/clear flag5 for reused5 signal5           
   wire              check_age5;          // request flag5 for age5 check
   wire [31:0]       last_accessed5;      // time field sent5 for age5 check




alut_reg_bank5 i_alut_reg_bank5
(   
   // Inputs5
   .pclk5(pclk5),
   .n_p_reset5(n_p_reset5),
   .psel5(psel5),            
   .penable5(penable5),       
   .pwrite5(pwrite5),         
   .paddr5(paddr5),           
   .pwdata5(pwdata5),          
   .curr_time5(curr_time5),
   .add_check_active5(add_check_active5),
   .age_check_active5(age_check_active5),
   .inval_in_prog5(inval_in_prog5),
   .reused5(reused5),
   .d_port5(d_port5),
   .lst_inv_addr_nrm5(lst_inv_addr_nrm5),
   .lst_inv_port_nrm5(lst_inv_port_nrm5),
   .lst_inv_addr_cmd5(lst_inv_addr_cmd5),
   .lst_inv_port_cmd5(lst_inv_port_cmd5),

   // Outputs5
   .mac_addr5(mac_addr5),    
   .d_addr5(d_addr5),   
   .s_addr5(s_addr5),    
   .s_port5(s_port5),    
   .best_bfr_age5(best_bfr_age5),
   .div_clk5(div_clk5),     
   .command(command), 
   .prdata5(prdata5),  
   .clear_reused5(clear_reused5)           
);


alut_addr_checker5 i_alut_addr_checker5
(   
   // Inputs5
   .pclk5(pclk5),
   .n_p_reset5(n_p_reset5),
   .command(command),
   .mac_addr5(mac_addr5),
   .d_addr5(d_addr5),
   .s_addr5(s_addr5),
   .s_port5(s_port5),
   .curr_time5(curr_time5),
   .mem_read_data_add5(mem_read_data_add5),
   .age_confirmed5(age_confirmed5),
   .age_ok5(age_ok5),
   .clear_reused5(clear_reused5),

   //outputs5
   .d_port5(d_port5),
   .add_check_active5(add_check_active5),
   .mem_addr_add5(mem_addr_add5),
   .mem_write_add5(mem_write_add5),
   .mem_write_data_add5(mem_write_data_add5),
   .lst_inv_addr_nrm5(lst_inv_addr_nrm5),
   .lst_inv_port_nrm5(lst_inv_port_nrm5),
   .check_age5(check_age5),
   .last_accessed5(last_accessed5),
   .reused5(reused5)
);


alut_age_checker5 i_alut_age_checker5
(   
   // Inputs5
   .pclk5(pclk5),
   .n_p_reset5(n_p_reset5),
   .command(command),          
   .div_clk5(div_clk5),          
   .mem_read_data_age5(mem_read_data_age5),
   .check_age5(check_age5),        
   .last_accessed5(last_accessed5), 
   .best_bfr_age5(best_bfr_age5),   
   .add_check_active5(add_check_active5),

   // outputs5
   .curr_time5(curr_time5),         
   .mem_addr_age5(mem_addr_age5),      
   .mem_write_age5(mem_write_age5),     
   .mem_write_data_age5(mem_write_data_age5),
   .lst_inv_addr_cmd5(lst_inv_addr_cmd5),  
   .lst_inv_port_cmd5(lst_inv_port_cmd5),  
   .age_confirmed5(age_confirmed5),     
   .age_ok5(age_ok5),
   .inval_in_prog5(inval_in_prog5),            
   .age_check_active5(age_check_active5)
);   


alut_mem5 i_alut_mem5
(   
   // Inputs5
   .pclk5(pclk5),
   .mem_addr_add5(mem_addr_add5),
   .mem_write_add5(mem_write_add5),
   .mem_write_data_add5(mem_write_data_add5),
   .mem_addr_age5(mem_addr_age5),
   .mem_write_age5(mem_write_age5),
   .mem_write_data_age5(mem_write_data_age5),

   .mem_read_data_add5(mem_read_data_add5),  
   .mem_read_data_age5(mem_read_data_age5)
);   



`ifdef ABV_ON5
// psl5 default clock5 = (posedge pclk5);

// ASSUMPTIONS5

// ASSERTION5 CHECKS5
// the invalidate5 aged5 in progress5 flag5 and the active flag5 
// should never both be set.
// psl5 assert_inval_in_prog_active5 : assert never (inval_in_prog5 & active);

// it should never be possible5 for the destination5 port to indicate5 the MAC5
// switch5 address and one of the other 4 Ethernets5
// psl5 assert_valid_dest_port5 : assert never (d_port5[4] & |{d_port5[3:0]});

// COVER5 SANITY5 CHECKS5
// check all values of destination5 port can be returned.
// psl5 cover_d_port_05 : cover { d_port5 == 5'b0_0001 };
// psl5 cover_d_port_15 : cover { d_port5 == 5'b0_0010 };
// psl5 cover_d_port_25 : cover { d_port5 == 5'b0_0100 };
// psl5 cover_d_port_35 : cover { d_port5 == 5'b0_1000 };
// psl5 cover_d_port_45 : cover { d_port5 == 5'b1_0000 };
// psl5 cover_d_port_all5 : cover { d_port5 == 5'b0_1111 };

`endif


endmodule
