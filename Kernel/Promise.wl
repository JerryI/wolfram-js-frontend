hashTable = <||>

Promise[] := With[{uid = CreateUUID},
    hashTable[uid] = Promise[<|"Resolve"->, "Reject"->, "UID"->uid|>]
]

Promise[uid_String]["Resolve"][data_] := hashTable[]