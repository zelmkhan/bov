// Data
# [0, ...]
0 - Channel type, ...Signature,

# [1, [...], [...]]
1 - Channel type, ...Message, ...Message



// Responses
# [2, 0]
2 (success), 1 (Auth successfull)

# [2, 1]
2 (success), 1 (client online, message sent to client)

# [2, 2]
2 (success), 1 (client offlain, message added to Busstop)

# [4, 0]
4 (error), 0 (Invalid Auth)

# [4, 1]
4 (error), 0 (Message has not been sent)