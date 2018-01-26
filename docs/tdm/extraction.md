

Ce chapitre fait l'inventaire des différentes méthodes permettant d'extraire un corpus de documents correspondant à une requête.

Tous ces outils proposent de télécharger un corpus de fichiers textes (PDF, TEI, TXT, etc.), de fichiers de métadonnées (Mods, XML) ou de fichiers d’enrichissement (TEI) depuis la base ISTEX à partir d’une requête.



## Application ISTEX-dl (ISTEX download)

Il s'agit d'une application Web permettant de télécharger très facilement, via une interface conviviale, un corpus de documents ISTEX sous forme d'archive zip à partir d’une requête.

- **Avantages :**
    - très simple d'emploi, l'application propose des exemples pour aider à la construction d'une requête 
    - elle peut être utilisée en dehors de l’Inist car gère l’authentification par la fédération d’identité 
    - elle offre également le téléchargement des annexes et couvertures disponibles.
- **Inconvénients :**
    - la sauvegarde des requêtes n'est pas encore proposée
    - les corpus ne peuvent être extraits actuellement que dans la limite de 10 000 documents
    - l'extraction des enrichissements n'est pas encore opérationnelle
- **Mode d'emploi :** cette application est accessible à l’adresse suivante : <https://dl.istex.fr/> 
- **Astuces :** 
      - la requête ne nécessite pas d'opérateur booléen en majuscule
      - si l'on souhaite extraire tous les formats pour un type de fichier particulier, il suffit de cocher ce type de fichier sans autre précision
          - ***Exemple :** voir en page d'accueil le type de fichier "Métadonnées" (case cochée par défaut)*





## Fonction « Extract »

Il s'agit d'une fonction du moteur de recherche de l'API ISTEX permettant d’extraire un corpus correspondant à des critères de recherche. Celle-ci s’utilise directement dans l’URL de requêtage sur l’API.

- **Avantages :**
    - simple à utiliser, elle ne nécessite aucune installation
    - elle peut être utilisée en dehors de l’Inist car gère l’authentification par la fédération d’identité
    - elle offre également le téléchargement des annexes et couvertures disponibles. 
- **Inconvénients :** 
    - les corpus ne peuvent être extraits actuellement que dans la limite de 10 000 documents
    - l'extraction des annexes et des enrichissements n'est actuellement pas utilisable, mais le fichier JSON extrait par défaut reprend la totalité des enrichissements disponibles d'un document numérique donné.
- **Mode d'emploi :** cette fonction et la syntaxe requise pour son utilisation sont décrites dans la rubrique **["Extraction"](https://api.istex.fr/documentation/search/#extraction)** de la documentation technique ISTEX.
- **Astuces :** 
    - pour que la fonction `extract` soit opérationnelle, il faut la faire suivre obligatoirement par le signe "=" et une valeur quelconque, mais seuls les fichiers JSON sont extraits. Indiquer un (ou plusieurs) type de fichiers pour obtenir leur extraction.

        - ***Exemple :** moissonnage des métadonnées au format JSON pour les documents contenant l'expression "by draconis stars" dans le résumé*

        *[https://api.istex.fr/document/?q=abstract:"by draconis stars"&extract=lhjd](https://api.istex.fr/document/?q=abstract:%22by%20draconis%20stars%22&extract=lhjd)*

    - sans indication de format, tous les formats disponibles pour un type de fichiers sont extraits

    - la syntaxe pour extraire les enrichissements ne comporte pas de "s" (*enrichment*).

    - indiquer une taille de corpus au moins égale au nombre de documents à extraire. Sans cette précision, 5 documents sont extraits par défaut.

        - ***Exemple :** moissonnage du texte intégral au format pdf des 18 documents contenant le terme Groenland dans le titre*

        *[https://api.istex.fr/document/?q=title:groenland&size=20&extract=fulltext[pdf]](https://api.istex.fr/document/?q=title:groenland&size=20&extract=fulltext[pdf])*

      ​



## Moissonneur de l’API Istex

Il s'agit d'un utilitaire en ligne de commande permettant de moissonner les corpus requêtés par l'API de la plateforme ISTEX. Il est écrit en NodeJS. 

- **Avantage** : il peut être utilisé en dehors de l’Inist car gère l’authentification par la fédération d’identité.


- **Inconvénient** : son utilisation nécessite de disposer de Git et de NodeJs, ainsi que d'installer le moissonneur via un terminal de commande.

- **Mode d'emploi :** ce programme est disponible sur **[Github](https://github.com/istex/istex-api-harvester)**.

- **Installations :** 

    - installation de Git pour Windows : [https://git-for-windows.github.io/](https://git-for-windows.github.io/)
    - installation de NodeJS pour Windows : [https://nodejs.org/en/download/](https://nodejs.org/en/download/)
    - lancement du terminal Git Bash : `Démarrer /Toutes les Applications / Git Bash`
    - installation du moissonneur : `npm install -g istex-api-harvester`

- **Astuces :** 

    - indiquer le nombre de documents à extraire. Sans précision, aucun document n'est moissonné

    - les métadonnées étant extraites par défaut, si on ne souhaite que les fichiers textes, utiliser l'option -M avec une chaîne vide, c’est-à-dire un blanc entre doubles quotes : -M **""** 

        - ***Exemple :** moissonnage du texte intégral au format txt, sans les métadonnées, de 590 documents correspondant à la requête querya1.txt, à télécharger dans le répertoire « corpusAncien»* 

        `istex-api-harvester  -F txt -M "" -o corpusAncien -s 600 --query="'cat querya1.txt'"`

    -   Si le corpus est volumineux, il faut augmenter la durée de vie de la fonction Scroll qui est de 30 s par défaut. Avec un tel délai, le parcours des 100 résultats de la "page courante" peut s’avérer trop long et entraîner une erreur 404 renvoyée par l'API.

        - ***Exemple :** moissonnage du texte intégral au format pdf et des métadonnées associées de 17 257 documents contenant le terme "arctic" dans le titre ou le résumé, à télécharger dans le répertoire Polaris (la durée de vie de la fonction Scroll a été portée à 5 mn)*

        `istex-api-harvester -t 5m -F pdf -o Polaris -s 17500 -q "title:arctic OR abstract:arctic"`


## Programme « harvestCorpus.pl »

Il s'agit d'un outil d’extraction de corpus ISTEX en ligne de commande. Il est écrit en Perl.

Il permet de décharger un corpus depuis la base ISTEX à partir d’une requête ou d’un fichier `.corpus`. 

- **Avantages** : 
    - Il permet de renommer les fichiers déchargés, de gérer l’arborescence des fichiers et de générer un fichier de notices bibliographiques et un fichier `.corpus` (contenant la liste des identifiants du corpus). 
    - Il permet également de traiter une requête de grande taille (9 000 caractères). 
    - De plus, il est associé à plusieurs [outils](https://git.istex.fr/scodex/harvest-corpus/tree/master/outils) dont `statsCorpus.pl`, un programme de réalisation de statistiques sur le corpus, et `extraitXmlEditeur.pl`, un programme pour extraire à partir des archives ZIP les fichiers XML fournis par les éditeurs . 
    - Comme ce programme extrait d'abord la liste des identifiants des documents pertinents avant de décharger les fichiers correspondants, il ne devrait pas être affecté par les limitations de la méthode  `scroll`. Donc, même si la connexion Internet a un faible débit, l'extraction se déroulera sans problème. 
    - Il gère l'authentification au serveur en dehors du réseau interne de l'Inist. 
    - Il vérifie le type des fichiers déchargés, signale les problèmes d'authentification et relance le déchargement des fichiers concernés (pour plus de détails, voir la rubrique Détecter les problèmes d'authentification dans le chapitre **[Vérification et la mise en forme des résultats](verification/)**). 

- **Inconvénients** : 
    - Il s'utilise en ligne de commande à partir d'un terminal. Sous Windows, cela peut se faire avec [Cygwin](https://www.cygwin.com/)  (Git Bash ne convient pas). 
    - Il existe des solutions alternatives sous Windows avec [Strawberry Perl](http://strawberryperl.com/) ou [ActivePerl](https://www.activestate.com/activeperl), mais elles n'ont pas été testées pour l'instant. 

- **Mode d'emploi :** ce programme est disponible sur **[Gibucket](https://git.istex.fr/scodex/harvest-corpus)**. 

- **Installations :** 

    - si besoin, installer Git pour Windows : https://git-for-windows.github.io/

    - cloner la distribution `harvest-corpus` :

```bash
git clone https://git.istex.fr/git/scodex/harvest-corpus.git
```

- **Exemples :** pour récupérer les fichiers PDF et TEI à partir d'une requête et les placer dans le répertoire `Data/Fichiers` tout en générant un fichier de notices bibliographiques `oiseaux.txt` et un fichier d'identifiants `oiseaux.corpus` :


```bash
harvestCorpus.pl -r '/birds?/ OR (avian NOT flu)' -t pdf,tei -d Data/Fichiers -s oiseaux.corpus -n oiseaux.txt -p Oiseau_ -v
```


Tous les fichiers PDF et TEI seront renommés en __Oiseaux\_0*nnn*.pdf__ et __Oiseaux\_0*nnn*.tei__. La chaîne de caractères « 0*nnn* »  représente un nombre séquentiel avec autant de chiffres que nécessaire. 

L'option `-v` permet de conserver toutes le métadonnées envoyées par l'API. Elles sont placées dans le fichier `logRequete.txt` dans le répertoire `Data/Fichiers`. 

- **Astuce :** l'intérêt des fichiers `.corpus` est de permettre de documenter et de référencer le corpus réalisé. Il permet aussi de refaire le même corpus ou de le compléter avec d'autres fichiers. Par exemple, pour décharger les métadonnées du corpus obtenu précédemment et placer les fichiers correspondants dans le répertoire `Data/Metadata`, il suffit de lancer :

```bash
harvestCorpus.pl -c oiseaux.corpus -m all -d Data/Metadata
```

Les fichiers au format MODS ou XML dans le répertoire `Data/Metadata` auront le même préfixe que les fichiers PDF et TEI correspondants dans le répertoire  `Data/Fichiers`. 
