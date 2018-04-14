`timescale 1ns / 1ps

module reaction_timer_top (
    input enable,
    input response_btn,
    input ready_btn,
    input restart_btn,
    input reset,
    input clk,
    output reg trigger_led,
    output wire  [7:0] ssd_cathode,
    output wire [3:0] ssd_anode
    );

    reg run_reaction_timer;
    reg reset_counters;
    reg enable_counters;
    wire [13:0] reaction_timer_count;
    reg [13:0] random_prep_time;

    reg run_prep_timer;
    wire [13:0] random_number;
    
    reg [13:0] display_value;
    wire db_response_btn;
    wire db_ready_btn;
    wire db_restart_btn;
    wire clk_1kHz;
    wire clk_1Hz;
    wire [13:0] trigger_timer_count;
    wire [13:0] preparation_timer_count;
    reg run_trigger_timer;
    reg [1:0] display_data_type;
    reg run_delay_timer;
    wire [13:0] delay_timer_count;
    reg clear_display;

    debouncer DEBOUNCE_RESPONSE_BTN (
        .clk(clk),
        .button_in(response_btn),
        .button_out(db_response_btn)
        );

    debouncer DEBOUNCE_READY_BTN (
        .clk(clk),
        .button_in(ready_btn),
        .button_out(db_ready_btn)
        );

    debouncer DEBOUNCE_RESTRT_BTN (
        .clk(clk),
        .button_in(restart_btn),
        .button_out(db_restart_btn)
        );
    
    clock_divider #(
        .THRESHOLD(50_000)
    ) CLOCK_1kHZ_GENERATOR (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .divided_clk(clk_1kHz)
        );

    counter REACTION_COUNTER (
        .run(run_reaction_timer),
        .count(reaction_timer_count),
        .reset(reset_counters),
        .enable(enable_counters),
        .clk(clk_1kHz)
        );

    clock_divider #(
        .THRESHOLD(50_000_000)
    ) CLOCK_1HZ_GENERATOR (
        .clk(clk),
        .reset(1'b0),
        .enable(1'b1),
        .divided_clk(clk_1Hz)
        );

    counter TRIGGER_COUNTER (
        .run(run_trigger_timer),
        .count(trigger_timer_count),
        .reset(reset_counters),
        .enable(enable_counters),
        .clk(clk_1kHz)
        );

    reverse_counter #(
        .INITIAL_VALUE(10)
    )  DELAY_COUNTER (
        .run(run_delay_timer),
        .count(delay_timer_count),
        .reset(reset_counters),
        .enable(enable_counters),
        .clk(clk_1Hz)
        );


    reverse_counter #(
        .INITIAL_VALUE(3)
    ) PREPARATION_COUNTER (
        .clk(clk_1Hz),
        .enable(enable_counters),
        .run(run_prep_timer),
        .reset(reset_counters),
        .count(preparation_timer_count)
        ); 

    display DISPLAY (
        .clk(clk_1kHz),
        .value(display_value),
        .type(display_data_type),       
        .ssd_cathode(ssd_cathode),
        .ssd_anode(ssd_anode),
        .clear(clear_display)
        );

    lfsr RAND_NUM_GEN (
        .random_number(random_number),
        .reset(reset),
        .clk(clk)
        );
    
    game_fsm GAME_FSM (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .restart(db_restart_btn),
        .ready(db_ready_btn),
        .response(db_response_btn),
        .trigger_timer_count(trigger_timer_count),
        .reaction_timer_count(reaction_timer_count),
        .delay_timer_count(delay_timer_count),
        .clear_display(clear_display),
        .run_delay_timer(run_delay_timer),
        .run_prep_timer(run_prep_timer),
        .run_trigger_timer(run_trigger_timer),
        .run_reaction_timer(run_reaction_timer),
        .reset_counters(reset_counters),
        .trigger_led(trigger_led),
        .enable_counters(enable_counters),
        .display_data_type(display_data_type),
        .display_value(display_value),
        .preparation_timer_count(preparation_timer_count),
        .random_number(random_number)
        );

endmodule
