# Vérification et mise en forme des résultats

 

Une fois extraits, les documents doivent subir un certain nombre de vérifications et d’interventions afin d'être exploités de manière optimale par des outils manipulant du texte intégral, tels que les outils de traitement automatique du langage ou de fouille de textes. 

## Détecter les problèmes d’authentification

Pendant l’extraction, il est possible que le programme perde la connexion avec le serveur et soit redirigé vers la page d’authentification de la fédération d’identité. C’est le cas lorsque le programme d’extraction fonctionne pendant la nuit, au moment où la liste des IP autorisés est rechargée par l’API, ce qui occasionne une non reconnaissance momentanée de l'adresse IP de la machine. Dans ce cas, le fichier extrait contient non pas le document souhaité, mais la page HTML d'authentification par la fédération d’identité. 

Le texte du document ne correspond alors plus au document souhaité et peut ainsi générer du bruit dans les analyses thématiques ou dans l'analyse du silence dans les détection d'entités spécifiques.

Ci-dessous un exemple de fichier extrait (Vieil_00718.txt Corpus Vieillissement V2 old):

![pbauthentification](../img/pbAuthentification.png)

Ce phénomène est aléatoire et peut survenir sur n'importe quel document, lors d'une extraction de nuit.

Dans ce cas, il faut simplement vérifier que le corpus ne contient pas de document HTML même si l'extension indique .txt, .zip, .pdf, etc. 

Le programme suivant permet de réaliser cette action pour les fichiers extraits et renommés par l'outil harvestCorpus.pl (selon modèle de renommage « nomCorpus\_0*nn* » où « *0nn* » est un nombre) :

```bash
for i in nomCorpus_0*
do
j=`file $i | egrep -c 'HTML document'`
if [ $j != 0 ]
then
echo $i
fi
done
```

Si le programme détecte un document HTML, il faut relancer l'extraction et recommencer la vérification.



## Détecter les PDF image 

Cette procédure est utile si l'on souhaite exploiter les PDF pour faire de la fouille de texte. Dans ce cas, il est nécessaire de vérifier que le PDF de départ ne soit pas du PDF image car celui-ci risque de bloquer le traitement de l'outil utilisé.

Pour cela, il faut d'abord calculer le nombre de mots par page contenus dans un document et ensuite vérifier s'il s'agit d'une image ou d'un texte. En-deçà d’un certain seuil (seuil qui est variable: voir étape 4), le document sera considéré comme un PDF image.

Le programme « harvestCorpus.pl » génère un fichier « logRequete.txt » qui conserve les métadonnées des documents Istex extraits et un fichier « .corpus », lequel contient une mise en correspondance entre les identifiants Istex et les noms de fichiers.

#### Etape 1 : Récupération des données de logRequete.txt (commande sur une seule ligne) 

Le programme ci-dessous calcule le ratio entre le nombre total de pages et le nombre total de mots pour un document.

```bash
perl -ne 'if (/^ {6}"id":"(\w+)"/o) {$id = $1;} 
            elsif (/^{8}"pdfWordCount": (\d+)/o) {
                        $nW = $1; $ok = 1;} 
            elsif  (/^ {8}"pdfPageCount": (\d+)/o) {
                       $nP = $1;} 
            elsif (/^    \}/o) {
                  if ($id and $nP and $ok) {
                        printf "%s\t%d\t%d\t%.2f\n",
                             $id, $nP, $nW,$nW/$nP; 
                        $id = $nP = $nW = $ok =0;} 
                 else  {
                        print STDERR"Erreur ligne $.\n";
                        }
                  }' logRequete.txt | 
 sort > tmp01.txt
```

Ce programme génère un fichier "tmp01.txt" qui contient les informations suivantes :

- identifiant ISTEX
- nombre total de pages
- nombre total de mots
- nombre de mots par page

Exemple :

```
000177F07386D728EA2F5D0169D4F9BF8276EB22	12	7338	611.50
0005217AB88EECA913D27DDDBAE470D54209FBA2	11	5859	532.64
00052DA849FA3FEA62F65A2984754C513B541F85	13	6549	503.77
00058F61D87EA5FB84BBE46EFE8504533D9F43C2	13	5625	432.69
0005E3037CAF703BD38CCCE35910E0D1681C2536	13	7924	609.54
0007685B6CD6C8F51866F7BC893C5A5726B7A05B	11	3778	343.45
```



#### Etape 2 : Récupération des noms de fichiers correspondant aux identifiants ISTEX

Ce programme récupère les noms de fichiers dans le fichier « .corpus » et fait la jointure avec le fichier précédent sur l'identifiant ISTEX.

```bash
perl -ne 'if (/^id /o) {
                        @c = split(/\s+/); 
                        print"$c[1]\t$c[3]\n";
                        }'Nom_de_fichier.corpus | 
sort | join -t $'\t' - tmp01.txt > DistNbMotNbPage.txt
```

Il génère ainsi un fichier "DistNbMotNbPage.txt" qui contient les informations suivantes :

- identifiant ISTEX
- nom de fichier
- nombre total de pages
- nombre total de mots
- nombre de mots par page

Exemple :

```
000177F07386D728EA2F5D0169D4F9BF8276EB22	Syst_veg6_v2_045218	12	7338	611.50
0005217AB88EECA913D27DDDBAE470D54209FBA2	Syst_veg6_v2_027437	11	5859	532.64
00052DA849FA3FEA62F65A2984754C513B541F85	Syst_veg6_v2_051847	13	6549	503.77
00058F61D87EA5FB84BBE46EFE8504533D9F43C2	Syst_veg6_v2_048335	13	5625	432.69
0005E3037CAF703BD38CCCE35910E0D1681C2536	Syst_veg6_v2_008028	13	7924	609.54
0007685B6CD6C8F51866F7BC893C5A5726B7A05B	Syst_veg6_v2_004392	11	3778	343.45
```



#### Etape 3 : Nettoyage

On supprime le fichier "tmp01.txt" qui n'a plus d'utilité.      

```bash
rm tmp01.txt
```



#### Etape 4 : Procédure de vérification

Le fichier « DistNbMotNbPage.txt » ainsi obtenu indique, pour chaque document du corpus, le nombre de mots par page qui va servir à identifier les documents à vérifier manuellement :

Si le nombre de mots par page est égal à 0, il s’agit d’un PDF image.  

Si ce nombre est supérieur à 0, il s’agit également potentiellement d’un PDF image. La valeur limite à partir de laquelle, le PDF peut être considéré comme textuel est variable : environ 80, 100, 140 mots par page.

Dans ce cas, il faut vérifier manuellement chaque PDF dans le démonstrateur.

La procédure de vérification est la suivante :

-    Recherche dans le démonstrateur Istex : 

```
     q=id:identifiant_Istex
```

-    Ouverture du PDF correspondant au résultat de cette requête

-    Sélection du texte

     -         Si la sélection totale ou partielle du texte est possible et si en collant le texte dans un document Word, ce texte est illisible => il s’agit d’un PDF Image
     -         Si la sélection totale du texte est possible et si en collant le texte dans un document Word, ce texte est identique au texte sélectionné => il s’agit d’un PDF Texte



#### Etape 5 : Procédure de suppression des PDF Image

Une fois les PDF Image identifiés, il faut les supprimer du corpus.

La procédure de suppression est la suivante :

-         Préparer la liste d’identifiants Istex à supprimer et le fichier « .corpus » faisant la correspondance entre les identifiants et les noms de fichiers


```bash
export LC_COLLATE=C

sort -u liste-PDF-a-supprimer.txt > tmp01.txt

egrep '^id ' fichier.corpus | sort -u > tmp02.txt
```

-         Mettre les documents à supprimer dans un répertoire séparé nommé, par exemple, « rejets »

```bash
join tmp01.txt tmp02.txt | 
while read x
do 
set $x
echo $3
mv corpus_requete_6_v2.3/$3.* rejets/
done
```

-         Supprimer les fichiers "tmp01.txt" et "tmp02.txt"





## Remplacer les documents TXT par les documents OCR

Cette procédure est utile si l'on souhaite exploiter les documents TXT pour faire de la fouille de textes. 

Les fichiers TXT résultent d’une transformation du PDF par l’API Istex via PDF-to-text.

Les fichiers OCR sont des documents issus d’un processus d’océrisation par l’équipe ISTEX-DATA lorsque le TXT est de mauvaise qualité (voir billet de blog **["OCR - production de plein texte"](http://blog.istex.fr/ocr-production-de-plein-texte/)**).

Lorsqu’un fichier OCR est disponible pour un document et que l’on a pensé à l’extraire, il faut écraser le fichier TXT existant pour ce même document par le fichier OCR qui sera de meilleure qualité.

La commande suivante permet de réaliser cette action :

```bash
for i in *.ocr
do
j=`basename $i .ocr`
mv $i $j.txt
done
```

  

## Détecter les ligatures dans le TXT

En typographie, on appelle ligature la fusion de plusieurs caractères. Une ligature peut être linguistique, donc obligatoire, comme **æ** ou **œ** dans des mots comme « c**æ**cum » ou « b**œ**uf ». Elle peut aussi être esthétique, donc optionnelle, pour améliorer la lisibilité d'un document imprimé. C'est notamment le cas des documents PDF. Le problème, c'est qu'un mot avec une ligature ou son équivalent sans ligature ne sont pas considérés comme identiques, aussi bien lors du requêtage que lors des différents traitements réalisés sur le corpus obtenu. 

Par exemple, la recherche de noms d'espèces végétales à partir d'une ressource terminologique (taxonomie) sera incomplète si on ne remplace pas les ligatures par les chaînes de caractères correspondantes. Le tableau suivant montre les différentes ligatures concernées avec des exemples pris dans le texte et dans la ressource ([The Plant List](http://www.theplantlist.org/)). La différence est parfois subtile à nos yeux, mais elle est rédhibitoire pour un programme. 


![ligatures](../img/ligatures.png)

Pour ne pas gêner la reconnaissance de mots dans le texte, on recherche les ligatures afin de les remplacer par la forme sans ligature.

Le script Perl **[ligature.pl](https://git.istex.fr/scodex/harvest-corpus/blob/master/outils/ligature/ligature.pl)** a été développé afin de faire cette correction dans un fichier ou un répertoire de fichiers. Il est téléchargeable dans Gitbucket.



## Extraire les documents XML des fichiers ZIP

Parmi les fichiers fournis par les éditeurs, on a des archives ZIP contenant généralement pour chaque document un répertoire avec un fichier PDF et un fichier XML. Ce fichier XML peut ne contenir que des métadonnées ou contenir en plus le texte du document sous forme structurée. 

Mais la situation n'est pas toujours aussi simple : dans certains cas, on a dans l'archive plusieurs répertoires avec parfois plusieurs fichiers PDF ou plusieurs fichiers XML ainsi que des fichiers accessoires comme des images ou des photos.

A l’aide du script Perl **[extraitXmlEditeur.pl](https://git.istex.fr/scodex/harvest-corpus/blob/master/outils/extrait-xml-%C3%A9diteur/extraitXmlEditeur.pl)** (téléchargeable dans GitBucket), nous procédons à l’extraction du fichier XML en passant par les étapes suivantes :

- Recherche dans l’archive ZIP des fichiers PDF et XML par `unzip –l` 
- Mise en correspondance entre fichier PDF et fichier XML par différentes heuristiques
- Extraction du fichier XML sélectionné et renommage

A ce stade, il reste encore quelques cas compliqués qui sont signalés, mais pas traités automatiquement. Il faut donc les extraire manuellement.

#### Extraction manuelle

Pour expliciter la méthode, prenons comme exemple le corpus « Vieillissement » dont un fichier ZIP,  « Vieil_03555.zip », n'a pas pu être traité. Les différentes étapes sont :

- listage des fichiers de l'archive ZIP : pour cela, on utilise le programme `unzip` :

```bash
unzip -l Vieillissement/Vieil_03555.zip
Archive:  Vieillissement/Vieil_03555.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
   137102  04-14-2016 21:55   ageing36_5pdf/afm068.pdf
    49123  04-14-2016 21:55   ageing36_5xml/afm068.xml
   184080  04-14-2016 21:55   ageing36_5largeimages/afm068-f1.jpeg
    85847  04-14-2016 21:55   ageing36_5largeimages/afm068-f2.jpeg
    24094  04-14-2016 21:55   ageing36_5mediumimages/afm068-f1.gif
    11810  04-14-2016 21:55   ageing36_5mediumimages/afm068-f2.gif
  9175398  04-14-2016 21:55   ageing36_5peripherals/back_matter.pdf
  7629198  04-14-2016 21:55   ageing36_5peripherals/front_matter.pdf
     9133  04-14-2016 21:55   ageing36_5smallimages/afm068-f1.gif
     4702  04-14-2016 21:55   ageing36_5smallimages/afm068-f2.gif
   262568  04-14-2016 21:55   ageing36_5peripherals/cover.tif
---------                     -------
 17573055                     11 files
```


- repérage du fichier XML à extraire : d​ans le cas présent, on a plusieurs fichiers PDF, mais un seul fichier XML `afm068.xml` qui correspond au fichier PDF `afm068.pdf` présent dans un autre répertoire. 


- extraction du fichier XML : également avec le programme `unzip`, mais en utilisant l'option `-j` pour ne pas créer le répertoire `ageing36_5xml` :

```bash
unzip _j ageing36_5xml/afm068.xml
```

- renommage du fichier XML extrait : le fichier extrait `afm068.xml` est présent dans le répertoire courant. Il faut donc le remettre dans le répertoire avec les autres fichier XML en lui donnant le préfixe du document correspondant dans ce corpus :

```bash
mv afm068.xml Vieillissement/Vieil_03555.xml
```


