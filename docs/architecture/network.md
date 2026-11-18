
## 11. Accès depuis le poste hôte

Un test de connectivité a été effectué depuis Windows PowerShell.

| Élément | Valeur |
|---|---|
| Interface Windows | VMware Network Adapter VMnet8 |
| Adresse source | 192.168.196.1 |
| Adresse destination | 192.168.196.131 |
| Port distant | TCP 8080 |
| Résultat | TcpTestSucceeded: True |

Le serveur Nginx est donc accessible depuis le poste hôte à l'adresse :

http://192.168.196.131:8080

Le test confirme la communication entre le poste Windows et le serveur web
hébergé dans un conteneur Docker sur la machine virtuelle.
