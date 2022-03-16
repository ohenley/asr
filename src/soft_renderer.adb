--with Ada.Numerics.Generic_Real_Arrays;
with linear_algebra;
with Ada.text_io; use ada.text_io;
package body soft_renderer is

    procedure set_pixel_color (img : in out image; 
                                x  : natural; 
                                y  : natural;
                                c  : color) is
    begin
        img.r (x, y) := c.r;
        img.g (x, y) := c.g;
        img.b (x, y) := c.b;
        img.a (x, y) := c.a;
    end;

    procedure line (x0 : in out natural; 
                    y0 : in out natural; 
                    x1 : in out natural; 
                    y1 : in out natural; 
                    c : color; 
                    img : in out image)
    is
        procedure swap is new generic_swap (T => natural);
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

    procedure triangle (px0 : in out natural; 
                        py0 : in out natural; 
                        px1 : in out natural; 
                        py1 : in out natural;
                        px2 : in out natural; 
                        py2 : in out natural;
                        c : color; 
                        img : in out image) is
        procedure swap is new generic_swap (T => natural);
        total_height : real;
        second_half : boolean;
        segment_height : real;
        alpha, beta : real;
        
        package screen_coords is new linear_algebra (base => real);
        use screen_coords;

        t0 : vec := (real(px0), real(py0));
        t1 : vec := (real(px1), real(py1));
        t2 : vec := (real(px2), real(py2));

    begin
        if (t0 (1) = t1 (1) and t0 (1) = t2 (1)) then
            return;
        end if;
        if t0 (1) > t1 (1) then 
            swap (t0, t1);
        end if;
        if t0 (1) > t2 (1) then 
            swap (t0, t2);
        end if;
        if t1 (1) > t2 (1) then 
            swap (t1, t2);
        end if;
        total_height := t2 (1) - t0 (1);
        for i in 0 .. integer (total_height) - 1 loop 
            second_half := i > integer (t1 (1) - t0 (1)) or t1 (1) = t0 (1);
            segment_height := (if second_half then t2 (1) - t1 (1) else t1 (1) - t0 (1));
            alpha := real (i) / total_height;
            beta  := (real (i) - (if second_half then t1 (1) - t0 (1) else 0.0))/segment_height;
            declare
                a : vec := t0 + (t2-t0) * alpha;
                b : vec := (if second_half then t1 + (t2-t1) * beta else t0 + (t1-t0) * beta);
            begin
                if a (0) > b(0) then
                    swap (a, b);
                end if;
                for j in integer (a(0)) .. integer (b(0)) loop
                    set_pixel_color (img, j, integer (t0 (1) + real (i)), c);
                end loop;
            end;
        end loop;
    end;
end soft_renderer;

--void triangle(Vec2i t0, Vec2i t1, Vec2i t2, TGAImage &image, TGAColor color) { 
--    if (t0.y==t1.y && t0.y==t2.y) return; // I dont care about degenerate triangles 
--    // sort the vertices, t0, t1, t2 lower−to−upper (bubblesort yay!) 
--    if (t0.y>t1.y) std::swap(t0, t1); 
--    if (t0.y>t2.y) std::swap(t0, t2); 
--    if (t1.y>t2.y) std::swap(t1, t2); 
--    int total_height = t2.y-t0.y; 
--    for (int i=0; i<total_height; i++) { 
--        bool second_half = i>t1.y-t0.y || t1.y==t0.y; 
--        int segment_height = second_half ? t2.y-t1.y : t1.y-t0.y; 
--        float alpha = (float)i/total_height; 
--        float beta  = (float)(i-(second_half ? t1.y-t0.y : 0))/segment_height; // be careful: with above conditions no division by zero here 
--        Vec2i A =               t0 + (t2-t0)*alpha; 
--        Vec2i B = second_half ? t1 + (t2-t1)*beta : t0 + (t1-t0)*beta; 
--        if (A.x>B.x) std::swap(A, B); 
--        for (int j=A.x; j<=B.x; j++) { 
--            image.set(j, t0.y+i, color); // attention, due to int casts t0.y+i != A.y 
--        } 
--    } 
--}


        -- function int_times_real (L: integer; R : real) return integer is
        -- begin
        --     return integer(real(L) * R);
        -- end;

        --package int_la is new linear_algebra (base => integer, scalar => real, "*" => int_times_real);
        --use type int_la.vec;

        --package screen_coords is new Ada.Numerics.Generic_Real_Arrays (float);
        --use screen_coords;