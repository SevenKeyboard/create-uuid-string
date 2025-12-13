#Requires AutoHotkey v2.0.0+
;==============================================================
; CreateUuidString — UUID string generator using Win32 RPC APIs
;
; GitHub: https://github.com/SevenKeyboard/create-uuid-string
; Author: SevenKeyboard Ltd. (2025)
; License: The Unlicense
;
; Documentation / References:
;   UuidCreate function (rpcdce.h):
;     https://learn.microsoft.com/en-us/windows/win32/api/rpcdce/nf-rpcdce-uuidcreate
;   UuidToString function (rpcdce.h):
;     https://learn.microsoft.com/en-us/windows/win32/api/rpcdce/nf-rpcdce-uuidtostring
;   RpcStringFree function (rpcdce.h):
;     https://learn.microsoft.com/en-us/windows/win32/api/rpcdce/nf-rpcdce-rpcstringfree
;=====================
class VersionManager_createUuidString
{
    static _ := this._init()
    static _init()    {
        global
        CREATEUUIDSTRING_VERSION := "1.0.0"
    }
}
createUuidString(&rpcStatusUC:="", &rpcStatusUTS:="")    {
    static RPC_S_OK:=0
        ,RPC_S_UUID_LOCAL_ONLY:=1824
        ,RPC_S_UUID_NO_ADDRESS:=1739
        ,RPC_S_OUT_OF_MEMORY:=14
    rpcStatusUC:= rpcStatusUTS:= ""
    uuid:=buffer(16,0)
    rpcStatusUC:=dllCall("Rpcrt4.dll\UuidCreate", "Ptr",uuid.Ptr, "Int")
    if (rpcStatusUC!==RPC_S_UUID_NO_ADDRESS)    {
        rpcStatusUTS:=dllCall("Rpcrt4.dll\UuidToString", "Ptr",uuid.Ptr, "Ptr*",&stringUuid:=0, "Int")
        if (rpcStatusUTS==RPC_S_OK)    {
            uuidStr:=strGet(stringUuid)
            dllCall("Rpcrt4.dll\RpcStringFree", "Ptr*",&stringUuid, "Int")
            return uuidStr
        }
    }
}