with ada.text_io;
with Ada.Directories; use Ada.Directories;

with GNAT.Spitbol.Patterns;  

with ada.strings.unbounded;
package body importer is

    procedure get_model_stats (file_path : string; nbr_vertices: out natural; nbr_faces: out natural; face_t: out geometry.face_type) is
    use GNAT.Spitbol.Patterns;
    use ada.text_io;
    input_file : file_type;
    vertex_pattern : pattern := pos(0) & "v ";
    face_pattern : pattern := pos(0) & "f ";

    digs : constant pattern := span("0123456789");
    face_vertex_pattern : constant pattern := digs & "/" & digs & "/" & digs;
    found_face_type : boolean := false;
    nbr_vertex_per_face : natural := 0;

    begin
        nbr_vertices := 0;
        nbr_faces := 0;
        open (input_file, in_file, file_path);
        while not end_of_file (input_file) loop
            declare
            use ada.strings.Unbounded;
                line : string := get_line(input_file);
                vline : VString_Var := to_unbounded_string(line);
            begin
                if match (line, vertex_pattern) then
                    nbr_vertices := nbr_vertices + 1;
                end if;
                if match (line, face_pattern) then
                    if not found_face_type then
                        while match (vline, face_vertex_pattern, "") loop
                            nbr_vertex_per_face := nbr_vertex_per_face + 1;
                        end loop;
                        found_face_type := true;
                    end if;
                    nbr_faces := nbr_faces + 1;
                end if;
            end;
        end loop;
        close (input_file);

        face_t := (if nbr_vertex_per_face = 4 then geometry.quad_face else geometry.tris_face);

        put_line ("nbr vertices: " & nbr_vertices'image);
        put_line ("nbr faces: " & nbr_faces'image);
        put_line ("nbr_vertex_per_face: " & nbr_vertex_per_face'image);
    end;

    procedure fill_mesh (file_path : string; m : in out geometry.mesh) is
        use GNAT.Spitbol.Patterns;
        use ada.text_io;
        input_file : file_type;
        vertex_pattern : pattern := pos(0) & "v ";
        face_pattern : pattern := pos(0) & "f ";
        nbr_vertices : natural := 0;
        nbr_faces : natural := 0;
        face_t : geometry.face_type := m.ft;
    begin
        open (input_file, in_file, file_path);
        while not end_of_file (input_file) loop
            declare
            use ada.strings.Unbounded;
                line : string := get_line(input_file);
                vline : vstring_var := to_unbounded_string(line);
            begin
                if match (vline, vertex_pattern, "") then
                    --Put_Line ("vline: " & vline'image);
                    nbr_vertices := nbr_vertices + 1;
                    declare
                        integ : constant Pattern := Span("-0123456789");
                        frac : constant Pattern := Span("-e0123456789");
                        res : Unbounded_string;
                        real : constant Pattern := (Pos(0) & integ & '.' & frac & Span(' ')) * res;
                        --value : geometry.real;
                    begin
                        for i in 1 .. 3 loop
                            match (vline, real, "");
                            case i is
                                when 1 => m.x (nbr_vertices) := geometry.real'Value(to_string(res));
                                when 2 => m.y (nbr_vertices) := geometry.real'Value(to_string(res));
                                when 3 => m.z (nbr_vertices) := geometry.real'Value(to_string(res));
                            end case;
                            --Put_Line (to_string(res));
                            --value := geometry.real'Value(to_string(res));
                            --Put_Line (value'image);
                            --Put_Line (to_string(res));
                        end loop;
                    end;
                    --Put_Line ("----------------");
                end if;
                if match (vline, face_pattern, "") then
                    nbr_faces := nbr_faces + 1;
                    declare
                        use geometry;
                        res : Unbounded_string;
                        digs : constant pattern := span("0123456789");
                        face_vertex_pattern : constant pattern := (digs & "/" & digs & "/" & digs) * res;
                    begin
                        for i in 1 .. geometry.face_type'enum_rep(face_t) loop
                            match (vline, face_vertex_pattern, "");
                            --put_line (to_String(res));
                            declare
                            
                                vertex_idx : unbounded_string;
                                vertex_idx_pattern : pattern := (Pos(0) & digs) * vertex_idx;
                            begin
                                match (res, vertex_idx_pattern, "");
                                if face_t = geometry.tris_face then
                                    --m.f.tris_indices (i) := natural'value(to_string(vertex_idx));
                                    m.f.tris_indices (nbr_faces)(i) := natural'value(to_string(vertex_idx));
                                else
                                    m.f.quad_indices (nbr_faces)(i) := natural'value(to_string(vertex_idx));
                                end if;
                                --put_line (to_String(vertex_idx));
                            end;
                        end loop;
                    end;
                    --Put_Line ("----------------");
                end if;
            end;
        end loop;
        close (input_file);
    end;

end importer;