//File18 name   : alut18.v
//Title18       : ALUT18 top level
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
module alut18
(   
   // Inputs18
   pclk18,
   n_p_reset18,
   psel18,            
   penable18,       
   pwrite18,         
   paddr18,           
   pwdata18,          

   // Outputs18
   prdata18  
);

   parameter   DW18 = 83;          // width of data busses18
   parameter   DD18 = 256;         // depth of RAM18


   // APB18 Inputs18
   input             pclk18;               // APB18 clock18                          
   input             n_p_reset18;          // Reset18                              
   input             psel18;               // Module18 select18 signal18               
   input             penable18;            // Enable18 signal18                      
   input             pwrite18;             // Write when HIGH18 and read when LOW18  
   input [6:0]       paddr18;              // Address bus for read write         
   input [31:0]      pwdata18;             // APB18 write bus                      

   output [31:0]     prdata18;             // APB18 read bus                       

   wire              pclk18;               // APB18 clock18                           
   wire [7:0]        mem_addr_add18;       // hash18 address for R/W18 to memory     
   wire              mem_write_add18;      // R/W18 flag18 (write = high18)            
   wire [DW18-1:0]     mem_write_data_add18; // write data for memory             
   wire [7:0]        mem_addr_age18;       // hash18 address for R/W18 to memory     
   wire              mem_write_age18;      // R/W18 flag18 (write = high18)            
   wire [DW18-1:0]     mem_write_data_age18; // write data for memory             
   wire [DW18-1:0]     mem_read_data_add18;  // read data from mem                 
   wire [DW18-1:0]     mem_read_data_age18;  // read data from mem  
   wire [31:0]       curr_time18;          // current time
   wire              active;             // status[0] adress18 checker active
   wire              inval_in_prog18;      // status[1] 
   wire              reused18;             // status[2] ALUT18 location18 overwritten18
   wire [4:0]        d_port18;             // calculated18 destination18 port for tx18
   wire [47:0]       lst_inv_addr_nrm18;   // last invalidated18 addr normal18 op
   wire [1:0]        lst_inv_port_nrm18;   // last invalidated18 port normal18 op
   wire [47:0]       lst_inv_addr_cmd18;   // last invalidated18 addr via cmd18
   wire [1:0]        lst_inv_port_cmd18;   // last invalidated18 port via cmd18
   wire [47:0]       mac_addr18;           // address of the switch18
   wire [47:0]       d_addr18;             // address of frame18 to be checked18
   wire [47:0]       s_addr18;             // address of frame18 to be stored18
   wire [1:0]        s_port18;             // source18 port of current frame18
   wire [31:0]       best_bfr_age18;       // best18 before age18
   wire [7:0]        div_clk18;            // programmed18 clock18 divider18 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata18;             // APB18 read bus
   wire              age_confirmed18;      // valid flag18 from age18 checker        
   wire              age_ok18;             // result from age18 checker 
   wire              clear_reused18;       // read/clear flag18 for reused18 signal18           
   wire              check_age18;          // request flag18 for age18 check
   wire [31:0]       last_accessed18;      // time field sent18 for age18 check




alut_reg_bank18 i_alut_reg_bank18
(   
   // Inputs18
   .pclk18(pclk18),
   .n_p_reset18(n_p_reset18),
   .psel18(psel18),            
   .penable18(penable18),       
   .pwrite18(pwrite18),         
   .paddr18(paddr18),           
   .pwdata18(pwdata18),          
   .curr_time18(curr_time18),
   .add_check_active18(add_check_active18),
   .age_check_active18(age_check_active18),
   .inval_in_prog18(inval_in_prog18),
   .reused18(reused18),
   .d_port18(d_port18),
   .lst_inv_addr_nrm18(lst_inv_addr_nrm18),
   .lst_inv_port_nrm18(lst_inv_port_nrm18),
   .lst_inv_addr_cmd18(lst_inv_addr_cmd18),
   .lst_inv_port_cmd18(lst_inv_port_cmd18),

   // Outputs18
   .mac_addr18(mac_addr18),    
   .d_addr18(d_addr18),   
   .s_addr18(s_addr18),    
   .s_port18(s_port18),    
   .best_bfr_age18(best_bfr_age18),
   .div_clk18(div_clk18),     
   .command(command), 
   .prdata18(prdata18),  
   .clear_reused18(clear_reused18)           
);


alut_addr_checker18 i_alut_addr_checker18
(   
   // Inputs18
   .pclk18(pclk18),
   .n_p_reset18(n_p_reset18),
   .command(command),
   .mac_addr18(mac_addr18),
   .d_addr18(d_addr18),
   .s_addr18(s_addr18),
   .s_port18(s_port18),
   .curr_time18(curr_time18),
   .mem_read_data_add18(mem_read_data_add18),
   .age_confirmed18(age_confirmed18),
   .age_ok18(age_ok18),
   .clear_reused18(clear_reused18),

   //outputs18
   .d_port18(d_port18),
   .add_check_active18(add_check_active18),
   .mem_addr_add18(mem_addr_add18),
   .mem_write_add18(mem_write_add18),
   .mem_write_data_add18(mem_write_data_add18),
   .lst_inv_addr_nrm18(lst_inv_addr_nrm18),
   .lst_inv_port_nrm18(lst_inv_port_nrm18),
   .check_age18(check_age18),
   .last_accessed18(last_accessed18),
   .reused18(reused18)
);


alut_age_checker18 i_alut_age_checker18
(   
   // Inputs18
   .pclk18(pclk18),
   .n_p_reset18(n_p_reset18),
   .command(command),          
   .div_clk18(div_clk18),          
   .mem_read_data_age18(mem_read_data_age18),
   .check_age18(check_age18),        
   .last_accessed18(last_accessed18), 
   .best_bfr_age18(best_bfr_age18),   
   .add_check_active18(add_check_active18),

   // outputs18
   .curr_time18(curr_time18),         
   .mem_addr_age18(mem_addr_age18),      
   .mem_write_age18(mem_write_age18),     
   .mem_write_data_age18(mem_write_data_age18),
   .lst_inv_addr_cmd18(lst_inv_addr_cmd18),  
   .lst_inv_port_cmd18(lst_inv_port_cmd18),  
   .age_confirmed18(age_confirmed18),     
   .age_ok18(age_ok18),
   .inval_in_prog18(inval_in_prog18),            
   .age_check_active18(age_check_active18)
);   


alut_mem18 i_alut_mem18
(   
   // Inputs18
   .pclk18(pclk18),
   .mem_addr_add18(mem_addr_add18),
   .mem_write_add18(mem_write_add18),
   .mem_write_data_add18(mem_write_data_add18),
   .mem_addr_age18(mem_addr_age18),
   .mem_write_age18(mem_write_age18),
   .mem_write_data_age18(mem_write_data_age18),

   .mem_read_data_add18(mem_read_data_add18),  
   .mem_read_data_age18(mem_read_data_age18)
);   



`ifdef ABV_ON18
// psl18 default clock18 = (posedge pclk18);

// ASSUMPTIONS18

// ASSERTION18 CHECKS18
// the invalidate18 aged18 in progress18 flag18 and the active flag18 
// should never both be set.
// psl18 assert_inval_in_prog_active18 : assert never (inval_in_prog18 & active);

// it should never be possible18 for the destination18 port to indicate18 the MAC18
// switch18 address and one of the other 4 Ethernets18
// psl18 assert_valid_dest_port18 : assert never (d_port18[4] & |{d_port18[3:0]});

// COVER18 SANITY18 CHECKS18
// check all values of destination18 port can be returned.
// psl18 cover_d_port_018 : cover { d_port18 == 5'b0_0001 };
// psl18 cover_d_port_118 : cover { d_port18 == 5'b0_0010 };
// psl18 cover_d_port_218 : cover { d_port18 == 5'b0_0100 };
// psl18 cover_d_port_318 : cover { d_port18 == 5'b0_1000 };
// psl18 cover_d_port_418 : cover { d_port18 == 5'b1_0000 };
// psl18 cover_d_port_all18 : cover { d_port18 == 5'b0_1111 };

`endif


endmodule
