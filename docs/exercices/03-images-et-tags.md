# Exercice 03 - Gérer les images Docker et leurs tags

## Objectifs

Distinguer une image d'un conteneur, lister et inspecter les images, créer et supprimer des tags, comprendre `latest`, nettoyer les images orphelines et publier une image sur Docker Hub.

## 1. Théorie : référence d'image et tag

Une référence d'image Docker peut contenir un registre, un espace de noms, un nom de dépôt et un tag :

```text
[registre/][espace-de-noms/]nom-image[:tag]
```

Exemples :

```text
ubuntu:24.04
nginx:latest
toolbox:1.0
rufus/toolbox:2.0
```

Dans `toolbox:1.0` :

- `toolbox` est le nom du dépôt d'image local.
- `1.0` est le tag.

Un tag est une référence lisible vers une image. Ajouter un tag ne reconstruit pas l'image et ne modifie pas son contenu. Plusieurs tags peuvent pointer vers le même `IMAGE ID`.

**Important :** `latest` est un tag conventionnel. Il n'est pas mis à jour automatiquement par Docker et ne signifie pas nécessairement « version la plus récente ». Il pointe vers l'image à laquelle quelqu'un a attribué ce tag.

Lorsque tu utilises un nom d'image sans tag, par exemple `docker run ubuntu`, Docker interprète la référence comme `ubuntu:latest`. Cela ne veut pas dire qu'un `docker build .` sans `-t` donnera automatiquement un tag `latest` : le résultat de ce build reste sans tag.

## 2. Image ou conteneur ?

Une image est le modèle utilisé pour créer un conteneur. Un conteneur est une instance créée à partir de cette image, avec son propre état d'exécution.

| Image | Conteneur |
|---|---|
| Modèle construit ou téléchargé | Instance créée à partir d'une image |
| Identifiée notamment par un ID et une ou plusieurs références | Identifiée par son ID et éventuellement son nom |
| Peut être réutilisée par plusieurs conteneurs | Peut être démarré, arrêté et supprimé |
| Se liste avec `docker image ls` | Se liste avec `docker ps -a` |

## 3. Commandes de gestion

Lister les images :

```bash
docker image ls
```

Lister également les images intermédiaires :

```bash
docker image ls -a
```

Inspecter une image :

```bash
docker image inspect ubuntu:24.04
```

Afficher uniquement son identifiant complet :

```bash
docker image inspect ubuntu:24.04 --format '{{.Id}}'
```

Supprimer un tag ou une image :

```bash
docker image rm NOM_IMAGE:TAG
```

Lister les images dangling :

```bash
docker image ls --filter dangling=true
```

Nettoyer les images dangling :

```bash
docker image prune
```

## 4. Construire volontairement une image sans tag

Crée un dossier réservé à cet exercice :

```bash
mkdir -p ~/docker-lab/toolbox-tags
cd ~/docker-lab/toolbox-tags
nano Dockerfile
```

Ajoute :

```dockerfile
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y curl
CMD ["bash"]
```

Enregistre le fichier. Vérifie son nom et son contenu :

```bash
ls -l
cat Dockerfile
```

Construis maintenant l'image **sans** `-t` :

```bash
docker build .
```

Affiche les images :

```bash
docker image ls -a
```

Puis affiche uniquement les images dangling :

```bash
docker image ls --filter dangling=true
```

### À observer

L'image construite peut apparaître avec une référence de type `<none>:<none>` dans la présentation classique du CLI. Certaines présentations récentes, notamment l'affichage de type Docker Desktop, utilisent plutôt `<untagged>`.

Ces deux présentations indiquent ici que l'image n'a pas de nom et de tag associés. L'image existe tout de même et possède un `IMAGE ID`.

Ne confonds pas cette situation avec une image supprimée : une image sans tag peut toujours être présente dans le magasin local.

## 5. Retagger l'image avec son IMAGE ID

Repère la ligne correspondant à l'image que tu viens de construire. Copie son `IMAGE ID`, puis utilise-le à la place de `ID_DE_TON_IMAGE` dans la commande suivante :

```bash
docker image tag ID_DE_TON_IMAGE toolbox:1.0
```

`ID_DE_TON_IMAGE` est un texte de remplacement : ne tape pas les mots ni les chevrons. Utilise l'identifiant affiché sur ta machine.

Vérifie :

```bash
docker image ls
```

L'image doit maintenant avoir le tag `toolbox:1.0`.

## 6. Construire une deuxième version avec un tag

Dans le même dossier, reconstruis l'image en donnant directement un tag :

```bash
docker build -t toolbox:2.0 .
```

Compare les deux versions :

```bash
docker image ls
```

Inspecte les identifiants :

```bash
docker image inspect toolbox:1.0 --format '{{.Id}}'
docker image inspect toolbox:2.0 --format '{{.Id}}'
```

Si les identifiants sont identiques, les deux tags désignent la même image. S'ils sont différents, cela peut venir d'une différence dans le contenu construit, dans l'image de base ou dans les métadonnées de build. Ne conclus pas uniquement à partir du numéro de version inscrit dans le tag.

### Attention aux noms proches

`toolbox:1.0` et `docker-network-toolkit/toolbox:1.0` sont deux références différentes. Le deuxième nom comprend un espace de noms supplémentaire. Le fait qu'elles contiennent toutes les deux le mot `toolbox` ne signifie pas qu'elles désignent la même image.

## 7. Ajouter le tag `latest`

Attribue le tag `latest` à la version 2.0 :

```bash
docker image tag toolbox:2.0 toolbox:latest
```

Vérifie les trois références :

```bash
docker image ls
```

Tu dois retrouver les références `toolbox:1.0`, `toolbox:2.0` et `toolbox:latest`.

Lance la version 1.0 :

```bash
docker run -it toolbox:1.0
```

Dans le conteneur, affiche la version d'Ubuntu et celle de curl :

```bash
cat /etc/os-release
curl --version
```

Quitte le shell :

```bash
exit
```

Lance ensuite l'image sans préciser le tag :

```bash
docker run -it toolbox
```

Docker utilise alors la référence `toolbox:latest`. Affiche les mêmes informations et quitte avec `exit`.

**À comparer :** les deux conteneurs proviennent-ils de la même image ? Vérifie les `IMAGE ID` plutôt que de te fier uniquement aux noms des tags.

## 8. Supprimer un tag et nettoyer

Supprime uniquement le tag `1.0` :

```bash
docker image rm toolbox:1.0
```

Affiche les images :

```bash
docker image ls
```

Si les tags `2.0` ou `latest` pointent encore vers la même image, le contenu de l'image peut être conservé. La commande a retiré une référence, pas nécessairement toutes les références de l'image.

Nettoie ensuite les images dangling :

```bash
docker image prune
```

Docker demande une confirmation. Lis le message puis réponds `y` si tu souhaites réellement effectuer le nettoyage.

La commande `docker image prune` supprime les images dangling non référencées par des conteneurs. L'option `-a` est plus large et supprime aussi les images inutilisées qui possèdent encore un tag. Pour cet exercice, **n'utilise pas `-a`**.

## 9. Publication sur Docker Hub

Publier une image la rend accessible depuis un registre. Le nom distant doit inclure ton identifiant Docker Hub.

Connecte-toi :

```bash
docker login
```

Docker Hub peut proposer une connexion par navigateur et code à usage unique. Ne partage jamais ce code.

Définis une variable contenant ton identifiant Docker Hub :

```bash
DOCKERHUB_USER="ton-identifiant-docker-hub"
```

Retague l'image :

```bash
docker image tag toolbox:2.0 "$DOCKERHUB_USER/toolbox:2.0"
```

Envoie-la :

```bash
docker image push "$DOCKERHUB_USER/toolbox:2.0"
```

Vérifie sur [Docker Hub](https://hub.docker.com/) que le dépôt et le tag sont visibles dans ton compte. Avant de publier, confirme que l'image ne contient aucun secret, fichier personnel ou donnée de l'école qui ne doit pas être publique.

## 10. Questions à compléter

**10.1** Explique la différence entre une image Docker et un conteneur.

Réponse :


**10.2** Quelle commande liste les images locales ?

Réponse :


**10.3** Quelle commande inspecte une image ?

Réponse :


**10.4** Quelle commande supprime un tag ?

Réponse :


**10.5** Que signifie `<none>:<none>` ou `<untagged>` ?

Réponse :


**10.6** Que fait `docker tag` ? Est-ce que cette commande reconstruit l'image ?

Réponse :


**10.7** Quelle différence y a-t-il entre `latest` et un numéro de version ?

Réponse :


**10.8** Pourquoi faut-il éviter de déployer aveuglément une image avec le tag `latest` en production ?

Réponse :


## 11. Commandes à retenir

| Besoin | Commande |
|---|---|
| Construire avec un tag | `docker build -t toolbox:1.0 .` |
| Lister | `docker image ls` |
| Inspecter | `docker image inspect toolbox:1.0` |
| Ajouter un tag | `docker image tag toolbox:1.0 toolbox:2.0` |
| Supprimer un tag | `docker image rm toolbox:1.0` |
| Afficher les dangling | `docker image ls --filter dangling=true` |
| Nettoyer les dangling | `docker image prune` |
| Se connecter au registre | `docker login` |
| Publier | `docker image push utilisateur/toolbox:2.0` |

## Références

- [Docker image ls](https://docs.docker.com/reference/cli/docker/image/ls/)
- [Docker image tag](https://docs.docker.com/reference/cli/docker/image/tag/)
- [Docker image rm](https://docs.docker.com/reference/cli/docker/image/rm/)
- [Docker image prune](https://docs.docker.com/reference/cli/docker/image/prune/)
- [Docker login](https://docs.docker.com/reference/cli/docker/login/)
- [Docker image push](https://docs.docker.com/reference/cli/docker/image/push/)
