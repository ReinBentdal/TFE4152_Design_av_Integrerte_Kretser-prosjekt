// **Custom imports** 
`include "../../../components/gates.lib"

/* Generated by Yosys 0.10.0 (git sha1 UNKNOWN, clang 13.0.0 -fPIC -Os) */

(* dynports =  1  *)
(* hdlname = "\\PIXEL_SENSOR" *)
(* src = "output/pixelArray.v:3.1-27.10" *)
module \$paramod$004a2d6c4d72b173587acaf41269bb48988ab7d5\PIXEL_SENSOR (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA);
  (* src = "output/pixelArray.v:17.27-17.34" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:18.33-18.37" *)
  output [7:0] DATA;
  (* src = "output/pixelArray.v:14.13-14.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:15.13-15.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:13.13-13.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:16.13-16.17" *)
  input READ;
  (* src = "output/pixelArray.v:12.13-12.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:21.6-21.9" *)
  wire cmp;
  (* src = "output/pixelArray.v:23.12-23.18" *)
  wire [7:0] p_data;
  (* src = "output/pixelArray.v:26.2-26.37" *)
  DFF _0_ (
    .C(VBN1),
    .D(VBN1),
    .Q(cmp)
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _1_ (
    .C(cmp),
    .D(COUNTER[0]),
    .Q(p_data[0])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _2_ (
    .C(cmp),
    .D(COUNTER[1]),
    .Q(p_data[1])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _3_ (
    .C(cmp),
    .D(COUNTER[2]),
    .Q(p_data[2])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _4_ (
    .C(cmp),
    .D(COUNTER[3]),
    .Q(p_data[3])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _5_ (
    .C(cmp),
    .D(COUNTER[4]),
    .Q(p_data[4])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _6_ (
    .C(cmp),
    .D(COUNTER[5]),
    .Q(p_data[5])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _7_ (
    .C(cmp),
    .D(COUNTER[6]),
    .Q(p_data[6])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _8_ (
    .C(cmp),
    .D(COUNTER[7]),
    .Q(p_data[7])
  );
  assign DATA = p_data;
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_SENSOR" *)
(* src = "output/pixelArray.v:3.1-27.10" *)
module \$paramod$08fbb61fbeee1479bbddb2440780cddb7817a39f\PIXEL_SENSOR (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA);
  (* src = "output/pixelArray.v:17.27-17.34" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:18.33-18.37" *)
  output [7:0] DATA;
  (* src = "output/pixelArray.v:14.13-14.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:15.13-15.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:13.13-13.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:16.13-16.17" *)
  input READ;
  (* src = "output/pixelArray.v:12.13-12.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:21.6-21.9" *)
  wire cmp;
  (* src = "output/pixelArray.v:23.12-23.18" *)
  wire [7:0] p_data;
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _0_ (
    .C(cmp),
    .D(COUNTER[0]),
    .Q(p_data[0])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _1_ (
    .C(cmp),
    .D(COUNTER[1]),
    .Q(p_data[1])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _2_ (
    .C(cmp),
    .D(COUNTER[2]),
    .Q(p_data[2])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _3_ (
    .C(cmp),
    .D(COUNTER[3]),
    .Q(p_data[3])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _4_ (
    .C(cmp),
    .D(COUNTER[4]),
    .Q(p_data[4])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _5_ (
    .C(cmp),
    .D(COUNTER[5]),
    .Q(p_data[5])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _6_ (
    .C(cmp),
    .D(COUNTER[6]),
    .Q(p_data[6])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _7_ (
    .C(cmp),
    .D(COUNTER[7]),
    .Q(p_data[7])
  );
  (* src = "output/pixelArray.v:26.2-26.37" *)
  DFF _8_ (
    .C(VBN1),
    .D(VBN1),
    .Q(cmp)
  );
  assign DATA = p_data;
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_SENSOR" *)
(* src = "output/pixelArray.v:3.1-27.10" *)
module \$paramod$1850f0e476e36dbff939940fa2bdad9f281d7d2a\PIXEL_SENSOR (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA);
  (* src = "output/pixelArray.v:17.27-17.34" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:18.33-18.37" *)
  output [7:0] DATA;
  (* src = "output/pixelArray.v:14.13-14.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:15.13-15.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:13.13-13.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:16.13-16.17" *)
  input READ;
  (* src = "output/pixelArray.v:12.13-12.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:21.6-21.9" *)
  wire cmp;
  (* src = "output/pixelArray.v:23.12-23.18" *)
  wire [7:0] p_data;
  (* src = "output/pixelArray.v:26.2-26.37" *)
  DFF _0_ (
    .C(VBN1),
    .D(VBN1),
    .Q(cmp)
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _1_ (
    .C(cmp),
    .D(COUNTER[0]),
    .Q(p_data[0])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _2_ (
    .C(cmp),
    .D(COUNTER[1]),
    .Q(p_data[1])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _3_ (
    .C(cmp),
    .D(COUNTER[2]),
    .Q(p_data[2])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _4_ (
    .C(cmp),
    .D(COUNTER[3]),
    .Q(p_data[3])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _5_ (
    .C(cmp),
    .D(COUNTER[4]),
    .Q(p_data[4])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _6_ (
    .C(cmp),
    .D(COUNTER[5]),
    .Q(p_data[5])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _7_ (
    .C(cmp),
    .D(COUNTER[6]),
    .Q(p_data[6])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _8_ (
    .C(cmp),
    .D(COUNTER[7]),
    .Q(p_data[7])
  );
  assign DATA = p_data;
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_SENSOR" *)
(* src = "output/pixelArray.v:3.1-27.10" *)
module \$paramod$203b7c4b259ee952572b87d3e94151b5b02bbd2b\PIXEL_SENSOR (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA);
  (* src = "output/pixelArray.v:17.27-17.34" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:18.33-18.37" *)
  output [7:0] DATA;
  (* src = "output/pixelArray.v:14.13-14.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:15.13-15.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:13.13-13.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:16.13-16.17" *)
  input READ;
  (* src = "output/pixelArray.v:12.13-12.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:21.6-21.9" *)
  wire cmp;
  (* src = "output/pixelArray.v:23.12-23.18" *)
  wire [7:0] p_data;
  (* src = "output/pixelArray.v:26.2-26.37" *)
  DFF _0_ (
    .C(VBN1),
    .D(VBN1),
    .Q(cmp)
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _1_ (
    .C(cmp),
    .D(COUNTER[0]),
    .Q(p_data[0])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _2_ (
    .C(cmp),
    .D(COUNTER[1]),
    .Q(p_data[1])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _3_ (
    .C(cmp),
    .D(COUNTER[2]),
    .Q(p_data[2])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _4_ (
    .C(cmp),
    .D(COUNTER[3]),
    .Q(p_data[3])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _5_ (
    .C(cmp),
    .D(COUNTER[4]),
    .Q(p_data[4])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _6_ (
    .C(cmp),
    .D(COUNTER[5]),
    .Q(p_data[5])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _7_ (
    .C(cmp),
    .D(COUNTER[6]),
    .Q(p_data[6])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _8_ (
    .C(cmp),
    .D(COUNTER[7]),
    .Q(p_data[7])
  );
  assign DATA = p_data;
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_SENSOR" *)
(* src = "output/pixelArray.v:3.1-27.10" *)
module \$paramod$2d7398bc60324bc42c137744e6f1e701f82607bd\PIXEL_SENSOR (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA);
  (* src = "output/pixelArray.v:17.27-17.34" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:18.33-18.37" *)
  output [7:0] DATA;
  (* src = "output/pixelArray.v:14.13-14.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:15.13-15.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:13.13-13.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:16.13-16.17" *)
  input READ;
  (* src = "output/pixelArray.v:12.13-12.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:21.6-21.9" *)
  wire cmp;
  (* src = "output/pixelArray.v:23.12-23.18" *)
  wire [7:0] p_data;
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _0_ (
    .C(cmp),
    .D(COUNTER[0]),
    .Q(p_data[0])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _1_ (
    .C(cmp),
    .D(COUNTER[1]),
    .Q(p_data[1])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _2_ (
    .C(cmp),
    .D(COUNTER[2]),
    .Q(p_data[2])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _3_ (
    .C(cmp),
    .D(COUNTER[3]),
    .Q(p_data[3])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _4_ (
    .C(cmp),
    .D(COUNTER[4]),
    .Q(p_data[4])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _5_ (
    .C(cmp),
    .D(COUNTER[5]),
    .Q(p_data[5])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _6_ (
    .C(cmp),
    .D(COUNTER[6]),
    .Q(p_data[6])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _7_ (
    .C(cmp),
    .D(COUNTER[7]),
    .Q(p_data[7])
  );
  (* src = "output/pixelArray.v:26.2-26.37" *)
  DFF _8_ (
    .C(VBN1),
    .D(VBN1),
    .Q(cmp)
  );
  assign DATA = p_data;
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_SENSOR" *)
(* src = "output/pixelArray.v:3.1-27.10" *)
module \$paramod$3157723d492346a7befead03d9df7a61b9ef7ef2\PIXEL_SENSOR (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA);
  (* src = "output/pixelArray.v:17.27-17.34" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:18.33-18.37" *)
  output [7:0] DATA;
  (* src = "output/pixelArray.v:14.13-14.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:15.13-15.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:13.13-13.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:16.13-16.17" *)
  input READ;
  (* src = "output/pixelArray.v:12.13-12.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:21.6-21.9" *)
  wire cmp;
  (* src = "output/pixelArray.v:23.12-23.18" *)
  wire [7:0] p_data;
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _0_ (
    .C(cmp),
    .D(COUNTER[0]),
    .Q(p_data[0])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _1_ (
    .C(cmp),
    .D(COUNTER[1]),
    .Q(p_data[1])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _2_ (
    .C(cmp),
    .D(COUNTER[2]),
    .Q(p_data[2])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _3_ (
    .C(cmp),
    .D(COUNTER[3]),
    .Q(p_data[3])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _4_ (
    .C(cmp),
    .D(COUNTER[4]),
    .Q(p_data[4])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _5_ (
    .C(cmp),
    .D(COUNTER[5]),
    .Q(p_data[5])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _6_ (
    .C(cmp),
    .D(COUNTER[6]),
    .Q(p_data[6])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _7_ (
    .C(cmp),
    .D(COUNTER[7]),
    .Q(p_data[7])
  );
  (* src = "output/pixelArray.v:26.2-26.37" *)
  DFF _8_ (
    .C(VBN1),
    .D(VBN1),
    .Q(cmp)
  );
  assign DATA = p_data;
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_SENSOR" *)
(* src = "output/pixelArray.v:3.1-27.10" *)
module \$paramod$6b654c3306cca70bce345b07a67a0bfc062f966d\PIXEL_SENSOR (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA);
  (* src = "output/pixelArray.v:17.27-17.34" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:18.33-18.37" *)
  output [7:0] DATA;
  (* src = "output/pixelArray.v:14.13-14.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:15.13-15.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:13.13-13.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:16.13-16.17" *)
  input READ;
  (* src = "output/pixelArray.v:12.13-12.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:21.6-21.9" *)
  wire cmp;
  (* src = "output/pixelArray.v:23.12-23.18" *)
  wire [7:0] p_data;
  (* src = "output/pixelArray.v:26.2-26.37" *)
  DFF _0_ (
    .C(VBN1),
    .D(VBN1),
    .Q(cmp)
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _1_ (
    .C(cmp),
    .D(COUNTER[0]),
    .Q(p_data[0])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _2_ (
    .C(cmp),
    .D(COUNTER[1]),
    .Q(p_data[1])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _3_ (
    .C(cmp),
    .D(COUNTER[2]),
    .Q(p_data[2])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _4_ (
    .C(cmp),
    .D(COUNTER[3]),
    .Q(p_data[3])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _5_ (
    .C(cmp),
    .D(COUNTER[4]),
    .Q(p_data[4])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _6_ (
    .C(cmp),
    .D(COUNTER[5]),
    .Q(p_data[5])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _7_ (
    .C(cmp),
    .D(COUNTER[6]),
    .Q(p_data[6])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _8_ (
    .C(cmp),
    .D(COUNTER[7]),
    .Q(p_data[7])
  );
  assign DATA = p_data;
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_SENSOR" *)
(* src = "output/pixelArray.v:3.1-27.10" *)
module \$paramod$806ef7cc717a19ecafc9b286c8440c49829369ff\PIXEL_SENSOR (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA);
  (* src = "output/pixelArray.v:17.27-17.34" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:18.33-18.37" *)
  output [7:0] DATA;
  (* src = "output/pixelArray.v:14.13-14.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:15.13-15.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:13.13-13.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:16.13-16.17" *)
  input READ;
  (* src = "output/pixelArray.v:12.13-12.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:21.6-21.9" *)
  wire cmp;
  (* src = "output/pixelArray.v:23.12-23.18" *)
  wire [7:0] p_data;
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _0_ (
    .C(cmp),
    .D(COUNTER[0]),
    .Q(p_data[0])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _1_ (
    .C(cmp),
    .D(COUNTER[1]),
    .Q(p_data[1])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _2_ (
    .C(cmp),
    .D(COUNTER[2]),
    .Q(p_data[2])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _3_ (
    .C(cmp),
    .D(COUNTER[3]),
    .Q(p_data[3])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _4_ (
    .C(cmp),
    .D(COUNTER[4]),
    .Q(p_data[4])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _5_ (
    .C(cmp),
    .D(COUNTER[5]),
    .Q(p_data[5])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _6_ (
    .C(cmp),
    .D(COUNTER[6]),
    .Q(p_data[6])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _7_ (
    .C(cmp),
    .D(COUNTER[7]),
    .Q(p_data[7])
  );
  (* src = "output/pixelArray.v:26.2-26.37" *)
  DFF _8_ (
    .C(VBN1),
    .D(VBN1),
    .Q(cmp)
  );
  assign DATA = p_data;
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_SENSOR" *)
(* src = "output/pixelArray.v:3.1-27.10" *)
module \$paramod$c1779105b47a492e95a170d797783cce44f65393\PIXEL_SENSOR (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA);
  (* src = "output/pixelArray.v:17.27-17.34" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:18.33-18.37" *)
  output [7:0] DATA;
  (* src = "output/pixelArray.v:14.13-14.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:15.13-15.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:13.13-13.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:16.13-16.17" *)
  input READ;
  (* src = "output/pixelArray.v:12.13-12.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:21.6-21.9" *)
  wire cmp;
  (* src = "output/pixelArray.v:23.12-23.18" *)
  wire [7:0] p_data;
  (* src = "output/pixelArray.v:26.2-26.37" *)
  DFF _0_ (
    .C(VBN1),
    .D(VBN1),
    .Q(cmp)
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _1_ (
    .C(cmp),
    .D(COUNTER[0]),
    .Q(p_data[0])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _2_ (
    .C(cmp),
    .D(COUNTER[1]),
    .Q(p_data[1])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _3_ (
    .C(cmp),
    .D(COUNTER[2]),
    .Q(p_data[2])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _4_ (
    .C(cmp),
    .D(COUNTER[3]),
    .Q(p_data[3])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _5_ (
    .C(cmp),
    .D(COUNTER[4]),
    .Q(p_data[4])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _6_ (
    .C(cmp),
    .D(COUNTER[5]),
    .Q(p_data[5])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _7_ (
    .C(cmp),
    .D(COUNTER[6]),
    .Q(p_data[6])
  );
  (* src = "output/pixelArray.v:24.2-24.42" *)
  DFF _8_ (
    .C(cmp),
    .D(COUNTER[7]),
    .Q(p_data[7])
  );
  assign DATA = p_data;
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_ROW" *)
(* src = "output/pixelArray.v:29.1-65.10" *)
module \$paramod\PIXEL_ROW\row_index=s32'00000000000000000000000000000000 (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA_OUT);
  (* unused_bits = "0 1 2 3 4" *)
  wire [4:0] _0_;
  (* unused_bits = "0 1 2 3 4" *)
  wire [4:0] _1_;
  (* unused_bits = "0 1 2 3 4" *)
  wire [4:0] _2_;
  (* src = "output/pixelArray.v:43.14-43.21" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:44.55-44.63" *)
  output [8:0] DATA_OUT;
  (* src = "output/pixelArray.v:40.13-40.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:41.13-41.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:39.13-39.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:42.13-42.17" *)
  input READ;
  (* src = "output/pixelArray.v:38.13-38.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:54.6-62.5" *)
  \$paramod$c1779105b47a492e95a170d797783cce44f65393\PIXEL_SENSOR  \genblk1[0].ps  (
    .COUNTER(COUNTER),
    .DATA({ _2_, DATA_OUT[2:0] }),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ),
    .VBN1(VBN1)
  );
  (* src = "output/pixelArray.v:54.6-62.5" *)
  \$paramod$1850f0e476e36dbff939940fa2bdad9f281d7d2a\PIXEL_SENSOR  \genblk1[1].ps  (
    .COUNTER(COUNTER),
    .DATA({ _1_, DATA_OUT[5:3] }),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ),
    .VBN1(VBN1)
  );
  (* src = "output/pixelArray.v:54.6-62.5" *)
  \$paramod$6b654c3306cca70bce345b07a67a0bfc062f966d\PIXEL_SENSOR  \genblk1[2].ps  (
    .COUNTER(COUNTER),
    .DATA({ _0_, DATA_OUT[8:6] }),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ),
    .VBN1(VBN1)
  );
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_ROW" *)
(* src = "output/pixelArray.v:29.1-65.10" *)
module \$paramod\PIXEL_ROW\row_index=s32'00000000000000000000000000000001 (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA_OUT);
  (* unused_bits = "0 1 2 3 4" *)
  wire [4:0] _0_;
  (* unused_bits = "0 1 2 3 4" *)
  wire [4:0] _1_;
  (* unused_bits = "0 1 2 3 4" *)
  wire [4:0] _2_;
  (* src = "output/pixelArray.v:43.14-43.21" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:44.55-44.63" *)
  output [8:0] DATA_OUT;
  (* src = "output/pixelArray.v:40.13-40.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:41.13-41.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:39.13-39.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:42.13-42.17" *)
  input READ;
  (* src = "output/pixelArray.v:38.13-38.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:54.6-62.5" *)
  \$paramod$203b7c4b259ee952572b87d3e94151b5b02bbd2b\PIXEL_SENSOR  \genblk1[0].ps  (
    .COUNTER(COUNTER),
    .DATA({ _2_, DATA_OUT[2:0] }),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ),
    .VBN1(VBN1)
  );
  (* src = "output/pixelArray.v:54.6-62.5" *)
  \$paramod$004a2d6c4d72b173587acaf41269bb48988ab7d5\PIXEL_SENSOR  \genblk1[1].ps  (
    .COUNTER(COUNTER),
    .DATA({ _1_, DATA_OUT[5:3] }),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ),
    .VBN1(VBN1)
  );
  (* src = "output/pixelArray.v:54.6-62.5" *)
  \$paramod$08fbb61fbeee1479bbddb2440780cddb7817a39f\PIXEL_SENSOR  \genblk1[2].ps  (
    .COUNTER(COUNTER),
    .DATA({ _0_, DATA_OUT[8:6] }),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ),
    .VBN1(VBN1)
  );
endmodule

(* dynports =  1  *)
(* hdlname = "\\PIXEL_ROW" *)
(* src = "output/pixelArray.v:29.1-65.10" *)
module \$paramod\PIXEL_ROW\row_index=s32'00000000000000000000000000000010 (VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA_OUT);
  (* unused_bits = "0 1 2 3 4" *)
  wire [4:0] _0_;
  (* unused_bits = "0 1 2 3 4" *)
  wire [4:0] _1_;
  (* unused_bits = "0 1 2 3 4" *)
  wire [4:0] _2_;
  (* src = "output/pixelArray.v:43.14-43.21" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:44.55-44.63" *)
  output [8:0] DATA_OUT;
  (* src = "output/pixelArray.v:40.13-40.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:41.13-41.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:39.13-39.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:42.13-42.17" *)
  input READ;
  (* src = "output/pixelArray.v:38.13-38.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:54.6-62.5" *)
  \$paramod$3157723d492346a7befead03d9df7a61b9ef7ef2\PIXEL_SENSOR  \genblk1[0].ps  (
    .COUNTER(COUNTER),
    .DATA({ _2_, DATA_OUT[2:0] }),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ),
    .VBN1(VBN1)
  );
  (* src = "output/pixelArray.v:54.6-62.5" *)
  \$paramod$2d7398bc60324bc42c137744e6f1e701f82607bd\PIXEL_SENSOR  \genblk1[1].ps  (
    .COUNTER(COUNTER),
    .DATA({ _1_, DATA_OUT[5:3] }),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ),
    .VBN1(VBN1)
  );
  (* src = "output/pixelArray.v:54.6-62.5" *)
  \$paramod$806ef7cc717a19ecafc9b286c8440c49829369ff\PIXEL_SENSOR  \genblk1[2].ps  (
    .COUNTER(COUNTER),
    .DATA({ _0_, DATA_OUT[8:6] }),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ),
    .VBN1(VBN1)
  );
endmodule

(* dynports =  1  *)
(* top =  1  *)
(* src = "output/pixelArray.v:66.1-99.10" *)
module PIXEL_ARRAY(VBN1, RAMP, ERASE, EXPOSE, READ, COUNTER, DATA_OUT);
  (* src = "output/pixelArray.v:80.14-80.21" *)
  input [7:0] COUNTER;
  (* src = "output/pixelArray.v:81.55-81.63" *)
  output [8:0] DATA_OUT;
  (* src = "output/pixelArray.v:77.13-77.18" *)
  input ERASE;
  (* src = "output/pixelArray.v:78.13-78.19" *)
  input EXPOSE;
  (* src = "output/pixelArray.v:76.13-76.17" *)
  input RAMP;
  (* src = "output/pixelArray.v:79.35-79.39" *)
  input [2:0] READ;
  (* src = "output/pixelArray.v:75.13-75.17" *)
  input VBN1;
  (* src = "output/pixelArray.v:88.31-96.5" *)
  \$paramod\PIXEL_ROW\row_index=s32'00000000000000000000000000000000  \genblk1[0].pr  (
    .COUNTER(COUNTER),
    .DATA_OUT(DATA_OUT),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ[0]),
    .VBN1(VBN1)
  );
  (* src = "output/pixelArray.v:88.31-96.5" *)
  \$paramod\PIXEL_ROW\row_index=s32'00000000000000000000000000000001  \genblk1[1].pr  (
    .COUNTER(COUNTER),
    .DATA_OUT(DATA_OUT),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ[1]),
    .VBN1(VBN1)
  );
  (* src = "output/pixelArray.v:88.31-96.5" *)
  \$paramod\PIXEL_ROW\row_index=s32'00000000000000000000000000000010  \genblk1[2].pr  (
    .COUNTER(COUNTER),
    .DATA_OUT(DATA_OUT),
    .ERASE(ERASE),
    .EXPOSE(EXPOSE),
    .RAMP(RAMP),
    .READ(READ[2]),
    .VBN1(VBN1)
  );
endmodule