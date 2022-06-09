//File2 name   : alut2.v
//Title2       : ALUT2 top level
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
module alut2
(   
   // Inputs2
   pclk2,
   n_p_reset2,
   psel2,            
   penable2,       
   pwrite2,         
   paddr2,           
   pwdata2,          

   // Outputs2
   prdata2  
);

   parameter   DW2 = 83;          // width of data busses2
   parameter   DD2 = 256;         // depth of RAM2


   // APB2 Inputs2
   input             pclk2;               // APB2 clock2                          
   input             n_p_reset2;          // Reset2                              
   input             psel2;               // Module2 select2 signal2               
   input             penable2;            // Enable2 signal2                      
   input             pwrite2;             // Write when HIGH2 and read when LOW2  
   input [6:0]       paddr2;              // Address bus for read write         
   input [31:0]      pwdata2;             // APB2 write bus                      

   output [31:0]     prdata2;             // APB2 read bus                       

   wire              pclk2;               // APB2 clock2                           
   wire [7:0]        mem_addr_add2;       // hash2 address for R/W2 to memory     
   wire              mem_write_add2;      // R/W2 flag2 (write = high2)            
   wire [DW2-1:0]     mem_write_data_add2; // write data for memory             
   wire [7:0]        mem_addr_age2;       // hash2 address for R/W2 to memory     
   wire              mem_write_age2;      // R/W2 flag2 (write = high2)            
   wire [DW2-1:0]     mem_write_data_age2; // write data for memory             
   wire [DW2-1:0]     mem_read_data_add2;  // read data from mem                 
   wire [DW2-1:0]     mem_read_data_age2;  // read data from mem  
   wire [31:0]       curr_time2;          // current time
   wire              active;             // status[0] adress2 checker active
   wire              inval_in_prog2;      // status[1] 
   wire              reused2;             // status[2] ALUT2 location2 overwritten2
   wire [4:0]        d_port2;             // calculated2 destination2 port for tx2
   wire [47:0]       lst_inv_addr_nrm2;   // last invalidated2 addr normal2 op
   wire [1:0]        lst_inv_port_nrm2;   // last invalidated2 port normal2 op
   wire [47:0]       lst_inv_addr_cmd2;   // last invalidated2 addr via cmd2
   wire [1:0]        lst_inv_port_cmd2;   // last invalidated2 port via cmd2
   wire [47:0]       mac_addr2;           // address of the switch2
   wire [47:0]       d_addr2;             // address of frame2 to be checked2
   wire [47:0]       s_addr2;             // address of frame2 to be stored2
   wire [1:0]        s_port2;             // source2 port of current frame2
   wire [31:0]       best_bfr_age2;       // best2 before age2
   wire [7:0]        div_clk2;            // programmed2 clock2 divider2 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata2;             // APB2 read bus
   wire              age_confirmed2;      // valid flag2 from age2 checker        
   wire              age_ok2;             // result from age2 checker 
   wire              clear_reused2;       // read/clear flag2 for reused2 signal2           
   wire              check_age2;          // request flag2 for age2 check
   wire [31:0]       last_accessed2;      // time field sent2 for age2 check




alut_reg_bank2 i_alut_reg_bank2
(   
   // Inputs2
   .pclk2(pclk2),
   .n_p_reset2(n_p_reset2),
   .psel2(psel2),            
   .penable2(penable2),       
   .pwrite2(pwrite2),         
   .paddr2(paddr2),           
   .pwdata2(pwdata2),          
   .curr_time2(curr_time2),
   .add_check_active2(add_check_active2),
   .age_check_active2(age_check_active2),
   .inval_in_prog2(inval_in_prog2),
   .reused2(reused2),
   .d_port2(d_port2),
   .lst_inv_addr_nrm2(lst_inv_addr_nrm2),
   .lst_inv_port_nrm2(lst_inv_port_nrm2),
   .lst_inv_addr_cmd2(lst_inv_addr_cmd2),
   .lst_inv_port_cmd2(lst_inv_port_cmd2),

   // Outputs2
   .mac_addr2(mac_addr2),    
   .d_addr2(d_addr2),   
   .s_addr2(s_addr2),    
   .s_port2(s_port2),    
   .best_bfr_age2(best_bfr_age2),
   .div_clk2(div_clk2),     
   .command(command), 
   .prdata2(prdata2),  
   .clear_reused2(clear_reused2)           
);


alut_addr_checker2 i_alut_addr_checker2
(   
   // Inputs2
   .pclk2(pclk2),
   .n_p_reset2(n_p_reset2),
   .command(command),
   .mac_addr2(mac_addr2),
   .d_addr2(d_addr2),
   .s_addr2(s_addr2),
   .s_port2(s_port2),
   .curr_time2(curr_time2),
   .mem_read_data_add2(mem_read_data_add2),
   .age_confirmed2(age_confirmed2),
   .age_ok2(age_ok2),
   .clear_reused2(clear_reused2),

   //outputs2
   .d_port2(d_port2),
   .add_check_active2(add_check_active2),
   .mem_addr_add2(mem_addr_add2),
   .mem_write_add2(mem_write_add2),
   .mem_write_data_add2(mem_write_data_add2),
   .lst_inv_addr_nrm2(lst_inv_addr_nrm2),
   .lst_inv_port_nrm2(lst_inv_port_nrm2),
   .check_age2(check_age2),
   .last_accessed2(last_accessed2),
   .reused2(reused2)
);


alut_age_checker2 i_alut_age_checker2
(   
   // Inputs2
   .pclk2(pclk2),
   .n_p_reset2(n_p_reset2),
   .command(command),          
   .div_clk2(div_clk2),          
   .mem_read_data_age2(mem_read_data_age2),
   .check_age2(check_age2),        
   .last_accessed2(last_accessed2), 
   .best_bfr_age2(best_bfr_age2),   
   .add_check_active2(add_check_active2),

   // outputs2
   .curr_time2(curr_time2),         
   .mem_addr_age2(mem_addr_age2),      
   .mem_write_age2(mem_write_age2),     
   .mem_write_data_age2(mem_write_data_age2),
   .lst_inv_addr_cmd2(lst_inv_addr_cmd2),  
   .lst_inv_port_cmd2(lst_inv_port_cmd2),  
   .age_confirmed2(age_confirmed2),     
   .age_ok2(age_ok2),
   .inval_in_prog2(inval_in_prog2),            
   .age_check_active2(age_check_active2)
);   


alut_mem2 i_alut_mem2
(   
   // Inputs2
   .pclk2(pclk2),
   .mem_addr_add2(mem_addr_add2),
   .mem_write_add2(mem_write_add2),
   .mem_write_data_add2(mem_write_data_add2),
   .mem_addr_age2(mem_addr_age2),
   .mem_write_age2(mem_write_age2),
   .mem_write_data_age2(mem_write_data_age2),

   .mem_read_data_add2(mem_read_data_add2),  
   .mem_read_data_age2(mem_read_data_age2)
);   



`ifdef ABV_ON2
// psl2 default clock2 = (posedge pclk2);

// ASSUMPTIONS2

// ASSERTION2 CHECKS2
// the invalidate2 aged2 in progress2 flag2 and the active flag2 
// should never both be set.
// psl2 assert_inval_in_prog_active2 : assert never (inval_in_prog2 & active);

// it should never be possible2 for the destination2 port to indicate2 the MAC2
// switch2 address and one of the other 4 Ethernets2
// psl2 assert_valid_dest_port2 : assert never (d_port2[4] & |{d_port2[3:0]});

// COVER2 SANITY2 CHECKS2
// check all values of destination2 port can be returned.
// psl2 cover_d_port_02 : cover { d_port2 == 5'b0_0001 };
// psl2 cover_d_port_12 : cover { d_port2 == 5'b0_0010 };
// psl2 cover_d_port_22 : cover { d_port2 == 5'b0_0100 };
// psl2 cover_d_port_32 : cover { d_port2 == 5'b0_1000 };
// psl2 cover_d_port_42 : cover { d_port2 == 5'b1_0000 };
// psl2 cover_d_port_all2 : cover { d_port2 == 5'b0_1111 };

`endif


endmodule
