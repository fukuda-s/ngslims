<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
  <div class="navbar-header">
    <button class="navbar-toggle" data-toggle="collapse" data-target=".target">
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
    {{ link_to("index", "ngsLIMS", "class": "navbar-brand") }}
  </div>
  <div class="collapse navbar-collapse target">
    {{ elements.getMenu() }}
  </div>
</nav>