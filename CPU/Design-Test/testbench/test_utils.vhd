-- Utils for tests
-- Author : Guillaume Fournier-Mayer (tinf101922)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;

package test_utils is

    function to_string ( a: std_logic_vector)
        return string;

    function to_string ( a: std_logic)
        return string;

    procedure compare_assert(
        actual_data : std_logic_vector(31 downto 0);
        expect_data : std_logic_vector(31 downto 0);
        report_msg  : string;
        delay: time);
    
    procedure compare_assert(
        actual_data : std_logic;
        expect_data : std_logic;
        report_msg  : string;
        delay: time);

end package test_utils;
   
package body test_utils is

    function to_string (a: std_logic_vector) return string is
        variable b : string (1 to a'length) := (others => NUL);
        variable stri : integer := 1; 
        begin
            for i in a'range loop
                b(stri) := std_logic'image(a(i))(2);
            stri := stri+1;
            end loop;
        return b;
    end function;

    function to_string (a: std_logic) return string is
        variable b : string (1 to 1) := (others => NUL);
        begin
            b(1) := std_logic'image(a)(2);
        return b;
    end function;

    procedure compare_assert(
        actual_data: std_logic_vector(31 downto 0);
        expect_data: std_logic_vector(31 downto 0);
        report_msg: string;
        delay: time)
        is
    begin
        wait for delay;
        if expect_data = actual_data then
            report "PASSED " & report_msg severity note;
        else
            report "ASSERT " & report_msg & " -> "
                & "expect: [" & to_string(expect_data) & "], "
                & "actual: [" & to_string(actual_data) & "]"
                severity error;
        end if;
        wait for delay;
    end procedure;

    procedure compare_assert(
        actual_data : std_logic;
        expect_data : std_logic;
        report_msg  : string;
        delay: time)
        is
    begin
        wait for delay;
        if expect_data = actual_data then
            report "PASSED " & report_msg severity note;
        else
            report "ASSERT " & report_msg & " -> "
                & "expect: [" & to_string(expect_data) & "], "
                & "actual: [" & to_string(actual_data) & "]"
            severity error;
        end if;
        wait for delay;
    end procedure;

 end package body test_utils;
