<nav class="navbar navbar-inverse" role="navigation">
  <div class="navbar-header">
    <button class="navbar-toggle" data-toggle="collapse" data-target=".target">
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
    {{ link_to("/index", "ngsLIMS", "class": "navbar-brand") }}
  </div>
  <div class="collapse navbar-collapse target">
  	{{ elements.getMenu() }}
    <form class="navbar-form navbar-right" role="search" action="report.php">
      <div class="form-group">
        <input method="get" name="search_l" type="text" class="form-control" placeholder="Sample Search" />
      </div>
      <button type="submit" class="btn btn-default" value="action">Submit</button>
    </form>
  </div>
</nav>