//File30 name   : alut30.v
//Title30       : ALUT30 top level
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
module alut30
(   
   // Inputs30
   pclk30,
   n_p_reset30,
   psel30,            
   penable30,       
   pwrite30,         
   paddr30,           
   pwdata30,          

   // Outputs30
   prdata30  
);

   parameter   DW30 = 83;          // width of data busses30
   parameter   DD30 = 256;         // depth of RAM30


   // APB30 Inputs30
   input             pclk30;               // APB30 clock30                          
   input             n_p_reset30;          // Reset30                              
   input             psel30;               // Module30 select30 signal30               
   input             penable30;            // Enable30 signal30                      
   input             pwrite30;             // Write when HIGH30 and read when LOW30  
   input [6:0]       paddr30;              // Address bus for read write         
   input [31:0]      pwdata30;             // APB30 write bus                      

   output [31:0]     prdata30;             // APB30 read bus                       

   wire              pclk30;               // APB30 clock30                           
   wire [7:0]        mem_addr_add30;       // hash30 address for R/W30 to memory     
   wire              mem_write_add30;      // R/W30 flag30 (write = high30)            
   wire [DW30-1:0]     mem_write_data_add30; // write data for memory             
   wire [7:0]        mem_addr_age30;       // hash30 address for R/W30 to memory     
   wire              mem_write_age30;      // R/W30 flag30 (write = high30)            
   wire [DW30-1:0]     mem_write_data_age30; // write data for memory             
   wire [DW30-1:0]     mem_read_data_add30;  // read data from mem                 
   wire [DW30-1:0]     mem_read_data_age30;  // read data from mem  
   wire [31:0]       curr_time30;          // current time
   wire              active;             // status[0] adress30 checker active
   wire              inval_in_prog30;      // status[1] 
   wire              reused30;             // status[2] ALUT30 location30 overwritten30
   wire [4:0]        d_port30;             // calculated30 destination30 port for tx30
   wire [47:0]       lst_inv_addr_nrm30;   // last invalidated30 addr normal30 op
   wire [1:0]        lst_inv_port_nrm30;   // last invalidated30 port normal30 op
   wire [47:0]       lst_inv_addr_cmd30;   // last invalidated30 addr via cmd30
   wire [1:0]        lst_inv_port_cmd30;   // last invalidated30 port via cmd30
   wire [47:0]       mac_addr30;           // address of the switch30
   wire [47:0]       d_addr30;             // address of frame30 to be checked30
   wire [47:0]       s_addr30;             // address of frame30 to be stored30
   wire [1:0]        s_port30;             // source30 port of current frame30
   wire [31:0]       best_bfr_age30;       // best30 before age30
   wire [7:0]        div_clk30;            // programmed30 clock30 divider30 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata30;             // APB30 read bus
   wire              age_confirmed30;      // valid flag30 from age30 checker        
   wire              age_ok30;             // result from age30 checker 
   wire              clear_reused30;       // read/clear flag30 for reused30 signal30           
   wire              check_age30;          // request flag30 for age30 check
   wire [31:0]       last_accessed30;      // time field sent30 for age30 check




alut_reg_bank30 i_alut_reg_bank30
(   
   // Inputs30
   .pclk30(pclk30),
   .n_p_reset30(n_p_reset30),
   .psel30(psel30),            
   .penable30(penable30),       
   .pwrite30(pwrite30),         
   .paddr30(paddr30),           
   .pwdata30(pwdata30),          
   .curr_time30(curr_time30),
   .add_check_active30(add_check_active30),
   .age_check_active30(age_check_active30),
   .inval_in_prog30(inval_in_prog30),
   .reused30(reused30),
   .d_port30(d_port30),
   .lst_inv_addr_nrm30(lst_inv_addr_nrm30),
   .lst_inv_port_nrm30(lst_inv_port_nrm30),
   .lst_inv_addr_cmd30(lst_inv_addr_cmd30),
   .lst_inv_port_cmd30(lst_inv_port_cmd30),

   // Outputs30
   .mac_addr30(mac_addr30),    
   .d_addr30(d_addr30),   
   .s_addr30(s_addr30),    
   .s_port30(s_port30),    
   .best_bfr_age30(best_bfr_age30),
   .div_clk30(div_clk30),     
   .command(command), 
   .prdata30(prdata30),  
   .clear_reused30(clear_reused30)           
);


alut_addr_checker30 i_alut_addr_checker30
(   
   // Inputs30
   .pclk30(pclk30),
   .n_p_reset30(n_p_reset30),
   .command(command),
   .mac_addr30(mac_addr30),
   .d_addr30(d_addr30),
   .s_addr30(s_addr30),
   .s_port30(s_port30),
   .curr_time30(curr_time30),
   .mem_read_data_add30(mem_read_data_add30),
   .age_confirmed30(age_confirmed30),
   .age_ok30(age_ok30),
   .clear_reused30(clear_reused30),

   //outputs30
   .d_port30(d_port30),
   .add_check_active30(add_check_active30),
   .mem_addr_add30(mem_addr_add30),
   .mem_write_add30(mem_write_add30),
   .mem_write_data_add30(mem_write_data_add30),
   .lst_inv_addr_nrm30(lst_inv_addr_nrm30),
   .lst_inv_port_nrm30(lst_inv_port_nrm30),
   .check_age30(check_age30),
   .last_accessed30(last_accessed30),
   .reused30(reused30)
);


alut_age_checker30 i_alut_age_checker30
(   
   // Inputs30
   .pclk30(pclk30),
   .n_p_reset30(n_p_reset30),
   .command(command),          
   .div_clk30(div_clk30),          
   .mem_read_data_age30(mem_read_data_age30),
   .check_age30(check_age30),        
   .last_accessed30(last_accessed30), 
   .best_bfr_age30(best_bfr_age30),   
   .add_check_active30(add_check_active30),

   // outputs30
   .curr_time30(curr_time30),         
   .mem_addr_age30(mem_addr_age30),      
   .mem_write_age30(mem_write_age30),     
   .mem_write_data_age30(mem_write_data_age30),
   .lst_inv_addr_cmd30(lst_inv_addr_cmd30),  
   .lst_inv_port_cmd30(lst_inv_port_cmd30),  
   .age_confirmed30(age_confirmed30),     
   .age_ok30(age_ok30),
   .inval_in_prog30(inval_in_prog30),            
   .age_check_active30(age_check_active30)
);   


alut_mem30 i_alut_mem30
(   
   // Inputs30
   .pclk30(pclk30),
   .mem_addr_add30(mem_addr_add30),
   .mem_write_add30(mem_write_add30),
   .mem_write_data_add30(mem_write_data_add30),
   .mem_addr_age30(mem_addr_age30),
   .mem_write_age30(mem_write_age30),
   .mem_write_data_age30(mem_write_data_age30),

   .mem_read_data_add30(mem_read_data_add30),  
   .mem_read_data_age30(mem_read_data_age30)
);   



`ifdef ABV_ON30
// psl30 default clock30 = (posedge pclk30);

// ASSUMPTIONS30

// ASSERTION30 CHECKS30
// the invalidate30 aged30 in progress30 flag30 and the active flag30 
// should never both be set.
// psl30 assert_inval_in_prog_active30 : assert never (inval_in_prog30 & active);

// it should never be possible30 for the destination30 port to indicate30 the MAC30
// switch30 address and one of the other 4 Ethernets30
// psl30 assert_valid_dest_port30 : assert never (d_port30[4] & |{d_port30[3:0]});

// COVER30 SANITY30 CHECKS30
// check all values of destination30 port can be returned.
// psl30 cover_d_port_030 : cover { d_port30 == 5'b0_0001 };
// psl30 cover_d_port_130 : cover { d_port30 == 5'b0_0010 };
// psl30 cover_d_port_230 : cover { d_port30 == 5'b0_0100 };
// psl30 cover_d_port_330 : cover { d_port30 == 5'b0_1000 };
// psl30 cover_d_port_430 : cover { d_port30 == 5'b1_0000 };
// psl30 cover_d_port_all30 : cover { d_port30 == 5'b0_1111 };

`endif


endmodule
