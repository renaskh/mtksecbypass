unit DTSetupApi_hwd;

interface

uses
  windows;

const
  ANYSIZE_ARRAY = 1;
  LINE_LEN = 256; // Win95-compatible maximum for displayable

type

  HDEVINFO = Pointer;
  DevInst = DWORD;
  RETURN_TYPE = DWORD;
  CONFIGRET = RETURN_TYPE;
  PPTSTR = ^PTSTR;
  PTSTR = LPWSTR;
  TCHAR = Char;
  ULONG_PTR = DWORD;
  
  PSPDevInfoData = ^TSPDevInfoData;

  SP_DEVINFO_DATA = packed record
    cbSize: DWORD;
    ClassGuid: TGUID;
    DevInst: DWORD; // DEVINST handle
    Reserved: ULONG_PTR;
  end;

  TSPDevInfoData = SP_DEVINFO_DATA;

  PSPDrvInfoDataW = ^TSPDrvInfoDataW;

  SP_DRVINFO_DATA_V1_W = packed record
    cbSize: DWORD;
    DriverType: DWORD;
    Reserved: ULONG_PTR;
    Description: array [0 .. LINE_LEN - 1] of WideChar;
    MfgName: array [0 .. LINE_LEN - 1] of WideChar;
    ProviderName: array [0 .. LINE_LEN - 1] of WideChar;
  end;

  TSPDrvInfoDataW = SP_DRVINFO_DATA_V1_W;

  PSPDrvInfoDetailDataW = ^TSPDrvInfoDetailDataW;

  SP_DRVINFO_DETAIL_DATA_W = packed record
    cbSize: DWORD;
    InfDate: TFileTime;
    CompatIDsOffset: DWORD;
    CompatIDsLength: DWORD;
    Reserved: ULONG_PTR;
    SectionName: array [0 .. LINE_LEN - 1] of WideChar;
    InfFileName: array [0 .. MAX_PATH - 1] of WideChar;
    DrvDescription: array [0 .. LINE_LEN - 1] of WideChar;
    HardwareID: array [0 .. ANYSIZE_ARRAY - 1] of WideChar;
  end;

  TSPDrvInfoDetailDataW = SP_DRVINFO_DETAIL_DATA_W;

  //
  // Device interface information structure (references a device
  // interface that is associated with the device information
  // element that owns it).
  //
  PSPDeviceInterfaceData = ^TSPDeviceInterfaceData;

  SP_DEVICE_INTERFACE_DATA = packed record
    cbSize: DWORD;
    InterfaceClassGuid: TGUID;
    Flags: DWORD;
    Reserved: ULONG_PTR;
  end;

  TSPDeviceInterfaceData = SP_DEVICE_INTERFACE_DATA;

  PSPDeviceInterfaceDetailDataW = ^TSPDeviceInterfaceDetailDataW;
  PSPDeviceInterfaceDetailData = PSPDeviceInterfaceDetailDataW;

  SP_DEVICE_INTERFACE_DETAIL_DATA_W = packed record
    cbSize: DWORD;
    DevicePath: array [0 .. ANYSIZE_ARRAY - 1] of WideChar;
  end;

  TSPDeviceInterfaceDetailDataW = SP_DEVICE_INTERFACE_DETAIL_DATA_W;
  TSPDeviceInterfaceDetailData = TSPDeviceInterfaceDetailDataW;

const

  //
  // GUID for devices
  //
  GUID_DEVINTERFACE_SERENUM_BUS_ENUMERATOR
    : TGUID = '{4D36E978-E325-11CE-BFC1-08002BE10318}';

  GUID_USB: TGUID = '{36fc9e60-c465-11cf-8056-444553540000}';
  GUID_Modem: TGUID = '{4d36e96d-e325-11ce-bfc1-08002be10318}';
  GUID_Modem_Bytes: array [0 .. 15] of byte = ($4D, $36, $E9, $6D, $E3, $25,
    $11, $CE, $BF, $C1, $08, $00, $2B, $E1, $03, $18);
  GUID_Ports: TGUID = '{4D36E978-E325-11CE-BFC1-08002BE10318}';
  GUID_Ports_Bytes: array [0 .. 15] of byte = ($4D, $36, $E9, $78, $E3, $25,
    $11, $CE, $BF, $C1, $08, $00, $2B, $E1, $03, $18);
  GUID_MultiPortsSerial: TGUID = '{50906CB8-BA12-11D1-BF5D-0000F805F530}';
  GUID_Null: TGUID = '{00000000-0000-0000-0000-000000000000}';
  GUID_Adapter: TGUID = '{4d36e964-e325-11ce-bfc1-08002be10318}';
  GUID_APMSupport: TGUID = '{d45b1c18-c8fa-11d1-9f77-0000f805f530}';
  GUID_Computer: TGUID = '{4d36e966-e325-11ce-bfc1-08002be10318}';
  GUID_Decoder: TGUID = '{6bdd1fc2-810f-11d0-bec7-08002be2092f}';
  GUID_GPS: TGUID = '{6bdd1fc3-810f-11d0-bec7-08002be2092f}';
  GUID_1394Debug: TGUID = '{66f250d6-7801-4a64-b139-eea80a450b24}';
  GUID_Enum1394: TGUID = '{c459df55-db08-11d1-b009-00a0c9081ff6}';
  GUID_NoDriver: TGUID = '{4d36e976-e325-11ce-bfc1-08002be10318}';
  GUID_LegacyDriver: TGUID = '{8ecc055d-047f-11d1-a537-0000f8753ed1}';
  GUID_Unknown: TGUID = '{4d36e97e-e325-11ce-bfc1-08002be10318}';
  GUID_PrinterUpgrade: TGUID = '{4d36e97a-e325-11ce-bfc1-08002be10318}';
  GUID_Sound: TGUID = '{4d36e97c-e325-11ce-bfc1-08002be10318}';
  GUID_VolumeSnapshot: TGUID = '{533c5b84-ec70-11d2-9505-00c04F79deaf}';
  GUID_USB_Hub: TGUID = '{F18A0E88-C30C-11D0-8815-00A0C906BED8}';
  GUID_USB_HC: TGUID = '{3ABF6F2D-71C4-462A-8A92-1E6861E6AF27}';
  GUID_DEVINTERFACE_HID: TGUID = '{4D1E55B2-F16F-11CF-88CB-001111000030}';

  // GUID_ReservedForSystem: array [0 .. 12] of TGUID =
  // ('{4d36e964-e325-11ce-bfc1-08002be10318}',
  // '{d45b1c18-c8fa-11d1-9f77-0000f805f530}',
  // '{4d36e966-e325-11ce-bfc1-08002be10318}',
  // '{6bdd1fc2-810f-11d0-bec7-08002be2092f}',
  // '{6bdd1fc3-810f-11d0-bec7-08002be2092f}',
  // '{66f250d6-7801-4a64-b139-eea80a450b24}',
  // '{c459df55-db08-11d1-b009-00a0c9081ff6}',
  // '{4d36e976-e325-11ce-bfc1-08002be10318}',
  // '{8ecc055d-047f-11d1-a537-0000f8753ed1}',
  // '{4d36e97e-e325-11ce-bfc1-08002be10318}',
  // '{4d36e97a-e325-11ce-bfc1-08002be10318}',
  // '{4d36e97c-e325-11ce-bfc1-08002be10318}',
  // '{533c5b84-ec70-11d2-9505-00c04F79deaf}');
  // Adapter
  // Class = Adapter
  // ClassGuid = {4d36e964-e325-11ce-bfc1-08002be10318}
  // APM
  // Class = APMSupport
  // ClassGuid = {d45b1c18-c8fa-11d1-9f77-0000f805f530}
  // Computer
  // Class = Computer
  // ClassGuid = {4d36e966-e325-11ce-bfc1-08002be10318}
  // Decoders
  // Class = Decoder
  // ClassGuid = {6bdd1fc2-810f-11d0-bec7-08002be2092f}
  // Global Positioning System
  // Class = GPS
  // ClassGuid = {6bdd1fc3-810f-11d0-bec7-08002be2092f}
  // Host-side IEEE 1394 Kernel Debugger Support
  // Class = 1394Debug
  // ClassGuid = {66f250d6-7801-4a64-b139-eea80a450b24}
  // IEEE 1394 IP Network Enumerator
  // Class = Enum1394
  // ClassGuid = {c459df55-db08-11d1-b009-00a0c9081ff6}
  // No driver
  // Class = NoDriver
  // ClassGuid = {4d36e976-e325-11ce-bfc1-08002be10318}
  // Non-Plug and Play Drivers
  // Class = LegacyDriver
  // ClassGuid = {8ecc055d-047f-11d1-a537-0000f8753ed1}
  // Other Devices
  // Class = Unknown
  // ClassGuid = {4d36e97e-e325-11ce-bfc1-08002be10318}
  // Printer Upgrade
  // Class = PrinterUpgrade
  // ClassGuid = {4d36e97a-e325-11ce-bfc1-08002be10318}
  // Sound
  // Class = Sound
  // ClassGuid = {4d36e97c-e325-11ce-bfc1-08002be10318}
  // Storage Volume Snapshots
  // Class = VolumeSnapshot
  // ClassGuid = {533c5b84-ec70-11d2-9505-00c04F79deaf}
  //
  // Flags controlling what is included in the device information set built
  // by SetupDiGetClassDevs
  //
  DIGCF_DEFAULT = $00000001; // only valid with DIGCF_DEVICEINTERFACE
  DIGCF_PRESENT = $00000002;
  DIGCF_ALLCLASSES = $00000004;
  DIGCF_PROFILE = $00000008;
  DIGCF_DEVICEINTERFACE = $00000010;

  //
  // Values specifying the scope of a device property change
  //
  DICS_FLAG_GLOBAL = $00000001; // make change in all hardware profiles
  DICS_FLAG_CONFIGSPECIFIC = $00000002; // make change in specified profile only
  DICS_FLAG_CONFIGGENERAL = $00000004; // 1 or more hardware profile-specific
  // changes to follow.
  //
  // Values indicating a change in a device's state
  //
  DICS_ENABLE = 00000001;
  DICS_DISABLE = 00000002;
  DICS_PROPCHANGE = 00000003;
  DICS_START = 00000004;
  DICS_STOP = 00000005;
  //
  // Device registry property codes
  // (Codes marked as read-only (R) may only be used for
  // SetupDiGetDeviceRegistryProperty)
  //
  // These values should cover the same set of registry properties
  // as defined by the CM_DRP codes in cfgmgr32.h.
  //
  // Note that SPDRP codes are zero based while CM_DRP codes are one based!
  //
  SPDRP_DEVICEDESC = $00000000; // DeviceDesc (R/W)
  SPDRP_HARDWAREID = $00000001; // HardwareID (R/W)
  SPDRP_COMPATIBLEIDS = $00000002; // CompatibleIDs (R/W)
  SPDRP_UNUSED0 = $00000003; // unused
  SPDRP_SERVICE = $00000004; // Service (R/W)
  SPDRP_UNUSED1 = $00000005; // unused
  SPDRP_UNUSED2 = $00000006; // unused
  SPDRP_CLASS = $00000007; // Class (R--tied to ClassGUID)
  SPDRP_CLASSGUID = $00000008; // ClassGUID (R/W)
  SPDRP_DRIVER = $00000009; // Driver (R/W)
  SPDRP_CONFIGFLAGS = $0000000A; // ConfigFlags (R/W)
  SPDRP_MFG = $0000000B; // Mfg (R/W)
  SPDRP_FRIENDLYNAME = $0000000C; // FriendlyName (R/W)
  SPDRP_LOCATION_INFORMATION = $0000000D; // LocationInformation (R/W)
  SPDRP_PHYSICAL_DEVICE_OBJECT_NAME = $0000000E; // PhysicalDeviceObjectName (R)
  SPDRP_CAPABILITIES = $0000000F; // Capabilities (R)
  SPDRP_UI_NUMBER = $00000010; // UiNumber (R)
  SPDRP_UPPERFILTERS = $00000011; // UpperFilters (R/W)
  SPDRP_LOWERFILTERS = $00000012; // LowerFilters (R/W)
  SPDRP_BUSTYPEGUID = $00000013; // BusTypeGUID (R)
  SPDRP_LEGACYBUSTYPE = $00000014; // LegacyBusType (R)
  SPDRP_BUSNUMBER = $00000015; // BusNumber (R)
  SPDRP_ENUMERATOR_NAME = $00000016; // Enumerator Name (R)
  SPDRP_SECURITY = $00000017; // Security (R/W, binary form)
  SPDRP_SECURITY_SDS = $00000018; // Security (W, SDS form)
  SPDRP_DEVTYPE = $00000019; // Device Type (R/W)
  SPDRP_EXCLUSIVE = $0000001A; // Device is exclusive-access (R/W)
  SPDRP_CHARACTERISTICS = $0000001B; // Device Characteristics (R/W)
  SPDRP_ADDRESS = $0000001C; // Device Address (R)
  SPDRP_UI_NUMBER_DESC_FORMAT = $0000001D; // UiNumberDescFormat (R/W)
  SPDRP_DEVICE_POWER_DATA = $0000001E; // Device Power Data (R)
  SPDRP_REMOVAL_POLICY = $0000001F; // Removal Policy (R)
  SPDRP_REMOVAL_POLICY_HW_DEFAULT = $00000020; // Hardware Removal Policy (R)
  SPDRP_REMOVAL_POLICY_OVERRIDE = $00000021; // Removal Policy Override (RW)
  SPDRP_INSTALL_STATE = $00000022; // Device Install State (R)
  SPDRP_LOCATION_PATHS = $00000023; // Device Location Paths (R)
  SPDRP_BASE_CONTAINERID = $00000024; // Base ContainerID (R)
  SPDRP_MAXIMUM_PROPERTY = $00000025; // Upper bound on ordinals

  //
  // KeyType values for SetupDiCreateDevRegKey, SetupDiOpenDevRegKey, and
  // SetupDiDeleteDevRegKey.
  //
  DIREG_DEV = $00000001; // Open/Create/Delete device key
  DIREG_DRV = $00000002; // Open/Create/Delete driver key
  DIREG_BOTH = $00000004; // Delete both driver and Device key
  //
  // Class installer function codes
  //
  DIF_SELECTDEVICE = $00000001;
  DIF_INSTALLDEVICE = $00000002;
  DIF_ASSIGNRESOURCES = $00000003;
  DIF_PROPERTIES = $00000004;
  DIF_REMOVE = $00000005;
  DIF_FIRSTTIMESETUP = $00000006;
  DIF_FOUNDDEVICE = $00000007;
  DIF_SELECTCLASSDRIVERS = $00000008;
  DIF_VALIDATECLASSDRIVERS = $00000009;
  DIF_INSTALLCLASSDRIVERS = $0000000A;
  DIF_CALCDISKSPACE = $0000000B;
  DIF_DESTROYPRIVATEDATA = $0000000C;
  DIF_VALIDATEDRIVER = $0000000D;
  DIF_DETECT = $0000000F;
  DIF_INSTALLWIZARD = $00000010;
  DIF_DESTROYWIZARDDATA = $00000011;
  DIF_PROPERTYCHANGE = $00000012;
  DIF_ENABLECLASS = $00000013;
  DIF_DETECTVERIFY = $00000014;
  DIF_INSTALLDEVICEFILES = $00000015;
  DIF_UNREMOVE = $00000016;
  DIF_SELECTBESTCOMPATDRV = $00000017;
  DIF_ALLOW_INSTALL = $00000018;
  DIF_REGISTERDEVICE = $00000019;
  DIF_NEWDEVICEWIZARD_PRESELECT = $0000001A;
  DIF_NEWDEVICEWIZARD_SELECT = $0000001B;
  DIF_NEWDEVICEWIZARD_PREANALYZE = $0000001C;
  DIF_NEWDEVICEWIZARD_POSTANALYZE = $0000001D;
  DIF_NEWDEVICEWIZARD_FINISHINSTALL = $0000001E;
  DIF_UNUSED1 = $0000001F;
  DIF_INSTALLINTERFACES = $00000020;
  DIF_DETECTCANCEL = $00000021;
  DIF_REGISTER_COINSTALLERS = $00000022;
  DIF_ADDPROPERTYPAGE_ADVANCED = $00000023;
  DIF_ADDPROPERTYPAGE_BASIC = $00000024;
  DIF_RESERVED1 = $00000025;
  DIF_TROUBLESHOOTER = $00000026;
  DIF_POWERMESSAGEWAKE = $00000027;
  DIF_ADDREMOTEPROPERTYPAGE_ADVANCED = $00000028;
  DIF_UPDATEDRIVER_UI = $00000029;
  DIF_FINISHINSTALL_ACTION = $0000002A;
  DIF_RESERVED2 = $00000030;

  //
  // Flags for SetupDiOpenClassRegKeyEx
  //
  DIOCR_INSTALLER = $00000001; // class installer registry branch
  DIOCR_INTERFACE = $00000002; // interface class registry branch
  //
  //
  //
  CR_SUCCESS = $00000000;
  CR_DEFAULT = $00000001;
  CR_OUT_OF_MEMORY = $00000002;
  CR_INVALID_POINTER = $00000003;
  CR_INVALID_FLAG = $00000004;
  CR_INVALID_DEVNODE = $00000005;
  CR_INVALID_DEVINST = CR_INVALID_DEVNODE;
  CR_INVALID_RES_DES = $00000006;
  CR_INVALID_LOG_CONF = $00000007;
  CR_INVALID_ARBITRATOR = $00000008;
  CR_INVALID_NODELIST = $00000009;
  CR_DEVNODE_HAS_REQS = $0000000A;
  CR_DEVINST_HAS_REQS = CR_DEVNODE_HAS_REQS;
  CR_INVALID_RESOURCEID = $0000000B;
  CR_DLVXD_NOT_FOUND = $0000000C;
  // WIN 95 ONLY
  CR_NO_SUCH_DEVNODE = $0000000D;
  CR_NO_SUCH_DEVINST = CR_NO_SUCH_DEVNODE;
  CR_NO_MORE_LOG_CONF = $0000000E;
  CR_NO_MORE_RES_DES = $0000000F;
  CR_ALREADY_SUCH_DEVNODE = $00000010;
  CR_ALREADY_SUCH_DEVINST = CR_ALREADY_SUCH_DEVNODE;
  CR_INVALID_RANGE_LIST = $00000011;
  CR_INVALID_RANGE = $00000012;
  CR_FAILURE = $00000013;
  CR_NO_SUCH_LOGICAL_DEV = $00000014;
  CR_CREATE_BLOCKED = $00000015;
  CR_NOT_SYSTEM_VM = $00000016; // WIN 95 ONLY
  CR_REMOVE_VETOED = $00000017;
  CR_APM_VETOED = $00000018;
  CR_INVALID_LOAD_TYPE = $00000019;
  CR_BUFFER_SMALL = $0000001A;
  CR_NO_ARBITRATOR = $0000001B;
  CR_NO_REGISTRY_HANDLE = $0000001C;
  CR_REGISTRY_ERROR = $0000001D;
  CR_INVALID_DEVICE_ID = $0000001E;
  CR_INVALID_DATA = $0000001F;
  CR_INVALID_API = $00000020;
  CR_DEVLOADER_NOT_READY = $00000021;
  CR_NEED_RESTART = $00000022;
  CR_NO_MORE_HW_PROFILES = $00000023;
  CR_DEVICE_NOT_THERE = $00000024;
  CR_NO_SUCH_VALUE = $00000025;
  CR_WRONG_TYPE = $00000026;
  CR_INVALID_PRIORITY = $00000027;
  CR_NOT_DISABLEABLE = $00000028;
  CR_FREE_RESOURCES = $00000029;
  CR_QUERY_VETOED = $0000002A;
  CR_CANT_SHARE_IRQ = $0000002B;
  CR_NO_DEPENDENT = $0000002C;
  CR_SAME_RESOURCES = $0000002D;
  CR_NO_SUCH_REGISTRY_KEY = $0000002E;
  CR_INVALID_MACHINENAME = $0000002F; // NT ONLY
  CR_REMOTE_COMM_FAILURE = $00000030; // NT ONLY
  CR_MACHINE_UNAVAILABLE = $00000031; // NT ONLY
  CR_NO_CM_SERVICES = $00000032; // NT ONLY
  CR_ACCESS_DENIED = $00000033; // NT ONLY
  CR_CALL_NOT_IMPLEMENTED = $00000034;
  CR_INVALID_PROPERTY = $00000035;
  CR_DEVICE_INTERFACE_ACTIVE = $00000036;
  CR_NO_SUCH_DEVICE_INTERFACE = $00000037;
  CR_INVALID_REFERENCE_STRING = $00000038;
  CR_INVALID_CONFLICT_LIST = $00000039;
  CR_INVALID_INDEX = $0000003A;
  CR_INVALID_STRUCTURE_SIZE = $0000003B;
  NUM_CR_RESULTS = $0000003C;
  //
  // DevInst problem values, returned by call to CM_Get_DevInst_Status
  //
  CM_PROB_NOT_CONFIGURED = $00000001; // no config for device
{$EXTERNALSYM CM_PROB_NOT_CONFIGURED}
  CM_PROB_DEVLOADER_FAILED = $00000002; // service load failed
{$EXTERNALSYM CM_PROB_DEVLOADER_FAILED}
  CM_PROB_OUT_OF_MEMORY = $00000003; // out of memory
{$EXTERNALSYM CM_PROB_OUT_OF_MEMORY}
  CM_PROB_ENTRY_IS_WRONG_TYPE = $00000004; //
{$EXTERNALSYM CM_PROB_ENTRY_IS_WRONG_TYPE}
  CM_PROB_LACKED_ARBITRATOR = $00000005; //
{$EXTERNALSYM CM_PROB_LACKED_ARBITRATOR}
  CM_PROB_BOOT_CONFIG_CONFLICT = $00000006; // boot config conflict
{$EXTERNALSYM CM_PROB_BOOT_CONFIG_CONFLICT}
  CM_PROB_FAILED_FILTER = $00000007; //
{$EXTERNALSYM CM_PROB_FAILED_FILTER}
  CM_PROB_DEVLOADER_NOT_FOUND = $00000008; // Devloader not found
{$EXTERNALSYM CM_PROB_DEVLOADER_NOT_FOUND}
  CM_PROB_INVALID_DATA = $00000009; //
{$EXTERNALSYM CM_PROB_INVALID_DATA}
  CM_PROB_FAILED_START = $0000000A; //
{$EXTERNALSYM CM_PROB_FAILED_START}
  CM_PROB_LIAR = $0000000B; //
{$EXTERNALSYM CM_PROB_LIAR}
  CM_PROB_NORMAL_CONFLICT = $0000000C; // config conflict
{$EXTERNALSYM CM_PROB_NORMAL_CONFLICT}
  CM_PROB_NOT_VERIFIED = $0000000D; //
{$EXTERNALSYM CM_PROB_NOT_VERIFIED}
  CM_PROB_NEED_RESTART = $0000000E; // requires restart
{$EXTERNALSYM CM_PROB_NEED_RESTART}
  CM_PROB_REENUMERATION = $0000000F; //
{$EXTERNALSYM CM_PROB_REENUMERATION}
  CM_PROB_PARTIAL_LOG_CONF = $00000010; //
{$EXTERNALSYM CM_PROB_PARTIAL_LOG_CONF}
  CM_PROB_UNKNOWN_RESOURCE = $00000011; // unknown res type
{$EXTERNALSYM CM_PROB_UNKNOWN_RESOURCE}
  CM_PROB_REINSTALL = $00000012; //
{$EXTERNALSYM CM_PROB_REINSTALL}
  CM_PROB_REGISTRY = $00000013; //
{$EXTERNALSYM CM_PROB_REGISTRY}
  CM_PROB_VXDLDR = $00000014; // WINDOWS 95 ONLY
{$EXTERNALSYM CM_PROB_VXDLDR}
  CM_PROB_WILL_BE_REMOVED = $00000015; // devinst will remove
{$EXTERNALSYM CM_PROB_WILL_BE_REMOVED}
  CM_PROB_DISABLED = $00000016; // devinst is disabled
{$EXTERNALSYM CM_PROB_DISABLED}
  CM_PROB_DEVLOADER_NOT_READY = $00000017; // Devloader not ready
{$EXTERNALSYM CM_PROB_DEVLOADER_NOT_READY}
  CM_PROB_DEVICE_NOT_THERE = $00000018; // device doesn't exist
{$EXTERNALSYM CM_PROB_DEVICE_NOT_THERE}
  CM_PROB_MOVED = $00000019; //
{$EXTERNALSYM CM_PROB_MOVED}
  CM_PROB_TOO_EARLY = $0000001A; //
{$EXTERNALSYM CM_PROB_TOO_EARLY}
  CM_PROB_NO_VALID_LOG_CONF = $0000001B; // no valid log config
{$EXTERNALSYM CM_PROB_NO_VALID_LOG_CONF}
  CM_PROB_FAILED_INSTALL = $0000001C; // install failed
{$EXTERNALSYM CM_PROB_FAILED_INSTALL}
  CM_PROB_HARDWARE_DISABLED = $0000001D; // device disabled
{$EXTERNALSYM CM_PROB_HARDWARE_DISABLED}
  CM_PROB_CANT_SHARE_IRQ = $0000001E; // can't share IRQ
{$EXTERNALSYM CM_PROB_CANT_SHARE_IRQ}
  CM_PROB_FAILED_ADD = $0000001F; // driver failed add
{$EXTERNALSYM CM_PROB_FAILED_ADD}
  CM_PROB_DISABLED_SERVICE = $00000020; // service's Start = 4
{$EXTERNALSYM CM_PROB_DISABLED_SERVICE}
  CM_PROB_TRANSLATION_FAILED = $00000021; // resource translation failed
{$EXTERNALSYM CM_PROB_TRANSLATION_FAILED}
  CM_PROB_NO_SOFTCONFIG = $00000022; // no soft config
{$EXTERNALSYM CM_PROB_NO_SOFTCONFIG}
  CM_PROB_BIOS_TABLE = $00000023; // device missing in BIOS table
{$EXTERNALSYM CM_PROB_BIOS_TABLE}
  CM_PROB_IRQ_TRANSLATION_FAILED = $00000024; // IRQ translator failed
{$EXTERNALSYM CM_PROB_IRQ_TRANSLATION_FAILED}
  CM_PROB_FAILED_DRIVER_ENTRY = $00000025; // DriverEntry() failed.
{$EXTERNALSYM CM_PROB_FAILED_DRIVER_ENTRY}
  CM_PROB_DRIVER_FAILED_PRIOR_UNLOAD = $00000026;
  // Driver should have unloaded.
{$EXTERNALSYM CM_PROB_DRIVER_FAILED_PRIOR_UNLOAD}
  CM_PROB_DRIVER_FAILED_LOAD = $00000027; // Driver load unsuccessful.
{$EXTERNALSYM CM_PROB_DRIVER_FAILED_LOAD}
  CM_PROB_DRIVER_SERVICE_KEY_INVALID = $00000028;
  // Error accessing driver's service key
{$EXTERNALSYM CM_PROB_DRIVER_SERVICE_KEY_INVALID}
  CM_PROB_LEGACY_SERVICE_NO_DEVICES = $00000029;
  // Loaded legacy service created no devices
{$EXTERNALSYM CM_PROB_LEGACY_SERVICE_NO_DEVICES}
  CM_PROB_DUPLICATE_DEVICE = $0000002A;
  // Two devices were discovered with the same name
{$EXTERNALSYM CM_PROB_DUPLICATE_DEVICE}
  CM_PROB_FAILED_POST_START = $0000002B;
  // The drivers set the device state to failed
{$EXTERNALSYM CM_PROB_FAILED_POST_START}
  CM_PROB_HALTED = $0000002C; // This device was failed post start via usermode
{$EXTERNALSYM CM_PROB_HALTED}
  CM_PROB_PHANTOM = $0000002D;
  // The devinst currently exists only in the registry
{$EXTERNALSYM CM_PROB_PHANTOM}
  CM_PROB_SYSTEM_SHUTDOWN = $0000002E; // The system is shutting down
{$EXTERNALSYM CM_PROB_SYSTEM_SHUTDOWN}
  CM_PROB_HELD_FOR_EJECT = $0000002F; // The device is offline awaiting removal
{$EXTERNALSYM CM_PROB_HELD_FOR_EJECT}
  CM_PROB_DRIVER_BLOCKED = $00000030;
  // One or more drivers is blocked from loading
{$EXTERNALSYM CM_PROB_DRIVER_BLOCKED}
  CM_PROB_REGISTRY_TOO_LARGE = $00000031; // System hive has grown too large
{$EXTERNALSYM CM_PROB_REGISTRY_TOO_LARGE}
  NUM_CM_PROB = $00000032;
{$EXTERNALSYM NUM_CM_PROB}
  //
  // Configuration Manager Global State Flags (returned by CM_Get_Global_State)
  //
  CM_GLOBAL_STATE_CAN_DO_UI = $00000001; // Can  do UI?
{$EXTERNALSYM CM_GLOBAL_STATE_CAN_DO_UI}
  CM_GLOBAL_STATE_ON_BIG_STACK = $00000002; // WINDOWS 95 ONLY
{$EXTERNALSYM CM_GLOBAL_STATE_ON_BIG_STACK}
  CM_GLOBAL_STATE_SERVICES_AVAILABLE = $00000004; // CM APIs available?
{$EXTERNALSYM CM_GLOBAL_STATE_SERVICES_AVAILABLE}
  CM_GLOBAL_STATE_SHUTTING_DOWN = $00000008; // CM shutting down
{$EXTERNALSYM CM_GLOBAL_STATE_SHUTTING_DOWN}
  CM_GLOBAL_STATE_DETECTION_PENDING = $00000010; // detection pending
{$EXTERNALSYM CM_GLOBAL_STATE_DETECTION_PENDING}
//
  // Flags for CM_Get_Device_ID_List, CM_Get_Device_ID_List_Size
  //
  CM_GETIDLIST_FILTER_NONE = $00000000;
{$EXTERNALSYM CM_GETIDLIST_FILTER_NONE}
  CM_GETIDLIST_FILTER_ENUMERATOR = $00000001;
{$EXTERNALSYM CM_GETIDLIST_FILTER_ENUMERATOR}
  CM_GETIDLIST_FILTER_SERVICE = $00000002;
{$EXTERNALSYM CM_GETIDLIST_FILTER_SERVICE}
  CM_GETIDLIST_FILTER_EJECTRELATIONS = $00000004;
{$EXTERNALSYM CM_GETIDLIST_FILTER_EJECTRELATIONS}
  CM_GETIDLIST_FILTER_REMOVALRELATIONS = $00000008;
{$EXTERNALSYM CM_GETIDLIST_FILTER_REMOVALRELATIONS}
  CM_GETIDLIST_FILTER_POWERRELATIONS = $00000010;
{$EXTERNALSYM CM_GETIDLIST_FILTER_POWERRELATIONS}
  CM_GETIDLIST_FILTER_BUSRELATIONS = $00000020;
{$EXTERNALSYM CM_GETIDLIST_FILTER_BUSRELATIONS}
  CM_GETIDLIST_DONOTGENERATE = $10000040;
{$EXTERNALSYM CM_GETIDLIST_DONOTGENERATE}
  CM_GETIDLIST_FILTER_BITS = $1000007F;
{$EXTERNALSYM CM_GETIDLIST_FILTER_BITS}
//
  // Device Instance status flags, returned by call to CM_Get_DevInst_Status
  //
  DN_ROOT_ENUMERATED = $00000001; // Was enumerated by ROOT
{$EXTERNALSYM DN_ROOT_ENUMERATED}
  DN_DRIVER_LOADED = $00000002; // Has Register_Device_Driver
{$EXTERNALSYM DN_DRIVER_LOADED}
  DN_ENUM_LOADED = $00000004; // Has Register_Enumerator
{$EXTERNALSYM DN_ENUM_LOADED}
  DN_STARTED = $00000008; // Is currently configured
{$EXTERNALSYM DN_STARTED}
  DN_MANUAL = $00000010; // Manually installed
{$EXTERNALSYM DN_MANUAL}
  DN_NEED_TO_ENUM = $00000020; // May need reenumeration
{$EXTERNALSYM DN_NEED_TO_ENUM}
  DN_NOT_FIRST_TIME = $00000040; // Has received a config
{$EXTERNALSYM DN_NOT_FIRST_TIME}
  DN_HARDWARE_ENUM = $00000080; // Enum generates hardware ID
{$EXTERNALSYM DN_HARDWARE_ENUM}
  DN_LIAR = $00000100; // Lied about can reconfig once
{$EXTERNALSYM DN_LIAR}
  DN_HAS_MARK = $00000200; // Not CM_Create_DevInst lately
{$EXTERNALSYM DN_HAS_MARK}
  DN_HAS_PROBLEM = $00000400; // Need device installer
{$EXTERNALSYM DN_HAS_PROBLEM}
  DN_FILTERED = $00000800; // Is filtered
{$EXTERNALSYM DN_FILTERED}
  DN_MOVED = $00001000; // Has been moved
{$EXTERNALSYM DN_MOVED}
  DN_DISABLEABLE = $00002000; // Can be rebalanced
{$EXTERNALSYM DN_DISABLEABLE}
  DN_REMOVABLE = $00004000; // Can be removed
{$EXTERNALSYM DN_REMOVABLE}
  DN_PRIVATE_PROBLEM = $00008000; // Has a private problem
{$EXTERNALSYM DN_PRIVATE_PROBLEM}
  DN_MF_PARENT = $00010000; // Multi function parent
{$EXTERNALSYM DN_MF_PARENT}
  DN_MF_CHILD = $00020000; // Multi function child
{$EXTERNALSYM DN_MF_CHILD}
  DN_WILL_BE_REMOVED = $00040000; // DevInst is being removed
{$EXTERNALSYM DN_WILL_BE_REMOVED}
  //
  // Windows 4 OPK2 Flags
  //
  DN_NOT_FIRST_TIMEE = $00080000; // S: Has received a config enumerate
{$EXTERNALSYM DN_NOT_FIRST_TIMEE}
  DN_STOP_FREE_RES = $00100000; // S: When child is stopped, free resources
{$EXTERNALSYM DN_STOP_FREE_RES}
  DN_REBAL_CANDIDATE = $00200000; // S: Don't skip during rebalance
{$EXTERNALSYM DN_REBAL_CANDIDATE}
  DN_BAD_PARTIAL = $00400000;
  // S: This devnode's log_confs do not have same resources
{$EXTERNALSYM DN_BAD_PARTIAL}
  DN_NT_ENUMERATOR = $00800000; // S: This devnode's is an NT enumerator
{$EXTERNALSYM DN_NT_ENUMERATOR}
  DN_NT_DRIVER = $01000000; // S: This devnode's is an NT driver
{$EXTERNALSYM DN_NT_DRIVER}
  //
  // Windows 4.1 Flags
  //
  DN_NEEDS_LOCKING = $02000000; // S: Devnode need lock resume processing
{$EXTERNALSYM DN_NEEDS_LOCKING}
  DN_ARM_WAKEUP = $04000000; // S: Devnode can be the wakeup device
{$EXTERNALSYM DN_ARM_WAKEUP}
  DN_APM_ENUMERATOR = $08000000; // S: APM aware enumerator
{$EXTERNALSYM DN_APM_ENUMERATOR}
  DN_APM_DRIVER = $10000000; // S: APM aware driver
{$EXTERNALSYM DN_APM_DRIVER}
  DN_SILENT_INSTALL = $20000000; // S: Silent install
{$EXTERNALSYM DN_SILENT_INSTALL}
  DN_NO_SHOW_IN_DM = $40000000; // S: No show in device manager
{$EXTERNALSYM DN_NO_SHOW_IN_DM}
  DN_BOOT_LOG_PROB = $80000000;
  // S: Had a problem during preassignment of boot log conf
{$EXTERNALSYM DN_BOOT_LOG_PROB}
  //
  // Windows NT Flags
  //
  // These are overloaded on top of unused Win 9X flags
  //
  // DN_LIAR             = $00000100;           // Lied about can reconfig once
  DN_NEED_RESTART = DN_LIAR;
  // System needs to be restarted for this Devnode to work properly
{$EXTERNALSYM DN_NEED_RESTART}
  // DN_NOT_FIRST_TIME   = $00000040;           // Has Register_Enumerator
  DN_DRIVER_BLOCKED = DN_NOT_FIRST_TIME;
  // One or more drivers are blocked from loading for this Devnode
{$EXTERNALSYM DN_DRIVER_BLOCKED}
  // DN_MOVED            = $00001000;           // Has been moved
  DN_LEGACY_DRIVER = DN_MOVED; // This device is using a legacy driver
{$EXTERNALSYM DN_LEGACY_DRIVER}
  DN_CHANGEABLE_FLAGS = DWORD(DN_NOT_FIRST_TIME + DN_HARDWARE_ENUM + DN_HAS_MARK
    + DN_DISABLEABLE + DN_REMOVABLE + DN_MF_CHILD + DN_MF_PARENT +
    DN_NOT_FIRST_TIMEE + DN_STOP_FREE_RES + DN_REBAL_CANDIDATE +
    DN_NT_ENUMERATOR + DN_NT_DRIVER + DN_SILENT_INSTALL + DN_NO_SHOW_IN_DM);
{$EXTERNALSYM DN_CHANGEABLE_FLAGS}

type
  REGDISPOSITION = ^ULONG;
{$EXTERNALSYM REGDISPOSITION}

CONST
  //
  // Registry disposition values
  // (specified in call to CM_Open_DevNode_Key and CM_Open_Class_Key)
  //
  RegDisposition_OpenAlways = $00000000; // open if exists else create
{$EXTERNALSYM RegDisposition_OpenAlways}
  RegDisposition_OpenExisting = $00000001; // open key only if exists
{$EXTERNALSYM RegDisposition_OpenExisting}
  RegDisposition_Bits = $00000001;
{$EXTERNALSYM RegDisposition_Bits}
// *******************FUNCTIONS********************************************
  // *******************FUNCTIONS********************************************
  // *******************FUNCTIONS********************************************
  // *******************FUNCTIONS********************************************
  //
  /// ////////////////////////////////////
  // SetupDixxx  functions
  /// ////////////////////////////////////
  //
  // The SetupDiClassGuidsFromName function retrieves the GUID(s) associated with the specified class name. This list is built based on the classes currently installed on the system.
function SetupDiClassGuidsFromNameW(const ClassName: PWideChar;
  ClassGuidList: PGUID; ClassGuidListSize: DWORD; var RequiredSize: DWORD)
  : BOOL; stdcall; external 'SetupApi.dll';

// The SetupDiGetClassDevs function returns a handle to a device information set that contains requested device information elements for a local computer.
function SetupDiGetClassDevsW(ClassGuid: PGUID; const Enumerator: PWideChar;
  hwndParent: HWND; Flags: DWORD): HDEVINFO; stdcall; external 'SetupApi.dll';

// The SetupDiEnumDeviceInfo function returns a SP_DEVINFO_DATA structure that specifies a device information element in a device information set.
function SetupDiEnumDeviceInfo(DeviceInfoSet: HDEVINFO; MemberIndex: DWORD;
  var DeviceInfoData: TSPDevInfoData): BOOL; stdcall; external 'SetupApi.dll';

// The SetupDiEnumDeviceInterfaces function enumerates the device interfaces that are contained in a device information set.
function SetupDiEnumDeviceInterfaces(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; const InterfaceClassGuid: TGUID;
  MemberIndex: DWORD; var DeviceInterfaceData: TSPDeviceInterfaceData): BOOL;
  stdcall; external 'SetupApi.dll';

// The SetupDiGetDeviceInterfaceDetail function returns details about a device interface.
function SetupDiGetDeviceInterfaceDetailW(DeviceInfoSet: HDEVINFO;
  DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailDataW;
  DeviceInterfaceDetailDataSize: DWORD; var RequiredSize: DWORD;
  Device: PSPDevInfoData): BOOL; stdcall; external 'SetupApi.dll';

function SetupDiGetDeviceRegistryPropertyW(DeviceInfoSet: HDEVINFO;
  const DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  var PropertyRegDataType: DWORD; PropertyBuffer: PBYTE;
  PropertyBufferSize: DWORD; var RequiredSize: DWORD): BOOL; stdcall;
  external 'SetupApi.dll';

// The SetupDiOpenDevRegKey function opens a registry key for device-specific configuration information.
function SetupDiOpenDevRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Scope, HwProfile, KeyType: DWORD;
  samDesired: REGSAM): HKEY; stdcall; external 'SetupApi.dll';

// The SetupDiCallClassInstaller function calls the appropriate class installer, and any registered co-installers, with the specified installation request (DIF code).
function SetupDiCallClassInstaller(InstallFunction: Cardinal;
  DeviceInfoSet: HDEVINFO; DeviceInfoData: PSPDevInfoData): longbool; stdcall;
  external 'SetupApi.dll';

// SetupDiDestroyDeviceInfoList: Necesaria para destrurir el DevInfSet obtenido por SetupDiGetClassDevsA(
function SetupDiDestroyDeviceInfoList(DeviceInfoSet: HDEVINFO): longbool;
  stdcall; external 'SetupApi.dll';

function SetupDiGetClassDescriptionW(var ClassGuid: TGUID;
  ClassDescription: PWideChar; ClassDescriptionSize: DWORD;
  var RequiredSize: DWORD): BOOL; stdcall; external 'SetupApi.dll';

function SetupDiGetSelectedDriverW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataW): BOOL;
  stdcall; external 'SetupApi.dll';

function SetupDiGetDriverInfoDetailW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataW;
  DriverInfoDetailData: PSPDrvInfoDetailDataW; DriverInfoDetailDataSize: DWORD;
  RequiredSize: PDWORD): BOOL; stdcall; external 'SetupApi.dll';

// The SetupDiOpenClassRegKeyEx function opens the device setup class registry key, the device interface class registry key, or a specific class's subkey. This function opens the specified key on the local computer or on a remote computer.
function SetupDiOpenClassRegKeyExW(ClassGuid: PGUID; samDesired: REGSAM;
  Flags: DWORD; const MachineName: PWideChar; Reserved: Pointer): HKEY; stdcall;
  external 'SetupApi.dll';

function SetupDiGetDeviceInterfaceAlias(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData;
  var AliasInterfaceClassGuid: TGUID;
  var AliasDeviceInterfaceData: TSPDeviceInterfaceData): BOOL; stdcall;
  external 'SetupApi.dll';

function SetupDiRestartDevicesW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData): BOOL; stdcall; external 'SetupApi.dll';

//
/// ////////////////////////////////////
// CM_xxx functions
/// ////////////////////////////////////
//
function CM_Get_Parent(var dnDevInstParent: DevInst; dnDevInst: DevInst;
  ulFlags: ULONG): CONFIGRET; stdcall; external 'Cfgmgr32.dll';

function CM_Get_Device_ID(dnDevInst: DevInst; Buffer: PTSTR; BufferLen: ULONG;
  ulFlags: ULONG): CONFIGRET; stdcall; external 'Cfgmgr32.dll';

function CM_Get_Device_IDA(dnDevInst: DevInst; Buffer: PAnsiChar;
  BufferLen: ULONG; ulFlags: ULONG): CONFIGRET; stdcall;
  external 'Cfgmgr32.dll';

function CM_Get_Device_IDW(dnDevInst: DevInst; Buffer: PWideChar;
  BufferLen: ULONG; ulFlags: ULONG): CONFIGRET; stdcall;
  external 'Cfgmgr32.dll';

function CM_Get_Device_ID_Size(var ulLen: ULONG; dnDevInst: DevInst;
  ulFlags: ULONG): CONFIGRET; stdcall; external 'Cfgmgr32.dll';

function CM_Get_DevNode_Status(var ulStatus: ULONG; var ulProblemNumber: ULONG;
  dnDevInst: DevInst; ulFlags: ULONG): CONFIGRET; stdcall;
  external 'Cfgmgr32.dll';

function CM_Open_DevNode_Key(dnDevNode: DevInst; samDesired: REGSAM;
  ulHardwareProfile: ULONG; Disposition: REGDISPOSITION; var hkDevice: HKEY;
  ulFlags: ULONG): CONFIGRET; stdcall; external 'Cfgmgr32.dll';

function CM_Get_Device_ID_ListA(const pszFilter: PAnsiChar; // OPTIONAL
  Buffer: PAnsiChar; BufferLen: ULONG; ulFlags: ULONG): CONFIGRET; stdcall;
  external 'Cfgmgr32.dll';

function CM_Get_Device_ID_ListW(const pszFilter: PWideChar; // OPTIONAL
  Buffer: PWideChar; BufferLen: ULONG; ulFlags: ULONG): CONFIGRET; stdcall;
  external 'Cfgmgr32.dll';

function CM_Get_Device_ID_List(const pszFilter: PTSTR; // OPTIONAL
  Buffer: PTSTR; BufferLen: ULONG; ulFlags: ULONG): CONFIGRET; stdcall;
  external 'Cfgmgr32.dll';

function CM_Get_Device_ID_List_SizeA(var ulLen: ULONG;
  const pszFilter: PAnsiChar; // OPTIONAL
  ulFlags: ULONG): CONFIGRET; stdcall; external 'Cfgmgr32.dll';

function CM_Get_Device_ID_List_SizeW(var ulLen: ULONG;
  const pszFilter: PWideChar; // OPTIONAL
  ulFlags: ULONG): CONFIGRET; stdcall; external 'Cfgmgr32.dll';

function CM_Get_Device_ID_List_Size(var pulLen: ULONG; const pszFilter: PTSTR;
  // OPTIONAL
  ulFlags: ULONG): CONFIGRET; stdcall; external 'Cfgmgr32.dll';

implementation

end.
