unit untDM;

interface

uses
  System.SysUtils, System.Classes, Data.DBXFirebird, Data.DB, Data.SqlExpr,
  Data.FMTBcd, Datasnap.DBClient, Datasnap.Provider, Vcl.Dialogs, Vcl.Controls, Vcl.forms;

type
  Tdm = class(TDataModule)
    conn: TSQLConnection;
    qryCombustivel: TSQLQuery;
    dspCombustivel: TDataSetProvider;
    cdsCombustivel: TClientDataSet;
    cdsCombustivelID_COMBUSTIVEL: TIntegerField;
    cdsCombustivelDESCRICAO: TStringField;
    cdsCombustivelVALOR: TFMTBCDField;
    cdsCombustivelIMPOSTO: TFMTBCDField;
    qryTanque: TSQLQuery;
    dspTanque: TDataSetProvider;
    cdsTanque: TClientDataSet;
    cdsTanqueID_TANQUE: TIntegerField;
    cdsTanqueID_COMBUSTIVEL: TIntegerField;
    qryBomba: TSQLQuery;
    dspBomba: TDataSetProvider;
    cdsBomba: TClientDataSet;
    cdsBombaID_BOMBA: TIntegerField;
    cdsBombaID_TANQUE: TIntegerField;
    cdsTanqueCOMBUSTIVEL: TStringField;
    qryAbastecimento: TSQLQuery;
    dspAbastecimento: TDataSetProvider;
    cdsAbastecimento: TClientDataSet;
    cdsAbastecimentoID_ABASTECIMENTO: TIntegerField;
    cdsAbastecimentoID_BOMBA: TIntegerField;
    cdsAbastecimentoDATA: TSQLTimeStampField;
    cdsAbastecimentoQUANTIDADE: TFMTBCDField;
    cdsAbastecimentoVALOR: TFMTBCDField;
    cdsAbastecimentoVALOR_IMPOSTO: TFMTBCDField;
    cdsBombaCOMBUSTIVEL: TStringField;
    cdsTanqueVALOR: TFloatField;
    cdsTanqueIMPOSTO: TFloatField;
    cdsBombaTANQUE: TIntegerField;
    cdsBombaQTDE: TFloatField;
    cdsBombaIMPOSTO: TFloatField;
    cdsBombaTOTAL: TFloatField;
    cdsBombaVALOR_LITRO: TFloatField;
    cdsBombaVALOR: TFloatField;
    cdsBombaTAXA_IMPOSTO: TFloatField;
    qryRelatorio: TSQLQuery;
    dspRelatorio: TDataSetProvider;
    cdsRelatorio: TClientDataSet;
    cdsRelatorioDATA: TSQLTimeStampField;
    cdsRelatorioID_TANQUE: TIntegerField;
    cdsRelatorioID_BOMBA: TIntegerField;
    cdsRelatorioDESCRICAO: TStringField;
    cdsRelatorioQTDE_ABASTECIMENTOS: TIntegerField;
    cdsRelatorioQUANTIDADE_LITROS: TFMTBCDField;
    cdsRelatorioVALOR: TFMTBCDField;
    cdsRelatorioVALOR_IMPOSTO: TFMTBCDField;
    cdsRelatorioVALOR_PAGO: TFloatField;
    procedure cdsCombustivelAfterInsert(DataSet: TDataSet);
    procedure cdsCombustivelBeforeDelete(DataSet: TDataSet);
    procedure cdsTanqueAfterInsert(DataSet: TDataSet);
    procedure cdsTanqueBeforeDelete(DataSet: TDataSet);
    procedure cdsTanqueAfterDelete(DataSet: TDataSet);
    procedure cdsCombustivelAfterDelete(DataSet: TDataSet);
    procedure cdsBombaAfterDelete(DataSet: TDataSet);
    procedure cdsBombaAfterInsert(DataSet: TDataSet);
    procedure cdsBombaBeforeDelete(DataSet: TDataSet);
    procedure cdsAbastecimentoAfterDelete(DataSet: TDataSet);
    procedure cdsAbastecimentoBeforeDelete(DataSet: TDataSet);
    procedure cdsAbastecimentoAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
    procedure confirmaExclusao;
  public
    { Public declarations }
    function salvar(oCds: TClientDataSet): boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure Tdm.cdsAbastecimentoAfterDelete(DataSet: TDataSet);
begin
   salvar(cdsAbastecimento);
end;

procedure Tdm.cdsAbastecimentoAfterInsert(DataSet: TDataSet);
begin
   if(cdsAbastecimento.RecordCount = 0)then
      cdsAbastecimentoID_ABASTECIMENTO.AsInteger :=  1
   else cdsAbastecimentoID_ABASTECIMENTO.AsInteger :=  cdsAbastecimento.Aggregates.Find('seq').Value + 1;
end;

procedure Tdm.cdsAbastecimentoBeforeDelete(DataSet: TDataSet);
begin
   confirmaExclusao();
end;

procedure Tdm.cdsBombaAfterDelete(DataSet: TDataSet);
begin
   salvar(cdsBomba);
end;

procedure Tdm.cdsBombaAfterInsert(DataSet: TDataSet);
begin
   if(cdsBomba.RecordCount = 0)then
      cdsBombaID_BOMBA.AsInteger :=  1
   else cdsBombaID_BOMBA.AsInteger :=  cdsBomba.Aggregates.Find('seq').Value + 1;
end;

procedure Tdm.cdsBombaBeforeDelete(DataSet: TDataSet);
begin
   confirmaExclusao();
end;

procedure Tdm.cdsCombustivelAfterDelete(DataSet: TDataSet);
begin
   salvar(cdsCombustivel);
end;

procedure Tdm.cdsCombustivelAfterInsert(DataSet: TDataSet);
begin
   if(cdsCombustivel.RecordCount = 0)then
      cdsCombustivelID_COMBUSTIVEL.AsInteger :=  1
   else cdsCombustivelID_COMBUSTIVEL.AsInteger :=  cdsCombustivel.Aggregates.Find('seq').Value + 1;
end;

procedure Tdm.cdsCombustivelBeforeDelete(DataSet: TDataSet);
begin
   confirmaExclusao();
end;

procedure Tdm.cdsTanqueAfterDelete(DataSet: TDataSet);
begin
   salvar(cdsTanque);
end;

procedure Tdm.cdsTanqueAfterInsert(DataSet: TDataSet);
begin
   if(cdsTanque.RecordCount = 0)then
      cdsTanqueID_TANQUE.AsInteger :=  1
   else cdsTanqueID_TANQUE.AsInteger :=  cdsTanque.Aggregates.Find('seq').Value + 1;
end;

procedure Tdm.cdsTanqueBeforeDelete(DataSet: TDataSet);
begin
   confirmaExclusao();
end;

procedure Tdm.confirmaExclusao;
begin
   if MessageDlg('Tem certeza que excluir?', mtConfirmation, mbYesNo, 0) <> mrYes then
      abort;
end;

function Tdm.salvar(oCds: TClientDataSet): boolean;
begin
   result := false;
   try
      if oCds.State in [dsInsert, dsEdit] then
         oCds.Post;

      oCds.ApplyUpdates(0);

      result := true;

   except
      on e: Exception do
         MessageDlg('N�o foi poss�vel concluir essa opera��o, motivo: '+e.Message, mtError, [mbOk], 0);
   end;
end;

end.
