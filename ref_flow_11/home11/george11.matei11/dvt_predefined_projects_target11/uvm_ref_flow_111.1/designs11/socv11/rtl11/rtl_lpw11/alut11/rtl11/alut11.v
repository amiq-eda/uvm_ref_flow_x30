//File11 name   : alut11.v
//Title11       : ALUT11 top level
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
module alut11
(   
   // Inputs11
   pclk11,
   n_p_reset11,
   psel11,            
   penable11,       
   pwrite11,         
   paddr11,           
   pwdata11,          

   // Outputs11
   prdata11  
);

   parameter   DW11 = 83;          // width of data busses11
   parameter   DD11 = 256;         // depth of RAM11


   // APB11 Inputs11
   input             pclk11;               // APB11 clock11                          
   input             n_p_reset11;          // Reset11                              
   input             psel11;               // Module11 select11 signal11               
   input             penable11;            // Enable11 signal11                      
   input             pwrite11;             // Write when HIGH11 and read when LOW11  
   input [6:0]       paddr11;              // Address bus for read write         
   input [31:0]      pwdata11;             // APB11 write bus                      

   output [31:0]     prdata11;             // APB11 read bus                       

   wire              pclk11;               // APB11 clock11                           
   wire [7:0]        mem_addr_add11;       // hash11 address for R/W11 to memory     
   wire              mem_write_add11;      // R/W11 flag11 (write = high11)            
   wire [DW11-1:0]     mem_write_data_add11; // write data for memory             
   wire [7:0]        mem_addr_age11;       // hash11 address for R/W11 to memory     
   wire              mem_write_age11;      // R/W11 flag11 (write = high11)            
   wire [DW11-1:0]     mem_write_data_age11; // write data for memory             
   wire [DW11-1:0]     mem_read_data_add11;  // read data from mem                 
   wire [DW11-1:0]     mem_read_data_age11;  // read data from mem  
   wire [31:0]       curr_time11;          // current time
   wire              active;             // status[0] adress11 checker active
   wire              inval_in_prog11;      // status[1] 
   wire              reused11;             // status[2] ALUT11 location11 overwritten11
   wire [4:0]        d_port11;             // calculated11 destination11 port for tx11
   wire [47:0]       lst_inv_addr_nrm11;   // last invalidated11 addr normal11 op
   wire [1:0]        lst_inv_port_nrm11;   // last invalidated11 port normal11 op
   wire [47:0]       lst_inv_addr_cmd11;   // last invalidated11 addr via cmd11
   wire [1:0]        lst_inv_port_cmd11;   // last invalidated11 port via cmd11
   wire [47:0]       mac_addr11;           // address of the switch11
   wire [47:0]       d_addr11;             // address of frame11 to be checked11
   wire [47:0]       s_addr11;             // address of frame11 to be stored11
   wire [1:0]        s_port11;             // source11 port of current frame11
   wire [31:0]       best_bfr_age11;       // best11 before age11
   wire [7:0]        div_clk11;            // programmed11 clock11 divider11 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata11;             // APB11 read bus
   wire              age_confirmed11;      // valid flag11 from age11 checker        
   wire              age_ok11;             // result from age11 checker 
   wire              clear_reused11;       // read/clear flag11 for reused11 signal11           
   wire              check_age11;          // request flag11 for age11 check
   wire [31:0]       last_accessed11;      // time field sent11 for age11 check




alut_reg_bank11 i_alut_reg_bank11
(   
   // Inputs11
   .pclk11(pclk11),
   .n_p_reset11(n_p_reset11),
   .psel11(psel11),            
   .penable11(penable11),       
   .pwrite11(pwrite11),         
   .paddr11(paddr11),           
   .pwdata11(pwdata11),          
   .curr_time11(curr_time11),
   .add_check_active11(add_check_active11),
   .age_check_active11(age_check_active11),
   .inval_in_prog11(inval_in_prog11),
   .reused11(reused11),
   .d_port11(d_port11),
   .lst_inv_addr_nrm11(lst_inv_addr_nrm11),
   .lst_inv_port_nrm11(lst_inv_port_nrm11),
   .lst_inv_addr_cmd11(lst_inv_addr_cmd11),
   .lst_inv_port_cmd11(lst_inv_port_cmd11),

   // Outputs11
   .mac_addr11(mac_addr11),    
   .d_addr11(d_addr11),   
   .s_addr11(s_addr11),    
   .s_port11(s_port11),    
   .best_bfr_age11(best_bfr_age11),
   .div_clk11(div_clk11),     
   .command(command), 
   .prdata11(prdata11),  
   .clear_reused11(clear_reused11)           
);


alut_addr_checker11 i_alut_addr_checker11
(   
   // Inputs11
   .pclk11(pclk11),
   .n_p_reset11(n_p_reset11),
   .command(command),
   .mac_addr11(mac_addr11),
   .d_addr11(d_addr11),
   .s_addr11(s_addr11),
   .s_port11(s_port11),
   .curr_time11(curr_time11),
   .mem_read_data_add11(mem_read_data_add11),
   .age_confirmed11(age_confirmed11),
   .age_ok11(age_ok11),
   .clear_reused11(clear_reused11),

   //outputs11
   .d_port11(d_port11),
   .add_check_active11(add_check_active11),
   .mem_addr_add11(mem_addr_add11),
   .mem_write_add11(mem_write_add11),
   .mem_write_data_add11(mem_write_data_add11),
   .lst_inv_addr_nrm11(lst_inv_addr_nrm11),
   .lst_inv_port_nrm11(lst_inv_port_nrm11),
   .check_age11(check_age11),
   .last_accessed11(last_accessed11),
   .reused11(reused11)
);


alut_age_checker11 i_alut_age_checker11
(   
   // Inputs11
   .pclk11(pclk11),
   .n_p_reset11(n_p_reset11),
   .command(command),          
   .div_clk11(div_clk11),          
   .mem_read_data_age11(mem_read_data_age11),
   .check_age11(check_age11),        
   .last_accessed11(last_accessed11), 
   .best_bfr_age11(best_bfr_age11),   
   .add_check_active11(add_check_active11),

   // outputs11
   .curr_time11(curr_time11),         
   .mem_addr_age11(mem_addr_age11),      
   .mem_write_age11(mem_write_age11),     
   .mem_write_data_age11(mem_write_data_age11),
   .lst_inv_addr_cmd11(lst_inv_addr_cmd11),  
   .lst_inv_port_cmd11(lst_inv_port_cmd11),  
   .age_confirmed11(age_confirmed11),     
   .age_ok11(age_ok11),
   .inval_in_prog11(inval_in_prog11),            
   .age_check_active11(age_check_active11)
);   


alut_mem11 i_alut_mem11
(   
   // Inputs11
   .pclk11(pclk11),
   .mem_addr_add11(mem_addr_add11),
   .mem_write_add11(mem_write_add11),
   .mem_write_data_add11(mem_write_data_add11),
   .mem_addr_age11(mem_addr_age11),
   .mem_write_age11(mem_write_age11),
   .mem_write_data_age11(mem_write_data_age11),

   .mem_read_data_add11(mem_read_data_add11),  
   .mem_read_data_age11(mem_read_data_age11)
);   



`ifdef ABV_ON11
// psl11 default clock11 = (posedge pclk11);

// ASSUMPTIONS11

// ASSERTION11 CHECKS11
// the invalidate11 aged11 in progress11 flag11 and the active flag11 
// should never both be set.
// psl11 assert_inval_in_prog_active11 : assert never (inval_in_prog11 & active);

// it should never be possible11 for the destination11 port to indicate11 the MAC11
// switch11 address and one of the other 4 Ethernets11
// psl11 assert_valid_dest_port11 : assert never (d_port11[4] & |{d_port11[3:0]});

// COVER11 SANITY11 CHECKS11
// check all values of destination11 port can be returned.
// psl11 cover_d_port_011 : cover { d_port11 == 5'b0_0001 };
// psl11 cover_d_port_111 : cover { d_port11 == 5'b0_0010 };
// psl11 cover_d_port_211 : cover { d_port11 == 5'b0_0100 };
// psl11 cover_d_port_311 : cover { d_port11 == 5'b0_1000 };
// psl11 cover_d_port_411 : cover { d_port11 == 5'b1_0000 };
// psl11 cover_d_port_all11 : cover { d_port11 == 5'b0_1111 };

`endif


endmodule
