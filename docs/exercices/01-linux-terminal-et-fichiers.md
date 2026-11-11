# Exercice 01 - Prendre en main le terminal Linux

## Objectifs

À la fin de l'exercice, tu dois savoir retrouver ton emplacement dans le système, te déplacer dans les dossiers, créer une arborescence, modifier un fichier texte et vérifier son contenu.

## 1. Théorie : terminal, shell et commandes

Le **terminal** est la fenêtre dans laquelle tu écris des commandes. Le **shell**, par exemple Bash, interprète ces commandes et demande au système de les exécuter.

Une commande simple suit souvent cette structure :

```text
commande [options] [arguments]
```

Exemple :

```bash
ls -lah
```

- `ls` demande la liste des éléments d'un dossier.
- `-l` affiche une vue détaillée.
- `-a` inclut les éléments cachés.
- `-h` rend les tailles plus lisibles.

Linux distingue les majuscules et les minuscules. `Dockerfile`, `dockerfile` et `DOCKERFILE` sont donc trois noms différents.

## 2. Comprendre les chemins

Un chemin **absolu** commence à la racine `/`. Un chemin **relatif** est interprété depuis le dossier actuel.

Quelques symboles utiles :

| Symbole | Signification |
|---|---|
| `/` | Racine du système de fichiers |
| `~` | Dossier personnel de l'utilisateur |
| `.` | Dossier actuel |
| `..` | Dossier parent |

## 3. Commandes de base

Afficher le dossier actuel :

```bash
pwd
```

Lister les fichiers :

```bash
ls
ls -lah
```

Se déplacer dans un dossier :

```bash
cd ~/Documents
cd ..
cd ~
```

Créer un dossier, y compris les dossiers parents manquants :

```bash
mkdir -p ~/docker-lab/01-terminal
```

Entrer dans ce dossier :

```bash
cd ~/docker-lab/01-terminal
```

Créer un fichier vide :

```bash
touch notes.txt
```

Afficher un fichier :

```bash
cat notes.txt
```

Modifier un fichier avec Nano :

```bash
nano notes.txt
```

Dans Nano : `Ctrl + O` enregistre, `Entrée` confirme le nom du fichier et `Ctrl + X` quitte l'éditeur.

## 4. Mise en pratique

### Étape A - Préparer un dossier de travail

Exécute :

```bash
mkdir -p ~/docker-lab/01-terminal
cd ~/docker-lab/01-terminal
pwd
```

**À observer :** le dernier résultat doit montrer le chemin absolu de ton nouveau dossier.

### Étape B - Créer une note

```bash
touch notes.txt
nano notes.txt
```

Écris deux ou trois lignes qui expliquent à quoi sert le terminal dans cet exercice. Enregistre, quitte Nano, puis affiche le fichier :

```bash
cat notes.txt
```

### Étape C - Explorer les fichiers

```bash
ls -lah
file notes.txt
```

`file` indique le type de contenu détecté. Il ne garantit pas que le texte est correct, mais il aide à identifier le fichier.

## 5. Exercice sans modèle

Réalise les actions suivantes sans recopier la procédure complète :

1. Depuis ton dossier personnel, crée `docker-lab/revision/semaine-1`.
2. Entre dans ce dossier et vérifie ton emplacement avec `pwd`.
3. Crée `commandes.txt`.
4. Ajoute au moins cinq commandes Linux que tu connais et leur rôle.
5. Affiche le contenu du fichier.
6. Reviens dans le dossier personnel avec une seule commande.

## 6. Comprendre `sudo`

`sudo` permet d'exécuter une commande avec des privilèges administrateur, si ton compte y est autorisé.

Exemple :

```bash
sudo systemctl status docker
```

Ne mets pas `sudo` devant toutes les commandes par réflexe. Il est inutile pour créer des fichiers dans ton propre dossier personnel et peut créer des fichiers appartenant à `root` si tu l'utilises pour des opérations dans ton espace utilisateur.

Sur certaines installations Docker, l'accès au moteur nécessite `sudo`. Suis la configuration de ta machine et évite d'alterner entre une installation Docker rootless et le moteur système sans savoir lequel tu interroges.

## 7. Questions à compléter

**7.1** Quelle différence fais-tu entre un chemin absolu et un chemin relatif ?

Réponse :


**7.2** Que renvoie `pwd` ?

Réponse :


**7.3** Quelle différence existe entre `ls` et `ls -lah` ?

Réponse :


**7.4** Pourquoi faut-il éviter d'utiliser `sudo` sans raison ?

Réponse :


## 8. Validation

- [ ] Je sais afficher le dossier actuel.
- [ ] Je sais naviguer avec `cd`.
- [ ] Je sais créer un dossier.
- [ ] Je sais créer et modifier un fichier texte.
- [ ] Je sais afficher le contenu d'un fichier.
- [ ] Je comprends à quoi sert `sudo`.

## Référence

- [GNU Bash manual](https://www.gnu.org/software/bash/manual/)
- [GNU Coreutils](https://www.gnu.org/software/coreutils/manual/coreutils.html)
