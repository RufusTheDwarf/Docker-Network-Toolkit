# Exercice 04 - Comprendre le cycle de vie d'un conteneur

## Objectifs

Créer un conteneur, lister les conteneurs actifs et arrêtés, exécuter une commande dans un conteneur existant, consulter ses journaux, l'arrêter, le redémarrer et le supprimer.

## 1. Théorie : un conteneur exécute un processus

Une image est un modèle. Un conteneur est une instance de ce modèle avec une configuration et un état d'exécution propres.

Un conteneur reste actif tant que son processus principal fonctionne. Le mode détaché `-d` ne maintient pas artificiellement le conteneur en vie : il libère simplement le terminal. Si le processus principal se termine, le conteneur s'arrête également.

Dans l'image `network-utils`, la commande par défaut est `bash`. Un Bash lancé sans session interactive peut se terminer lorsqu'il reçoit une entrée vide. Les options `-i` et `-t` permettent de garder une entrée ouverte et de créer un terminal virtuel.

## 2. Créer un conteneur

Cette fiche suppose que l'image `network-utils:latest` a été construite dans l'exercice précédent.

Vérifie :

```bash
docker image ls network-utils
```

Crée un conteneur en arrière-plan :

```bash
docker run -dit --name toolbox-session network-utils:latest
```

Si ce nom existe déjà, choisis un autre nom, par exemple `toolbox-session-2`. Ne supprime pas un conteneur existant sans avoir vérifié à quoi il sert.

## 3. Lister et comprendre l'état

Afficher uniquement les conteneurs actifs :

```bash
docker ps
```

Afficher tous les conteneurs, y compris ceux qui sont arrêtés :

```bash
docker ps -a
```

La colonne `STATUS` indique par exemple `Up` pour un conteneur actif ou `Exited` pour un conteneur arrêté.

## 4. Exécuter une commande avec `docker exec`

`docker exec` ne crée pas un nouveau conteneur. Il lance une commande dans un conteneur déjà actif.

Exécuter une commande simple :

```bash
docker exec toolbox-session ip a
```

Ouvrir un shell interactif :

```bash
docker exec -it toolbox-session bash
```

Dans le conteneur, exécute :

```bash
pwd
ip route
nmap -h
```

Quitte le shell secondaire avec :

```bash
exit
```

Le conteneur principal doit rester actif, car tu as quitté le processus lancé par `docker exec`, pas le Bash principal du conteneur.

## 5. Consulter les journaux et les détails

Afficher les journaux du conteneur :

```bash
docker logs toolbox-session
```

Afficher les journaux en continu :

```bash
docker logs -f toolbox-session
```

Pour quitter l'affichage continu, utilise `Ctrl + C`. Cette action arrête l'affichage des logs, pas le conteneur.

Inspecter la configuration complète :

```bash
docker inspect toolbox-session
```

Afficher uniquement l'adresse IP attribuée au conteneur sur son réseau principal :

```bash
docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' toolbox-session
```

## 6. Arrêter et redémarrer

Arrêter proprement le conteneur :

```bash
docker stop toolbox-session
```

Vérifier son état :

```bash
docker ps -a
```

Le conteneur doit maintenant être arrêté. Le redémarrer :

```bash
docker start toolbox-session
```

Vérifier :

```bash
docker ps
```

## 7. Supprimer un conteneur

Supprimer un conteneur arrêté :

```bash
docker rm toolbox-session
```

Si le conteneur est actif, il faut l'arrêter avant de le supprimer :

```bash
docker stop toolbox-session
docker rm toolbox-session
```

La variante `docker rm -f toolbox-session` force l'arrêt et la suppression. Ne l'utilise que si tu as vérifié le nom et que tu acceptes de supprimer ce conteneur.

La suppression du conteneur ne supprime pas automatiquement l'image utilisée pour le créer.

## 8. Exercice sans modèle

1. Crée un conteneur `session-revision` à partir de `network-utils:latest` en mode détaché avec entrée ouverte et terminal.
2. Vérifie qu'il est actif.
3. Affiche ses interfaces réseau avec `docker exec`.
4. Ouvre un Bash à l'intérieur du conteneur.
5. Quitte le Bash ouvert par `docker exec` et vérifie que le conteneur est toujours actif.
6. Arrête le conteneur, puis redémarre-le.
7. Supprime uniquement le conteneur que tu viens de créer.

## 9. Questions à compléter

**9.1** Quelle différence y a-t-il entre `docker run` et `docker exec` ?

Réponse :


**9.2** Quelle différence y a-t-il entre `docker ps` et `docker ps -a` ?

Réponse :


**9.3** Qu'est-ce qui détermine si un conteneur reste actif ?

Réponse :


**9.4** Est-ce que `docker rm` supprime aussi l'image ? Explique.

Réponse :


## Références

- [Docker container run](https://docs.docker.com/reference/cli/docker/container/run/)
- [Docker container exec](https://docs.docker.com/reference/cli/docker/container/exec/)
- [Docker container ls](https://docs.docker.com/reference/cli/docker/container/ls/)
- [Docker container logs](https://docs.docker.com/reference/cli/docker/container/logs/)
- [Docker container stop](https://docs.docker.com/reference/cli/docker/container/stop/)
- [Docker container start](https://docs.docker.com/reference/cli/docker/container/start/)
- [Docker container rm](https://docs.docker.com/reference/cli/docker/container/rm/)
