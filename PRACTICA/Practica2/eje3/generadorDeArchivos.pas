{
   Generador de detalle1.dat detalle2.dat y maestro.dat
   
}


program CrearArchivos;

type
  cadena = string[30];

  regm = record
    provincia: cadena;
    cant_per_alf: integer;
    total_encu: integer;
  end;

  regd = record
    provincia: cadena;
    codL: integer;
    cant_per_alf: integer;
    cant_encu: integer;
  end;

  mae = file of regm;
  det = file of regd;

var
  maestro: mae;
  detalle1, detalle2: det;
  reg_m: regm;
  reg_d: regd;

begin
  // Crear archivo maestro
  assign(maestro, 'maestro.dat');
  rewrite(maestro);

  reg_m.provincia := 'Buenos Aires';
  reg_m.cant_per_alf := 500;
  reg_m.total_encu := 600;
  write(maestro, reg_m);

  reg_m.provincia := 'Cordoba';
  reg_m.cant_per_alf := 300;
  reg_m.total_encu := 400;
  write(maestro, reg_m);

  reg_m.provincia := 'Santa Fe';
  reg_m.cant_per_alf := 200;
  reg_m.total_encu := 300;
  write(maestro, reg_m);

  close(maestro);

  // Crear archivo detalle1
  assign(detalle1, 'detalle1.dat');
  rewrite(detalle1);

  reg_d.provincia := 'Buenos Aires';
  reg_d.codL := 101;
  reg_d.cant_per_alf := 100;
  reg_d.cant_encu := 60;
  write(detalle1, reg_d);

  reg_d.provincia := 'Cordoba';
  reg_d.codL := 201;
  reg_d.cant_per_alf := 40;
  reg_d.cant_encu := 34;
  write(detalle1, reg_d);

  close(detalle1);

  // Crear archivo detalle2
  assign(detalle2, 'detalle2.dat');
  rewrite(detalle2);

  reg_d.provincia := 'Buenos Aires';
  reg_d.codL := 102;
  reg_d.cant_per_alf := 30;
  reg_d.cant_encu := 70;
  write(detalle2, reg_d);

  reg_d.provincia := 'Santa Fe';
  reg_d.codL := 301;
  reg_d.cant_per_alf := 25;
  reg_d.cant_encu := 30;
  write(detalle2, reg_d);

  close(detalle2);

  writeln('Archivos maestro, detalle1 y detalle2 generados correctamente.');
end.


