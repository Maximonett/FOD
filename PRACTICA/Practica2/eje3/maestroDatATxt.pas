{
   DE .DAT a .TXT para probar si se actualiza el maestro
   
   
}


program MaestroBinarioATexto;

type
  cadena = string[30];

  regm = record
    provincia: cadena;
    cant_per_alf: integer;
    total_encu: integer;
  end;

  mae = file of regm;

var
  archivo_bin: mae;
  archivo_txt: text;
  reg: regm;

begin
  assign(archivo_bin, 'maestro.dat');
  assign(archivo_txt, 'maestro.txt');
  reset(archivo_bin);
  rewrite(archivo_txt);

  while not eof(archivo_bin) do
  begin
    read(archivo_bin, reg);
    writeln(archivo_txt, 'Provincia: ', reg.provincia);
    writeln(archivo_txt, '  Alfabetizados: ', reg.cant_per_alf);
    writeln(archivo_txt, '  Encuestados:   ', reg.total_encu);
    writeln(archivo_txt, '-----------------------------');
  end;

  close(archivo_bin);
  close(archivo_txt);
  writeln('Archivo maestro.txt generado correctamente.');
end.

