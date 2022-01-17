package body soft_renderer.line is

    procedure swap (x, y : in out integer) is
        t : integer := x;
    begin
        x := y;
        y := t;
    end swap;

    procedure line
       (x0 : in out Integer; y0 : in out Integer; x1 : in out  Integer; y1 : in out  Integer; c : color; img : in out image)
    is
        steep   : Boolean := False;
        dx      : Integer := x0 - x1;
        dy      : Integer := y0 - y1;
        derror2, error2, y : integer := 0;
    begin
        if abs dx < abs dy then
            swap (x0, y0);
            swap (x1, y1);
            steep := true;
        end if;
        if x0 > x1 then
            swap (x0, x1);
            swap (y0, y1);
        end if;

        dx := x1-x0;
        dy := y1-y0;
        derror2 := (abs dy) * 2;
        y := y0;

        for x in x0 .. x1 loop
            if steep then
                set_pixel_color (img, y, x, c);
            else
                set_pixel_color (img, x, y, c);
            end if;
            error2 := error2 + derror2;
            if error2 > dx then
                y := y + (if y1 > y0 then 1 else -1);
                error2 := error2 - dx*2;
            end if;
        end loop;

    end line;

end soft_renderer.line;