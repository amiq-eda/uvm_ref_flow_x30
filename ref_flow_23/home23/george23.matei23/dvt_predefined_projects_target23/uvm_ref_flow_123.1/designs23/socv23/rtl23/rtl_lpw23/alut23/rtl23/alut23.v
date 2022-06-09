//File23 name   : alut23.v
//Title23       : ALUT23 top level
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
module alut23
(   
   // Inputs23
   pclk23,
   n_p_reset23,
   psel23,            
   penable23,       
   pwrite23,         
   paddr23,           
   pwdata23,          

   // Outputs23
   prdata23  
);

   parameter   DW23 = 83;          // width of data busses23
   parameter   DD23 = 256;         // depth of RAM23


   // APB23 Inputs23
   input             pclk23;               // APB23 clock23                          
   input             n_p_reset23;          // Reset23                              
   input             psel23;               // Module23 select23 signal23               
   input             penable23;            // Enable23 signal23                      
   input             pwrite23;             // Write when HIGH23 and read when LOW23  
   input [6:0]       paddr23;              // Address bus for read write         
   input [31:0]      pwdata23;             // APB23 write bus                      

   output [31:0]     prdata23;             // APB23 read bus                       

   wire              pclk23;               // APB23 clock23                           
   wire [7:0]        mem_addr_add23;       // hash23 address for R/W23 to memory     
   wire              mem_write_add23;      // R/W23 flag23 (write = high23)            
   wire [DW23-1:0]     mem_write_data_add23; // write data for memory             
   wire [7:0]        mem_addr_age23;       // hash23 address for R/W23 to memory     
   wire              mem_write_age23;      // R/W23 flag23 (write = high23)            
   wire [DW23-1:0]     mem_write_data_age23; // write data for memory             
   wire [DW23-1:0]     mem_read_data_add23;  // read data from mem                 
   wire [DW23-1:0]     mem_read_data_age23;  // read data from mem  
   wire [31:0]       curr_time23;          // current time
   wire              active;             // status[0] adress23 checker active
   wire              inval_in_prog23;      // status[1] 
   wire              reused23;             // status[2] ALUT23 location23 overwritten23
   wire [4:0]        d_port23;             // calculated23 destination23 port for tx23
   wire [47:0]       lst_inv_addr_nrm23;   // last invalidated23 addr normal23 op
   wire [1:0]        lst_inv_port_nrm23;   // last invalidated23 port normal23 op
   wire [47:0]       lst_inv_addr_cmd23;   // last invalidated23 addr via cmd23
   wire [1:0]        lst_inv_port_cmd23;   // last invalidated23 port via cmd23
   wire [47:0]       mac_addr23;           // address of the switch23
   wire [47:0]       d_addr23;             // address of frame23 to be checked23
   wire [47:0]       s_addr23;             // address of frame23 to be stored23
   wire [1:0]        s_port23;             // source23 port of current frame23
   wire [31:0]       best_bfr_age23;       // best23 before age23
   wire [7:0]        div_clk23;            // programmed23 clock23 divider23 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata23;             // APB23 read bus
   wire              age_confirmed23;      // valid flag23 from age23 checker        
   wire              age_ok23;             // result from age23 checker 
   wire              clear_reused23;       // read/clear flag23 for reused23 signal23           
   wire              check_age23;          // request flag23 for age23 check
   wire [31:0]       last_accessed23;      // time field sent23 for age23 check




alut_reg_bank23 i_alut_reg_bank23
(   
   // Inputs23
   .pclk23(pclk23),
   .n_p_reset23(n_p_reset23),
   .psel23(psel23),            
   .penable23(penable23),       
   .pwrite23(pwrite23),         
   .paddr23(paddr23),           
   .pwdata23(pwdata23),          
   .curr_time23(curr_time23),
   .add_check_active23(add_check_active23),
   .age_check_active23(age_check_active23),
   .inval_in_prog23(inval_in_prog23),
   .reused23(reused23),
   .d_port23(d_port23),
   .lst_inv_addr_nrm23(lst_inv_addr_nrm23),
   .lst_inv_port_nrm23(lst_inv_port_nrm23),
   .lst_inv_addr_cmd23(lst_inv_addr_cmd23),
   .lst_inv_port_cmd23(lst_inv_port_cmd23),

   // Outputs23
   .mac_addr23(mac_addr23),    
   .d_addr23(d_addr23),   
   .s_addr23(s_addr23),    
   .s_port23(s_port23),    
   .best_bfr_age23(best_bfr_age23),
   .div_clk23(div_clk23),     
   .command(command), 
   .prdata23(prdata23),  
   .clear_reused23(clear_reused23)           
);


alut_addr_checker23 i_alut_addr_checker23
(   
   // Inputs23
   .pclk23(pclk23),
   .n_p_reset23(n_p_reset23),
   .command(command),
   .mac_addr23(mac_addr23),
   .d_addr23(d_addr23),
   .s_addr23(s_addr23),
   .s_port23(s_port23),
   .curr_time23(curr_time23),
   .mem_read_data_add23(mem_read_data_add23),
   .age_confirmed23(age_confirmed23),
   .age_ok23(age_ok23),
   .clear_reused23(clear_reused23),

   //outputs23
   .d_port23(d_port23),
   .add_check_active23(add_check_active23),
   .mem_addr_add23(mem_addr_add23),
   .mem_write_add23(mem_write_add23),
   .mem_write_data_add23(mem_write_data_add23),
   .lst_inv_addr_nrm23(lst_inv_addr_nrm23),
   .lst_inv_port_nrm23(lst_inv_port_nrm23),
   .check_age23(check_age23),
   .last_accessed23(last_accessed23),
   .reused23(reused23)
);


alut_age_checker23 i_alut_age_checker23
(   
   // Inputs23
   .pclk23(pclk23),
   .n_p_reset23(n_p_reset23),
   .command(command),          
   .div_clk23(div_clk23),          
   .mem_read_data_age23(mem_read_data_age23),
   .check_age23(check_age23),        
   .last_accessed23(last_accessed23), 
   .best_bfr_age23(best_bfr_age23),   
   .add_check_active23(add_check_active23),

   // outputs23
   .curr_time23(curr_time23),         
   .mem_addr_age23(mem_addr_age23),      
   .mem_write_age23(mem_write_age23),     
   .mem_write_data_age23(mem_write_data_age23),
   .lst_inv_addr_cmd23(lst_inv_addr_cmd23),  
   .lst_inv_port_cmd23(lst_inv_port_cmd23),  
   .age_confirmed23(age_confirmed23),     
   .age_ok23(age_ok23),
   .inval_in_prog23(inval_in_prog23),            
   .age_check_active23(age_check_active23)
);   


alut_mem23 i_alut_mem23
(   
   // Inputs23
   .pclk23(pclk23),
   .mem_addr_add23(mem_addr_add23),
   .mem_write_add23(mem_write_add23),
   .mem_write_data_add23(mem_write_data_add23),
   .mem_addr_age23(mem_addr_age23),
   .mem_write_age23(mem_write_age23),
   .mem_write_data_age23(mem_write_data_age23),

   .mem_read_data_add23(mem_read_data_add23),  
   .mem_read_data_age23(mem_read_data_age23)
);   



`ifdef ABV_ON23
// psl23 default clock23 = (posedge pclk23);

// ASSUMPTIONS23

// ASSERTION23 CHECKS23
// the invalidate23 aged23 in progress23 flag23 and the active flag23 
// should never both be set.
// psl23 assert_inval_in_prog_active23 : assert never (inval_in_prog23 & active);

// it should never be possible23 for the destination23 port to indicate23 the MAC23
// switch23 address and one of the other 4 Ethernets23
// psl23 assert_valid_dest_port23 : assert never (d_port23[4] & |{d_port23[3:0]});

// COVER23 SANITY23 CHECKS23
// check all values of destination23 port can be returned.
// psl23 cover_d_port_023 : cover { d_port23 == 5'b0_0001 };
// psl23 cover_d_port_123 : cover { d_port23 == 5'b0_0010 };
// psl23 cover_d_port_223 : cover { d_port23 == 5'b0_0100 };
// psl23 cover_d_port_323 : cover { d_port23 == 5'b0_1000 };
// psl23 cover_d_port_423 : cover { d_port23 == 5'b1_0000 };
// psl23 cover_d_port_all23 : cover { d_port23 == 5'b0_1111 };

`endif


endmodule
