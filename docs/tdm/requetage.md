


Ce chapitre propose un certain nombre d’éléments essentiels et incontournables pour construire sa requête et ainsi optimiser sa recherche.

Pour plus de détails sur la syntaxe d’une requête, n’hésitez pas à consulter la rubrique **[Recherche de documents](https://api.istex.fr/documentation/search/)** de la documentation technique de l’API ISTEX.

La requête peut être construite dans le **[Démonstrateur ISTEX](http://demo.istex.fr/)**, en mode simple ou en mode avancé, afin de visualiser directement le nombre de documents retrouvés et de naviguer dans le corpus à travers les différentes facettes. Le démonstrateur permet également de tester certaines parties d’une requête complexe afin de détecter ses éventuelles incohérences.

La requête est ensuite envoyée à l’API pour permettre d’extraire le corpus à l’aide de différents moyens qui sont décrits dans le chapitre suivant.

Une requête sur l'API ISTEX est constituée des éléments suivants :

- l'URL de base : `https://api.istex.fr/document/?`
- un paramètre obligatoire : 
    - q={requête}
- des paramètres optionnels : 
    - output={liste des champs à afficher}
    - size={nombre max. de documents affichés}
    - from={numéro du premier document}
- un séparateur de paramètres : &

> ***Exemple*** : *Recherche des documents issus de la revue dont le titre est "Biofutur" ou l'ISSN est "0294-3506", qui ont été publiés en 1955 et dont l'auteur est "Dodet". On souhaite visualiser le titre, l'auteur et les informations concernant la revue, pour les 100 premiers documents.*
>
> https://api.istex.fr/document/?q=(host.title:"Biofutur"+OR+host.issn:"0294-3506")+AND+host.publicationDate:1995+AND+author.name:"DODET"**&**output=title,author,host**&**size=100

NB : Tous les exemples de requêtes donnés ici sont conçus pour être utilisés directement dans l'API en précisant l'URL `https://api.istex.fr/document/?`. Si l'on souhaite les utiliser dans le démonstrateur, il ne faut garder que la partie {requête}, c'est-à-dire, supprimer `q=` et tout ce qui se trouve après `&` inclus.

# Le contenu de la requête

Lorsque l'utilisateur a bien identifié ses besoins par rapport aux corpus qu'il veut constituer, il reste à définir les modalités d’interrogation qui permettront de capter les documents correspondant au contenu et au périmètre identifiés pour le corpus.

![Schéma contenurequete](../../img/tabl_contenu_req.png)


La liste des différentes valeurs possibles dans les champs `language`, `host.genre` et `genre` est donnée dans le chapitre « Annexe ».

Le volume du corpus est apprécié en fonction des capacités de stockage, des capacités de traitement par l’outil auquel il est destiné et du degré de bruit et de silence toléré.

**Facettes**

Les facettes représentent une aide précieuse pour préciser le contenu du corpus.

En effet, leur utilisation sur le démonstrateur Istex ou sur l’API Istex peut permettre de connaître toutes les valeurs possibles d’un champ avant d’y opérer une sélection pour constituer le corpus attendu.

La syntaxe de la requête à utiliser sur l’API Istex est la suivante : 

> ​                      q=(...)&**facet=champ**&size=0
>

*​**Exemple** : si l’on souhaite connaître toutes les langues de publication des documents Istex de la revue « Astronomische Nachrichten », pour ne sélectionner par la suite que les langues intéressantes :*            

```
q=host.title:"Astronomische Nachrichten"&facet=language[*]&size=0
```

Pour afficher toutes les valeurs possibles dans un champ donné, on fait suivre le nom du champ, par exemple `language`, par `[*]`.  Autrement, le serveur ne renvoie que les dix premières valeurs. Dans le cas d'un champ de type **date**, on ajoute `[perYear]` au nom du champ pour avoir l'ensemble des années. 

L’argument facultatif `size=0` fait que l'on n’affiche que le résultat de la distribution par facette et pas les informations relatives aux documents pertinents.

**Facettes imbriquées**

Les facettes imbriquées permettent de combiner plusieurs critères. 

La syntaxe de la requête à utiliser sur l’API Istex est la suivante : 

> ​                      q=(...)&**facet=champ1>champ2**&size=0
>

*​**Exemple** : si l’on souhaite connaître toutes les langues de publication des documents Istex de la revue « Astronomische Nachrichten », avec pour chacune d’entre elles, le nombre de documents par année :*

```
q=host.title:"Astronomische Nachrichten"&facet=language[*]>publicationDate[perYear]&size=0
```




# Sur quel(s) champ(s) faire son interrogation ?

Les champs interrogeables sont présentés dans la rubrique **[Accès aux données indexées](https://api.istex.fr/documentation/fields/)** de la documentation technique de l’API ISTEX. 

Par défaut, sans mention de champ, la recherche est effectuée sur tout le document.

Mais, si on a un critère de recherche large, qui ne porte pas sur un champ particulier, il est préférable de commencer par cibler la recherche sur des champs tels que `title`, `abstract`, `subject.value` afin de ne pas générer trop de bruit. 

En effet, si on lance une requête sur l’ensemble du document, sans précision de champ, les mots recherchés peuvent être retrouvés dans les métadonnées ou dans les références bibliographiques, et ramener des résultats moins pertinents.

Dans ce cas, il faut répéter la requête en fonction des différents champs choisis (pas de factorisation de champs possible).

*​**Exemple** : si l'on souhaite rechercher des documents contenant les mots « Arctic » (mais pas « Arctic » quand il est présent avec des mots commençant par « charr»), Subarctic et ses variantes à la fois dans le champ `title` et dans le champ `abstract`, il faut répéter la requête, même complexe, pour chacun des champs souhaités.*

```
q=(title:(Arctic NOT (arctic AND /charr?/) OR Subarctic~1 OR Sub?arctic)) OR (abstract:(Arctic NOT (arctic AND /charr?/) OR Subarctic~1 OR Sub?arctic))
```



**Quelques champs particuliers**

***Langues***

Le champ `language` permet d'interroger la langue d’un document.

L’interrogation nécessite d’utiliser des codes langues (généralement 3 lettres) issus de la liste normalisée ISO 639, et non le nom complet de la langue ou de la famille de langues. 

- *​**Exemple** : Recherche de documents en **mohawk**​*

```
  q=language:moh
```

Pour savoir quel code langue utiliser, vous pouvez consulter en annexe la liste des codes interrogeables dans Istex.

NB : La valeur « unknown » est présente lorsqu'aucun code langue ne renseigne ce champ. Le champ `host.language` contient quant à lui systématiquement la valeur « unknown » car il n'est actuellement pas renseigné.

***Dates de publication***

Le champ `publicationDate` permet de retrouver les documents publiés au cours d’une année particulière ou bien d’un intervalle de temps grâce à l’emploi de **crochets ou d’accolades ** (voir à ce sujet le paragraphe « [Intervalles](Intervalles) »).

 **Quelques types de requêtes :**

- *Recherche de documents postérieurs à 2015* : 2 solutions

```
  q=publicationDate:[2015 TO *]
```

```
  q=publicationDate:{2014 TO *]
```

- Pour des statistiques concernant des publications sur plusieurs **périodes consécutives**, ne pas oublier d’exclure l’année frontière.

      *Exemple : année 1400 incluse dans une requête de documents du 14e siècle, mais exclue du 15e siècle* 
                           

```
  q=publicationDate:[1301 TO 1400] 
```
puis
```
  q=publicationDate:{1400 TO 1500] 
```
ou bien
```
  q=publicationDate:[1401 TO 1500]
```

- *Pour récupérer des documents **sans** date de publication :*   

```
  q=NOT publicationDate:[* TO *]
```

- *Pour rechercher des documents sans date de publication (champ `publicationDate` vide) mais qui comporteraient une date de copyright, en s’étant assuré au préalable que ce champ est renseigné (champ `copyrightDate` plein) :*

```
  q=copyrightDate:[* TO *] NOT publicationDate:[* TO *]
```

  

# Les principaux outils à manipuler 

**Les opérateurs booléens**

Les opérateurs à disposition sont : **OR**, **AND** et **NOT**. 

À écrire impérativement en **majuscules**, avec un **espace avant et après**, pour que le moteur de recherche en tienne compte.

Si aucun opérateur n’est utilisé entre 2 champs ou 2 valeurs recherchées, l’opérateur par défaut OR s’applique.

**Les opérateurs d’inclusion/exclusion**

L’opérateur d’inclusion « **+** » équivaut à **OR** (et non pas AND)

L’opérateur d’exclusion « **-** » équivaut à **NOT**

À écrire **sans espace** entre le « + » ou le « - » et le terme de recherche à inclure ou à exclure.

Ces opérateurs peuvent s’utiliser sur un terme unique ou sur une expression composée et délimitée par des parenthèses ou des guillemets.

***Exemples :***

- *recherche de documents contenant le mot « Greenland » et le mot « Sub-arctic »*


```
q=Greenland +"Sub-arctic"
```
- *recherche de documents contenant le mot « Iceland » mais pas les mots « Jan » et « Mayen »*
```
q=Iceland -(Jan AND Mayen)
```

**Les guillemets**

Les guillemets permettent de considérer 2 ou plusieurs mots comme faisant partie d'une même expression à rechercher.

Sans les guillemets, ces mots sont considérés comme étant reliés par l'opérateur booléen OR et sont recherchés dans le document indépendamment les uns des autres. 

`q="speech therapy"` ⇒ 12 908 résultats

`q=speech therapy` ⇒ 2 813 753 résultats

**Les troncatures**

Les troncatures sont très utiles pour ramener plusieurs résultats correspondant à une chaîne de caractères commune sans énumérer toutes les variantes possibles :

-         Le joker ou métacaractère « **?** » est utilisé pour remplacer 1 caractère

-         Le joker ou métacaractère « **\*** » est utilisé pour remplacer 0, 1 ou plusieurs caractère(s) 

Mais attention, elles impliquent quelques contraintes :

-    elles ne sont possibles qu’en milieu ou en fin de mot 

    Exemple : `q=te?t OR text*`

-    elles ne sont pas possibles en début de mot

    Exemple : `q=*ext`

-    elles ne fonctionnent pas dans les expressions entre guillemets lorsqu’elles sont employées en fin d’expression

    Exemples :

​        `q=title:"speech therap*"` ⇒ aucun résultat 

​        `q=title:"speech therap?"` ⇒ aucun résultat 

Par contre :

​        `q=title:"speech therapy"` ⇒ 169 résultats

Pour une requête complète, il faut donc écrire : 

​        `q=title:("speech therapy" "speech therapies" "speech therapist" "speech therapists")`  

​          ⇒ 199 résultats


La troncature avec jokers peut cependant générer beaucoup de bruit. 

​	Par exemple :

​       `q=title:fung*` ⇒ 24 612 résultats


Pour ouvrir le choix des variantes recherchées sans toutefois générer trop de bruit, on utilisera alors des expressions régulières (voir chapitre correspondant).

​	Exemple :

​     ` q=title:/fung(i|use?s?)/` ⇒ 13 321 résultats

Cette requête se concentre en effet sur des variantes comme « fungi » « fungus », « funguses » et ignore les mots comme « fungicide », « fungal », etc.

**Le parenthésage**

L’utilisation de parenthèses permet de factoriser des valeurs dans des champs ou de faire des combinaisons d’associations entre opérateurs booléens.

Exemple de parenthésage simple :

​	Il faut écrire : 

```
q=champ:(mot1 OR mot2 OR mot3 OR mot4)
```

​	ou, en tenant compte du caractère facultatif de **OR**, écrire : 

```
q=champ:(mot1 mot2 mot3 mot4)
```

​	Plutôt que : 

```
q=champ:mot1 OR mot2 OR mot3 OR mot4
```

En effet, dans le second cas, le champ n’est pas factorisé. Seul le 1er mot `mot1` sera recherché dans le champ indiqué et les autres mots seront recherchés dans l’ensemble du document.

Dans les parenthésages plus complexes, il est possible d’inclure un NOT dans un NOT afin d’autoriser la présence d’un mot lorsque l’on exclut la présence d’un autre mot : 

- *Recherche des documents contenant les mots commençant par pyrophyt- ou sciaphyt- ou sclerophyt- ou xerophyt- ou "aquatic plant" dans le résumé*

```
q=abstract:(pyrophyt* sciaphyt* sclerophyt* xerophyt* "aquatic plant")
```
​        ⇒ Résultat : 1 010
- *Parmi les documents contenant les mots commençant par pyrophyt- ou sciaphyt- ou sclerophyt- ou xerophyt- ou "aquatic plant" dans le résumé, on exclut ceux qui contiennent le mot fungi*

```
q=abstract:((pyrophyt* sciaphyt* sclerophyt* xerophyt* "aquatic plant") NOT fungi)
```
​        ⇒ Résultat : 1 000

- *Parmi les documents contenant les mots commençant par pyrophyt- ou sciaphyt- ou sclerophyt- ou xerophyt- ou "aquatic plant" et ne contenant pas le mot fungi dans le résumé, on accepte les documents contenant le mot fungi s’ils contiennent aussi les mots commençant par mycorrhiz- ou ectomycorrhiz- ou endomycorrhiz-*

```
q=abstract:(pyrophyt* sciaphyt* sclerophyt* xerophyt* "aquatic plant" NOT (fungi NOT (mycorrhiz* ectomycorrhiz* endomycorrhiz*)))
```
​       ⇒ Résultat : 1 001



# Quelques astuces pour peaufiner sa requête

**Minuscule ou majuscule ?**

De manière générale, la recherche est **insensible à la casse**, c’est-à-dire que le moteur ne tient pas compte des majuscules ou des minuscules.

Ainsi, la recherche sur "xxx" ramènera autant de résultats que celle sur "Xxx".

**Mots composés**

Tout comme pour les minuscules et majuscules, le moteur de recherche n’est pas sensible aux tirets présents dans les mots composés.

Ainsi, la recherche sur "disease-free plant" ramènera autant de résultats que celle sur "disease free plant".

**Diacritiques**

Le moteur de recherche est par contre sensible aux accents et autres caractères diacritiques et nécessite une indication de toutes les formes accentuées possibles si l’on veut prendre en compte des résultats de plusieurs langues.

***Exemple** : recherche de documents avec « logop**é**d**ie** », « logop**è**d**e** », « logop**e**di**cs** », « Logop**ä**d**ie** »* 

2 solutions :

```
q=logopéd* OR logopèd* OR logoped* OR logopäd*
```

ou, plus simplement :

```
q=logop?d*
```

Cette dernière requête aura l'avantage de retrouver des documents avec d'autres formes que l'on n'aurait pas pensé à rechercher (par exemple : "Logopadie").

Attention, certains documents peuvent échapper à une recherche sur un mot accentué car certaines entités caractères XML ne sont pas reconnues et sont donc supprimées lors de l’entrée dans la base ISTEX.

Ce problème concerne par exemple la recherche de documents en espagnol :

```
q=title: "ExploraciN CientimTrica De La ProducciN EspaOla En Logopedia Educativa"
```

Pour ne pas manquer ces documents, il faut prévoir dans la requête une variante où le caractère accentué est supprimé ou n’est pas accentué :

```
q=title:(exploración OR exploracion OR exploracin)
```

```
q=title:exploraci*n
```

**Apostrophe**

L’apostrophe qui sépare un nom et son déterminant marque la frontière entre les 2 mots. 

Dans l’API ISTEX, le nom n’est pas désolidarisé de son déterminant quand ce dernier contient une apostrophe.

Ainsi, on n’obtient pas les mêmes résultats lorsque l’on inclut le nom avec l’apostrophe ou pas : 

```
q=title:orthophonie
```
​     ⇒ 3 documents

```
title:(orthophonie OR l’orthophonie)
```
​     ⇒ 4 documents

En attendant que cet aspect soit pris en compte dans l'API, il convient d’inclure cette particularité dans la requête, en pensant à ajouter les cas avec « l’ » ou « d’ » lors des recherches sur des noms en français.

**Expressions régulières (//)**

Lorsque l’on recherche des termes comportant plusieurs formes d’écriture, les expressions régulières permettent de raccourcir la requête.

Aucune majuscule n’est autorisée entre les délimiteurs //. Les lettres qui ne sont pas communes aux différentes écritures sont indiquées **entre crochets**. Celles qui n’apparaissent que pour certaines écritures sont **suivies du métacaractère  « ? »** et sont éventuellement écrites **entre parenthèses** à partir de 2 lettres.

- ***Quelques exemples de syntaxes :*** 
    - _Spit**s**berg OR Spit**z**berg OR Spit**s**berg**en** OR Spit**z**berg**en**_ : `q=/spit[sz]berg(en)?/`

        - Dans les termes ci-dessus, le caractère au choix entre s et z est indiqué entre crochets ; la terminaison “en” optionnelle est indiquée entre parenthèses et suivie par le métacaractère « **?** ».

    - _Es**k**im**o** OR Es**qu**im**au** OR Es**k**im**os** OR Es**qu**im**aux**_ : `q=/es[kq]u?im[oa]u?[sx]?/`

        - 3e caractère au choix entre k et q (indiqué entre crochets), suivi d’un u optionnel (indiqué par un ?), terminaison par un o ou un a (entre crochets) suivi ou non d’un u (noté par un ?), caractère final pluriel au choix entre s et x et optionnel (entre crochets et suivi d’un ?)

    - _I**ñ**upi**at** OR I**ñ**upi**aq** OR I**ñ**up**iak** OR I**ñ**upi**k** OR I**n**upi**at** OR I**n**upi**aq** OR I**n**upi**ak** OR I**n**upi**k**_ : `q=/i[nñ]upia?[tqk]/`

        - caractère final au choix entre 3 lettres : t, q et k, indiqué entre crochets



Il est également possible d’employer la barre verticale « **|** » pour indiquer un choix entre plusieurs chaînes de caractères, ce qui permet de simplifier la syntaxe.

- ***Exemples :***  
    - _Fung**i** OR fung**us** OR fung**uses**_ : `q=/fung(i|us|uses)/` 
    - _Es**k**im**o** OR Es**qu**im**au** OR Es**k**im**os** OR Es**qu**im**aux**_ : `q=/es(k|qu)im(o|au)[sx]?/`


On peut également se servir d’une expression régulière dans une expression multi-termes

- ***Exemple :***  
    - *"Franz Josef Land" OR "Franz Joseph Land"* : `q=(franz AND /jose[fp]h?/ AND land)`


NB : L’utilisation des expressions régulières pour interroger les champs `.raw` ne donne aucun résultat.



**Recherche floue (~)**  

Recherche sur les variantes d’écriture d’un **terme unique** ayant **au maximum 2 caractères de différence**, caractères en plus, en moins ou caractères différents.

Ajouter derrière le terme de recherche (uniterme) un **tilde « ~ »** + **un nombre entier compris entre 0 et 2**. 

- Sans aucune précision après le tilde, le chiffre équivaudra à 2

- S’il est de 0, aucun degré de liberté n’est autorisé, c’est donc le mot exact qui est recherché.



Il est conseillé de faire des tests pour vérifier les résultats ramenés, car une recherche floue a :

- l’avantage de mettre en évidence **des variantes pertinentes** auxquelles on n’a pas pensé (ex. : Groenland, Grönland, Grünland, Grønland, etc.)
- l’avantage de mettre en évidence **des termes pertinents bien que contenant des caractères incorrects**, tels que des fautes d’orthographes (ex. : Geeenland, Greendland)
- l’inconvénient de ramener **des termes non pertinents** (ex. : Freeland, Greenlaw, Greensand, Greenman, etc.).



Cas des termes contenant des **tirets** : les tirets ne sont pas compris comme des caractères. C’est le cas par exemple de « sub-arctic » qui équivaudra à « sub arctic », c’est-à-dire à deux mots distincts. Une recherche avec un tilde ("sub-arctic"~) sera donc considérée comme une recherche de proximité (cf. paragraphe suivant).



**Recherche de proximité (~)**

Recherche d’une expression comportant **deux termes** plus ou moins distants.

Ajouter à la suite de l’expression recherchée, un **tilde « ~ »** + la distance autorisée représentée par un **nombre entier** **(de 0 à n)**.

Une distance de 3, par exemple, ramène tous les résultats correspondants aux termes de l’expression séparés par 3 mots au maximum.

Encadrer les termes de l’expression par des guillemets (pas d’usage de parenthèses). Les signes de ponctuation, les tirets, etc. sont considérés comme des espaces et ne sont pas comptabilisés.

**L’ordre des termes** dans la requête impacte les résultats obtenus !

- _**Exemples :**_ comparer les résultats avec les requêtes suivantes 
    - `q=title:("Bering seas"~2 AND Soviet)` :  « …onto the Soviet continental shelf in the northern **Bering and Chukchi seas**… »
    - `q="Seas Bering"~2 AND Soviet`  : « …in Soviet Arctic **seas and the Bering** Sea… »

***Les résultats sont inversés par rapport à Bering Seas !***



**Pondération (^)**

Donne plus de poids à un terme de recherche par rapport à un autre terme (ou à plusieurs autres). 

Faire suivre le terme à booster du **symbole ^** et d’un chiffre (**nombre entier ou décimal, ** **obligatoirement positif**). Plus ce chiffre est élevé, plus le poids donné au terme à privilégier est fort.

La pondération **impacte le tri des résultats** mais pas leur nombre : 

-  Si le chiffre indiqué est supérieur à 1, les premiers documents contiennent le terme « privilégié ».
-  Si le poids est une fraction de 1, le poids du terme est réduit par rapport aux autres termes de l’équation. Dans ce cas, les résultats contenant le terme pondéré sont proposés à la fin.



- _**Exemple :**_ comparer l’ordre des résultats affichés pour les deux pondérations suivantes
    - _Inupiat**^5**_ *Inupiaq* : `q=title:(Inupiat^5 Inupiaq)`
    - *Inupiat**^0.5** Inupiaq* : `q=title:(Inupiat^0.5 Inupiaq)`


On peut **booster une expression de recherche multi-termes**, encadrée par des guillemets.

- _**Exemple :**_ écriture avec  « f » (Josef), privilégiée par rapport à celle avec « ph » (Joseph)
    - _q=**"Franz Josef Land"^3** "Franz Joseph Land"_



On ne peut **pas booster un terme recherché dans un champ plutôt que dans un autre** (par exemple privilégier la recherche du terme « Asteroseismology» dans le champ titre plutôt que dans le champ résumé).

**Intervalles**

Interrogation sur des intervalles de **nombres ou de mots** à l‘aide de **crochets (inclusifs) ou d’accolades (exclusives)**

- _**Exemple :**_ recherche de documents antérieurs à 1407 :
    - q=publicationDate:[\* TO **1406]**
    - q=publicationDate:[\* TO **1407}**

Si l’interrogation porte sur plusieurs intervalles **consécutifs**, ne pas oublier d’**exclure la valeur limite** entre les deux intervalles.

- _**Exemple :**_ recherche de documents du 14e siècle, puis du 15e siècle :     
    - *q=publicationDate:[1301 TO 1400]* 
    - *puis q=publicationDate:**[**140**1** TO 1500] ou q=publicationDate:**{**1400 TO 1500]*

Une recherche sur un **intervalle de mots** équivaut à une recherche sur des mots dont les valeurs limites sont **tronquées par le métacaractère \***

- _**Exemple :**_ `[seal TO seas]` ramène tous les mots de 4 lettres compris entre **seal** et **seas** mais aussi **sealant**, **seamen**, **seaport**, **search**, etc.

**Utilisation de valeurs limites**

Dans le **démonstrateur Istex** en mode « recherche avancée » : 

- « supérieur » est équivalent à « supérieur **ou égal** »


- « inférieur » est équivalent à « inférieur **ou égal** »


- « est entre » est équivalent à « est entre les valeurs inférieure et supérieure, **y compris** ces deux valeurs limites »

