program leer_personas;

type
    persona = record
        dni: string[8];
        apellidoyNombre: string[30];
        direccion: string[40];
        sexo: char;
        salario: real;
    end;
    
    archivo_personas = file of persona;

var
    personas: archivo_personas;
    nombre_fisico: string[12];
    per: persona;
    
begin
    writeln('Ingrese el nombre del archivo a leer: ');
    readln(nombre_fisico);
    
    assign(personas, nombre_fisico);
    reset(personas);  { Abre el archivo para lectura }

    writeln('Contenido del archivo:');
    
    while not eof(personas) do
    begin
        read(personas, per);  { Lee un registro }
        writeln('DNI: ', per.dni);
        writeln('Nombre: ', per.apellidoyNombre);
        writeln('Direccion: ', per.direccion);
        writeln('Sexo: ', per.sexo);
        writeln('Salario: ', per.salario:0:2);
        writeln('-------------------------');
    end;
    
    close(personas);
end.
