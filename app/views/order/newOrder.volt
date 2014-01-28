{{ content() }}
<div class="row">
<div class="col-md-9">
  <div class="panel panel-default">
    <div class="panel-heading">User & Project</div>
    <div class="panel-body">
      <button type="button" class="btn btn-default btn-sm pull-right" data-target="#add_new_lab">
        <span class="glyphicon glyphicon-plus" data-toggle="collapse"></span>
      </button>
      <div id="lab_select" class="form-group">
        <label for="lab_id" class="control-label">Lab
        </label>
        {{ select('lab_id', labs, 'using': ['id', 'name'], 'useEmpty': true, 'emptyText': 'Please, choose Laboratory...', 'emptyValue': '@', 'class': 'form-control input-sm') }}
      </div>

      <button type="button" class="btn btn-default btn-sm pull-right">
        <span class="glyphicon glyphicon-plus" data-toggle="collapse" data-target="#add_new_pi"></span>
      </button>
      <div id="pi_user_select" class="form-group">
        <label for="pi_user_id" class="control-label">PI
        </label>
        <select id="pi_user_id" class="form-control input-sm" disabled></select>
      </div>

      <button type="button" class="btn btn-default btn-sm pull-right">
        <span class="glyphicon glyphicon-plus" data-toggle="collapse" data-target="#add_new_project"></span>
      </button>
      <div id="project_select" class="form-group">
        <label for="project_id" class="control-label">Project
        </label>
        <select id="project_id" class="form-control input-sm" disabled></select>
      </div>
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">Sample</div>
    <div class="panel-body">
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
            <li class="disabled" id="undo"><a href="#"><i class="fa fa-undo"></i> Undo</a></li>
            <li class="disabled" id="redo"><a href="#">Redo <i class="fa fa-repeat"></i></a></li>
          </ul>
          <form class="navbar-form navbar-right" role="search">
            <div class="form-group">
              <input type="text" class="form-control" placeholder="Search">
            </div>
          </form>
          <ul class="nav navbar-nav navbar-right">
            <li class="disabled" id="clear"><a href="#">Clear edit <i class="fa fa-refresh"></i></a></li>
          </ul>
        </div>
        <!-- /.navbar-collapse -->
      </nav>
      <div id="handsontable-sample"></div>
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">Sequence Library & Multiplex</div>
    <div class="panel-body"></div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">Sequencing Run</div>
    <div class="panel-body"></div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">Pipeline</div>
    <div class="panel-body"></div>
  </div>
</div>
<div class="col-md-3" id="new_order_summary">
  <div class="panel panel-default">
    <div class="panel-heading">Summary</div>
    <ul class="list-group">
      <li class="list-group-item">User & Project
        <ul>
          <li id="lab_name_selected" style="display: none;"></li>
          <li id="pi_user_name_selected" style="display: none;"></li>
          <li id="project_name_selected" style="display: none;"></li>
        </ul>
      </li>
      <li class="list-group-item">Sample
        <ul>
          <li>XXX</li>
        </ul>
      </li>
      <li class="list-group-item">Seqlib & Multiplex
        <ul>
          <li>XXX</li>
        </ul>
      </li>
      <li class="list-group-item">Sequencing
        <ul>
          <li>XXX</li>
        </ul>
      </li>
      <li class="list-group-item">Pipeline
        <ul>
          <li>XXX</li>
        </ul>
      </li>
    </ul>
    <div class="panel-footer">
      <button type="button" class="btn btn-default btn-xs" id=""> Next <span
            class="glyphicon glyphicon-chevron-right"></span>
      </button>
    </div>
  </div>
</div>
<script>
  $(document).ready(function () {
    /*
     * Fix cart
     */
    $("#new_order_summary").stick_in_parent();

    /*
     * Build function to get project list from selected pi_user_id.
     */
    function getProjectList(pi_user_id) {
      $.ajax({
        url: '{{ url("order/projectSelectList/")}}' + pi_user_id + '/',
        dataType: "html",
        type: "POST"
      })
          .done(function (data, status, xhr) {
            $("#project_select").html(data);
            //Change project_name_selected value on right side summary with selected values
            $("#project_id").change(function () {
              var project_name_selected = $("#project_id option:selected").text();
              $("#project_name_selected").show("normal").text(project_name_selected);
            });
          });
    };

    /*
     * Change PI user select list when lab select is changed
     */
    $("#lab_id").change(function () {
      $.ajax({
        url: '{{ url("order/userSelectList/")}}' + $(this).val() + '/',
        dataType: "html",
        type: "POST"
      })
          .done(function (data, status, xhr) {
            //Make select
            $("#pi_user_select").html(data);
            /*
             * Change Project list when pi_user_id select is changed
             */
            $("#pi_user_id").change(function () {
              getProjectList($(this).val());
              var pi_user_name_selected = $("#pi_user_id option:selected").text();
              $("#pi_user_name_selected").hide().show("normal").text(pi_user_name_selected);
            });

            //Change lab_name_selected value on right side summary with selected values
            var lab_name_selected = $("#lab_id option:selected").text();
            $("#lab_name_selected").show("normal").text(lab_name_selected);
            //Change pi_user_name_selected value on right side summary with first value (current user's name has been set).
            var pi_user_name_selected = $("#pi_user_id").children().first().text();
            $("#pi_user_name_selected").show("normal").text(pi_user_name_selected);

            //Refresh project_select
            var pi_user_id_selected = $("#pi_user_id").children().first().val();
            getProjectList(pi_user_id_selected);
          });
    });

    /*
     * Build Handsontable
     */
    var $container = $("#handsontable-sample");
    var $console = $("#handsontable-console");
    var $toolbar = $("#handsontable-toolbar");
    var autosaveNotification = new String();
    var isDirtyAr = new Array();
    $container.handsontable({
      stretchH: 'all',
      rowHeaders: true,
      contextMenu: true,
      minSpareRows: 1,
      columnSorting: true,
      manualColumnResize: true,
      columns: [
        { data: "name", title: "Sample Name" },
        { data: "qual_concentration", title: "Conc. (ng/uL)", type: 'numeric', format: '0.000' },
        { data: "qual_od260280", title: "A260/A280", type: 'numeric', format: '0.00' },
        { data: "qual_od260230", title: "A260/A230", type: 'numeric', format: '0.00' },
        { data: "qual_RIN", title: "RIN", type: 'numeric', format: '0.00' },
        { data: "qual_fragmentsize", title: "Fragment Size", type: 'numeric' },
        { data: "qual_nanodrop_conc", title: "Conc. (ng/uL) (NanoDrop)", type: 'numeric', format: '0.000' },
        { data: "qual_volume", title: "Volume (uL)", type: 'numeric', format: '0.00' },
        { data: "qual_amount", data: 0, title: "Total (ng)", type: 'numeric', format: '0.00' },
        { data: "qual_date", title: "QC Date", type: 'date', dateFormat: 'yy-mm-dd' }
      ]
    });

  });
</script>