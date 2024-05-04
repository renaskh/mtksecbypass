object MForm: TMForm
  Left = 0
  Top = 0
  Caption = 'MTKSECBypass [By https://github.com/renaskh]'
  ClientHeight = 677
  ClientWidth = 983
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  DesignSize = (
    983
    677)
  TextHeight = 13
  object Button1: TButton
    Left = 695
    Top = 8
    Width = 280
    Height = 33
    Anchors = [akTop, akRight]
    Caption = 'Bypass Auth'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 599
    Top = 648
    Width = 90
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object RichEdit1: TRichEdit
    Left = 8
    Top = 8
    Width = 681
    Height = 634
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = TURKISH_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    HideSelection = False
    HideScrollBars = False
    ParentFont = False
    PlainText = True
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 648
    Width = 585
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
  end
end
