program ejemplo1;

type
	persona= record
		dni:string[8];
		apellidoyNombre:string[30];
		direccion:string[40];
		sexo:char;
		salario:real;
	end;
	
	archivo_personas=file of persona;
	
var
	personas:archivo_personas;
	nombre_fisico:string[12];
	per:persona;
	
begin
	writeln('Ingrese el nombre del archivo: '); {puede ser un archivo.dat o .bin o etc......}
	readln(nombre_fisico);
	
	{enlace entre el nombre logico y el nombre fisico}
	
	
	assign (personas,nombre_fisico);
	
	{apertura del archivo para creacion}
	
	rewrite(personas); {en este caso debemos crear el archivo si solo lo queremos abrir usamos RESET}
	
	{LECTURA DEL DNI UNA PERSONA}
	writeln('Ingrese el Nº DNI o dejelo en blanco y aprete enter para salir: ');
	readln(per.dni);
	while (per.dni<>'') do begin
		{lectura del resto de los datos }
		writeln('Apellido y Nombre: ');
		readln(per.apellidoyNombre);
		writeln('Direccion: ');
		readln(per.direccion);
		writeln('GENERO M/F/LGBT');
		readln(per.sexo);
		writeln('Salario: ');
		readln(per.salario);
		
		{Escritura del registro de la persona en el archivo }
		
		write(personas,per);
		
		{Lectura del DNI de una nueva persona }
		writeln('Ingre el Nº de DNI');
		readln(per.dni);
	end;
	
	{Cierre del archivo}
	close(personas);
	
end.

	
	

