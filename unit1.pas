unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MaskEdit, Ordenamiento;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCargarPersona: TButton;
    btnMostrarArchivo: TButton;
    btnMostrarEscalafon: TButton;
    btnAplicarNombre: TButton;
    btnOrdenar: TButton;
    comboSexo: TComboBox;
    comboEscalafon: TComboBox;
    comboFiltrarEscalafon: TComboBox;
    editNombreArchivo: TEdit;
    editNombre: TEdit;
    editApellido: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    maskFNac: TMaskEdit;
    maskSueldo: TMaskEdit;
    memoArchivoCompleto: TMemo;
    memoEscalafon: TMemo;
    procedure btnAplicarNombreClick(Sender: TObject);
    procedure btnCargarPersonaClick(Sender: TObject);
    procedure btnMostrarArchivoClick(Sender: TObject);
    procedure btnMostrarEscalafonClick(Sender: TObject);
    procedure btnOrdenarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;


var
  Form1: TForm1;
  nombreDeArchivo: string;

implementation

//Carga Persona en un archivo .bin, si el archivo no existe, lo crea.
procedure cargarPersona(nombreDelArchivo:string);
var
  archivoPersonas: File of registroPersona;
  registro: registroPersona;
begin
  AssignFile(archivoPersonas, ExtractFilePath(Application.ExeName)+nombreDelArchivo+'.bin');
  if not FileExists(ExtractFilePath(Application.ExeName)+nombreDelArchivo+'.bin') then
     Rewrite(archivoPersonas)
  else
     Reset(archivoPersonas);
  Seek(archivoPersonas,FileSize(archivoPersonas));
  registro.nombre:=Form1.editNombre.Text;
  registro.apellido:=Form1.editApellido.Text;
  registro.fechaNac:=Form1.maskFNac.Text;
  registro.sexo:=Form1.comboSexo.Text[1];
  registro.escalafon:=Form1.comboEscalafon.Text[1];
  registro.sueldo:=StrToFloat(Form1.maskSueldo.Text);
  Write(archivoPersonas, registro);
  CloseFile(archivoPersonas);
end;

//Muestra todas las personas guardadas en el archivo en un Memo
procedure mostrarArchivoEnMemo(nombreDelArchivo:string);
var
  archivoPersonas: File of registroPersona;
  registro: registroPersona;
begin
  if FileExists(ExtractFilePath(Application.ExeName)+nombreDelArchivo+'.bin') then
     begin
      AssignFile(archivoPersonas, ExtractFilePath(Application.ExeName)+nombreDelArchivo+'.bin');
      Reset(archivoPersonas);
      Form1.memoArchivoCompleto.Lines.Clear;
      while not EOF(archivoPersonas) do
            begin
              Read(archivoPersonas,registro);
              Form1.memoArchivoCompleto.lines.add(registro.nombre+' '+
              registro.apellido+' '+registro.fechaNac+' '+registro.sexo+' '+
              registro.escalafon+' '+FloatToStr(registro.sueldo));
            end;
      ShowMessage('Cantidad de personas cargadas: '+IntToStr(FileSize(archivoPersonas)));
      CloseFile(archivoPersonas);
     end
  else
      ShowMessage('El archivo no existe');
end;

//Filtra personas por escalafón y las muestra en un Memo
procedure filtrarPersonasEscalafon(nombreDelArchivo:string;escalafon:Char);
var
  archivoPersonas: File of registroPersona;
  registro: registroPersona;
  contador: integer;
begin
  contador:=0;
  if FileExists(ExtractFilePath(Application.ExeName)+nombreDelArchivo+'.bin') then
     begin
        AssignFile(archivoPersonas, ExtractFilePath(Application.ExeName)+nombreDelArchivo+'.bin');
        Reset(archivoPersonas);
        Form1.memoEscalafon.Lines.Clear;
        while not EOF(archivoPersonas) do
            begin
              Read(archivoPersonas, registro);
              if (registro.escalafon=escalafon) then
                 begin
                   Form1.memoEscalafon.Lines.Add(registro.nombre+' '+
                   registro.apellido+' '+registro.fechaNac+' '+registro.sexo+' '+
                   registro.escalafon+' '+FloatToStr(registro.sueldo));
                   contador:=contador+1;
                 end;
            end;
        ShowMessage('Cantidad de resultados: '+IntToStr(contador));
        CloseFile(archivoPersonas);
     end
  else
      ShowMessage('El archivo no existe');
end;

//Limpia campos de Cargar Persona
procedure limpiarCampos();
begin
  Form1.editNombre.Text:='';
  Form1.editApellido.Text:='';
  Form1.maskFNac.Text:='';
  Form1.maskSueldo.Text:='';
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnCargarPersonaClick(Sender: TObject);
begin
  cargarPersona(nombreDeArchivo);
  limpiarCampos();
end;

procedure TForm1.btnAplicarNombreClick(Sender: TObject);
begin
  nombreDeArchivo:=editNombreArchivo.Text;
end;

procedure TForm1.btnMostrarArchivoClick(Sender: TObject);
begin
  mostrarArchivoEnMemo(nombreDeArchivo);
end;

procedure TForm1.btnMostrarEscalafonClick(Sender: TObject);
begin
  filtrarPersonasEscalafon(nombreDeArchivo, comboFiltrarEscalafon.Text[1]);
end;

procedure TForm1.btnOrdenarClick(Sender: TObject);
begin
  ordenarArchivoBinario(nombreDeArchivo);
  mostrarArchivoEnMemo(nombreDeArchivo);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  nombreDeArchivo:='Personas';
end;

end.

