# Parcours d'exercices Docker et réseau

Ce dossier regroupe des fiches progressives pour apprendre Linux, Docker et les bases du diagnostic réseau. Chaque fiche mélange une courte partie théorique, des commandes expliquées, une mise en pratique et des questions à compléter.

Les exercices sont conçus pour être réalisés dans une machine virtuelle Linux avec Docker Engine opérationnel. Les commandes sont écrites pour Bash. Selon la configuration de la machine, il peut être nécessaire d'utiliser `sudo` devant les commandes Docker. Dans ce cas, garde la même méthode pendant tout l'exercice et vérifie que tu utilises le bon moteur Docker.

## Ordre conseillé

| Fiche | Sujet | Résultat attendu |
|---|---|---|
| [01 - Linux et terminal](01-linux-terminal-et-fichiers.md) | Navigation, fichiers, chemins et éditeur de texte | Savoir préparer un dossier de travail et créer un fichier |
| [02 - Construire une image](02-construire-une-image-docker.md) | Dockerfile, build, image de base et conteneur | Construire et vérifier `network-utils:latest` |
| [03 - Images et tags](03-images-et-tags.md) | Image ID, tags, `latest`, suppression et Docker Hub | Gérer plusieurs références d'une image |
| [04 - Cycle de vie des conteneurs](04-conteneurs-cycle-de-vie.md) | `run`, `ps`, `exec`, `logs`, `stop`, `start` et `rm` | Administrer un conteneur sans confondre image et conteneur |
| [05 - Réseaux Docker](05-reseaux-docker.md) | Bridge, adresses IP, DNS et communication entre conteneurs | Faire communiquer deux conteneurs sur un réseau de laboratoire |
| [Fiche de compte rendu](fiche-compte-rendu.md) | Modèle à compléter | Garder une trace des commandes, résultats et explications |
| [Aide-mémoire](aide-memoire-commandes.txt) | Commandes courantes | Retrouver rapidement une commande |

## Comment travailler avec les fiches

1. Lire la partie **Théorie** avant de taper les commandes.
2. Exécuter les commandes une par une, dans l'ordre.
3. Lire le résultat avant de continuer. Ne copie pas une commande si tu ne sais pas dans quel dossier tu te trouves.
4. Compléter les parties **À observer** et **À expliquer** avec tes propres résultats.
5. En cas d'erreur, conserver le message exact et chercher sa cause avant de supprimer des images ou des conteneurs.
6. Garder les éléments réutilisés par la fiche suivante. Une fiche indique clairement lorsqu'un nettoyage est nécessaire.

## Préparer le laboratoire

Avant de commencer, vérifie que Docker répond :

```bash
docker --version
docker info
docker image ls
```

Si `docker info` renvoie une erreur de permission, utilise la méthode prévue par ton installation, souvent `sudo docker info` sur une installation Linux classique. Si le service Docker n'est pas démarré, vérifie son état avec :

```bash
sudo systemctl status docker
```

Cette dernière commande concerne les distributions utilisant `systemd`. Ne lance pas de commande `systemctl` dans un environnement qui ne l'utilise pas.

## Règles de sécurité et de nettoyage

- Effectuer les scans et tests réseau uniquement sur les machines et réseaux du laboratoire ou sur des cibles pour lesquelles tu as une autorisation.
- Ne jamais publier de mot de passe, jeton, clé privée ou fichier contenant des secrets.
- Ne pas utiliser `docker system prune -a` pour faire du ménage sans avoir compris ce qui sera supprimé.
- `docker image prune` cible les images dangling. L'option `-a` élargit le nettoyage aux images inutilisées, même si elles ont un tag.
- Une image utilisée par un conteneur peut rester présente même après la suppression d'un tag.
- Avant de supprimer un conteneur, vérifier son nom et son état avec `docker ps -a`.

## Références officielles

- [Docker CLI](https://docs.docker.com/reference/cli/docker/)
- [Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [Build context](https://docs.docker.com/build/concepts/context/)
- [Docker image ls](https://docs.docker.com/reference/cli/docker/image/ls/)
- [Docker image tag](https://docs.docker.com/reference/cli/docker/image/tag/)
- [Docker image prune](https://docs.docker.com/reference/cli/docker/image/prune/)
- [Docker container run](https://docs.docker.com/reference/cli/docker/container/run/)
- [Docker networking](https://docs.docker.com/engine/network/)
- [Bridge network driver](https://docs.docker.com/engine/network/drivers/bridge/)
- [Docker login](https://docs.docker.com/reference/cli/docker/login/)
- [Docker image push](https://docs.docker.com/reference/cli/docker/image/push/)
