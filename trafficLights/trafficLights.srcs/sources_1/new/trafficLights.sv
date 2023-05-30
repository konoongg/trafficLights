`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02.05.2023 12:56:35
// Design Name:
// Module Name: trafficLights
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module trafficLights(
    input  reset, clk, night,
    output logic [7:0] digit1, [7:0] digit10,
    output logic [7:0] led
);
    typedef enum logic[2:0]{GREEN, YELLOWR, YELLOWG, RED, HALFG, HALFR, NIGHT} stateType;
    stateType state, nextState;
    logic [3:0] sec1;
    logic [3:0] secNight;
    logic [2:0] sec10;
    logic [23:0] div;
    logic [23:0] divNight;
    logic [3:0] nextSec1;
    logic [2:0] nextSec10;
   
   
    always_ff @(posedge clk or posedge reset)
    begin
        if(!reset) begin
            state = GREEN;
            sec1 <= 0;
            sec10 <= 3;
            div <= 0;
        end
        else begin
            if(div == 0) begin
                if(sec1 == 0) begin
                    sec1 <= 9;
                end
                else begin
                    sec1 <= sec1 - 1;
                end
            div <= 12000000;
            end
            else begin
                div <= div - 1;
            end
            if(div == 0 && sec1 == 0) begin
                if(sec10 == 0) begin
                    sec10 <= nextSec10;
                    sec1 <= nextSec1;
                    state <= nextState;
                end
                else begin
                    sec10 <= sec10 - 1;
                end
            end
        end
    end
    always_comb begin
              case(sec1)
                   4'd9: digit1 = 8'b01101111;
                   4'd8: digit1 = 8'b01111111;
                   4'd7: digit1 = 8'b00000111;
                   4'd6: digit1 = 8'b01111101;
                   4'd5: digit1 = 8'b01101101;
                   4'd4: digit1 = 8'b01100110;
                   4'd3: digit1 = 8'b01001111;
                   4'd2: digit1 = 8'b01011011;
                   4'd1: digit1 = 8'b00000110;
                   4'd0: digit1 = 8'b00111111;
                   default: digit1 = 8'b00000000;
               endcase
               case(sec10)
                   4'd3: digit10 = 8'b01001111;
                   4'd2: digit10 = 8'b01011011;
                   4'd1: digit10 = 8'b00000110;
                   4'd0: digit10 = 8'b00111111;
                   default: digit10 = 8'b00000000;
                endcase
          end
     always_comb
              begin
              led = 8'b00000000;
              nextState = state;
              if (sec1 == 0 && sec10 == 0 && div == 0) begin
                case(state)
                    GREEN: begin
                        if (!night) begin
                            nextState = NIGHT;
                            nextSec10 = 0;
                            nextSec1 = 5;
                        end
                        else begin
                            nextState = HALFG;
                            nextSec10 = 0;
                            nextSec1 = 5;
                            led = 8'b00100100;
                        end
                    end
                    NIGHT: begin
                        if (!night) begin
                            nextState = NIGHT;
                            nextSec10 = 0;
                            nextSec1 = 5;
                        end
                        else begin
                            nextState = GREEN;
                            nextSec10 = 3;
                            nextSec1 = 0;
                        end
                    end
                    HALFG: begin
                        nextState = YELLOWG;
                        nextSec10 = 0;
                        nextSec1 = 5;
                    end
                    YELLOWG: begin
                        nextState = RED;
                        nextSec10 = 3;
                        nextSec1 = 0;  
                    end
                    YELLOWR: begin
                        nextState = GREEN;
                        nextSec10 = 3;
                        nextSec1 = 0;  
                    end
                    RED: begin
                        nextState = HALFR;
                        nextSec10 = 0;
                        nextSec1 = 5;  
                    end
                    HALFR: begin
                        nextState = YELLOWR;
                        nextSec10 = 0;
                        nextSec1 = 5;
                    end
                    default: begin
                        nextState = GREEN;
                        nextSec10 = 3;
                        nextSec1 = 0;
                  end
              endcase
            end
            case(state)
                GREEN: begin
                    led = 8'b00100100;
                end
                NIGHT: begin
                    if (sec1 % 2 == 1) begin
                        led = 8'b01000010;
                    end
                    else begin
                        led = 8'b00000000;
                    end
                end
                HALFG: begin
                    if (sec1 % 2 == 1) begin
                        led = 8'b00000100;
                    end
                    else begin
                        led = 8'b00100100;
                    end
                end
                YELLOWG: begin
                    led = 8'b01000010;
                end
                YELLOWR: begin
                    led = 8'b01000010;
                end
                RED: begin
                    led = 8'b10000001;
                end
                HALFR: begin
                 if (sec1 % 2 == 1) begin
                    led = 8'b10000000;  
                 end
                 else begin
                    led = 8'b10000001;
                 end
                end
                default: begin
                    led = 8'b00100100;
                end
            endcase
        end    
   
endmodule
