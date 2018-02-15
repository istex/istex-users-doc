# Intégrer ISTEX dans un ENT ou dans un site web

ISTEX a vocation à venir s'intégrer dans les outils documentaires des établissements. Il peut s'y intégrer de différentes manières.

Dans cette section nous détaillons les **intégrations d'ISTEX de type "Site web"**. 
Les typologies de sites web visés sont :

- Les ENT car ils permettent de proposer des points d'accès à tous les service d'une université, service de documentation compris.
- Les portails documentaires car ce sont les vitrines des services de la documentation de l'établissement, la bibliothèque numérique ISTEX peut logiquement venir s'y insérer.
- Les OPAC car ils proposent des ressources documentaires aux usagers de façon directe ou indirecte. ISTEX peut venir s'y insérer pour proposer un accès directe à la ressources lorsque cette dernière est présente dans ISTEX.

Remarque : les [intégrations dans les outils de découvertes et les résolveur de lien](../discovery-tools/) sont expliquées dans la section voisine.

Les technologies des sites web où ISTEX peut venir s'intégrer sont les suivantes :

- ENT uPortal
- CMS Drupal
- Tout autre site web divers en HTML/CSS

Attention car ces intégrations avancées nécessites des compétences plus où moins techniques : du webmaster à l'informaticien codeur.

Un webmaster pourra sans problème intégrer ISTEX en utilisant les techniques suivantes :

- Le widget ISTEX
- Le bouton ISTEX intégré
- COinS pour le bouton ISTEX

Un informaticien codeur (peu importe le language de programmation) pourra intégrer ISTEX en utilisant les techniques suivantes :

- Toute les techniques lister plus haut adaptées au webmaster.
- Intégration directe par API ISTEX

# Widget génériques

Disponible sous peu.

- [https://widgets.istex.fr](https://widgets.istex.fr)
- [https://github.com/istex/istex-widgets-angular](https://github.com/istex/istex-widgets-angular)

# ENT uPortal

Disponible sous peu.

- [https://github.com/istex/istex-ent-uportal](https://github.com/istex/istex-ent-uportal)

# Drupal

Disponible sous peu.

- [https://github.com/istex/istex-drupal](https://github.com/istex/istex-drupal)

# Bouton ISTEX intégré

Vous disposez d'un portail documentaire (exemple : base de données bibliographiques, archive institutionnelle ...) proposant des ressources documentaires ayant un recoupement avec celles présentes dans la plateforme ISTEX. Vous souhaitez alors afficher un bouton d'accès ISTEX aux *fulltexts* de ces ressources lorsque ces dernières sont présentes dans la plateforme ISTEX.

C'est par exemple ce que fait la base de donnée bibliographique [LiSSa](http://www.lissa.fr). Lorsque vous arrivez sur [la page d'une ressource](http://www.lissa.fr/fr/rep/articles/11109591) et que cette dernière est présente dans la plateforme ISTEX le site propose alors un bouton d'accès au *fulltext* de la ressource sur la droite (le bouton n'est pas affiché dans le cas contraire) comme vous pouvez le voir sur cette copie d'écran :

![Bouton ISTEX intégran dans LiSSa](../../img/lissa-btn-istex.png)



Ce bouton peut être intégré dans n'importe quel site web similaire. Il est cependant nécessaire d'avoir des  compétences de webmaster et que les ressources possèdent des métadonnées si possible de type identifiants (ex: PMID ou un DOI). 

Voici alors comment procéder au niveau de votre page HTML en reprenant l'exemple de LiSSa et en utilisant la librairie Javascript jQuery :

```html
<div class="block" id="istex-button-hook">
  <a onclick="urlClick2Log(this,'FT_NLM','NLM_11109591','SYS_USER_254');" href="http://dx.doi.org/10.1016/S0248-8663(00)00250-2" target="_blank" class="v-button-link block" style="margin-top:0px;margin-right:8px;margin-bottom:0px;margin-left:8px;"><img src="../../../img/icons/article_access_doi.png" alt=" "/></a>
  <a onclick="urlClick2Log(this,'FT_NLM','NLM_11109591','SYS_USER_254');" href="http://linkinghub.elsevier.com/retrieve/pii/S0248866300002502" target="_blank" class="v-button-link block" style="margin-top:0px;margin-right:8px;margin-bottom:0px;margin-left:8px;"><img src="../../../img/icons/article_access.png" alt=" "/></a>
  <script type="text/javascript">
  $.get('https://api.istex.fr/document/openurl?rft_id=info:doi/10.1016/S0248-8663(00)00250-2&noredirect=1&sid=lissa')
    .done(function (res) {
      if (res && res.resourceUrl) {
        var btn = $('<a><img src="../../../img/icons/article_access_istex.png" alt=" "/></a>');
        btn.attr('onclick', "urlClick2Log(this,\'FT_NLM\',\'NLM_11109591\',\'SYS_USER_254\');");
        btn.attr('href', res.resourceUrl);
        btn.attr('target', "_blank");
        btn.attr('class', "v-button-link block");
        btn.attr('style', "margin-top:0px;margin-right:8px;margin-bottom:0px;margin-left:8px;");
        $('#istex-button-hook').append(btn);
      }
    });
  </script>
</div>
```

Vous remarquez que l'[OpenURL de l'API ISTEX](https://api.istex.fr/documentation/openurl/) est appelée en AJAX en interrogeant le DOI :

``https://api.istex.fr/document/openurl?rft_id=info:doi/10.1016/S0248-8663(00)00250-2&noredirect=1&sid=lissa``

Vous devrez alors rendre la valeur du DOI paramétrable (sur notre exemple "10.1016/S0248-8663(00)00250-2") pour que la vérification de disponibilité de la ressource côté ISTEX puisse se faire en fonction de la ressource actuellement consultée par l'utilisateur.

Pensez également à ajuster votre HTML et le code jQuery pour venir ajouter le bon élément HTML au bon endroit dans votre page web (notez l'ajout de l'attribut ``id="istex-button-hook"``)

Si possible, merci également d'indiquer ``sid=lissa`` à la fin de l'appel à l'OpenURL ISTEX en adaptant le mot clé "lissa" à un nom court décrivant votre portail. Ceci permettra à l'équipe ISTEX de récolter des statistiques d'utilisation de la plateforme ISTEX avec un peu de contexte.

Des intégrations similaires sont réalisées dans différents établissements en France :

- Université d'Aix-Marseille avec le [résolveur de lien SMASH](http://sh2hh6qx2e.search.serialssolutions.com/?url_ver=Z39.88-2004&ctx_ver=Z39.88-2004&rfr_id=info%3Asid%2Fzotero.org%3A2&rft_id=info%3Adoi%2F10.1108%2F17465261011016531&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&rft.genre=article&rft.atitle=Post%E2%80%90merger%20integration%20and%20change%20processes%20from%20a%20complexity%20perspective&rft.jtitle=Baltic%20Journal%20of%20Management&rft.volume=5&rft.issue=1&rft.aufirst=B%C3%A4rbel&rft.aulast=Lauser&rft.au=B%C3%A4rbel%20Lauser&rft.date=2010-01-12&rft.pages=6-27&rft.spage=6&rft.epage=27&rft.issn=1746-5265&rft.language=en).  Un grand merci à Laurent Lhuillier pour cette intégration ! ([code source](https://github.com/SCD-Aix-Marseille-Universite/SMASH/blob/master/resolver.js#L726-L746))

  [![](../../img/istex-smash-small.png)](http://sh2hh6qx2e.search.serialssolutions.com/?url_ver=Z39.88-2004&ctx_ver=Z39.88-2004&rfr_id=info%3Asid%2Fzotero.org%3A2&rft_id=info%3Adoi%2F10.1002%2Fanie.201306656&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&rft.genre=article&rft.atitle=Enantioselective%20Organocatalytic%20Multicomponent%20Synthesis%20of%202%2C6-Diazabicyclo%5B2.2.2%5Doctanones&rft.jtitle=Angewandte%20Chemie%20International%20Edition&rft.stitle=Angew.%20Chem.%20Int.%20Ed.&rft.volume=52&rft.issue=52&rft.aufirst=Maria%20del%20Mar&rft.aulast=Sanchez%E2%80%85Duque&rft.au=Maria%20del%20Mar%20Sanchez%E2%80%85Duque&rft.au=Olivier%20Basl%C3%A9&rft.au=Yves%20G%C3%A9nisson&rft.au=Jean-Christophe%20Plaquevent&rft.au=Xavier%20Bugaut&rft.au=Thierry%20Constantieux&rft.au=Jean%20Rodriguez&rft.date=2013-12-23&rft.pages=14143-14146&rft.spage=14143&rft.epage=14146&rft.issn=1521-3773&rft.language=en)

- [LiSSa](http://www.lissa.fr) "Base de donnée bibliographique en Santé". Un grand merci à Gaétan Kerdelhué et Julien Grosjean pour cette intégration !



- [Archive ouverte HAL](https://hal.archives-ouvertes.fr/)
  Dans HAL, la notice est enrichie avec un lien vers le texte intégral lorsque celui-ci est disponible en libre accès sur une autre plateforme comme arXiv ou PubMed Central. Le bouton d'accès ISTEX s’affiche si la ressource n’existe pas en libre accès mais est disponible sur la plateforme ISTEX (cf [billet de blog HAL](https://www.ccsd.cnrs.fr/2018/02/faciliter-acces-au-texte-integral-en-signalant-les-ressources-en-libre-acces/) et [billet de blog ISTEX](http://blog.istex.fr/une-nouvelle-integration-du-bouton-istex-hal/))
  [![interrogationhal](../../img/istexhal1.JPG)](https://hal.archives-ouvertes.fr/hal-01705904)
  Un grand merci à Yannick Barborini et toute son équipe pour cette intégration !



- Vous très bientôt ? [dites-le à l'équipe ISTEX](mailto:contact@listes.istex.fr), savoir que la plateforme ISTEX est utilisée par la communauté et comment est très important.

# Métadonnées pour le bouton ISTEX

L'[extension pour navigateur ISTEX](../../usage/button/) permet de venir afficher des boutons ISTEX ![](../../img/istex-button.png) au sein de vos pages web lorsque des références bibliographiques y sont trouvées et qu'elles correspondent à des ressources présentes dans la plateforme ISTEX. Pour que cette technique fonctionne cela nécessite d'[installer dans son navigateur web l'extension ISTEX](../../usage/button/).

Ces références bibliographiques sont le plus souvent des identifiants forts de documents comme des DOI ou des PMID mais elle peuvent également être des OpenURL que le bouton ISTEX sera aussi capable de repérer. Ces métadonnées peuvent apparaitre dans la page HTML sous différentes formes.

Par exemple par la présence d'une ancre HTML :

```html
<a href="http://dx.doi.org/10.1016/S0248-8663(00)00250-2">Accès à l'article</a>
```

Ou encore avec un PMID qui sera détecté dans le HTML (cf [exemple en bas de cette page](https://fr.wikipedia.org/wiki/Espace_dod%C3%A9ca%C3%A9drique_de_Poincar%C3%A9)) :

```html
<a rel="nofollow" href="http://www.ncbi.nlm.nih.gov/pubmed/14534579">
14534579
</a>
```

Ou bien par la présence d'un DOI directement dans le texte d'un paragraphe :

```html
<p>
  Texte de mon article citant un DOI : 10.1016/S0248-8663(00)00250-2
</p>
```

Et également par la présence du DOI directement dans une [balise COinS](https://www.zotero.org/support/dev/exposing_metadata/coins) :

```html
<span class="Z3988" title="ctx_ver=Z39.88-2004&amp;id=doi:10.1016/S0987-7053(05)80281-3"></span> 
```

Et un peu plus complexe avec un set de métadonnées complet exprimé sous la forme d'un COinS OpenURL (cf [exemple en bas de cette page](https://fr.wikipedia.org/wiki/Espace_dod%C3%A9ca%C3%A9drique_de_Poincar%C3%A9)) :

```html
<span class="Z3988" title="ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=Dodecahedral+space+topology+as+an+explanation+for+weak+wide-angle+temperature+correlations+in+the+cosmic+microwave+background&amp;rft.jtitle=Nature&amp;rft.issue=6958&amp;rft.aulast=Luminet&amp;rft.aufirst=Jean-Pierre&amp;rft.au=Jeff+Weeks&amp;rft.date=2003-10-09&amp;rft.volume=425&amp;rft.pages=593%E2%80%93595&amp;rft_id=info%3Adoi%2F10.1038%2Fnature01944&amp;rft_id=info%3Apmid%2F14534579&amp;rfr_id=info%3Asid%2Ffr.wikipedia.org%3AEspace+dod%C3%A9ca%C3%A9drique+de+Poincar%C3%A9" id="COinS_47149"></span>
```

Ces deux dernière manières de procéder avec COinS couplé à une balise span vide permettent d'afficher le bouton ISTEX dynamiquement à cet emplacement dans la page web et seulement lorsque la ressource ISTEX est disponible.

Toutes ces techniques sont des bonnes manières de procéder surtout lorsque vous avez des listes d'articles à présenter. C'est souvent le cas lorsqu'un portail documentaire ou une base de données bibliographique affiche une liste de résultats suite à une recherche.

Donc si vous voulez que des ![accès aux ressources ISTEX](../../img/istex-button.png) apparaissent automatiquement dans vos listes de résultats **pensez à y indiquer d'une façon ou d'une autre le DOI ou le PMID des ressources en question**.

# Intégration avancée avec l'API ISTEX

Disponible sous peu.

- [https://api.istex.fr](https://api.istex.fr)
