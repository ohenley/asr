package body basics is

    procedure generic_swap (x, y : in out t) is
        tmp : constant t := x;
    begin
        x := y;
        y := tmp;
    end;
    
end basics;