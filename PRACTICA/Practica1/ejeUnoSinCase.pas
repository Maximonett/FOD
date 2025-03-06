{1. Realizar un algoritmo que cree un archivo de números 
enteros no ordenados y permita incorporar datos al archivo. 
Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. 
La carga finaliza cuando se ingrese el número 30000, que no debe 
incorporarse al archivo.}

program eje1;

type
    tEntero = integer;
    archivo_numeros = file of tEntero;

var
    numeros: archivo_numeros;
    nombre_fisico: string[12];
    num: tEntero;

begin
	
    writeln('Ingrese el nombre del archivo a crear: ');
    readln(nombre_fisico);
    
    assign(numeros, nombre_fisico);
    rewrite(numeros); { Crea el archivo binario }

    writeln('Ingrese números enteros (finaliza con 30000):');
    
    repeat
        readln(num);
        if num <> 30000 then
            write(numeros, num); { Guarda el número en el archivo }
    until num = 30000;

    close(numeros); { Cierra el archivo }

    writeln('Archivo creado correctamente.');
end.
