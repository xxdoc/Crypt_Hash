Attribute VB_Name = "MNew"
Option Explicit

Public Function MSCrypt(ByVal alg As EHashAlgo) As MSCrypt
    Set MSCrypt = New MSCrypt: MSCrypt.New_ alg
End Function
