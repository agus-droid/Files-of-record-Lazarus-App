unit ordenamiento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms;

type

registroPersona = record
    nombre: String[20];
    apellido: String[20];
    fechaNac: String[10];
    sexo: Char;
    escalafon: Char;
    sueldo: real;
  end;

//Arreglo para cargar el archivo en memoria y ordenarlo
arregloPersonas = array[1..1000] of registroPersona;

//Procedimientos y funciones que me interesa exportar
procedure ordenarArchivoBinario(nombreDelArchivo:string);

implementation

//Intercambia dos valores de un arreglo
procedure Intercambia(var a:arregloPersonas;i,j:integer);
var
  temp:registroPersona;
begin
  temp:=a[i];
  a[i]:=a[j];
  a[j]:=temp;
end;

//No se que hace pero funciona
function PosMinimoNombre(var a:arregloPersonas;i,j:integer):integer;
var
   pmin,k:integer;
begin
  pmin:=i;
  for k:=i+1 to j do
      if a[k].nombre < a[pmin].nombre then
         pmin:=k;
  PosMinimoNombre:=pmin;
end;

//Ordena un arreglo
procedure Seleccion(var a:arregloPersonas;prim,ult:integer);
var
   i:integer;
begin
   for i:=prim to ult-1 do
       Intercambia(a,i,PosMinimoNombre(a,i,ult));
end;

//Toma un archivo de registros y mete su contenido en un arreglo
procedure cargarArchivoEnArray(nombreDelArchivo:string;var a:arregloPersonas);
var
  archivoPersonas: File of registroPersona;
  registro: registroPersona;
  i:integer;
begin
  AssignFile(archivoPersonas, ExtractFilePath(Application.ExeName)+nombreDelArchivo+'.bin');
  reset(archivoPersonas);
  i:=0;
  while not EOF(archivoPersonas)do
      begin
        i:=i+1;
        read(archivoPersonas, registro);
        a[i]:=registro;
      end;
  CloseFile(archivoPersonas);
end;

//Toma un arreglo de registros y guarda su contenido en un Archivo de registros
procedure guardarArrayEnArchivo(nombreDelArchivo:string;a:arregloPersonas;Max:integer);
var
  archivoPersonas: File of registroPersona;
  i:integer;
begin
  AssignFile(archivoPersonas, ExtractFilePath(Application.ExeName)+nombreDelArchivo+'.bin');
  Rewrite(archivoPersonas);
  for i:=1 to Max do
      begin
       Write(archivoPersonas, a[i]);
      end;
  CloseFile(archivoPersonas);
end;

//Función que nos devuelve el tamaño de un archivo sin romper el programa
function tamanioArchivo(nombreDelArchivo:string):integer;
var
  archivoPersonas: File of registroPersona;
  tam: integer;
begin
  AssignFile(archivoPersonas, ExtractFilePath(Application.ExeName)+nombreDelArchivo+'.bin');
  Reset(archivoPersonas);
  tam:= FileSize(archivoPersonas);
  CloseFile(archivoPersonas);
  tamanioArchivo:=tam;
end;

//Carga Archivo de registros en memoria, lo ordena y lo vuelve a guardar
procedure ordenarArchivoBinario(nombreDelArchivo:string);
var
  a: arregloPersonas;
  tam: integer;
begin
  a:= Default(arregloPersonas);//Inicializo el arreglo para que no se queje Lazarus
  tam:= tamanioArchivo(nombreDelArchivo);
  cargarArchivoEnArray(nombreDelArchivo, a);
  seleccion(a,1,tam);
  guardarArrayEnArchivo(nombreDelArchivo,a,tam);
end;

end.

