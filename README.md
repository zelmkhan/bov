# Bov

Bov is a node responsible for transmitting encrypted messages between clients. The name Bov comes from the Chechen word for watchtower, which reflects its role as a passive, secure relay — hereafter referred to as the Tower.

🛡️ Key Principles
End-to-End Encryption:
The Tower cannot decrypt messages — even if it wanted to. Its sole purpose is to forward encrypted messages from sender to recipient.

No Data Retention:
The Tower does not store user messages, except in one case:
If the recipient is offline, the message is temporarily stored in a queue called a Stop — similar to a bus stop where the message waits until the recipient "arrives" (comes online). Once delivered, the message is deleted permanently and leaves no trace in the system.

Authentication Protocol:
When a client connects to the network, the Tower initiates an authentication challenge. It sends a secret that the client must sign using their private key.
This signature proves the client controls the corresponding public key and is eligible to receive messages.

🕸️ Future Plans: Decentralization
In future versions, the Tower will evolve into a decentralized network of nodes, improving:

* Security

* Reliability

* Fault tolerance
by eliminating the single point of failure.

🔐 Summary
* Bov acts as a secure, passive message relay.

* It never has access to plaintext messages.

* It stores data only temporarily, and only when necessary.

* Authentication is based on public-key cryptography.

* Decentralization is part of the roadmap.