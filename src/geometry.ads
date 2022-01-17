-- https://stackoverflow.com/questions/52049531/can-a-record-discriminant-determine-array-lengths-indirectly-in-ada

package geometry is

    type real is delta 0.00001 range -1_000_000.0 .. 1_000_000.0;

    type component_array is array (natural range <>) of real;

    type face_type is (tris_face, quad_face);
    for face_type use (tris_face => 3, quad_face => 4);

    type tris is array (1 .. face_type'enum_rep(tris_face)) of natural;
    type quad is array (1 .. face_type'enum_rep(quad_face)) of natural;

    type tris_array is array (natural range <>) of tris;
    type quad_array is array (natural range <>) of quad;

    type faces (ft : face_type; nf : natural) is record
        case ft is
            when tris_face => 
                tris_indices : tris_array (1 .. nf);
            when quad_face => 
                quad_indices : quad_array (1 .. nf);
        end case;
    end record; 

    type mesh (ft : face_type; nf : natural; nv : natural) is record
        f : faces (ft, nf);
        x : component_array (1 .. nv);
        y : component_array (1 .. nv);
        z : component_array (1 .. nv);
    end record;

end geometry;