module sargam (
    input clk,                  // Input clock (50 MHz)
    input [6:0] btn,            // 7 buttons as inputs
    output reg speaker,         // Speaker output
    output reg [6:0] led        // 7 LEDs as outputs
);

    // Precomputed half-periods for notes (50 MHz clock)
    parameter SA  = 95556; // Sa (262 Hz)
    parameter RE  = 85131; // Re (294 Hz)
    parameter GA  = 75843; // Ga (330 Hz)
    parameter MA  = 71633; // Ma (349 Hz)
    parameter PA  = 63662; // Pa (392 Hz)
    parameter DHA = 56818; // Dha (440 Hz)
    parameter NI  = 50521; // Ni (494 Hz)

    // Precomputed note periods array
    reg [31:0] note_periods [0:6];
    initial begin
        note_periods[0] = SA;
        note_periods[1] = RE;
        note_periods[2] = GA;
        note_periods[3] = MA;
        note_periods[4] = PA;
        note_periods[5] = DHA;
        note_periods[6] = NI;
    end

    // Variables for generating PWM
    reg [31:0] counter = 0;      // PWM counter
    reg [31:0] current_period = 0; // Current half-period for the active note

    // Main logic
    always @(posedge clk) begin
        // Reset all LEDs by default
        led <= 7'b0000000;

        // Check which button is pressed
        if (btn[0]) begin
            current_period <= note_periods[0]; // Sa
            led[0] <= 1;                      // Turn on LED 0
        end else if (btn[1]) begin
            current_period <= note_periods[1]; // Re
            led[1] <= 1;                      // Turn on LED 1
        end else if (btn[2]) begin
            current_period <= note_periods[2]; // Ga
            led[2] <= 1;                      // Turn on LED 2
        end else if (btn[3]) begin
            current_period <= note_periods[3]; // Ma
            led[3] <= 1;                      // Turn on LED 3
        end else if (btn[4]) begin
            current_period <= note_periods[4]; // Pa
            led[4] <= 1;                      // Turn on LED 4
        end else if (btn[5]) begin
            current_period <= note_periods[5]; // Dha
            led[5] <= 1;                      // Turn on LED 5
        end else if (btn[6]) begin
            current_period <= note_periods[6]; // Ni
            led[6] <= 1;                      // Turn on LED 6
        end else begin
            current_period <= 0;              // No button pressed, silence speaker
        end

        // Generate PWM signal for the active note
        if (current_period != 0) begin
            if (counter >= current_period) begin
                counter <= 0;
                speaker <= ~speaker; // Toggle speaker output
            end else begin
                counter <= counter + 1;
            end
        end else begin
            speaker <= 0; // Silence the speaker when no button is pressed
        end
    end
endmodule
