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

Si possible, merci également d'indiquer ``sid=lissa`` à la fin de l'appel à l'OpenURL ISTEX en adaptant le mot clé "lissa" à un petiti nom court décrivant votre portail. Ceci permettra à l'équipe ISTEX de récolter des statistiques d'utilisation de la plateforme ISTEX avec un peu de contexte.

Des intégrations similaires sont réalisées dans différents établissements en France :

- Université d'Aix-Marseille avec le [résolveur de lien SMASH](https://github.com/SCD-Aix-Marseille-Universite/SMASH/blob/master/resolver.js#L726-L746).  Un grand merci à Laurent Lhuillier pour cette intégration !
- [LiSSa](http://www.lissa.fr) "Base de donnée bibliographique en Santé". Un grand merci à Gaétan Kerdelhué et Julien Grosjean pour cette intégration !
- Vous très bientôt ? [dites-le à l'équipe ISTEX](mailto:contact@listes.istex.fr), savoir que la plateforme ISTEX est utilisée par la communauté et comment est très important.

# COinS pour le bouton ISTEX

Disponible sous peu.

# Intégration avancée avec l'API ISTEX

Disponible sous peu.

- [https://api.istex.fr](https://api.istex.fr)
