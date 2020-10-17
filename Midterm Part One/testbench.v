module testbench();
// Connecting signals
    parameter m = 7;
    reg clk;
    reg signed [m-1:0]noise_in;
    wire signed [2*m-1:0]filter_out;

    integer in_file,out_file,i,status0;
//Design under test
top dut(
    .clk(clk),
    .noise_in(noise_in),
    .filter_out(filter_out)
);

// Clock Generator
always begin
    #5 clk = ~clk; // 100 Mhz clock for simulation
end

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,testbench);
    in_file = $fopen("Python_Input_Scaled_By_M.dat","r");
    out_file = $fopen("Verilog_Filter_Out.dat","w");
    clk = 0;
    noise_in = 0;
	 
	for(i=0 ;i<42028;i=i+1) begin
		status0 = $fscanf(in_file,"%d",noise_in);
		//$display($time ," Input: %d" ,noise_in);
		@(negedge clk);
        if (i >= 5 && i <= 42027-5) begin
            if(i >= 10) begin
                //$display($time," Output: %f" ,$itor(filter_out)/(2.0**(2.0*m)));
		        $fwrite(out_file,"%f\n",$itor(filter_out)/(2.00**(2.00*m)));
            end
        end
        else begin
            $fwrite(out_file,"%f\n",$itor(noise_in)/(2.00**(m)));
        end
	end
    #100;
	$fclose(in_file);
	$fclose(out_file);
	$finish;
end



endmodule