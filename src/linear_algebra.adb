with Ada.Numerics.Elementary_Functions;
use  Ada.Numerics.Elementary_Functions;

with Ada.text_io; use ada.text_io;

package body linear_algebra is

    function "+" (left : vec; right : vec) return vec is
        result : vec := left;
    begin
        for i in left'range loop
            result (i) := left (i) + right (i);
        end loop;
        return result;
    end;

    function "-" (left : vec; right : vec) return vec is
        result : vec := left;
        res : base;
    begin
        for i in left'range loop
            result (i) := left (i) - right (i);
        end loop;
        return result;
    end;

    function "*" (left : vec; right : base) return vec is
        result : vec := left;
    begin
        for i in left'range loop
            result (i) := left (i) * right;
        end loop;
        return result;
    end;

    function dot (left: vec; right: vec) return base is
		result : base := 0.0;
	begin
		--if not (left'length = right'length) then raise Constraint_Error; end if;
        --put_line ("---------------");
		for i in left'range loop
            --put_line (left (i)'image & " " & right (i)'image);
			result := result + left (i) * right(i);
            --put_line ("result: " & result'image);
		end loop;
		return result;
	end;

    function cross (a : vec; b : vec) return vec is
        result : vec := a;
    begin
        -- if Left'Length /= Right'Length then
        --     raise Constraint_Error
        --        with "vectors of different size in dot product";
        -- end if;
        -- if left'Length /= 3 then
        --     raise Constraint_Error
        --        with "dot product only implemented for R**3";
        -- end if;
        --put_line (a (0)'image & " " & a (1)'image & " " & a (2)'image);
        --put_line (b (0)'image & " " & b (1)'image & " " & b (2)'image);
        result := (
            a(1)*b(2) - a(2)*b(1), -(a(0)*b(2) - a(2)*b(0)), a(0)*b(1)-a(1)*b(0)
        );
        --    (Left (Left'First + 1) * Right (Right'First + 2) - Left (Left'First + 2) * Right (Right'First + 1),
        --     Left (Left'First + 2) * Right (Right'First) - Left (Left'First) * Right (Right'First + 2),
        --     Left (Left'First) * Right (Right'First + 1) - Left (Left'First + 1) * Right (Right'First));
        --put_line (result (0)'image & " " & result (1)'image & " " & result (2)'image);
        return result;
    end;

    procedure swap (left : in out vec; right : in out vec) is
        tmp : constant vec := left;
    begin
        left := right;
        right := tmp;
    end;

    procedure normalize (v : in out vec) is
        sum : base := 0.0;
        result : base := 0.0;
    begin
        for i in v'range loop
			--sum := sum + float(v (i) * v (i));
            sum := sum + v (i) * v (i);
		end loop;
        sum := base (Sqrt(float(sum)));
		for i in v'range loop
            --result := float(v (i)) / sum;
            v (i) := v (i) / sum;
			--v (i) := base(result);
            --put_line (result'image);
		end loop;
    end;

end linear_algebra;