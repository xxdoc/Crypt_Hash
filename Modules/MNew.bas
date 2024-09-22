Attribute VB_Name = "MNew"
Option Explicit

Public Function CRC32(aHashAlgo As ECRC32Algo) As CRC32
    Set CRC32 = New CRC32: CRC32.New_ aHashAlgo
End Function

Public Function MSCrypt(ByVal alg As EHashAlgo) As MSCrypt
    Set MSCrypt = New MSCrypt: MSCrypt.New_ alg
End Function

Public Function MSBCrypt(ByVal alg As EHashAlgo) As MSBCrypt
    Set MSBCrypt = New MSBCrypt: MSBCrypt.New_ alg
End Function

