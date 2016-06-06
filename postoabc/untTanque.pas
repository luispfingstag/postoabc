unit untTanque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Data.FMTBcd, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.DBCtrls, Data.DB, Datasnap.Provider, Datasnap.DBClient,
  Data.SqlExpr, Vcl.DBLookup;

type
  TfrmTanque = class(TForm)
    Image1: TImage;
    pcCadastro: TPageControl;
    tbsLista: TTabSheet;
    tbsCadastro: TTabSheet;
    dbgLista: TDBGrid;
    dsTanque: TDataSource;
    Panel1: TPanel;
    btnInserir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnCancelar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnFechar: TBitBtn;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dsTanqueDataChange(Sender: TObject; Field: TField);
    procedure btnFecharClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure dbgListaDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure tratarBotoes(isEdicao: boolean);
  end;

var
  frmTanque: TfrmTanque;

implementation

{$R *.dfm}

uses untDM;

procedure TfrmTanque.btnAlterarClick(Sender: TObject);
begin
   dm.cdsTanque.Edit;
end;

procedure TfrmTanque.btnCancelarClick(Sender: TObject);
begin
   dm.cdsTanque.CancelUpdates;
end;

procedure TfrmTanque.btnConfirmarClick(Sender: TObject);
begin
   dm.salvar(dm.cdsTanque);

   pcCadastro.ActivePageIndex := 0;
end;

procedure TfrmTanque.btnExcluirClick(Sender: TObject);
begin
   if not dm.cdsBomba.Active then
      dm.cdsBomba.Open;

   if dm.cdsBomba.Locate('ID_TANQUE', dm.cdsTanqueID_TANQUE.AsInteger, []) then
      MessageDlg('Antes de excluir esse Tanque voc� deve desvicul�-lo da Bomba '+dm.cdsBombaID_BOMBA.AsString+'.', mtWarning, [mbOk],0)
   else dm.cdsTanque.Delete;
end;

procedure TfrmTanque.btnFecharClick(Sender: TObject);
begin
   close;
end;

procedure TfrmTanque.btnInserirClick(Sender: TObject);
begin
   dm.cdsTanque.Insert;
end;

procedure TfrmTanque.dbgListaDblClick(Sender: TObject);
begin
   pcCadastro.ActivePageIndex := 1;
end;

procedure TfrmTanque.dsTanqueDataChange(Sender: TObject;
  Field: TField);
begin
   tratarBotoes(dm.cdsTanque.State in [dsEdit, dsInsert]);
end;

procedure TfrmTanque.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   dm.cdsTanque.Close;
end;

procedure TfrmTanque.FormShow(Sender: TObject);
begin
   dm.cdsTanque.Open;

   pcCadastro.ActivePageIndex := 0;
end;

procedure TfrmTanque.tratarBotoes(isEdicao: boolean);
begin

   btnInserir.Enabled := not isEdicao;
   btnAlterar.Enabled := not isEdicao;
   btnExcluir.Enabled := not isEdicao;
   btnConfirmar.Enabled := isEdicao;
   btnCancelar.Enabled := isEdicao;

   if isEdicao then
      pcCadastro.ActivePageIndex := 1
   else pcCadastro.ActivePageIndex := 0;


end;

end.
