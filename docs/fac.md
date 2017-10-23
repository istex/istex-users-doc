#  A quoi sert ISTEX ? Quel est l'apport de ce service par rapport à BiblioInserm, BibCnrs, NCBI ou PubMed ?


C’est tout à fait normal de se poser ce genre de questions car pour beaucoup d’utilisateurs ISTEX c’est uniquement des archives en licences nationales avec accès sur  site éditeur via un portail institutionnel (BibCnrs, BiblioInserm, lien ressources portail <=> PubMed....).
 
Mais Le projet **[ISTEX](https://www.istex.fr/ )** a pour vocation :
 
- ** D’offrir à l’ensemble de la communauté de l’ESR, un accès en ligne aux collections rétrospectives de la littérature scientifique dans toutes les disciplines, en engageant une politique nationale d’acquisition massive de documentation** 
 `C'est l'utilisation documentaire quotidienne et transparente à partir d'une interface` 




 

**Recherche par titre de périodique**

Exemple : les archives de la revue **Europeen Journal of Cardio-Thoracic Surgery** (1987- 2010) achetées dans le cadre du projet ISTEX 


![ recherchepartitrefac1](img/fac1.JPG)
 
 

**Recherche par article**


 
“Clinical study of modified Ivor-Lewis esophagectomy plus adjuvant radiotherapy for local control of stage IIA squamous cell carcinoma in the mid-thoracic esophagus" 
 article de 2009


=> Via votre Portail


![ recherchepararticlefac2](img/fac2.JPG)

 
 
 *Le 1er accès du pdf se fait directement sur la plateforme ISTEX

 *Le 2ème accès qui est le même est consultable sur la plateforme éditeur, car l'accès éditeur et pour l'instant toujours disponible



![ recherchepararticlefac3](img/fac3.JPG)
 

=> Via NCBI - PubMed 


L'accès au texte intégral se fait en cliquant sur le logo du portail directement à partir de la notice bibliographique 



![ rechercheparpubmedfac4](img/fac4.JPG)


=> Via Google Scholar

 
En déchargeant [l’extension disponible pour chrome et firefox](https://addons.istex.fr/) l'icône ISTEX permet d’accéder directement au PDF de l’article présent sur la plateforme ISTEX.


![ googlescholarfac5](img/fac5.JPG)

 
 - **De développer une plateforme d’exploitation de ces ressources en proposant des services uniques à valeur ajoutée , notamment de fouille de textes et de contenus**

 `C'est l'interrogation par API de la plateforme ISTEX`



Le deuxième point concerne les personnes qui souhaitent interroger directement la plateforme ISTEX et ses ressources pour un usage d’extraction de données, fouille de textes, production de synthèses documentaires et de corpus terminologiques, en ne passant pas par un portail documentaire.
 
L’équation d'interrogation se fait directement le navigateur et [les tutoriaux](http://www.inist.fr/?Tutoriels-Interrogation-de-l-API&lang=fr) servent pour acquérir les connaissances nécessaires.


Le profil des utilisateurs est alors plus informaticien que documentaire.
 

 ![equationapifac6](img/fac6.JPG)

[Pour tout savoir sur l'API](https://api.istex.fr/documentation/)


#  Mais pourquoi mettre un ARK ??
 
** => Actuellement lorsque vous recherchez le PDF d'un article ** 


 _« Theatre in the Arab World: A Difficult Birth »_ l'URL se construit ainsi

 
<a href="https://api-istex-fr/document/48AB438A7C1179DAB7757096669C75BAFF8AA325/fulltext/pdf?auth=ip,fede&sid=ebsco,istex-view"><span class="mandParam">https://api-istex-fr/document/48AB438A7C1179DAB7757096669C75BAFF8AA325/</span>fulltext/pdf?auth=ip,fede&sid=ebsco,istex-view</a>

<a href="https://api.istex.fr/document/48AB438A7C1179DAB7757096669C75BAFF8AA325/fulltext/pdf?sid=istex-browser-addon?"><span class="mandParam">https://api.istex.fr/document/48AB438A7C1179DAB7757096669C75BAFF8AA325/</span>fulltext/pdf?sid=istex-browser-addon?</a>


* <span class="mandParam">URL de la plateforme</span>

* <span class="mandParam">Document/ numéro ISTEX/</span>

* Format du document

* Les modes [d’authentification]( https://api.istex.fr/documentation/access/) avec en premier l’adresse IP puis la fédération d’identité 

* Le sid qui caractérise la voie d’accès   

|1er exemple |[EDS/EBSCO Istex view](https://doc.istex.fr/users/discovery/)|
|----------|-----------------------------------------|
|2ème exemple|[L’extension](https://addons.istex.fr/)|


 
 ** => Dorénavant les notices vont se voir attribuer progressivement un ARK (Archival Resource Key)**

Seuls les corpus **« Cambridge »** et **« Nature »** sont déjà traités.
Sachant que les 2 types d’accès au document perdureront.
 
 _« Theatre in the Arab World: A Difficult Birth »_ qui provient de “Cambridge” l’accès au document se fait maintenant, également, avec cette url :

  <a href="https://api.istex.fr/ark:/67375/6GQ-9JJ7RGZM-W/fulltext.pdf"><span class="mandParam">https://api.istex.fr/ark:/67375/6GQ-9JJ7RGZM-W/</span><span class="vertgras">fulltext.pdf</a>
 
** => L’intérêt, aujourd’hui, c’est de pointer directement sur un format grâce <span class="vertgras">au qualificatif</a>**
				
<a href="https://api.istex.fr/ark:/67375/6GQ-9JJ7RGZM-W/"><span class="mandParam">https://api.istex.fr/ark:/67375/6GQ-9JJ7RGZM-W/</span></a>

La racine sans qualificatif indique toutes les typologies qui existent pour ce document

 ![Imageracine](img/ark.jpg)

**<span class="vertgras">Le qualificatif</a>** permet l’accès à un format spécifique.
 
**<a href="https://api.istex.fr/ark:/67375/6GQ-9JJ7RGZM-W/fulltext.tei"><span class="mandParam">https://api.istex.fr/ark:/67375/6GQ-9JJ7RGZM-W/</span><span class="vertgras">fulltext.tei</a>** 

** => Et demain, les qualificatifs permettront de pointer, citer… une page…une image …** 
Pour en savoir plus sur les ARK n’hésitez pas à consulter [le billet de blog](http://blog.istex.fr/des-ark-dans-istex/) et [la documentation sur les ARK](https://api.istex.fr/documentation/ark/)
 

  








