unit FSelItemPedCompraRealizada;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, Buttons, rxToolEdit, rxCurrEdit, cProduto, cDataModule, cControle, cEstoque,
  cPedidoDeCompra, cItemDePedido;

type
  TFrmSelItemPedCompraRealizada = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox3: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox4: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    CurrencyEdit2: TCurrencyEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    BitBtn4: TBitBtn;
    CurrencyEdit1: TCurrencyEdit;
    Label6: TLabel;
    Edit6: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Procedure ListarCatg;
    procedure ListarProdPorCatg;
    procedure ComboBox1Change(Sender: TObject);
    procedure ClearBox;
    procedure Habilitar;
    procedure ComboBox2Change(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure GerarMaxCod;
    procedure FormShow(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    PodeFechar : Boolean;
    { Private declarations }
  public                                                    
    { Public declarations }
  end;

var
  FrmSelItemPedCompraRealizada : TFrmSelItemPedCompraRealizada;

implementation

uses
    FTelaCompraRealizada;

{$R *.dfm}

procedure TFrmSelItemPedCompraRealizada.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    FrmTelaCompraRealizada.Enabled := true;
    self.ClearBox;
end;

procedure TFrmSelItemPedCompraRealizada.ListarProdPorCatg;
var
    DM : TDM;
    Prod : Produto;
    Ct  : Controle;
Begin
    try
        DM   := TDM.create (NIL);
        Prod := Produto.Create(0,'',0,'','','');
        Ct   := Controle.Create(DM, Prod);

        Prod.setcatProd(self.Combobox1.Text);
        Ct.ListarProd;

        While (NOT DM.ZQuery1.EOF) do
        begin
            Prod.setnomeProd(DM.ZQuery1.FieldByName('nomeProd').AsString);
            self.Combobox2.Items.Add(Prod.getnomeProd);
            DM.ZQuery1.Next;
        end;
    Except
       MessageDlg('Problema na Listagem das categorias de produtos.', mtError, [mbOk], 0);
    end;
end;

Procedure TFrmSelItemPedCompraRealizada.ListarCatg;
var
    DM   : TDM;
    Prod : Produto;
    Ct   : Controle;
Begin
    try
        DM   := TDM.create (NIL);
        Prod := Produto.Create(0,'',0,'','','');
        Ct   := Controle.Create(DM, Prod);
        Ct.ListarCat;

        While (NOT DM.ZQuery1.EOF) do
        begin
            Prod.setcatProd(DM.ZQuery1.FieldByName('catProd').AsString);
            self.Combobox1.Items.Add(Prod.getcatProd);
            DM.ZQuery1.Next;
        end;

    Except
       MessageDlg('Problema na Listagem das categorias de produtos.', mtError, [mbOk], 0);
    end;
end;

procedure TFrmSelItemPedCompraRealizada.GerarMaxCod;
var
    DM  : TDM;
    Ct  : Controle;
    res : integer;
begin
    try
        DM := TDM.Create(NIL);
        Ct := Controle.Create(DM);
        res := Ct.GerarMaxItemPed;
        self.Edit4.text := IntToStr(res + 1);    //atribuindo o c�digo de compra para inclus�o.
   except
       MessageDlg('Problema na Gera��o do C�digo do Item de Pedido.', mtError, [mbOk], 0);
   end;

end;

procedure TFrmSelItemPedCompraRealizada.ComboBox1Change(Sender: TObject);
begin
    self.ComboBox2.Clear;
    self.ListarProdPorCatg;
    self.ComboBox2.Enabled := true;
end;

procedure TFrmSelItemPedCompraRealizada.ClearBox;
begin
    self.Edit6.Text := '0';
    self.ComboBox1.Clear;
    self.ComboBox2.Clear;
    self.Edit6.Enabled := false;
    self.Edit1.Clear;
    self.Edit1.Enabled := false;
    self.Edit2.Clear;
    self.Edit2.Enabled := false;
    self.CurrencyEdit1.Text := '0';
    self.CurrencyEdit1.Enabled := false;
    self.CurrencyEdit2.Text := '0';
    self.CurrencyEdit2.Enabled := false;
    self.BitBtn1.Enabled := false;
    self.BitBtn4.Enabled := false;
end;

procedure TFrmSelItemPedCompraRealizada.Habilitar;
begin
    self.Edit1.Enabled := true;
    self.Edit2.Enabled := true;
    self.Edit6.Enabled := true;
    self.CurrencyEdit2.Enabled := true;
    self.BitBtn4.Enabled := true;
end;


procedure TFrmSelItemPedCompraRealizada.ComboBox2Change(Sender: TObject);
var
    Prod : Produto;
    DM   : TDM;
    Ct   : Controle;
    Estq : Estoque;
begin
    try
        if (Combobox2.Text <> '') then
        begin
            FrmTelaCompraRealizada.DBGrid1.Enabled := true;
            self.Habilitar;
            self.CurrencyEdit1.Enabled := true;
            DM   := TDM.Create(NIL);
            Prod := Produto.Create(0,'',0,'','','');
            Estq := Estoque.Create(0,0,0,0,0,0);
            Ct   := Controle.Create(DM,Prod,Estq);
            Prod.setnomeProd(Combobox2.Text);
            Ct.BuscarProdPorNome;
            Edit3.Text := IntToStr(Prod.getcodProd);
            self.Edit2.Text := Prod.gettipoMedProd;
            DecimalSeparator := ',';
            if (self.Edit2.Text = 'PESO') then
            begin
                self.Edit1.Text := FloatToStr(Estq.getqtdPesoEstqAtual);
            end
            else if (self.Edit2.Text = 'UNIDADE') then
            begin
                self.Edit1.Text := IntToStr(Estq.getqtdunitEstqAtual);
            end;
            self.Edit6.Text := '0';
            self.CurrencyEdit1.Clear;
            self.CurrencyEdit2.Clear;
        end;
    except
        MessageDlg('Problema na Exibi��o dos dados do Produto selecionado.', mtError, [mbOk], 0);
    end;
end;


procedure TFrmSelItemPedCompraRealizada.BitBtn2Click(Sender: TObject);
begin
    if MessageDlg('Deseja Cancelar a Sele��o de It�ns de Pedido?', mtconfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
        self.PodeFechar := true;
        self.Close;
    end;
end;




procedure TFrmSelItemPedCompraRealizada.FormShow(Sender: TObject);
begin
    self.PodeFechar := false;
    self.ComboBox1.Clear;
    self.ListarCatg;
    self.GerarMaxCod; //gerar o c�digo do item de compra.
    self.Edit6.Text := '0';
end;

procedure TFrmSelItemPedCompraRealizada.BitBtn4Click(Sender: TObject);
var
    valorpago : real;
    preco : real;
    qtd   : real;
    var_teste : real;
begin
    var_teste := StrToFloat(Edit6.Text);
    if (Edit6.Text <> '') AND (var_teste > 0) then
    begin
        try
            preco := StrToFloat(self.CurrencyEdit2.Text);
            Qtd := StrToFloat(self.Edit6.Text);
            valorpago := (preco * qtd);
            self.CurrencyEdit1.Text := FloatToStr(valorpago);
            self.BitBtn1.Enabled := true;
        except
            on E: EConvertError do
            begin
               MessageDlg('Valor Inv�lido para quantidade Compra.', mtError, [mbOk], 0);
               self.Edit6.Clear;
            end;
        end;
    end
    else
    begin
       MessageDlg('Valor Inv�lido para quantidade Compra.', mtError, [mbOk], 0);
       Edit6.Clear;
    end;
end;

procedure TFrmSelItemPedCompraRealizada.BitBtn1Click(Sender: TObject);
var
    DM : TDM;
    PdComp : PedidoDeCompra;
    ItemPed : ItemDePedido;
    Ct : Controle;
    Prod : Produto;
    pesoItem : real;
begin
    try
        DM := TDM.Create(NIL);
        PdComp := PedidoDeCompra.Create(StrToInt(self.Edit5.Text),00/00/0000,0,'');
        Prod := Produto.Create(StrToInt(self.Edit3.Text),self.ComboBox2.Text,0,'','','');
        ItemPed := ItemDePedido.Create(StrToInt(self.Edit4.Text),0,0,StrToFloat(self.CurrencyEdit1.Text));
        Ct := Controle.Create(DM,PdComp,ItemPed,Prod);

        if(Ct.VerifarItemPedNaLista <> 1) then
        begin
            if(self.Edit2.Text = 'PESO') then
            begin
                pesoItem := StrToFloat(self.Edit6.Text);
                DecimalSeparator := '.';
                ItemPed.setqtdPesoItemPed(pesoItem);
            end
            else if(self.Edit2.Text = 'UNIDADE') then
            begin
                ItemPed.setqtdUnitItemPed(StrToInt(self.Edit6.Text));
            end;
            Ct.IncluirItemPed;
            FrmTelaCompraRealizada.MostrarItens;
            FrmTelaCompraRealizada.CalcValTotPedCompra;
            FrmTelaCompraRealizada.BitBtn3.enabled := true;
            FrmTelaCompraRealizada.BitBtn1.enabled := true;
            self.ClearBox;
            self.PodeFechar := true;
            self.Close;
        end
        else
        begin
            MessageDlg('Este Produto j� foi Adicionado � Lista dos It�ns de Pedido.', mtWarning, [mbOk], 0);
        end;
    except
        MessageDlg('Problema na Inclus�o do Item de Pedido.', mtError, [mbOk], 0);
    end;
end;



procedure TFrmSelItemPedCompraRealizada.Edit6Change(Sender: TObject);
begin
    if(self.Edit2.Text = 'PESO') then
    begin
        try
            StrToFloat(self.Edit6.Text);
        except
            MessageDlg('Valor Inv�lido.', mtWarning, [mbOk], 0);
            self.Edit6.Text := '0';
        end
    end
    else if(self.Edit2.Text = 'UNIDADE') then
    begin
        try
            StrToInt(self.Edit6.Text);
        except
            MessageDlg('Valor Inv�lido.', mtWarning, [mbOk], 0);
            self.Edit6.Text := '0';
        end
    end;
end;

procedure TFrmSelItemPedCompraRealizada.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    CanClose := self.PodeFechar;
end;

end.
