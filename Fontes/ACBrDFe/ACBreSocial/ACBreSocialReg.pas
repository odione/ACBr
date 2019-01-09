{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
******************************************************************************}

{$I ACBr.inc}

unit ACBreSocialReg;

interface

uses
 SysUtils, Classes,
  {$IFDEF VisualCLX} QDialogs {$ELSE} Dialogs {$ENDIF},
  {$IFDEF FPC}
     LResources, LazarusPackageIntf, PropEdits, componenteditors,
  {$ELSE}
    {$IFNDEF COMPILER6_UP}
       DsgnIntf,
    {$ELSE}
       DesignIntf,
       DesignEditors,
    {$ENDIF}
  {$ENDIF}
 ACBreSocial;

procedure Register;

implementation

uses
 ACBreSocialConfiguracoes, ACBrDFeConfiguracoes, ACBrReg, ACBrDFeRegUtil;
{$IFNDEF FPC}
   {$R ACBreSocial.dcr}
{$ENDIF}

procedure Register;
begin
 RegisterComponents('ACBreSocial', [TACBreSocial]);

  RegisterPropertyEditor(TypeInfo(TCertificadosConf), TConfiguracoeseSocial, 'Certificados',
    TClassProperty);

  RegisterPropertyEditor(TypeInfo(TConfiguracoeseSocial), TACBreSocial, 'Configuracoes',
    TClassProperty);

  RegisterPropertyEditor(TypeInfo(TWebServicesConf), TConfiguracoeseSocial, 'WebServices',
    TClassProperty);

  RegisterPropertyEditor(TypeInfo(String), TWebServicesConf, 'UF',
     TACBrUFProperty);

  RegisterPropertyEditor(TypeInfo(TGeralConf), TConfiguracoeseSocial, 'Geral',
    TClassProperty);

  RegisterPropertyEditor(TypeInfo(String), TGeralConf, 'PathSalvar',
     TACBrDirProperty);

  RegisterPropertyEditor(TypeInfo(TArquivosConf), TConfiguracoeseSocial, 'Arquivos',
    TClassProperty);
end;

{$ifdef FPC}
initialization
   {$i ACBreSocial.lrs}
{$endif}

end.
