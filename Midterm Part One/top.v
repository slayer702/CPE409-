module top#(parameter m = 7)(
    input clk,
    input signed [m-1:0]noise_in,
    output reg signed [2*m-1:0]filter_out
);

    //////////// Parameter for 11 taps
    // Tap values found using python calculations
    localparam signed [m-1:0] tap0 = 5;
    localparam signed [m-1:0] tap1 = 8;
    localparam signed [m-1:0] tap2 = 11;
    localparam signed [m-1:0] tap3 = 15;
    localparam signed [m-1:0] tap4 = 17;
    localparam signed [m-1:0] tap5 = 18;
    localparam signed [m-1:0] tap6 = 17;
    localparam signed [m-1:0] tap7 = 15;
    localparam signed [m-1:0] tap8 = 11;
    localparam signed [m-1:0] tap9 = 8;
    localparam signed [m-1:0] tap10 = 5;
	
	/* Testing other M scale Values
	localparam signed [m-1:0] tap0 = 2348;
    localparam signed [m-1:0] tap1 = 3853;
    localparam signed [m-1:0] tap2 = 5664;
    localparam signed [m-1:0] tap3 = 7458;
    localparam signed [m-1:0] tap4 = 8798;
    localparam signed [m-1:0] tap5 = 9295;
    localparam signed [m-1:0] tap6 = 8798;
    localparam signed [m-1:0] tap7 = 7458;
    localparam signed [m-1:0] tap8 = 5664;
    localparam signed [m-1:0] tap9 = 3853;
    localparam signed [m-1:0] tap10 = 2348;
	*/
	
    // Filter Implementation
    // Interconnecting signals
    reg signed[m-1:0]register_0 = 0;
    reg signed[m-1:0]register_1 = 0;
    reg signed[m-1:0]register_2 = 0;
    reg signed[m-1:0]register_3 = 0;
    reg signed[m-1:0]register_4 = 0;
    reg signed[m-1:0]register_5 = 0;
    reg signed[m-1:0]register_6 = 0;
    reg signed[m-1:0]register_7 = 0;
    reg signed[m-1:0]register_8 = 0;
    reg signed[m-1:0]register_9 = 0;
    // Flipflops to register the data
    always@(posedge clk) begin
        // This will work as a shift register
        register_0 <= noise_in;
        register_1 <= register_0;
        register_2 <= register_1;
        register_3 <= register_2;
        register_4 <= register_3;
        register_5 <= register_4;
        register_6 <= register_5;
        register_7 <= register_6;
        register_8 <= register_7;
        register_9 <= register_8;  
        // finally output
        filter_out <=  noise_in * tap0 +
                            register_0 * tap1 +
                            register_1 * tap2 +
                            register_2 * tap3 +
                            register_3 * tap4 +
                            register_4 * tap5 +
                            register_5 * tap6 +
                            register_6 * tap7 +
                            register_7 * tap8 +
                            register_8 * tap9 +
                            register_9 * tap10;
    end
endmodule