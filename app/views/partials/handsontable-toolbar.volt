<div class="alert alert-info" id="handsontable-console">Click "Save" to save data to server</div>
<nav class="navbar navbar-default" role="navigation">
  <!-- Brand and toggle get grouped for better mobile display -->
  <div class="navbar-header">
    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#handsontable-toolbar">
      <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span
          class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
    </button>
  </div>
  <!-- Collect the nav links, forms, and other content for toggling -->
  <div class="collapse navbar-collapse" id="handsontable-toolbar">
    <ul class="nav navbar-nav">
      <li class="disabled" id="save"><a href="#"><i class="fa fa-save"></i> Save</a></li>
      <li class="disabled" id="undo"><a href="#"><i class="fa fa-undo"></i> Unde</a></li>
      <li class="disabled" id="redo"><a href="#">Redo <i class="fa fa-repeat"></i></a></li>
    </ul>
    <form class="navbar-form navbar-right" role="search">
      <div class="form-group">
        {% if step.id == 0 %}
        <select id="sample_property_types" multiple="multiple">
        {% for sample_property_type in sample_property_types %}
          {% if sample_property_type.sample_count > 0 %}
            <option value="sample_property_type_id_{{ sample_property_type.id }}" disabled="disabled" selected>{{ sample_property_type.name }}</option>
          {% else %}
            <option value="sample_property_type_id_{{ sample_property_type.id }}">{{ sample_property_type.name }}</option>
          {% endif %}
        {% endfor %}
        </select>
        {% endif %}
        <input type="text" class="form-control" placeholder="Search">
      </div>
    </form>
    <ul class="nav navbar-nav navbar-right">
      <li class="disabled" id="clear"><a href="#">Clear edit <i class="fa fa-refresh"></i></a></li>
    </ul>
  </div>
  <!-- /.navbar-collapse -->
</nav>
<div class="checkbox" id="handsontable-autosave">
  <label> <input class="checkbox" type="checkbox" autocomplete="off"> Autosave
  </label>
</div>