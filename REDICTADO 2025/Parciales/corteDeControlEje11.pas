{
   11. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:
Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división:
____
Monto total por división:
____
División
.................
Total horas departamento:
____
Monto total departamento:
____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.
   
   
}


program corteDeControlEje11;

const
	va=9999;
	nombre_archivo='horasExtra.txt';
type
	//departamento,división, número de empleado, categoría y cantidad de horas extras
	empleado=record
		departamento:integer; //1er orden
		division:integer; //2do orden
		numeroE:integer; //3er orden
		categoria:integer;
		cantHorasExt:integer;
	end;
	
	maestro=file of empleado;
	
	arreglo=array[1..15] of real;
	

procedure leer(var mae:maestro; var reg:empleado);
begin
	if not(eof(mae)) then
		read(mae,reg)
	else
		reg.departamento:=va;
end;

procedure cargarArreglo(var vect:arreglo);
var
	archivo:text;
	categoria:integer;
	valorHora:real;
	i:integer;
begin
	assign(archivo,nombre_archivo);
	reset(archivo);
	//inicializar arreglo
	for i:=1 to 15 do begin
		vect[i]:=0;
	end;
	
	while not eof(archivo) do begin
		readln(archivo,categoria,valorHora);
		if (categoria>=1)and (categoria<=15) then
			vect[categoria]:=valorHora
		else
			writeln('error!!! ');
	end;
	close(archivo);
	writeln('carga finalizada');	
end;
procedure informe(var mae:maestro);
var
	reg,act:empleado;
	totalHorasEmpleado,totalHorasDivision, totalHorasDepartamento:integer;
	montoEmpleado,montoXDivision, montoXDepartamento:real;
	vect:arreglo;
begin
	cargarArreglo(vect);
	reset(mae);
	leer(mae,reg);
	while(reg.departamento<>va)do begin
		act.departamento:=reg.departamento;
		totalHorasDepartamento:=0;
		montoXDepartamento:=0;
		writeln('Departamento: ',act.departamento);
		while (reg.departamento=act.departamento) do begin
			act.division:=reg.division;
			totalHorasDivision:=0;
			montoXDivision:=0;
			writeln('Division: ',act.division);
			while (reg.departamento=act.departamento)and(reg.division=act.division) do begin
				act.numeroE:=reg.numeroE;
				act.categoria:=reg.categoria;
				totalHorasEmpleado:=0;
				while (reg.departamento=act.departamento)and(reg.division=act.division)and(reg.numeroE=act.numeroE) do begin
					totalHorasEmpleado:=totalHorasEmpleado+reg.cantHorasExt;
					leer(mae,reg);
				end;
				montoEmpleado:=totalHorasEmpleado*vect[act.categoria];
				
				writeln('Numero de Empleado: ',act.numeroE,'Total de Horas: ',totalHorasEmpleado);
				writeln('Importe a cobrar: ',montoEmpleado);
				totalHorasDivision:=totalHorasDivision+totalHorasEmpleado;
				montoXDivision:=montoXDivision+montoEmpleado;
			end;
			writeln('Total horas por division: ',totalHorasDivision);
			writeln('Monto Total por division: ',montoXDivision);
			totalHorasDepartamento:=totalHorasDepartamento+totalHorasDivision;
			montoXDepartamento:=montoXDepartamento+montoXDivision;
		end;
		writeln('Total horas por Departamento: ',totalHorasDepartamento);
		writeln('Monto total por Departamento: ',montoXDepartamento);
	end;
	close(mae);
	
end;	

var
	mae:maestro;
BEGIN
	informe(mae);
	
END.

