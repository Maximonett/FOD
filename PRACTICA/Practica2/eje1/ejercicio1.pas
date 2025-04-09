{
   Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.
   
   
}


program ejercicio1;

const
  valorAlto = 9999;

type
  empleado = record
    cod: integer;
    nombre: string[30];
    monto: real;
  end;

  archivo_empleados = file of empleado;

var
  arch_in, arch_out: archivo_empleados;
  emp_actual, emp_leido: empleado;
  total: real;

procedure crearArchivoTextoDesdebin;
var 
	txt:Text;
	bin:file of empleado;
	e:empleado;
begin
	assign(bin,'comisiones_compactado.dat');
	reset(bin);
	
	assign(txt,'comisiones_compactado.txt');
	rewrite(txt);
	
	while not eof(bin) do begin
		read(bin,e);
		writeln(txt,e.cod,' ',e.nombre,' ',e.monto:0:2);
	end;
	close(bin);
	close(txt);
	write('Archivo de texto "comisiones_compactado.txt" creado exitosamente.');
end;


procedure crearArchivoBinarioDesdeTexto;
var
	txt:Text;
	bin:file of empleado;
	e:empleado;
begin
	assign(txt,'empleados.txt');
	Reset(txt);
	
	assign(bin,'comisiones.dat');
	Rewrite(bin);
	while not eof(txt) do begin
		Readln(txt,e.cod,e.nombre,e.monto);
		write(bin,e);
	end;
	close(txt);
	close(bin);
	
	writeln('Archivo binario comisiones.dat creado correctamente.');
end;


procedure leer(var arch: archivo_empleados; var e: empleado);
begin
  if not eof(arch) then
    read(arch, e)
  else
    e.cod := valorAlto;
end;

begin
	crearArchivoBinarioDesdeTexto;
	
	assign(arch_in, 'comisiones.dat');
	reset(arch_in);

	assign(arch_out, 'comisiones_compactado.dat');
	rewrite(arch_out);

	leer(arch_in, emp_leido);

	while emp_leido.cod <> valorAlto do
	begin
		emp_actual := emp_leido;
		total := 0;

		while (emp_leido.cod <> valorAlto) and (emp_leido.cod = emp_actual.cod) do
		begin
			total := total + emp_leido.monto;
			leer(arch_in, emp_leido);
			

		end;

		emp_actual.monto := total;
		
		write(arch_out, emp_actual);
	end;

	close(arch_in);
	close(arch_out);

	writeln('Archivo compactado exitosamente.');
	
	crearArchivoTextoDesdebin;
end.
