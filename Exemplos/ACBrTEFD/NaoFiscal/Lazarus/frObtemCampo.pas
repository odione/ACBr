{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

unit frObtemCampo; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, 
  Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, ExtCtrls;

type

{$R *.lfm}

  TTipoCampo = (tcoString, tcoNumeric, tcoCurrency, tcoAlfa, tcoAlfaNum) ;

{ TFormObtemCampo }

  TFormObtemCampo = class(TForm)
    btOk : TBitBtn;
    btCancel : TBitBtn;
    btVoltar: TBitBtn;
    edtResposta : TEdit;
    pTitulo : TPanel;
    procedure edtRespostaChange(Sender: TObject);
    procedure edtRespostaKeyPress(Sender : TObject; var Key : char);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormCreate(Sender : TObject);
    procedure FormShow(Sender : TObject);
  private
    { private declarations }
    fMascara: String;
    FTamanhoMaximo: Integer;
    FTamanhoMinimo: Integer;
    fTipoCampo: TTipoCampo;
    function GetOcultar: Boolean;
    function GetResposta: String;
    function GetTitulo: String;
    procedure SetMascara(AValue: String);
    procedure SetOcultar(AValue: Boolean);
    procedure SetResposta(AValue: String);
    procedure SetTitulo(AValue: String);
  public
    { public declarations }
    property TipoCampo: TTipoCampo read fTipoCampo write FTipoCampo;
    property TamanhoMinimo: Integer read FTamanhoMinimo write FTamanhoMinimo;
    property TamanhoMaximo: Integer read FTamanhoMaximo write FTamanhoMaximo;
    property Mascara: String read fMascara write SetMascara;
    property Titulo: String read GetTitulo write SetTitulo;
    property Resposta: String read GetResposta write SetResposta;
    property Ocultar: Boolean read GetOcultar write SetOcultar;
  end;

implementation

uses
  ACBrConsts, ACBrUtil, ACBrValidador;

{ TFormObtemCampo }

procedure TFormObtemCampo.FormCreate(Sender : TObject);
begin
  fTamanhoMinimo := 0;
  fTamanhoMaximo := 0;
  fTipoCampo := tcoString;
  fMascara := '';
end;

procedure TFormObtemCampo.FormShow(Sender : TObject);
begin
   if (fTipoCampo = tcoCurrency) then
   begin
     edtResposta.AutoSelect := False;
     edtResposta.Text := 'R$ 0,00';
     edtResposta.SelStart := Length(edtResposta.Text);
   end
   else
     edtResposta.SetFocus;
end;

procedure TFormObtemCampo.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  if (ModalResult = mrOK) then
  begin
    if (TamanhoMinimo > 0) and (Length(Resposta) < TamanhoMinimo) then
    begin
      ShowMessage('O Tamanho Mínimo para este campo e: '+IntToStr(TamanhoMinimo) );
      CanClose := False;
      edtResposta.SetFocus;
    end
    else if (TamanhoMaximo > 0) and (Length(Resposta) > TamanhoMaximo) then
    begin
      ShowMessage('O Tamanho Maximo para este campo e: '+IntToStr(TamanhoMaximo) );
      CanClose := False;
      edtResposta.SetFocus;
    end
  end;
end;

procedure TFormObtemCampo.edtRespostaKeyPress(Sender : TObject; var Key : char);
var
  Ok: Boolean;
begin
   if (Key in [#13,#8]) then  { Enter e BackSpace, OK }
     Exit;

   case fTipoCampo of
     tcoNumeric, tcoCurrency:
       Ok := CharIsNum(Key);

     tcoAlfa:
     begin
       Key := upcase(Key);
       Ok := CharIsAlpha(Key);
     end;

     tcoAlfaNum:
     begin
       Ok := CharIsNum(Key);
       if not Ok then
       begin
         Key := upcase(Key);
         Ok := CharIsAlpha(Key);
       end;
     end;

   else
     Ok := True;
   end;

   if (not Ok) then
   begin
     Key := #0;
     Exit;
   end;

   if (TamanhoMaximo > 0) and (Length(Resposta) >= TamanhoMaximo) then
     Key := #0;
end;

procedure TFormObtemCampo.edtRespostaChange(Sender: TObject);
var
  AValor: Int64;
begin
  if (TipoCampo = tcoCurrency) then
  begin
    AValor := StrToIntDef(OnlyNumber(edtResposta.Text), 0);
    edtResposta.Text := 'R$ '+FormatFloatBr(AValor/100);
    edtResposta.SelStart := Length(edtResposta.Text);
  end
  else if (fMascara <> '') then
  begin
    edtResposta.Text := FormatarMascaraDinamica( RemoverMascara(edtResposta.Text, fMascara), fMascara);
    edtResposta.SelStart := Length(edtResposta.Text);
  end;
end;

function TFormObtemCampo.GetResposta: String;
var
  AValor: Int64;
begin
  if (TipoCampo = tcoCurrency) then
  begin
    AValor := StrToIntDef(OnlyNumber(edtResposta.Text), 0);
    Result := FloatToString(AValor/100, '.', '0.00');
  end
  else if (fMascara <> '') then
    Result := ACBrValidador.RemoverMascara(edtResposta.Text, fMascara)
  else
    Result := edtResposta.Text;
end;

procedure TFormObtemCampo.SetResposta(AValue: String);
begin
  edtResposta.Text := AValue;
end;

function TFormObtemCampo.GetTitulo: String;
begin
  Result := pTitulo.Caption;
end;

procedure TFormObtemCampo.SetTitulo(AValue: String);
var
  NumLin, AltLin: Integer;
begin
  pTitulo.Caption := AValue;

  // Se houver quebra de linhas na msg, aumente o formulário...
  NumLin := CountStr(AValue, CR);
  if (NumLin > 0) then
  begin
    AltLin := pTitulo.Canvas.GetTextHeight('H');
    Height := Height + (NumLin * AltLin);
  end;
end;

procedure TFormObtemCampo.SetMascara(AValue: String);
begin
  if fMascara = AValue then
    Exit;

  fMascara := StringReplace(AValue, '@', '*', [rfReplaceAll]);
end;

function TFormObtemCampo.GetOcultar: Boolean;
begin
  Result := (edtResposta.PasswordChar <> #0);
end;


procedure TFormObtemCampo.SetOcultar(AValue: Boolean);
begin
  if AValue then
    edtResposta.PasswordChar := '*'
  else
    edtResposta.PasswordChar := #0;
end;

end.
