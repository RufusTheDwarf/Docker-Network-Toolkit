# Exercice 02 - Construire une image Docker avec un Dockerfile

## Objectifs

Créer un Dockerfile, comprendre les instructions `FROM`, `RUN` et `CMD`, construire une image personnalisée et vérifier les outils installés dans un conteneur.

## 1. Théorie : image, conteneur et Dockerfile

Une **image** est un modèle en lecture seule qui contient les fichiers et dépendances nécessaires à l'exécution d'un environnement. Un **conteneur** est une instance créée à partir d'une image. Plusieurs conteneurs peuvent utiliser la même image.

Un **Dockerfile** est un fichier texte qui décrit les étapes de construction d'une image. Il ne s'exécute pas comme un programme Linux classique : Docker lit ses instructions pendant le build.

Les instructions utilisées ici :

| Instruction | Rôle | Moment |
|---|---|---|
| `FROM` | Choisit l'image de base | Début du build |
| `RUN` | Exécute une commande et enregistre son résultat dans une couche | Pendant le build |
| `CMD` | Définit la commande par défaut du conteneur | Au démarrage du conteneur |

Le point `.` à la fin de `docker build` désigne le **contexte de build** : le dossier dont les fichiers peuvent être utilisés par le constructeur.

## 2. Créer le Dockerfile

Crée un dossier indépendant pour cet exercice :

```bash
mkdir -p ~/docker-lab/network-utils
cd ~/docker-lab/network-utils
nano Dockerfile
```

Inscris exactement :

```dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y nmap iproute2 iputils-ping
CMD ["bash"]
```

Enregistre avec `Ctrl + O`, confirme avec `Entrée`, puis quitte avec `Ctrl + X`.

Vérifie le nom du fichier et son contenu :

```bash
ls -l
cat Dockerfile
```

Le nom doit être exactement `Dockerfile`, sans extension `.txt`.

## 3. Comprendre chaque ligne

### `FROM ubuntu:latest`

Docker utilise l'image Ubuntu comme point de départ. `latest` est un tag, pas une garantie que l'image soit la plus récente au sens chronologique. Pour un projet reproductible, il est préférable de choisir une version précise d'Ubuntu plutôt qu'un tag flottant.

### `RUN apt-get update && apt-get install -y nmap iproute2 iputils-ping`

Cette commande est exécutée pendant le build.

- `apt-get update` actualise l'index des paquets disponibles.
- `apt-get install` installe les paquets demandés.
- `-y` répond automatiquement oui aux confirmations d'installation.
- `&&` lance la deuxième commande uniquement si la première réussit.

Les paquets apportent les commandes suivantes :

| Paquet | Outil principal | Utilité |
|---|---|---|
| `nmap` | `nmap` | Découverte et diagnostic réseau |
| `iproute2` | `ip` | Interfaces, adresses et routes IP |
| `iputils-ping` | `ping` | Test de connectivité ICMP |

### `CMD ["bash"]`

Bash est la commande par défaut du conteneur. En mode interactif, tu peux ouvrir un shell. En mode détaché sans entrée ouverte, Bash peut se terminer immédiatement. C'est pour cela que le lancement de cette fiche utilise `-dit`.

## 4. Construire l'image

Depuis le dossier qui contient le Dockerfile, exécute :

```bash
docker build -t network-utils:latest .
```

Décomposition :

| Élément | Rôle |
|---|---|
| `docker build` | Construit une image |
| `-t` | Ajoute un nom et un tag à l'image |
| `network-utils` | Nom de l'image |
| `latest` | Tag de cette image |
| `.` | Dossier utilisé comme contexte de build |

Vérifie que l'image existe :

```bash
docker image ls
```

Tu dois retrouver `network-utils` avec le tag `latest`.

Tu peux aussi afficher les détails :

```bash
docker image inspect network-utils:latest
```

## 5. Lancer le conteneur en arrière-plan

Crée et démarre le conteneur :

```bash
docker run -dit --name network-utils-lab network-utils:latest
```

Les options sont combinées :

- `-d` : détache le conteneur du terminal et le laisse fonctionner en arrière-plan.
- `-i` : garde l'entrée standard ouverte.
- `-t` : alloue un terminal virtuel.
- `--name network-utils-lab` : donne un nom lisible au conteneur.

Le nom `network-utils-lab` évite de remplacer ou de réutiliser par erreur un conteneur nommé `network-utils` déjà présent sur ta machine.

Vérifie son état :

```bash
docker ps
```

Il doit apparaître avec un statut `Up`. S'il est absent, vérifie aussi les conteneurs arrêtés :

```bash
docker ps -a
```

## 6. Vérifier les outils sans entrer dans le conteneur

`docker exec` exécute une commande dans un conteneur déjà démarré.

Tester Nmap :

```bash
docker exec network-utils-lab nmap -h
```

Résultat attendu : l'aide de Nmap et ses options s'affichent.

Tester les interfaces réseau :

```bash
docker exec network-utils-lab ip a
```

Résultat attendu : les interfaces du conteneur et leurs adresses sont affichées.

Tester Ping :

```bash
docker exec network-utils-lab ping -c 1 8.8.8.8
```

Résultat attendu : une tentative d'envoi d'un paquet ICMP vers `8.8.8.8`. Une réponse dépend de la connectivité et des règles réseau. Un ping bloqué ne prouve pas à lui seul que le paquet `iputils-ping` est absent.

Vérifie que le conteneur est toujours actif :

```bash
docker ps
```

## 7. À faire seul

1. Affiche les images disponibles et retrouve `network-utils:latest`.
2. Affiche les informations détaillées du conteneur.
3. Exécute `ip route` dans le conteneur.
4. Compare `ip a` dans la VM Linux et `ip a` dans le conteneur.
5. Explique pourquoi les deux sorties ne sont pas nécessairement identiques.

Commandes utiles :

```bash
docker inspect network-utils-lab
docker exec network-utils-lab ip route
ip a
```

## 8. Questions à compléter

**8.1** À quel moment `RUN` est-il exécuté ?

Réponse :


**8.2** À quel moment `CMD` est-il exécuté ?

Réponse :


**8.3** À quoi sert le point `.` dans `docker build -t network-utils:latest .` ?

Réponse :


**8.4** Pourquoi utilise-t-on `-dit` pour cette image ?

Réponse :


**8.5** Quelle différence y a-t-il entre `docker exec` et `docker run` ?

Réponse :


## 9. Nettoyage

Ne supprime pas `network-utils-lab` si une fiche suivante en a besoin. Pour arrêter le conteneur :

```bash
docker stop network-utils-lab
```

Pour le redémarrer :

```bash
docker start network-utils-lab
```

Pour le supprimer définitivement après les exercices :

```bash
docker rm -f network-utils-lab
```

La suppression du conteneur ne supprime pas automatiquement l'image `network-utils:latest`.

## Références

- [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [Docker build](https://docs.docker.com/reference/cli/docker/image/build/)
- [Build context](https://docs.docker.com/build/concepts/context/)
- [Docker container run](https://docs.docker.com/reference/cli/docker/container/run/)
- [Docker container exec](https://docs.docker.com/reference/cli/docker/container/exec/)
