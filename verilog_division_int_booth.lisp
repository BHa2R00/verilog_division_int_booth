(defparameter *dw* 16)
(defparameter *hex-f* (with-output-to-string(si)
			   (dotimes (n (/ *dw* 4))
			     (format si "f"))))
(format t 
"module div~A
(//de/ds=q...r
	input wire [~A:0]	de,ds,
	output wire [~A:0]	q,r
);
wire [~A:0]	r0={~A'd0,de};
wire [~A:0]	q0=~A'd0;
wire [~A:0]	ds0={ds,~A'd0};
//booth------------------------------
"
	*dw*
	(- *dw* 1)
	(- *dw* 1)
	(1-(* *dw* 2)) *dw*
	(1- *dw*) *dw*
	(1-(* *dw* 2)) *dw*)
(do ((n 1 (+ n 1))
     (m 0 (+ m 1)))
  ((> n (+ *dw* 1)))
  (format t
"wire [~A:0]	r~A_0=r~A-ds~A;
wire [~A:0]	r~A_n=r~A_0+ds~A;
wire [~A:0]	r~A=r~A_0[~A]?r~A_n:r~A_0;
wire [~A:0]	q~A=r~A_0[~A]?{q~A[~A:0],1'b0}:{q~A[~A:0],1'b1};
wire [~A:0]	ds~A={1'b0,ds~A[~A:1]};
"
	  (1-(* *dw* 2)) n m m
	  (1-(* *dw* 2)) n n m
	  (1-(* *dw* 2)) n n (1-(* *dw* 2)) n n
	  (1- *dw*) n n (1-(* *dw* 2)) m (- *dw* 2) m (- *dw* 2)
	  (1-(* *dw* 2)) n m (1-(* *dw* 2))))
(format t 
"//-----------------------------------
assign	q=(ds==~A'd0)?~A'h~A:
		((de==~A'd0)?~A'd0:
			q~A);
assign	r=(ds==~A'd0)?~A'h~A:
		((de==~A'd0)?~A'd0:
			r~A);
endmodule
"
	*dw* *dw* *hex-f*
	*dw* *dw*
	(1+ *dw*)
	*dw* *dw* *hex-f*
	*dw* *dw*
	(1+ *dw*))
