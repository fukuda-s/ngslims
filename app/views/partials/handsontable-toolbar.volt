<!--
  ~ (The MIT License)
  ~
  ~ Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining
  ~ a copy of this software and associated documentation files (the
  ~ 'Software'), to deal in the Software without restriction, including
  ~ without limitation the rights to use, copy, modify, merge, publish,
  ~ distribute, sublicense, and/or sell copies of the Software, and to
  ~ permit persons to whom the Software is furnished to do so, subject to
  ~ the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be
  ~ included in all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  ~ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  ~ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  ~ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  ~ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  ~ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  ~ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  -->

<div class="loading_icon collapse">
  {{ image('images/loading.gif') }}
</div>

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
      <li class="disabled" id="undo"><a href="#"><i class="fa fa-undo"></i> Undo</a></li>
      <li class="disabled" id="redo"><a href="#">Redo <i class="fa fa-repeat"></i></a></li>
    </ul>
    <form class="navbar-form navbar-right" role="search">
      <div class="form-group">
        {% if step.tabtype is defined and step.tabtype == 'sample' %}
          <select id="sample_property_types" multiple="multiple">
            {% for sample_property_type in sample_property_types %}
              {% if sample_property_type.sample_count > 0 %}
                <option value="sample_property_type_id_{{ sample_property_type.id }}" disabled="disabled"
                        selected>{{ sample_property_type.name }}</option>
              {% else %}
                <option
                    value="sample_property_type_id_{{ sample_property_type.id }}">{{ sample_property_type.name }}</option>
              {% endif %}
            {% endfor %}
          </select>
        {% endif %}
        <input id="search_field" type="search" class="form-control" placeholder="Search">
      </div>
    </form>
    <ul class="nav navbar-nav navbar-right">
      <li class="disabled" id="clear"><a href="#">Clear edit <i class="fa fa-refresh"></i></a></li>
    </ul>
  </div>
</nav>
  <!-- /.navbar-collapse -->
<form class="form-inline">
  <div class="form-group" id="handsontable-autosave">
    <label for="handsontable-autosave">
      <input class="checkbox" type="checkbox" autocomplete="off"> Autosave
    </label>
  </div>
  <button id="handsontable-size-ctl" type="button" class="btn btn-default pull-right">
    <span class="fa fa-expand"></span>
  </button>
</form>

<div class="clearfix"></div>