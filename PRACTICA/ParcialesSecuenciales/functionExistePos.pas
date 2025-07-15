{
   EXISTE EMPLEADO CON posicion en el archivo
   
   
}


program existe;

type

	cadena=string[30];
	empleado=record
		numero:integer;
		nombre:cadena;
	end;
	archivo=file of empleado;
	
function ExisteEmpleado(var a:archivo; var num:integer):integer;
var
	e:empleado;
begin
	reset(a);
	ExisteEmpleado:=-1;
	while not eof(a) do begin
		read(a,e);
		if (e.numero=num) then begin
			ExisteEmpleado:=filepos(a);
			close(a);
			exit;
		end;
	end;
	close(a);
	if(ExisteEmpleado=-1) then
		writeln('El empleado no se ha encontrado');
end;
		
	



BEGIN
	
	
END.

