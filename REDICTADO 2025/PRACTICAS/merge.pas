{
El responsable de Sistemas de un negocio con varias sucursales obtiene mensualmente
un archivo binario de cada una de ellas con el registro de facturas de ventas del mes pasado.
Un programa que ya existe extrae de los registros de cada archivo de sucursal el c�digo
de producto, cantidad vendida y precio de venta de cada producto que aparezca en una factura,
dejando esta informaci�n en otro archivo binario por cada sucursal, que luego ordena por
c�digo de producto.
El procedimiento Reporte recibe estos archivos de ventas mensuales ordenadas por producto
(asignados y sin abrir) y, recorri�ndolos una �nica vez, reporta en un archivo de texto
(que tambi�n se recibe asignado y sin abrir) y en una l�nea por cada producto:
el c�digo de producto, la cantidad de unidades vendidas del mismo en cada sucursal
(una columna por sucursal) y el total de pesos obtenido en el mes por ventas de ese producto
(el precio de venta del mismo producto puede variar entre sucursales y entre registros
de la misma sucursal). Se generaliza la soluci�n para 5 sucursales, pero el procedimiento
recibe el n�mero real se sucursales con las que se trabaja. Se codifica tambi�n la funci�n
para obtener el �ndice al m�nimo c�digo de producto.
   
   
}


program untitled;

const
	CGSS=5; //cantidad general de sucursales
	MaxCod=65535; //codigo maximo de producto Inalcanzable

type
	tReg=record
		codProd:word;
		cant:byte;
		pv:real;
	end;
	tArch=file of tReg; // archivo de registros ordenado por codProd y con repeticiones de codProd
	
	tCtrlArch=record  //Control de archivo de sucursal
		a:tArch;
		r:tReg;
		prodActual:word;
	end;
	tCltMerge=record
		crss:1..CGSS; //
		suc:array[1..CGSS] of tCtrlArch;
	end;

procedure Reporte(var ctl:tctlMerge; var ventas:text);

	function min(var ctl:tCtlMerge):byte;
	var 
		m,i:byte; 
	begin 
		m:=1;
		for i:=2 to ctl.crss do 
			if ctl.suc[i].r.codProd<ctl.suc[m].r.codProd then
				m:=i; min:=m;		
	end;
	
	procedure leer(var a:tArch, var r:tReg);
	begin
		if EOF(a) then
			r.codProd=MaxCOd
		else
			read(a,r);
	end;

var 
	s, sm:byte;
	codProdActual:word;
	cant:array[1..CGSS] of word;
	totPesosPA:real; // pesos producto actual
begin //Reporte
	//Inicializacion
	for s:=1 to ctl.crss do 
		with ctl.suc[s] do begin
			reset(a);
			leer(a,r);
			prodActual:=r.codProd;
		end;
	rewrite(ventas);
	for s:=1 to ctl.crss do
		write(ventas,'Suc: ',s:2); //columnas de 6 espacios
	writeln(ventas,'Total pesos: ',);
	sm:=min(ctl);
	
	//PROCESO
	while ctl.suc[sm].r.codProd<> codMax do begin
		//inicializaci�n producto actual
		codProdActual:=ctl.suc[sm].r.codProd; totPesosPA:=0;
		for s:=1 to ctl.crss do 
			with ctl.suc[s] do
				cant[s]:=0;
		while ctl.suc[sm].r.codProd=codProdActual do //ciclo de recorrido con codProdActual
			while ctl.suc[sm].r.codProd=ctl.suc[sm].prodActual do //ciclo de recorrido por sucursal para procesamiento del producto actual
				
		
		end;
		
	
	end; 
end;

begin

end;

	

BEGIN
	
	
END.

