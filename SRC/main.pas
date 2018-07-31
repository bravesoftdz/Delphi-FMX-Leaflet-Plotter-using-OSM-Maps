unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.WebBrowser, FMX.Layouts, FMX.Controls.Presentation, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Memo , SG.Scriptgate
    {$IFDEF MSWINDOWS}
  ,System.Win.Registry, FMX.TabControl
  {$ENDIF}
   ;

type
  TForm4 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    Layout1: TLayout;
    WebBrowser1: TWebBrowser;
    Splitter1: TSplitter;
    Layout2: TLayout;
    Button1: TButton;
    Label2: TLabel;
    Memo1: TMemo;
    btnedit: TButton;
    StyleBook1: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btneditClick(Sender: TObject);
    private
  FScriptgate:TScriptgate;
       {$IFDEF MSWINDOWS}
    procedure SetPermissions;
     {$ENDIF}
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}


{$IFDEF MSWINDOWS}
procedure Tform4.SetPermissions;
const
  cHomePath = 'SOFTWARE';
  cFeatureBrowserEmulation =
    'Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION\';
  cIE11 = 11001;

var
  Reg: TRegIniFile;
  sKey: string;
begin

  sKey := ExtractFileName(ParamStr(0));
  Reg := TRegIniFile.Create(cHomePath);
  try
    if Reg.OpenKey(cFeatureBrowserEmulation, True) and
      not(TRegistry(Reg).KeyExists(sKey) and (TRegistry(Reg).ReadInteger(sKey)
      = cIE11)) then
      TRegistry(Reg).WriteInteger(sKey, cIE11);
  finally
    Reg.Free;
  end;
 {$ENDIF}
  end;


procedure TForm4.btneditClick(Sender: TObject);
begin
if btnedit.text = 'Read Only' then
begin
FScriptGate.CallScript('toggle("read")',
procedure(const iResult:string)
begin
  btnedit.Text:= iResult;
end
);
 end
 else
if btnedit.text = 'Editing' then
begin
FScriptGate.CallScript('toggle("edit")',
procedure(const iResult:string)
begin
   btnedit.Text:= iResult;
end
);
end;
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
FScriptGate.CallScript('getpoints()',
 procedure(const iResult:string)
begin
  memo1.Text:= iResult;
end
);
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  SetPermissions;
{$ENDIF}

//load the javascript pdfviewer
WebBrowser1.URL := 'file://' + GetCurrentDir +
  '/../../plotter.html';

   btnedit.text := 'Read Only'   ;
   Fscriptgate:= TScriptgate.create(self,Webbrowser1,'yourorgScheme');
 end;

end.
