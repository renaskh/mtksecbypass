unit brom_config;

interface
uses mediatek;
  type
  TBrom_config = class
  public
  function configuration(var info:MTKIn): boolean;

  end;
implementation

uses MainForm,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms;

function ReadResourceToBytes(const ResName: string): TBytes;
begin
  var ResStream: TResourceStream;
  ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
  try
    SetLength(Result, ResStream.Size);
    ResStream.ReadBuffer(Result[0], ResStream.Size);
  finally
    ResStream.Free;
  end;
end;

function TBrom_config.configuration(var info:MTKIn): boolean;
begin

  mform.adlg('configuration...',clblack,true);
  if info.hwcode = $00 then
      raise Exception.Create('[CONFIGURATION] Invalid hwcode');



  if info.hwcode = $0571 then
  begin
    info.watchdog := $10007000;
    // uart
    // brom_payload_addr
    // da_payload_addr
    // gcpu_base
    // sej_base
    // cqdma_base
    // ap_dma_mem
    // blacklist

    info.damode := damodes.DEFAULT;
    info.dacode := $0571;
    info.name := 'MT0571';
  end
  else if info.hwcode = $598 then
  begin
    info.watchdog := $10211000;
    info.uart := $11020000;
    info.brom_payload_addr := $100A00;  // todo:check
    info.da_payload_addr := $201000;  // todo:check
    info.gcpu_base := $10224000;
    info.sej_base := $1000A000;
    info.cqdma_base := $10212C00;
    info.ap_dma_mem := $11000000 + $1A0;
    // blacklist
    info.damode := DEFAULT;
    info.dacode := $0598;
    info.name := 'ELBRUS/MT0598';
  end
  else if info.hwcode = $0992 then
  begin
    // watchdog
    // uart
    // brom_payload_addr
    // da_payload_addr
    // gcpu_base
    // sej_base
    // cqdma_base
    // ap_dma_mem
    // blacklist
    info.damode := XFLASH;
    info.dacode := $0992;
    info.name := 'MT0992';
  end
  else if info.hwcode = $992 then
  begin  // var1
        // watchdog
        // uart
        // brom_payload_addr
        // da_payload_addr
        // gcpu_base    
        // sej_base
        // cqdma_base
        // ap_dma_mem
        // blacklist
        info.damode := damodes.XFLASH;
        info.dacode := $0992;
        info.name := 'MT0992';
  end
  else if info.hwcode = $2601 then
  begin
        info.var1 := $A;  // Smartwatch; confirmed
        info.watchdog := $10007000;
        info.uart := $11005000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $2008000;
        info.pl_payload_addr := $81E00000;
        // no gcpu_base  := $10210000;
        info.sej_base := $1000A000;  // hacc
        // no dxcc
        // no cqdma_base
        // no ap_dma_mem
        info.blacklist[0][0]:=$11141F0C;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$11144BC4;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;
        info.send_ptr[0] := $11141f4c;
        info.send_ptr[1] := $ba68;
        info.ctrl_buffer := $11142BE0;
        info.cmd_handler := $0040C5AF;
        info.brom_register_access[0] := $40bd48;
        info.brom_register_access[1] := $40befc;
        info.meid_addr := $11142C34;
        info.dacode := $2601;
        info.damode := damodes.DEFAULT;  //
        info.name := 'MT2601';
        info.payload:=ReadResourceToBytes('mt2601_payload');
  end
  else if info.hwcode = $3967 then
  begin
        // var1
        // watchdog
        // uart
        info.brom_payload_addr:=$100A00;
        info.da_payload_addr:=$201000;
        info.pl_payload_addr:=$40020000;
        // gcpu_base
        // sej_base
        // no dxcc
        // cqdma_base
        // ap_dma_mem
        // blacklist
        info.dacode := $3967;
        info.damode := damodes.DEFAULT;
        info.name :='MT3967';
  end
  else if info.hwcode = $6255 then
  begin
        // var1
        // watchdog
        // uart
        // brom_payload_addr
        // da_payload_addr
        // gcpu_base
        info.sej_base := $80140000;
        // no dxcc
        // cqdma_base
        // ap_dma_mem
        // blacklist
        info.damode := damodes.DEFAULT;
        // dacode
        info.name := 'MT6255';
  end
  else if info.hwcode = $6261 then
  begin
        info.var1 := $28;  // Smartwatch; confirmed
        info.watchdog := $A0030000;
        info.uart := $A0080000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        // no gcpu_base
        info.sej_base := $A0110000;
        // no dxcc
        // no cqdma_base
        // no ap_dma_mem

        info.blacklist[0][0]:=$E003FC83;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$0;
        info.blacklist[1][1]:=$0;

        info.send_ptr[0] := $700044b0;
        info.send_ptr[1] := $700058EC;
        info.ctrl_buffer := $700041A8;
        info.cmd_handler := $700061F6;
        info.damode := damodes.DEFAULT;
        info.dacode := $6261;
        info.name := 'MT6261';
        info.payload:=ReadResourceToBytes('mt6261_payload');
  end
  else if info.hwcode = $6280 then
  begin
        // var1
        // watchdog
        // uart
        // brom_payload_addr
        // da_payload_addr
        // gcpu_base
        info.sej_base := $80080000;
        // no dxcc
        // cqdma_base
        // ap_dma_mem
        // blacklist
        info.damode := damodes.DEFAULT;
        info.name := 'MT6280';
  end
  else if info.hwcode = $6516 then
  begin
        // var1
        info.watchdog := $10003000;
        info.uart := $10023000;
        info.da_payload_addr := $201000;  // todo: check
        // gcpu_base
        info.sej_base := $1002D000;
        // no dxcc
        // cqdma_base
        // ap_dma_mem
        // blacklist
        info.damode := damodes.DEFAULT;
        info.dacode := $6516;
        info.name := 'MT6516';
  end
  else if info.hwcode = $633 then
  begin
        // var1
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;  // todo: check
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $80001000;  //
        info.gcpu_base := $1020D000;
        info.sej_base := $1000A000;
        // no dxcc
        info.cqdma_base := $1020ac00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_P_DMA_I2C_RX_MEM_ADDR
        info.efuse_addr := $10009000;
        info.damode := damodes.XFLASH;
        info.dacode := $6570;
        info.name := 'MT6570/MT8321';
  end
  else if info.hwcode = $6571 then
  begin
        // var1
        info.watchdog := $10007400;
        // uart
        info.da_payload_addr := $2009000;
        info.pl_payload_addr := $80001000;
        // gcpu_base
        // sej_base
        // no dxcc
        // cqdma_base
        // ap_dma_mem
        // blacklist
        info.misc_lock := $1000141C;
        info.damode := damodes.DEFAULT;  //
        info.dacode := $6571;
        info.name := 'MT6571';
  end
  else if info.hwcode = $6572 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11005000;
        info.brom_payload_addr := $10036A0;
        info.da_payload_addr := $2008000;
        info.pl_payload_addr := $81E00000;  //
        // gcpu_base
        // sej_base
        // no dxcc
        // cqdma_base
        info.ap_dma_mem := $11000000 + $19C;  // AP_P_DMA_I2C_1_MEM_ADDR

        info.blacklist[0][0]:=$11141F0C;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$11144BC4;
        info.blacklist[1][1]:=$0;

        info.blacklist_count := $00000008;

        info.send_ptr[0] := $11141f4c;
        info.send_ptr[1] := $40ba68;
        info.ctrl_buffer := $11142BE0;
        info.cmd_handler := $40C5AF;

        info.brom_register_access[0] := $40bd48;
        info.brom_register_access[1] := $40befc;
        info.meid_addr := $11142C34;
        info.misc_lock := $1000141C;
        info.efuse_addr := $10009000;
        info.damode := damodes.DEFAULT;  //
        info.dacode := $6572;
        info.name := 'MT6572';
        info.payload:=ReadResourceToBytes('mt6572_payload');
  end
  else if info.hwcode = $6573 then
  begin
        // var1
        info.watchdog := $70025000;
        // uart
        info.da_payload_addr := $90006000;
        info.pl_payload_addr := $f1020000;
        // gcpu_base
        info.sej_base := $7002A000;
        // no dxcc
        // cqdma_base
        // ap_dma_mem
        // blacklist
        info.damode := damodes.DEFAULT;
        info.dacode := $6573;
        info.name := 'MT6573/MT6260';
  end
  else if info.hwcode = $6575 then
  begin  // var1
        info.watchdog := $C0000000;
        info.uart := $C1009000;
        info.da_payload_addr := $c2001000;
        info.pl_payload_addr := $c2058000;
        // gcpu_base
        info.sej_base := $C101A000;
        // no dxcc
        // cqdma_base
        info.ap_dma_mem := $C100119C;
        // blacklist
        info.damode := damodes.DEFAULT;
        info.dacode := $6572;
        info.name := 'MT6575/77';
  end
  else if info.hwcode = $6577 then
  begin
        // var1
        info.watchdog := $C0000000;
        info.uart := $C1009000;
        info.da_payload_addr := $c2001000;
        info.pl_payload_addr := $c2058000;
        // gcpu_base
        info.sej_base := $C101A000;
        // no dxcc
        // cqdma_base
        info.ap_dma_mem := $C100119C;
        // blacklist
        info.damode := damodes.DEFAULT;
        info.dacode := $6577;
        info.name := 'MT6577';
  end
  else if info.hwcode = $6580 then
  begin
        info.var1 := $AC;
        info.watchdog := $10007000;
        info.uart := $11005000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $80001000;  //
        // no gcpu_base
        info.sej_base := $1000A000;
        // dxcc_base
        info.cqdma_base := $1020AC00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_P_DMA_I2C_1_RX_MEM_ADDR

        info.blacklist[0][0]:=$102764;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$001071D4;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027a4;
        info.send_ptr[1] := $b60c;
        info.ctrl_buffer := $00103060;
        info.cmd_handler := $0000C113;

        info.brom_register_access[0] := $b8e0;
        info.brom_register_access[1] := $ba94;
        info.efuse_addr := $10206000;
        info.misc_lock := $10001838;
        info.meid_addr := $1030B4;
        info.damode := damodes.DEFAULT;
        info.dacode := $6580;
        info.name := 'MT6580';
        info.payload:=ReadResourceToBytes('mt6580_payload');
  end
  else if info.hwcode = $6582 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $80001000;  //
        info.gcpu_base := $1101B000;
        info.sej_base := $1000A000;
        // no dxcc
        // no cqdma_base
        info.ap_dma_mem := $11000000 + $320;  // AP_DMA_I2C_0_RX_MEM_ADDR

        info.blacklist[0][0]:=$102788;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$00105BE4;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027c8;
        info.send_ptr[1] := $a5fc;
        info.ctrl_buffer := $00103078;
        info.cmd_handler := $0000B2E7;

        info.brom_register_access[0] := $a8d0;
        info.brom_register_access[1] := $aa84;
        info.efuse_addr := $10206000;
        info.meid_addr := $1030CC;
        info.misc_lock := $10002050;
        info.damode := damodes.DEFAULT;
        info.dacode := $6582;
        info.name := 'MT6582/MT6574/MT8382';
        info.payload:=ReadResourceToBytes('mt6582_payload');
  end
  else if info.hwcode = $6583 then
  begin
        // var1
        info.watchdog := $10000000;  // fixme
        info.uart := $11006000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $12001000;
        info.pl_payload_addr := $80001000;
        info.gcpu_base := $10210000;
        info.sej_base := $1000A000;
        // no dxcc
        // blacklist
        info.cqdma_base := $10212000;  // This chip might not support cqdma
        info.ap_dma_mem := $11000000 + $320;  // AP_DMA_I2C_0_RX_MEM_ADDR
        info.misc_lock := $10002050;
        info.damode := damodes.DEFAULT;
        info.dacode := $6589;
        info.name := 'MT6583/6589';
  end
  else if info.hwcode = $6592 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $111000;
        info.pl_payload_addr := $80001000;
        info.gcpu_base := $10210000;
        info.sej_base := $1000A000;
        // no dxcc
        info.cqdma_base := $10212000;  // This chip might not support cqdma
        info.ap_dma_mem := $11000000 + $320;  // AP_DMA_I2C_0_RX_MEM_ADDR

        info.blacklist[0][0]:=$00102764;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$00105BF0;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027a4;
        info.send_ptr[1] := $a564;
        info.ctrl_buffer := $00103054;
        info.cmd_handler := $0000B09F;

        info.brom_register_access[0] := $a838;
        info.brom_register_access[1] := $a9ec;
        info.meid_addr := $1030A8;
        info.misc_lock := $10002050;
        info.efuse_addr := $10206000;
        info.dacode := $6592;
        info.damode := damodes.DEFAULT;
        info.name := 'MT6592/MT8392';
        info.payload:=ReadResourceToBytes('mt6592_payload');
  end
  else if info.hwcode = $6595 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $111000;
        // gcpu_base
        info.sej_base := $1000A000;
        // dxcc_base
        // cqdma_base
        info.ap_dma_mem := $11000000 + $1A0;

        info.blacklist[0][0]:=$00102768;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$0106c88;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027a8;
        info.send_ptr[1] := $b218;
        info.ctrl_buffer := $00103050;
        info.cmd_handler := $0000BD53;

        info.brom_register_access[0] := $b4ec;
        info.brom_register_access[1] := $b6a0;
        info.meid_addr := $1030A4;
        info.efuse_addr := $10206000;
        info.dacode := $6595;
        info.damode := damodes.DEFAULT;
        info.name := 'MT6595';
        info.payload:=ReadResourceToBytes('mt6595_payload');
  end
  else if info.hwcode = $321 then
  begin
        info.var1 := $28;
        info.watchdog := $10212000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10216000;
        info.sej_base := $10008000;  // hacc
        // no dxcc
        info.cqdma_base := $10217C00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_DMA_I2C_O_RX_MEM_ADDR

        info.blacklist[0][0]:=$00102760;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$00105704;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027a0;
        info.send_ptr[1] := $95f8;
        info.ctrl_buffer := $0010305C;
        info.cmd_handler := $0000A17F;

        info.brom_register_access[0] := $98cc;
        info.brom_register_access[1] := $9a94;
        info.meid_addr := $1030B0;
        info.misc_lock := $10001838;
        info.efuse_addr := $11c50000;
        info.damode := damodes.DEFAULT;  //
        info.dacode := $6735;
        info.name := 'MT6735/MT8735A';
        info.payload:=ReadResourceToBytes('mt6735_payload');
  end
  else if info.hwcode = $335 then
  begin
        info.var1 := $28;  // confirmed
        info.watchdog := $10212000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10216000;
        info.sej_base := $10008000;
        // no dxcc
        info.cqdma_base := $10217C00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_DMA_I2C_O_RX_MEM_ADDR

        info.blacklist[0][0]:=$00102760;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$00105704;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027a0;
        info.send_ptr[1] := $9608;
        info.ctrl_buffer := $0010305C;
        info.cmd_handler := $0000A18F;

        info.brom_register_access[0] := $98dc;
        info.brom_register_access[1] := $9aa4;
        info.meid_addr := $1030B0;
        info.efuse_addr := $10206000;
        info.damode := damodes.DEFAULT;  //
        info.dacode := $6735;
        info.name := 'MT6737M/MT6735G';
        info.payload:=ReadResourceToBytes('mt6737_payload');
  end
  else if info.hwcode = $699 then
  begin
        info.var1 := $B4;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;
        info.sej_base := $1000A000;  // hacc
        info.dxcc_base := $10210000;
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000000 + $1a0;  // AP_DMA_I2C_1_RX_MEM_ADDR

        info.blacklist[0][0]:=$10282C;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$001076AC;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $102870;
        info.send_ptr[1] := $df1c;
        info.ctrl_buffer := $00102A28;
        info.cmd_handler := $0000EC49;

        info.brom_register_access[0] := $e330;
        info.brom_register_access[1] := $e3e8;
        info.meid_addr := $102AF8;
        info.socid_addr := $102b08;
        info.prov_addr := $10720C;
        info.misc_lock := $1001a100;
        info.efuse_addr := $11c00000;
        info.damode := damodes.XFLASH;
        info.dacode := $6739;
        info.name := 'MT6739/MT6731/MT8765';
        info.payload:=ReadResourceToBytes('mt6739_payload');
  end
  else if info.hwcode = $601 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10210000;
        info.sej_base := $1000A000;  // hacc
        info.cqdma_base := $10212C00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_DMA_I2C_1_RX_MEM_ADDR
        // blacklist
        info.efuse_addr := $10206000;
        info.misc_lock := $10001838;
        info.damode := damodes.XFLASH;
        info.dacode := $6755;
        info.name := 'MT6750';
  end
  else if info.hwcode = $6752 then
  begin
        info.var1 := $28;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;  //
        info.pl_payload_addr := $40001000;  //
        info.gcpu_base := $10210000;
        info.sej_base := $1000A000;  // hacc
        // no dxcc
        info.cqdma_base := $10212C00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_DMA_I2C_0_RX_MEM_ADDR

        info.blacklist[0][0]:=$00102764;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$00105704;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027a4;
        info.send_ptr[1] := $990c;
        info.ctrl_buffer := $00103060;
        info.cmd_handler := $0000A493;

        info.brom_register_access[0] := $9be0;
        info.brom_register_access[1] := $9da8;
        info.efuse_addr := $10206000;
        info.meid_addr := $1030B4;
        //no socid
        info.damode := damodes.DEFAULT;
        info.dacode := $6752;
        //misc_lock := $10001838;
        info.name := 'MT6752';
        info.payload:=ReadResourceToBytes('mt6752_payload');
  end
  else if info.hwcode = $337 then
  begin
        info.var1 := $28;  // confirmed
        info.watchdog := $10212000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10216000;
        info.sej_base := $10008000;
        // no dxcc
        info.cqdma_base := $10217C00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_DMA_I2C_0_RX_MEM_ADDR

        info.blacklist[0][0]:=$00102760;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$00105704;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027a0;
        info.send_ptr[1] := $9668;
        info.ctrl_buffer := $0010305C;
        info.cmd_handler := $0000A1EF;

        info.brom_register_access[0] := $993c;
        info.brom_register_access[1] := $9b04;
        info.meid_addr := $1030B0;
        info.damode := damodes.DEFAULT;  //
        info.dacode := $6735;
        info.misc_lock := $10001838;
        info.name := 'MT6753';
        info.payload:=ReadResourceToBytes('mt6753_payload');
  end
  else if info.hwcode = $326 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10210000;
        info.sej_base := $1000A000;  // hacc
        // no dxcc
        info.cqdma_base := $10212C00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_DMA_I2C_1_RX_MEM_ADDR

        info.blacklist[0][0]:=$10276C;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$00105704;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027b0;
        info.send_ptr[1] := $9a6c;
        info.ctrl_buffer := $00103058;
        info.cmd_handler := $0000A5FF;

        info.brom_register_access[0] := $9d4c;
        info.brom_register_access[1] := $9f14;
        info.meid_addr := $1030AC;
        info.efuse_addr := $10206000;
        info.damode := damodes.XFLASH;
        info.dacode := $6755;
        info.name := 'MT6755/MT6750/M/T/S';
        info.description:='Helio P10/P15/P18';
        info.payload:=ReadResourceToBytes('mt6755_payload');
  end
  else if info.hwcode = $551 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10210000;
        info.sej_base := $1000A000;
        // no dxcc
        info.cqdma_base := $10212C00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_DMA_I2C_1_RX_MEM_ADDR

        info.blacklist[0][0]:=$102774;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$00105704;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $1027b8;
        info.send_ptr[1] := $9c2c;
        info.ctrl_buffer := $00103060;
        info.cmd_handler := $0000A8FB;

        info.brom_register_access[0] := $a030;
        info.brom_register_access[1] := $a0e8;
        info.meid_addr := $1030B4;
        info.misc_lock := $10001838;
        info.efuse_addr := $10206000;
        info.damode := damodes.XFLASH;
        info.dacode := $6757;
        info.name := 'MT6757/MT6757D';
        info.description:='Helio P20';
        info.payload:=ReadResourceToBytes('mt6757_payload');
  end
  else if info.hwcode = $688 then
  begin
        info.var1 := $A;
        info.watchdog := $10211000;  //
        info.uart := $11020000;
        info.brom_payload_addr := $100A00;  //
        info.da_payload_addr := $201000;  //
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;  //
        info.sej_base := $10080000;  // hacc
        info.dxcc_base := $11240000;  //
        info.cqdma_base := $10200000;  //
        info.ap_dma_mem := $11000000 + $1A0;  //

        info.blacklist[0][0]:=$102830;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106A60;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $A;

        info.send_ptr[0] := $102874;
        info.send_ptr[1] := $d860;
        info.ctrl_buffer := $102B28;
        info.cmd_handler := $E58D;

        info.brom_register_access[0] := $dc74;
        info.brom_register_access[1] := $dd2c;
        info.meid_addr := $102bf8;
        info.socid_addr := $102c08;
        info.efuse_addr := $10450000;
        info.damode := damodes.XFLASH;
        info.dacode := $6758;
        info.name := 'MT6758';
        info.description := 'Helio P30';
        info.payload:=ReadResourceToBytes('mt6758_payload');
  end
  else if info.hwcode = $507 then
  begin
        // var1
        info.watchdog := $10210000;
        info.uart := $11020000;
        info.brom_payload_addr := $100A00;  // todo
        info.da_payload_addr := $201000;
        // pl_payload_addr
        info.gcpu_base := $10210000;
        // sej_base
        // dxcc_base
        // cqdma_base
        info.ap_dma_mem := $1030000 + $1A0;  // todo
        // blacklist
        // blacklist_count
        // send_ptr
        // ctrl_buffer
        // cmd_handler
        // brom_Register_access
        // meid_addr
        info.damode := damodes.DEFAULT;
        info.dacode := $6758;
        info.name := 'MT6759';
        info.description:='Helio P30';
        // loader
  end
  else if info.hwcode = $717 then
  begin
        info.var1 := $25;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;
        info.sej_base := $1000A000;  // hacc
        info.dxcc_base := $10210000;
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000a80 + $1a0;  // AP_DMA_I2C_CH0_RX_MEM_ADDR

        info.blacklist[0][0]:=$102828;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$00105994;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $10286c;
        info.send_ptr[1] := $bc8c;
        info.ctrl_buffer := $00102A28;
        info.cmd_handler := $0000C9B9;

        info.brom_register_access[0] := $c0a0;
        info.brom_register_access[1] := $c158;
        info.meid_addr := $102AF8;
        info.socid_addr := $102b08;
        info.prov_addr := $1054F4;
        info.misc_lock := $1001a100;
        info.efuse_addr := $11c50000;
        info.damode := damodes.XFLASH;
        info.dacode := $6761;
        info.name := 'MT6761/MT6762/MT3369/MT8766B';
        info.description:='Helio A20/P22/A22/A25/G25';
        info.payload:=ReadResourceToBytes('mt6761_payload');
  end
  else if info.hwcode = $690 then
  begin
        info.var1 := $7F;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;
        info.dxcc_base := $10210000;
        info.sej_base := $1000A000;  // hacc
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000a80 + $1a0;

        info.blacklist[0][0]:=$102834;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106CA4;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $102878;
        info.send_ptr[1] := $d66c;
        info.ctrl_buffer := $00102A90;
        info.cmd_handler := $0000E383;

        info.brom_register_access[0] := $da80;
        info.brom_register_access[1] := $db38;
        info.meid_addr := $102B78;
        info.socid_addr := $102b88;
        info.prov_addr := $106804;
        info.misc_lock := $1001a100;
        info.efuse_addr := $11f10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6763;
        info.name := 'MT6763';
        info.description:='Helio P23';
        info.payload:=ReadResourceToBytes('mt6763_payload');
  end
  else if info.hwcode = $766 then
  begin
        info.var1 := $25;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;  // not confirmed
        info.sej_base := $1000a000;  // hacc
        info.dxcc_base := $10210000;
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000000 + $1a0;  // AP_DMA_I2C2_CH0_RX_MEM_ADDR

        info.blacklist[0][0]:=$102828;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$105994;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $10286c;
        info.send_ptr[1] := $bdc0;
        info.ctrl_buffer := $00102A28;
        info.cmd_handler := $0000CAED;

        info.brom_register_access[0] := $c1d4;
        info.brom_register_access[1] := $c28c;
        info.meid_addr := $102AF8;
        info.socid_addr := $102b08; //0x10B72C
        info.prov_addr := $1054F4;
        info.misc_lock := $1001a100;
        info.efuse_addr := $11c50000;
        info.damode := damodes.XFLASH;
        info.dacode := $6765;
        info.name := 'MT6765/MT8768t';
        info.description:='Helio P35/G35';
        info.payload:=ReadResourceToBytes('mt6765_payload');
  end
  else if info.hwcode = $707 then
  begin
        info.var1 := $25;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;
        info.sej_base := $1000A000;  // hacc
        info.dxcc_base := $10210000;
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000000 + $1A0;

        info.blacklist[0][0]:=$10282C;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$105994;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $10286c;
        info.send_ptr[1] := $c190;
        info.ctrl_buffer := $00102A28;
        info.cmd_handler := $0000CF15;

        info.brom_register_access[0] := $c598;
        info.brom_register_access[1] := $c650;
        info.meid_addr := $102AF8;
        info.socid_addr := $102b08;
        info.prov_addr := $1054F4;
        info.misc_lock := $1001a100;
        info.efuse_addr := $11ce0000;
        info.damode := damodes.XFLASH;
        info.dacode := $6768;
        info.name := 'MT6768/MT6769';
        info.description:='Helio P65/G85 k68v1';
        info.payload:=ReadResourceToBytes('mt6768_payload');
  end
  else if info.hwcode = $788 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;
        info.sej_base := $1000A000;  // hacc
        info.dxcc_base := $10210000;  // dxcc_sec
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000000 + $158;  // AP_DMA_I2C_1_RX_MEM_ADDR

        info.blacklist[0][0]:=$102834;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106A60;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $102878;
        info.send_ptr[1] := $debc;
        info.ctrl_buffer := $00102A80;
        info.cmd_handler := $0000EBE9;

        info.brom_register_access[0] := $e2d0;
        info.brom_register_access[1] := $e388;
        info.meid_addr := $102B38;
        info.socid_addr := $102B48;
        info.prov_addr := $1065C0;
        info.misc_lock := $1001a100;
        info.efuse_addr := $11f10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6771;
        info.name := 'MT6771/MT8385/MT8183/MT8666';
        info.description:='Helio P60/P70/G80';
        info.payload:=ReadResourceToBytes('mt6771_payload');
        // blacklist={{0x00102830, 0x00200008};  // Static permission table pointer
        //        info.   (0x00102834; 2};  // Static permission table entry count
        //        info.   (0x00200000, 0x00000000};  // Memory region minimum address
        //        info.   (0x00200004, 0xfffffffc};  // Memory region maximum address
        //        info.   (0x00200008, 0x00000200};  // Memory read command bitmask
        //        info.   (0x0020000c, 0x00200000};  // Memory region array pointer
        //        info.   (0x00200010, 0x00000001};  // Memory region array length
        //        info.   (0x00200014, 0x00000400};  // Memory write command bitmask
        //        info.   (0x00200018, 0x00200000};  // Memory region array pointer
        //        info.   (0x0020001c, 0x00000001};  // Memory region array length
        //        info.   (0x00106A60; 0}};  // Dynamic permission table entry count?};
  end
  else if info.hwcode = $725 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;
        info.sej_base := $1000a000;  // hacc
        info.dxcc_base := $10210000;
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000000 + $158;

        info.blacklist[0][0]:=$102838;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106A60;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $102878;
        info.send_ptr[1] := $e04c;
        info.ctrl_buffer := $00102A80;
        info.cmd_handler := $0000ED6D;

        info.brom_register_access[0] := $e454;
        info.brom_register_access[1] := $e50c;
        info.meid_addr := $102B38;
        info.socid_addr := $102B48;
        info.prov_addr := $1065C0;
        info.misc_lock := $1001a100;
        info.efuse_addr := $11c10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6779;
        info.name := 'MT6779';
        info.description:='Helio P90 k79v1';
        info.payload:=ReadResourceToBytes('mt6779_payload');
  end
  else if info.hwcode = $1066 then
  begin
        info.var1 := $73;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;
        info.gcpu_base := $10050000;
        info.sej_base := $1000A000;  // hacc
        info.dxcc_base := $10210000;
        // cqdma_base := $10212000;
        // ap_dma_mem := $11000000 + 0x158;

        info.blacklist[0][0]:=$10284C;
        info.blacklist[0][1]:=$106B54;
        info.blacklist[1][0]:=$0;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $102890;
        info.send_ptr[1] := $e5d8;
        info.ctrl_buffer := $00102AB4;
        info.cmd_handler := $0000F3C1;

        info.brom_register_access[0] := $e9dc;
        info.brom_register_access[1] := $ea94;
        info.meid_addr := $102B98;
        info.socid_addr := $102BA8;
        info.efuse_addr := $11cb0000;
        info.damode := damodes.XFLASH;
        info.dacode := $6781;
        info.name := 'MT6781';
        info.description:='Helio G96';
        info.payload:=ReadResourceToBytes('mt6781_payload');
  end
  else if info.hwcode = $813 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;
        info.sej_base := $1000A000;  // hacc
        info.dxcc_base := $10210000;
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000000 + $158;

        info.blacklist[0][0]:=$102838;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106A60;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $102878;
        info.send_ptr[1] := $e2a4;
        info.ctrl_buffer := $00102A80;
        info.cmd_handler := $0000F029;

        info.brom_register_access[0] := $e6ac;
        info.brom_register_access[1] := $e764;
        info.meid_addr := $102B38;
        info.socid_addr := $102B48;
        info.prov_addr := $1065C0;
        info.misc_lock := $1001a100;
        info.efuse_addr := $11c10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6785;
        info.name := 'MT6785';
        info.description:='Helio G90';
        info.payload:=ReadResourceToBytes('mt6785_payload');
  end
  else if info.hwcode = $6795 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $110000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10210000;
        info.sej_base := $1000A000;  // hacc
        // no dxcc
        info.cqdma_base := $10212c00;
        info.ap_dma_mem := $11000000 + $1A0;

        info.blacklist[0][0]:=$102764;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$105704;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027a4;
        info.send_ptr[1] := $978c;
        info.ctrl_buffer := $0010304C;
        info.cmd_handler := $0000A313;  //

        info.brom_register_access[0] := $9a60;
        info.brom_register_access[1] := $9c28;
        info.meid_addr := $1030A0;
        info.efuse_addr := $10206000;
        info.damode := damodes.DEFAULT;  //
        info.dacode := $6795;
        info.name := 'MT6795';
        info.description:='Helio X10';
        info.payload:=ReadResourceToBytes('mt6795_payload');
  end
  else if info.hwcode = $279 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10210000;
        // no dxcc
        info.sej_base := $1000A000;  // hacc
        info.cqdma_base := $10212C00;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_DMA_I2C_1_RX_MEM_ADDR

        info.blacklist[0][0]:=$10276C;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$105704;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1027b0;
        info.send_ptr[1] := $9eac;
        info.ctrl_buffer := $00103058;
        info.cmd_handler := $0000AA3F;

        info.brom_register_access[0] := $a18c;
        info.brom_register_access[1] := $a354;
        info.meid_addr := $1030AC;
        info.misc_lock := $10002050;
        info.efuse_addr := $10206000;
        info.damode := damodes.XFLASH;
        info.dacode := $6797;
        info.name := 'MT6797/MT6767';
        info.description:='Helio X23/X25/X27';
        info.payload:=ReadResourceToBytes('mt6797_payload');
  end
  else if info.hwcode = $562 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10211000;
        info.uart := $11020000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  // not confirmed
        info.gcpu_base := $10210000;
        info.cqdma_base := $11B30000;
        info.ap_dma_mem := $11000000 + $1A0;  // AP_DMA_I2C_2_RX_MEM_ADDR
        info.dxcc_base := $11B20000;
        info.sej_base := $1000A000;

        info.blacklist[0][0]:=$102870;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$107070;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $1028b4;
        info.send_ptr[1] := $f5ac;
        info.ctrl_buffer := $001032F0;
        info.cmd_handler := $000102C3;

        info.brom_register_access[0] := $f9c0;
        info.brom_register_access[1] := $fa78;
        info.meid_addr := $1033B8;
        info.socid_addr := $1033C8;
        info.efuse_addr := $11F10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6799;
        info.name := 'MT6799';
        info.description:='Helio X30/X35';
        info.payload:=ReadResourceToBytes('mt6799_payload');
  end
  else if info.hwcode = $989 then
  begin
        info.var1 := $73;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;
        info.gcpu_base := $10050000;
        info.dxcc_base := $10210000;
        info.sej_base := $1000a000;  // hacc
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $10217a80 + $1a0;

        info.blacklist[0][0]:=$102844;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106B54;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $102884;
        info.send_ptr[1] := $dfe0;
        info.ctrl_buffer := $00102AA4;
        info.cmd_handler := $0000EDAD;

        info.brom_register_access[0] := $e3e8;
        info.brom_register_access[1] := $e4a0;
        info.meid_addr := $102b98;
        info.socid_addr := $102ba8;
        info.prov_addr := $1066B4;
        info.efuse_addr := $11c10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6833;
        info.name := 'MT6833';
        info.description := 'Dimensity 700 5G k6833';
        info.payload:=ReadResourceToBytes('mt6833_payload');
  end
  else if info.hwcode = $996 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;  //
        info.gcpu_base := $10050000;
        info.dxcc_base := $10210000;
        info.cqdma_base := $10212000;
        info.sej_base := $1000a000;  // hacc
        info.ap_dma_mem := $10217a80 + $1A0;

        info.blacklist[0][0]:=$10284C;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106B60;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $10288c;
        info.send_ptr[1] := $ea64;
        info.ctrl_buffer := $00102AA0;
        info.cmd_handler := $0000F831;

        info.brom_register_access[0] := $ee6c;
        info.brom_register_access[1] := $ef24;
        info.meid_addr := $102b78;
        info.socid_addr := $102b88;
        info.prov_addr := $1066C0;
        info.misc_lock := $1001A100;
        info.efuse_addr := $11c10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6853;
        info.name := 'MT6853';
        info.description := 'Dimensity 720 5G';
        info.payload:=ReadResourceToBytes('mt6853_payload');
  end
  else if info.hwcode = $886 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;
        info.gcpu_base := $10050000;
        info.dxcc_base := $10210000;
        info.sej_base := $1000a000;  // hacc
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $10217a80 + $1A0;

        info.blacklist[0][0]:=$10284C;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106B60;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $10288c;
        info.send_ptr[1] := $ea78;
        info.ctrl_buffer := $00102AA0;
        info.cmd_handler := $0000F7FD;

        info.brom_register_access[0] := $ee80;
        info.brom_register_access[1] := $ef38;
        info.meid_addr := $102B78;
        info.socid_addr := $102B88;
        info.prov_addr := $1066C0;
        info.misc_lock := $1001A100;
        info.efuse_addr := $11c10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6873;
        info.name := 'MT6873';
        info.description:='Dimensity 800/820 5G';
        info.payload:=ReadResourceToBytes('mt6873_payload');
  end
  else if info.hwcode = $959 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;
        info.gcpu_base := $10050000;
        info.sej_base := $1000a000;  // hacc
        info.dxcc_base := $10210000;
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $10217a80 + $1A0;

        info.blacklist[0][0]:=$102848;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106B60;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $A;

        info.send_ptr[0] := $102888;
        info.send_ptr[1] := $e8d0;
        info.ctrl_buffer := $00102A9C;
        info.cmd_handler := $0000F69D;

        info.brom_register_access[0] := $ecd8;
        info.brom_register_access[1] := $ed90;
        info.meid_addr := $102b98;
        info.socid_addr := $102ba8;
        info.prov_addr := $1066C0;
        info.efuse_addr := $11f10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6877;  // todo
        info.name := 'MT6877';
        info.description:='Dimensity 900';
        info.payload:=ReadResourceToBytes('mt6877_payload');
  end
  else if info.hwcode = $816 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;
        info.gcpu_base := $10050000;
        info.dxcc_base := $10210000;
        info.sej_base := $1000a000;  // hacc
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000a80 + $1a0;
        info.blacklist[0][0]:=$102848;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106B60;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $102888;
        info.send_ptr[1] := $E6FC;
        info.ctrl_buffer := $00102A9C;
        info.cmd_handler := $0000F481;

        info.brom_register_access[0] := $eb04;
        info.brom_register_access[1] := $ebbc;
        info.meid_addr := $102B78;
        info.socid_addr := $102B88;
        info.prov_addr := $1066C0;
        info.misc_lock := $1001A100;
        info.efuse_addr := $11c10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6885;
        info.name := 'MT6885/MT6883/MT6889/MT6880/MT6890';
        info.description:='Dimensity 1000L/1000';
        info.payload:=ReadResourceToBytes('mt6885_payload');
  end
  else if info.hwcode = $950 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;
        info.gcpu_base := $10050000;
        info.dxcc_base := $10210000;
        info.sej_base := $1000a000;  // hacc
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11000a80 + $1a0;

        info.blacklist[0][0]:=$102848;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106B60;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $102888;
        info.send_ptr[1] := $E79C;
        info.ctrl_buffer := $00102A9C;
        info.cmd_handler := $0000F569;

        info.brom_register_access[0] := $eba4;
        info.brom_register_access[1] := $ec5c;
        info.meid_addr := $102B98;
        info.socid_addr := $102BA8;
        info.prov_addr := $1066C0;
        info.efuse_addr := $11c10000;
        info.damode := damodes.XFLASH;
        info.dacode := $6893;
        info.name := 'MT6893';
        info.description:='Dimensity 1200';
        info.payload:=ReadResourceToBytes('mt6893_payload');
  end
  else if info.hwcode = $1172 then
  begin
        info.var1 := $A;
        info.watchdog := $1c007000;
        info.uart := $11001000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;
        info.gcpu_base := $10050000;
        info.dxcc_base := $10210000;
        info.sej_base := $1000a000;
        info.cqdma_base := $10212000;
        info.ap_dma_mem := $11300800 + $1a0;
        //blacklist={{0x102848, 0x0}, {0x00106B60, 0x0}};
        //blacklist_count := $0000000A;
        //send_ptr={0x102888, 0xE79C};
        //ctrl_buffer := $00102A9C;
        //cmd_handler := $0000F569;
        //brom_register_access={0xeba4, 0xec5c};
        //meid_addr := $102B98;
        //socid_addr := $102BA8;
        //prov_addr := $1066C0;
        info.damode := damodes.XFLASH;
        info.dacode := $6895;
        info.name := 'MT6895';
        info.description:='Dimensity 8100';
        //loader="mt6893_payload.bin"
  end
  else if info.hwcode = $1208 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;
        // gcpu_base := $10050000;
        info.dxcc_base := $10210000;
        // sej_base := $1000a000;
        // cqdma_base := $10212000;
        // ap_dma_mem := $11300800 + 0x1a0;
        // blacklist={{0x102848, 0x0}, {0x00106B60, 0x0}};
        // blacklist_count := $0000000A;
        // send_ptr={0x102888, 0xE79C};
        // ctrl_buffer := $00102A9C;
        // cmd_handler := $0000F569;
        // brom_register_access={0xeba4, 0xec5c};
        // meid_addr := $102B98;
        // socid_addr := $102BA8;
        // prov_addr := $1066C0;
        info.damode := damodes.XFLASH;
        info.dacode := $1208;
        info.name := 'MT6789';
        info.description:='MTK Helio G99';
        // loader="mt6789_payload.bin"
  end
  else if info.hwcode = $8127 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $80001000;
        info.gcpu_base := $11010000;
        info.sej_base := $1000A000;
        // no cqdma_base
        info.ap_dma_mem := $11000000 + $1A0;

        info.blacklist[0][0]:=$102870;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106C7C;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1028b0;
        info.send_ptr[1] := $b2b8;
        info.ctrl_buffer := $00103178;
        info.cmd_handler := $0000BDF3;

        info.brom_register_access[0] := $b58c;
        info.brom_register_access[1] := $b740;
        info.meid_addr := $1031CC;
        info.misc_lock := $10002050;
        info.damode := damodes.DEFAULT;  //
        info.dacode := $8127;
        info.name := 'MT8127/MT3367';
        info.payload:=ReadResourceToBytes('mt8127_payload');  // ford;austin;tank //mhmm wdt; nochmal checken
  end
  else if info.hwcode = $8135 then
  begin
        // var1
        info.watchdog := $10000000;
        // uart
        // brom_payload_addr
        info.da_payload_addr := $12001000;
        // pl_payload_addr
        // gcpu_base
        // sej_base
        // cqdma_base
        // ap_dma_mem
        // blacklist
        // blacklist_count
        // send_ptr
        // ctrl_buffer
        // cmd_handler
        // brom_register_access
        // meid_addr
        // socid_addr
        info.damode := damodes.DEFAULT;  //
        info.dacode := $8135;
        info.name := 'MT8135';
        // description
        // loader
  end
  else if info.hwcode = $8163 then
  begin
        info.var1 := $B1;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40001000;  //
        info.gcpu_base := $10210000;
        info.sej_base := $1000A000;
        // no dxcc
        info.cqdma_base := $10212C00;
        info.ap_dma_mem := $11000000 + $1A0;

        info.blacklist[0][0]:=$102868;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$1072DC;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1028a8;
        info.send_ptr[1] := $c12c;
        info.ctrl_buffer := $0010316C;
        info.cmd_handler := $0000CCB3;

        info.brom_register_access[0] := $c400;
        info.brom_register_access[1] := $c5c8;
        info.meid_addr := $1031C0;
        info.misc_lock := $10002050;
        info.efuse_addr := $10206000;
        info.damode := damodes.DEFAULT;  //
        info.dacode := $8163;
        info.name := 'MT8163';
        info.payload:=ReadResourceToBytes('mt8163_payload');  // douglas; karnak
  end
  else if info.hwcode = $8167 then
  begin
        info.var1 := $CC;
        info.watchdog := $10007000;
        info.uart := $11005000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40001000;  //
        info.gcpu_base := $1020D000;
        info.sej_base := $1000A000;
        // no dxcc
        info.cqdma_base := $10212C00;
        info.ap_dma_mem := $11000000 + $1A0;

        info.blacklist[0][0]:=$102968;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$107954;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $1029ac;
        info.send_ptr[1] := $d2e4;
        info.ctrl_buffer := $0010339C;
        info.cmd_handler := $0000DFF7;

        info.brom_register_access[0] := $d6f2;
        info.brom_register_access[1] := $d7ac;
        info.meid_addr := $103478;
        info.socid_addr := $103488;
        info.efuse_addr := $10009000;
        info.damode := damodes.XFLASH;
        info.dacode := $8167;
        info.name := 'MT8167/MT8516/MT8362';
        // description
        info.payload:=ReadResourceToBytes('mt8167_payload');
  end
  else if info.hwcode = $8168 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40001000;
        info.gcpu_base := $10241000;
        info.sej_base := $1000A000;
        // cqdma_base
        info.ap_dma_mem := $11000280 + $1A0;

        info.blacklist[0][0]:=$10303C;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$10A540;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $A;

        info.send_ptr[0] := $103080;
        info.send_ptr[1] := $13834;
        info.ctrl_buffer := $0010637C;
        info.cmd_handler := $1436F;

        info.brom_register_access[0] := $13c18;
        info.brom_register_access[1] := $13d78;
        info.meid_addr := $106438;
        info.socid_addr := $106448;
        info.efuse_addr := $10009000;
        info.damode := damodes.XFLASH;
        info.dacode := $8168;
        info.name := 'MT8168/MT6357';
        // description
        info.payload:=ReadResourceToBytes('mt8168_payload');
  end
  else if info.hwcode = $8172 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $120A00;
        info.da_payload_addr := $C0000;
        info.pl_payload_addr := $40001000;  //
        info.gcpu_base := $10210000;
        info.sej_base := $1000a000;
        // no dxcc
        info.cqdma_base := $10212c00;
        info.ap_dma_mem := $11000000 + $1A0;

        info.blacklist[0][0]:=$122774;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$125904;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1227b4;
        info.send_ptr[1] := $a0e4;
        info.ctrl_buffer := $0012305C;
        info.cmd_handler := $0000AC6B;

        info.brom_register_access[0] := $a3b8;
        info.brom_register_access[1] := $a580;
        info.meid_addr := $1230B0;
        info.misc_lock := $1202050;
        info.damode := damodes.DEFAULT;  //
        info.dacode := $8173;
        info.name := 'MT8173';
        // description
        info.payload:=ReadResourceToBytes('mt8173_payload');  // sloane; suez
  end
  else if info.hwcode = $8176 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $120A00;
        info.da_payload_addr := $C0000;
        info.pl_payload_addr := $40200000;
        info.gcpu_base := $10210000;
        info.sej_base := $1000A000;
        // no dxcc
        info.cqdma_base := $10212c00;
        info.ap_dma_mem := $11000000 + $1A0;

        info.blacklist[0][0]:=$122774;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$125904;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1227b4;
        info.send_ptr[1] := $a0e4;
        info.ctrl_buffer := $0012305C;
        info.cmd_handler := $0000AC6B;

        info.brom_register_access[0] := $a3b8;
        info.brom_register_access[1] := $a580;
        info.meid_addr := $1230B0;
        info.misc_lock := $1202050;
        // socid_addr
        info.efuse_addr := $10206000;
        info.dacode := $8173;
        info.damode := damodes.DEFAULT;
        // description
        info.name := 'MT8176';
        info.payload:=ReadResourceToBytes('mt8176_payload');
  end
  else if info.hwcode = $930 then
  begin
        // var1
        info.watchdog := $10007000;
        info.uart := $11001200;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40200000;
        // gcpu_base
        // sej_base
        // cqdma_base
        // ap_dma_mem
        // blacklist
        // blacklist_count
        // send_ptr
        // ctrl_buffer
        // cmd_handler
        // brom_register_access
        // meid_addr
        // socid_addr
        info.efuse_addr := $11c10000;
        info.misc_lock := $1001A100;
        info.dacode := $8195;
        info.damode := damodes.XFLASH;
        // description
        info.name := 'MT8195 Chromebook';
        // loader
  end
  else if info.hwcode = $8512 then
  begin
        info.var1 := $A;
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $111000;
        info.pl_payload_addr := $40200000;
        info.gcpu_base := $1020F000;
        info.sej_base := $1000A000;
        info.cqdma_base := $10214000;
        info.ap_dma_mem := $11000000 + $1A0;

        info.blacklist[0][0]:=$1041E4;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$10AA84;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $A;

        info.send_ptr[0] := $104258;
        info.send_ptr[1] := $cc44;
        info.ctrl_buffer := $00104570;
        info.cmd_handler := $0000D7AB;

        info.brom_register_access[0] := $d034;
        info.brom_register_access[1] := $d194;
        info.meid_addr := $104638;
        info.socid_addr := $104648;
        info.efuse_addr := $11c50000;
        info.dacode := $8512;
        info.damode := damodes.XFLASH;
        // description
        info.name := 'MT8512';
        info.payload:=ReadResourceToBytes('mt8512_payload');
  end
  else if info.hwcode = $8518 then
  begin
        // var1
        // watchdog
        // uart
        // brom_payload_addr
        // da_payload_addr
        // gcpu_base
        // sej_base
        // cqdma_base
        // ap_dma_mem
        // blacklist
        // blacklist_count
        // send_ptr
        // ctrl_buffer
        // cmd_handler
        // brom_register_access
        // meid_addr
        // socid_addr
        info.efuse_addr := $10009000;
        info.dacode := $8518;
        info.damode := damodes.XFLASH;
        info.name := 'MT8518 VoiceAssistant';
        // loader
  end
  else if info.hwcode = $8590 then
  begin
        info.var1 := $A;  // confirmed; router
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $80001000;
        info.gcpu_base := $1101B000;
        info.sej_base := $1000A000;
        // cqdma_base
        // ap_dma_mem := $11000000 + 0x1A0;

        info.blacklist[0][0]:=$102870;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106c7c;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $00000008;

        info.send_ptr[0] := $1028b0;
        info.send_ptr[1] := $bbe4;
        info.ctrl_buffer := $00103184;
        info.cmd_handler := $0000C71F;

        info.brom_register_access[0] := $beb8;
        info.brom_register_access[1] := $c06c;
        info.meid_addr := $1031D8;
        info.dacode := $8590;
        info.damode := damodes.DEFAULT;
        info.name := 'MT8590/MT7683/MT8521/MT7623';
        // description=
        info.payload:=ReadResourceToBytes('mt8590_payload');
  end
  else if info.hwcode = $8695 then
  begin
        info.var1 := $A;  // confirmed
        info.watchdog := $10007000;
        info.uart := $11002000;
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        info.pl_payload_addr := $40001000;  //
        // gcpu_base
        info.sej_base := $1000A000;
        // cqdma_base
        info.ap_dma_mem := $11000280 + $1A0;

        info.blacklist[0][0]:=$103048;
        info.blacklist[0][1]:=$0;
        info.blacklist[1][0]:=$106EC4;
        info.blacklist[1][1]:=$0;
        info.blacklist_count := $0000000A;

        info.send_ptr[0] := $103088;
        info.send_ptr[1] := $beec;
        info.ctrl_buffer := $001031EC;
        info.cmd_handler := $0000CAA7;

        info.brom_register_access[0] := $c298;
        info.brom_register_access[1] := $c3f8;
        info.meid_addr := $1032B8;
        info.efuse_addr := $10206000;
        info.damode := damodes.XFLASH;
        info.dacode := $8695;
        info.name := 'MT8695';  // mantis
        // description
        info.payload:=ReadResourceToBytes('mt8695_payload');
  end
  else if info.hwcode = $908 then
  begin
        // var1
        info.watchdog := $10007000;
        // uart
        info.brom_payload_addr := $100A00;
        info.da_payload_addr := $201000;
        // gcpu_base
        // sej_base
        // cqdma_base
        // ap_dma_mem
        // blacklist
        // blacklist_count
        // send_ptr
        // ctrl_buffer
        // cmd_handler
        // brom_register_access
        // meid_addr
        // socid_addr
        info.efuse_addr := $11c10000;
        info.damode := damodes.XFLASH;
        info.dacode := $8696;
        // description
        info.name := 'MT8696';
        // loader
  end;
  if info.name.IsEmpty then
      raise Exception.Create('[CONFIGURATION] Unsupported device connected');

  mform.ok;
  mform.adlg('ChipName : ',clblack,true);
  mform.adlg(info.name,clblue,false);
  mform.adlg('Description : ',clblack,true);
  mform.adlg(info.description,clblue,false);
  exit(true);
end;
end.
