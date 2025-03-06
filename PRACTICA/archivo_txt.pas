program ejemploTxtBinario;

type
    tRegistroVotos = record
        codProv: integer;
        codLoc: integer;
        nroMesa: integer;
        cantVotos: integer;
        desc: string[50]; { Tamaño fijo de la cadena }
    end;

    tArchVotos = file of tRegistroVotos;

var
    opc: byte;
    nomArch, nomArch2: string;
    arch: tArchVotos;
    carga: Text;
    votos: tRegistroVotos;

begin
    writeln('VOTOS');
    writeln;
    writeln('0. Terminar el Programa');
    writeln('1. Crear un archivo binario desde un archivo de texto');
    writeln('2. Abrir un archivo binario y exportar a texto');

    repeat
        writeln('Ingrese el numero de opcion: ');
        readln(opc);
        
        if (opc = 1) or (opc = 2) then begin
            writeln;
            write('Nombre del archivo binario: ');
            readln(nomArch);
            assign(arch, nomArch);
        end;

        case opc of
            1: begin
                write('Nombre del archivo de carga (texto): ');
                readln(nomArch2);
                assign(carga, nomArch2);
                reset(carga); { Abre el archivo de texto }
                rewrite(arch); { Crea el archivo binario }

                while (not eof(carga)) do begin
                    with votos do begin
                        readln(carga, codProv, codLoc, nroMesa, cantVotos);
                        readln(carga, desc); { La descripción se lee en una línea separada }
                    end;
                    write(arch, votos); { Escribe en binario }
                end;

                writeln('Archivo binario generado correctamente.');
                close(arch);
                close(carga);
            end;

            2: begin
                write('Nombre del archivo de salida (texto): ');
                readln(nomArch2);
                assign(carga, nomArch2);
                reset(arch); { Abre el archivo binario }
                rewrite(carga); { Crea el archivo de texto }

                while not eof(arch) do begin
                    read(arch, votos);
                    with votos do begin
                        writeln(codProv:5, codLoc:5, nroMesa:5, cantVotos:5, ' ', desc); { Muestra en pantalla }
                        writeln(carga, codProv, ' ', codLoc, ' ', nroMesa, ' ', cantVotos, ' ', desc); { Guarda en el archivo de texto }
                    end;
                end;

                writeln('Archivo exportado a texto correctamente.');
                close(arch);
                close(carga);
            end;
        end;
    until opc = 0;
    
    writeln('Programa finalizado.');
end.
