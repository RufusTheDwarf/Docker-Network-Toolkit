# Exercice 05 - Créer un réseau Docker et tester la communication

## Objectifs

Créer un réseau Docker de type bridge, connecter plusieurs conteneurs, observer leurs adresses IP, tester la résolution DNS par nom de conteneur et vérifier la connectivité.

## 1. Théorie : pourquoi un réseau Docker ?

Docker peut connecter les conteneurs à des réseaux virtuels. Un réseau de type **bridge** fournit une connectivité entre les conteneurs qui y sont raccordés.

Un réseau bridge défini par l'utilisateur apporte notamment une résolution DNS automatique entre les conteneurs par leur nom ou alias. C'est une raison importante de préférer un réseau personnalisé au réseau `bridge` par défaut pour un laboratoire.

Les notions à distinguer :

- **Adresse IP** : identifie une interface sur un réseau IP.
- **Sous-réseau** : plage d'adresses associée à un réseau.
- **Passerelle** : point de sortie vers un autre réseau.
- **DNS** : associe un nom à une adresse IP.
- **Port** : identifie un service sur une machine ou une adresse IP.
- **Port publié** : fait correspondre un port de l'hôte à un port du conteneur.

Les conteneurs d'un même réseau bridge peuvent communiquer directement entre eux. Il n'est pas nécessaire de publier un port pour chaque communication interne.

## 2. Vérifier l'image nécessaire

Les deux conteneurs de cet exercice utilisent l'image créée dans la fiche précédente :

```bash
docker image ls network-utils
```

Si elle n'existe pas, termine d'abord l'exercice de construction d'image.

## 3. Créer un réseau personnalisé

Crée le réseau :

```bash
docker network create lab-net
```

Liste les réseaux :

```bash
docker network ls
```

Inspecte le réseau :

```bash
docker network inspect lab-net
```

Observe le driver, le sous-réseau et la passerelle. Docker choisit automatiquement une plage d'adresses si tu ne lui en imposes pas une.

## 4. Démarrer deux conteneurs sur ce réseau

Démarre le premier conteneur :

```bash
docker run -dit --name net-a --network lab-net network-utils:latest
```

Démarre le second :

```bash
docker run -dit --name net-b --network lab-net network-utils:latest
```

Vérifie les conteneurs actifs :

```bash
docker ps
```

Inspecte à nouveau le réseau :

```bash
docker network inspect lab-net
```

Tu dois retrouver `net-a` et `net-b` dans la liste des conteneurs connectés.

## 5. Observer les adresses et les routes

Dans `net-a` :

```bash
docker exec net-a ip a
docker exec net-a ip route
```

Dans `net-b` :

```bash
docker exec net-b ip a
docker exec net-b ip route
```

Note les adresses attribuées. Les adresses peuvent changer si les conteneurs ou le réseau sont recréés.

## 6. Tester la communication par nom

Depuis `net-a`, teste la connectivité vers `net-b` :

```bash
docker exec net-a ping -c 2 net-b
```

Le nom `net-b` doit être résolu par le DNS du réseau bridge personnalisé. Le ping peut toutefois être bloqué dans certaines configurations. Dans ce cas, observe d'abord si le nom est résolu et examine les adresses et routes avant de conclure à une panne DNS.

Tu peux afficher les informations du réseau et des conteneurs avec :

```bash
docker network inspect lab-net
docker inspect net-a
docker inspect net-b
```

## 7. Tester la séparation des réseaux

Crée un deuxième réseau :

```bash
docker network create lab-isole
```

Démarre un troisième conteneur sur ce réseau :

```bash
docker run -dit --name net-c --network lab-isole network-utils:latest
```

Inspecte les deux réseaux :

```bash
docker network inspect lab-net
docker network inspect lab-isole
```

`net-c` n'appartient pas au réseau `lab-net`. Il ne bénéficie donc pas de la connectivité directe fournie par ce réseau.

Tu peux ajouter `net-c` à `lab-net` pour observer le changement :

```bash
docker network connect lab-net net-c
```

Vérifie l'appartenance aux réseaux avec `docker network inspect lab-net`.

## 8. Exercice sans modèle

1. Relève le sous-réseau et la passerelle de `lab-net`.
2. Relève les adresses IP de `net-a` et `net-b`.
3. Explique comment `net-a` trouve l'adresse de `net-b` lorsqu'il utilise son nom.
4. Connecte `net-c` au réseau `lab-net`.
5. Vérifie que `net-c` apparaît dans les deux réseaux.
6. Déconnecte `net-c` de `lab-net` :

```bash
docker network disconnect lab-net net-c
```

7. Explique ce qui a changé.

## 9. Nettoyer le laboratoire

Arrête les conteneurs :

```bash
docker stop net-a net-b net-c
```

Supprime les conteneurs de test :

```bash
docker rm net-a net-b net-c
```

Supprime les réseaux lorsqu'ils ne sont plus utilisés :

```bash
docker network rm lab-net lab-isole
```

Ne supprime pas un réseau tant qu'un conteneur en dépend. Si Docker refuse la suppression, inspecte les conteneurs connectés avant d'agir.

## 10. Questions à compléter

**10.1** Quel est le rôle d'un réseau bridge Docker ?

Réponse :


**10.2** Quelle différence y a-t-il entre le réseau `bridge` par défaut et un bridge défini par l'utilisateur ?

Réponse :


**10.3** Pourquoi `net-a` peut-il utiliser le nom `net-b` ?

Réponse :


**10.4** À quoi sert une passerelle ?

Réponse :


**10.5** Pourquoi un port n'a-t-il pas besoin d'être publié pour permettre une communication interne entre conteneurs du même réseau ?

Réponse :


## Sécurité

Les tests de cette fiche sont limités aux conteneurs que tu as créés dans ton laboratoire Docker. N'effectue pas de scan sur un réseau d'école, d'entreprise ou sur Internet sans autorisation explicite.

## Références

- [Docker networking overview](https://docs.docker.com/engine/network/)
- [Bridge network driver](https://docs.docker.com/engine/network/drivers/bridge/)
- [Docker network create](https://docs.docker.com/reference/cli/docker/network/create/)
- [Docker network inspect](https://docs.docker.com/reference/cli/docker/network/inspect/)
- [Docker network connect](https://docs.docker.com/reference/cli/docker/network/connect/)
- [Docker network disconnect](https://docs.docker.com/reference/cli/docker/network/disconnect/)
