//File3 name   : alut3.v
//Title3       : ALUT3 top level
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
module alut3
(   
   // Inputs3
   pclk3,
   n_p_reset3,
   psel3,            
   penable3,       
   pwrite3,         
   paddr3,           
   pwdata3,          

   // Outputs3
   prdata3  
);

   parameter   DW3 = 83;          // width of data busses3
   parameter   DD3 = 256;         // depth of RAM3


   // APB3 Inputs3
   input             pclk3;               // APB3 clock3                          
   input             n_p_reset3;          // Reset3                              
   input             psel3;               // Module3 select3 signal3               
   input             penable3;            // Enable3 signal3                      
   input             pwrite3;             // Write when HIGH3 and read when LOW3  
   input [6:0]       paddr3;              // Address bus for read write         
   input [31:0]      pwdata3;             // APB3 write bus                      

   output [31:0]     prdata3;             // APB3 read bus                       

   wire              pclk3;               // APB3 clock3                           
   wire [7:0]        mem_addr_add3;       // hash3 address for R/W3 to memory     
   wire              mem_write_add3;      // R/W3 flag3 (write = high3)            
   wire [DW3-1:0]     mem_write_data_add3; // write data for memory             
   wire [7:0]        mem_addr_age3;       // hash3 address for R/W3 to memory     
   wire              mem_write_age3;      // R/W3 flag3 (write = high3)            
   wire [DW3-1:0]     mem_write_data_age3; // write data for memory             
   wire [DW3-1:0]     mem_read_data_add3;  // read data from mem                 
   wire [DW3-1:0]     mem_read_data_age3;  // read data from mem  
   wire [31:0]       curr_time3;          // current time
   wire              active;             // status[0] adress3 checker active
   wire              inval_in_prog3;      // status[1] 
   wire              reused3;             // status[2] ALUT3 location3 overwritten3
   wire [4:0]        d_port3;             // calculated3 destination3 port for tx3
   wire [47:0]       lst_inv_addr_nrm3;   // last invalidated3 addr normal3 op
   wire [1:0]        lst_inv_port_nrm3;   // last invalidated3 port normal3 op
   wire [47:0]       lst_inv_addr_cmd3;   // last invalidated3 addr via cmd3
   wire [1:0]        lst_inv_port_cmd3;   // last invalidated3 port via cmd3
   wire [47:0]       mac_addr3;           // address of the switch3
   wire [47:0]       d_addr3;             // address of frame3 to be checked3
   wire [47:0]       s_addr3;             // address of frame3 to be stored3
   wire [1:0]        s_port3;             // source3 port of current frame3
   wire [31:0]       best_bfr_age3;       // best3 before age3
   wire [7:0]        div_clk3;            // programmed3 clock3 divider3 value
   wire [1:0]        command;            // command bus
   wire [31:0]       prdata3;             // APB3 read bus
   wire              age_confirmed3;      // valid flag3 from age3 checker        
   wire              age_ok3;             // result from age3 checker 
   wire              clear_reused3;       // read/clear flag3 for reused3 signal3           
   wire              check_age3;          // request flag3 for age3 check
   wire [31:0]       last_accessed3;      // time field sent3 for age3 check




alut_reg_bank3 i_alut_reg_bank3
(   
   // Inputs3
   .pclk3(pclk3),
   .n_p_reset3(n_p_reset3),
   .psel3(psel3),            
   .penable3(penable3),       
   .pwrite3(pwrite3),         
   .paddr3(paddr3),           
   .pwdata3(pwdata3),          
   .curr_time3(curr_time3),
   .add_check_active3(add_check_active3),
   .age_check_active3(age_check_active3),
   .inval_in_prog3(inval_in_prog3),
   .reused3(reused3),
   .d_port3(d_port3),
   .lst_inv_addr_nrm3(lst_inv_addr_nrm3),
   .lst_inv_port_nrm3(lst_inv_port_nrm3),
   .lst_inv_addr_cmd3(lst_inv_addr_cmd3),
   .lst_inv_port_cmd3(lst_inv_port_cmd3),

   // Outputs3
   .mac_addr3(mac_addr3),    
   .d_addr3(d_addr3),   
   .s_addr3(s_addr3),    
   .s_port3(s_port3),    
   .best_bfr_age3(best_bfr_age3),
   .div_clk3(div_clk3),     
   .command(command), 
   .prdata3(prdata3),  
   .clear_reused3(clear_reused3)           
);


alut_addr_checker3 i_alut_addr_checker3
(   
   // Inputs3
   .pclk3(pclk3),
   .n_p_reset3(n_p_reset3),
   .command(command),
   .mac_addr3(mac_addr3),
   .d_addr3(d_addr3),
   .s_addr3(s_addr3),
   .s_port3(s_port3),
   .curr_time3(curr_time3),
   .mem_read_data_add3(mem_read_data_add3),
   .age_confirmed3(age_confirmed3),
   .age_ok3(age_ok3),
   .clear_reused3(clear_reused3),

   //outputs3
   .d_port3(d_port3),
   .add_check_active3(add_check_active3),
   .mem_addr_add3(mem_addr_add3),
   .mem_write_add3(mem_write_add3),
   .mem_write_data_add3(mem_write_data_add3),
   .lst_inv_addr_nrm3(lst_inv_addr_nrm3),
   .lst_inv_port_nrm3(lst_inv_port_nrm3),
   .check_age3(check_age3),
   .last_accessed3(last_accessed3),
   .reused3(reused3)
);


alut_age_checker3 i_alut_age_checker3
(   
   // Inputs3
   .pclk3(pclk3),
   .n_p_reset3(n_p_reset3),
   .command(command),          
   .div_clk3(div_clk3),          
   .mem_read_data_age3(mem_read_data_age3),
   .check_age3(check_age3),        
   .last_accessed3(last_accessed3), 
   .best_bfr_age3(best_bfr_age3),   
   .add_check_active3(add_check_active3),

   // outputs3
   .curr_time3(curr_time3),         
   .mem_addr_age3(mem_addr_age3),      
   .mem_write_age3(mem_write_age3),     
   .mem_write_data_age3(mem_write_data_age3),
   .lst_inv_addr_cmd3(lst_inv_addr_cmd3),  
   .lst_inv_port_cmd3(lst_inv_port_cmd3),  
   .age_confirmed3(age_confirmed3),     
   .age_ok3(age_ok3),
   .inval_in_prog3(inval_in_prog3),            
   .age_check_active3(age_check_active3)
);   


alut_mem3 i_alut_mem3
(   
   // Inputs3
   .pclk3(pclk3),
   .mem_addr_add3(mem_addr_add3),
   .mem_write_add3(mem_write_add3),
   .mem_write_data_add3(mem_write_data_add3),
   .mem_addr_age3(mem_addr_age3),
   .mem_write_age3(mem_write_age3),
   .mem_write_data_age3(mem_write_data_age3),

   .mem_read_data_add3(mem_read_data_add3),  
   .mem_read_data_age3(mem_read_data_age3)
);   



`ifdef ABV_ON3
// psl3 default clock3 = (posedge pclk3);

// ASSUMPTIONS3

// ASSERTION3 CHECKS3
// the invalidate3 aged3 in progress3 flag3 and the active flag3 
// should never both be set.
// psl3 assert_inval_in_prog_active3 : assert never (inval_in_prog3 & active);

// it should never be possible3 for the destination3 port to indicate3 the MAC3
// switch3 address and one of the other 4 Ethernets3
// psl3 assert_valid_dest_port3 : assert never (d_port3[4] & |{d_port3[3:0]});

// COVER3 SANITY3 CHECKS3
// check all values of destination3 port can be returned.
// psl3 cover_d_port_03 : cover { d_port3 == 5'b0_0001 };
// psl3 cover_d_port_13 : cover { d_port3 == 5'b0_0010 };
// psl3 cover_d_port_23 : cover { d_port3 == 5'b0_0100 };
// psl3 cover_d_port_33 : cover { d_port3 == 5'b0_1000 };
// psl3 cover_d_port_43 : cover { d_port3 == 5'b1_0000 };
// psl3 cover_d_port_all3 : cover { d_port3 == 5'b0_1111 };

`endif


endmodule
