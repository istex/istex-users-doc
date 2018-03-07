
 **OpenURL et Discovery Tool**

Cette documentation est à destination des gestionnaires de documentation (ex : SCD) qui souhaitent paramétrer leur outil de découverte ("Discovery Tool") pour y ajouter les ressources ISTEX.

Une fonctionnalité intéressante de l’API ISTEX est son résolveur de liens compatible avec la norme OpenURL. Cette fonctionnalité permet de savoir, à partir de métadonnées simples (titre, auteurs…) ou d’identifiants standards (DOI, PMID…) si un document est présent dans la base de documents ISTEX. Si le document est trouvé, un rebond vers le texte plein est possible.

Les 3  Discovery Tool ou Outil de Découverte les plus utilisés actuellement sont :

- **EDS** et son résolveur FTF (EBSCO Discovery Service)

- **Primo** et son résolveur SFX (ExLibris/Proquest)

- **Summon** et son résolveur de liens 360 links (Serial Solution/ Proquest) _***En attente contact Ex-Libris USA***_ 



Ces réservoirs de métadonnées destinés aux bibliothèques permettent de faire une recherche à la "Google" et d’accéder :

- via un résolveur de liens, au plein texte des articles des abonnements souscrits chez l'éditeur


- via une OpenURL, au plein texte des articles des abonnements achetés dans le cadre des licences nationales ISTEX sur la plateforme ISTEX

Pour en savoir plus sur le **[résolveur OpenURL ISTEX](https://api.istex.fr/documentation/openurl/)**

==============================================================================

Si vous utilisez **un reverse proxy tel qu'EZproxy** pour donner accès à la documentation electrionique, vous pouvez le configurer avec la [**Stanza ISTEX**](https://github.com/ezproxy-config/french/blob/master/Istex.txt) ce qui permettra d'autoriser l'accès au ressources ISTEX [depuis votre proxy une fois que son adresse IP sera déclarée à ISTEX.](https://acces.licencesnationales.fr/) 

==============================================================================


## EDS - EBSCO ##

** Accès au PDF après une recherche **

Une recherche sur l’article suivant : *Tricuspid incompetence and right ventricular output in congestive heart failure*  de la revue **British Heart Journal  Janvier 1957, Vol. 19 Issue 1**,  du bouquet BMJ ISTEX

![Schéma interrogationbibcnrs](../../img/recherchebibcnrs.png)

Deux propositions d'accès au PDF :

- Directement à partir de la plateforme ISTEX par OpenURL avec pérennité de l’accès


- Ou par rebond à partir du site de l'éditeur via le résolveur de lien FTF d'EBSCO

![Schéma des liens possible](../../img/lien.png)


L'accès direct au document sur la plateforme ISTEX est possible de 2 façons en fonction des habitudes de travail.


** 1- FTF/Résolveur de lien  : En créant un lien Open URL et en lui assignant des bouquets**

** 2- EDS/Customlinks  :  En utilisant le CustomLink d'EBSCO **



#### 1- FTF/Résolveur de lien ####


Le Holdings Management (HLM) dans EBSCOADMIN permet à l’administrateur du compte de gérer les collections ou abonnements et leur associer un résolveur de liens permettant l’accès au plein texte sur le site de l’éditeur.


** A- Liens éditeurs pour Bouquets ou Titres de ressources ** 

Dans le HLM en cliquant sur **"Liens"**, l’administrateur peut visualiser les liens éditeurs disponibles dans le module d'administration qu'il faudra associer à un **"Titres"** ou un **"Bouquet"** de ressources pour aller jusqu'au plein texte. Dans notre exemple : 51 liens sont disponibles

![Schéma HLMliens](../../img/Liens.png)

** B- Création d'un lien vers la plateforme ISTEX **


Cliquer sur **"Nouveau lien"**



![Schéma création lien ISTEX](../../img/CreationdelienISTEX.png)



Remplir le formulaire **"Url\* de base"**



Avec `https://view.istex.fr/document/openurl`



Au niveau de la **"Chaîne de requête"** préciser le champ DOI et PMID plus le mode et l'ordre d'authentification : IP puis Fédération d'identité



`?rft_id=info:doi/{DOI}&rft_id=info:pmid/{PMID}&sid=ebsco&auth=ip,fede`


![Schéma istexview2](../../img/istexview2.jpg)


Ainsi que les métadonnées prises en compte : 

`{IfNotEmpty({DOI}{PMID},ok,)}`



Ne pas oublier de cocher l'affichage du lien "Pour mes fonds documentaires associés" 

![Schéma liensuite](../../img/liensuite.PNG)



Pour personnifier l'affichage du lien, rajouter l’icône ISTEX dont l'URL est :
 

`https://content-delivery.istex.fr/assets/img/istex-minilink.png`

![Schéma IconeIstex](../../img/IconeISTEX.png)


** C- OpenURL sur le champ PMID**

L'Open URL ne se fait pas que sur le champ DOI mais également sur le champ PMID et les résultats sont d'autant plus performants que 4 000 000 de PMID ont été ingérés dans la plateforme ISTEX.
Il faut donc au préalable en plus de rajouter le PMID dans le paramétrage au moment de la création du lien "ISTEX Plateforme", modifier l'équation dans le résolveur de lien.



=> EDS/Linking/Custom Links puis Modify

![Schéma PMID1](../../img/pmid1.png)


=> Choisir SetUp MaintainCustomLink

![Schéma PMID2](../../img/pmid2.png)


=> Sélectionner le résolver de lien FullTextFinder

![Schéma PMID3](../../img/pmid3.png)


=> Dans  Query String, vérifier

![Schéma PMID4](../../img/pmid4.png)


=> et complèter l'équation.

![Schéma PMID5](../../img/pmid5.png)





** D- Open URL : erreur 404 et Istex View**

 
Il peut y avoir une différence de contenu entre la liste des revues négociées avec les éditeurs, disponible au format Kbart sur le site des licences nationales, et les documents, réellement livrés en xml, disponibles sur la plateforme ISTEX.

 
 		
=> Un message code 404 peu **user friendly** s’affiche :

![Schéma istexview1](../../img/istexview1.jpg)

 
=> **Une couche IHM** (pour interface Homme-Machine) a été développée et rajoutée au-dessus de l'API ISTEX et en particulier de son OpenURL pour permettre l’affichage  d’un message plus explicite pour l’utilisateur. 		
Il suffit pour le voir de remplacer 
`https://api.istex.fr/document/openurl` (Pour ceux qui ont paramétré le lien avant ISTEX View) par `https://view.istex.fr/document/openurl` dans le champ **« URL* de base »**  de la fenêtre de paramétrage du lien ISTEX plateforme.


![Schéma istexview2](../../img/istexview2.jpg)
 

=>Le message devient :


![Schéma istexview3](../../img/istexview3.png)


** E- Assigner le lien aux bouquets concernés**

Une fois le lien créé il faut l’assigner à tous les bouquets  Licences Nationales ISTEX déjà présents dans la plateforme ISTEX :

- Les rechercher
![Schéma Bouquetsressourcesàassocier](../../img/Bouquetsressourcesàassocier.png)

- Les associer au lien OpenURL 
![Schéma associerbouquetsISTEX](../../img/associerbouquetsISTEX.png)

#####**!!!ATTENTION!!!**

Seuls les bouquets suivants sont déjà disponibles sur la plateforme ISTEX.

20 négociations mais 21 bouquets à sélectionner car la négociation "Numérique Premium" comporte 2 bouquets "Révolution française-Premier Empire" et "Littérature française et francophone".

![bouquetfevrier2018](../../img/hlmedp.JPG)


#### 2- EDS/Customlinks  


Contrairement au cas précédent ou un lien plateforme est créé par l'utilisateur, cette fois c'est EBSCO qui gère le CustomLink l'utilisateur choisit d'associer des  System collections (champ Local collection for filter) au Customlink ISTEX Plateforme créé par EBSCO.

L’activation par l’administrateur du compte se passe dans le sous onglet Linking du ou des Group(s) et profil(s) concernés. Elle sera à répéter pour chaque profil et ou Group.
Exemple le plus fréquent, Group Main, profil (eds), onglet Linking, puis Customlinks / lien Modify.


![Schéma customlink1](../../img/custom1.JPG)

** A- Premier cas : ISTEX plateforme est déjà activé parmi les customlinks EDS**


1. Cliquer sur SetUp/Maintain CustomLinks
2. Descendre jusqu’au lien ISTEX plateforme et cliquer sur le lien
3. Descendre jusqu’à la fonction Local Collections for Filter
![Schéma customlink2](../../img/custom2.JPG)
4. Appuyer sur la touche ctrl du clavier et en même temps cliquer sur la source  déjà sélectionnée (si elle se désélectionne, la cocher de nouveau sans lâcher la touche ctrl)
5. Toujours en appuyant sur la touche ctrl, appuyer sur la touche F du clavier pour ouvrir le champ de recherche dans la page et tapez ISTEX pour aller à toutes les occurrences du mot.
![Schéma customlink3](../../img/custom3.JPG)
6. Utiliser les flèches du champ de recherche pour naviguer d’occurrence en occurrence.
7. Sans lâcher la touche ctrl, sélectionner la/les nouvelle(s) source(s) choisie(s) puis valider.

![Schéma customlink4](../../img/custom4.JPG)

** B - Deuxième cas : ISTEX plateforme n’est pas activé parmi les customLinks EDS**


1. Cliquer sur SetUp/Maintain CustomLinks
2. Cliquer sur Add New CustomLink
3. Cocher “Copy from existing CustomLink » et cliquer sur Continue
4. Dans Choose Category, sélectionner Full Text et cliquer sur ++show other available CustomLinks
5. Descendre jusqu’au lien ISTEX plateforme et cliquer sur le lien
6. Descendre jusqu’à la fonction Local Collections for Filter
7. Suivre les étapes 4 à 7 de du Cas N°1



## PRIMO - ExLibris ##



#### 1-Paramétrage du résolveur SFX vers la plateforme ISTEX

- Se rendre dans l'interface d'administration SFX
- Dans l'écran de recherche chercher les Targets ISTEX
- Une liste s'affiche

![Schéma exlibris1](../../img/exlibris1.png)

 _Pour info une Target peut être associée à un bouquet de ressources plus un service comme "l'accès au texte intégral" ou **être associée uniquement à un service rebond vers un fournisseur de texte intégal sans bouquet associé**._ 

Dans notre interface d'administration : 20 Targets sont associées à des bouquets (bouton “P”) et **1 Target qui n'est pas associée à un bouquet et qui pointe vers la plateforme ISTEX**

- Activer la target ISTEX en cliquant sur la marque de coche à droite de l'écran

![Schéma exlibris2](../../img/exlibris2.png)

- Cliquer sur le bouton S pour sélectionner un service 

![Schéma exlibris3](../../img/exlibris3.png)

- Cliquer sur la marque de coche pour activer le service comme indiquer sur la capture d'écran


 _le service getDOI ajoute alors un DOI à l’OpenURL du parseur ISTEX à condition que l’objet (les métadonnées d’une ressource) comporte un DOI._


- Cliquer sur le bouton “E” (edit) pour afficher le service 

![Schéma exlibris4](../../img/exlibris4.png)

- La Target est activée


####2-Résultat 


- Rechercher l’article _"Disenchantment and the Environmental Crisis"_ dans l’outil de découverte


![Schéma exlibris5](../../img/exlibris5.png)

- Cliquer sur l’onglet “Ressource en ligne” (résolveur de liens SFX)

_Le texte intégral disponible chez l’éditeur est affiché dans la partie gauche alors que les services supplémentaires sont accessibles avec le bouton “Plus” situé à droite_

![Schéma exlibris6](../../img/exlibris6.png)

- Cliquer sur “Accès au texte intégral” sur la plateforme ISTEX

![Schéma exlibris7](../../img/exlibris7.png)

![Schéma exlibris8](../../img/exlibris8.png)



Un grand merci à Laurent Aucher (Université PSL/ACEF)


## SUMMON ##


Actuellement il est impossible de proposer le même service avec cette solution de découverte.




















