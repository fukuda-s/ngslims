<ol class="breadcrumb">
  <li>
    {{ link_to('tracker', 'Tracker') }}
  </li>
  <li>
    {{ link_to('tracker/experiments/' ~ step.step_phase_code , step.StepPhases.description ~ ' View' ) }}
  </li>
  <li class="active">
    {{ step.name }}
  </li>
</ol>
{{ flashSession.output() }}
<div class="row">
  <div class="col-md-12">
    <div class="panel panel-primary" id="flowcell-panel">
      <div class="panel-heading">
        <h3 class="panel-title">Flowcell</h3>
      </div>
      <div class="panel-body">
        <label for="flowcell_name">Flowcell ID</label>
        {% if flowcell_name is defined %}
          {{ text_field('flowcell_name', 'value': flowcell_name) }}
        {% else %}
          {{ text_field('flowcell_name') }}
        {% endif %}
      </div>
      <ol class="panel-body">
        {% for index in lane_index %}
          {% if seqlanes[index] is defined %}
            {% set seqlane = seqlanes[index] %}
            <li class="tube tube-active"
                id="seqtemplate-tube-{{ seqlane["seqtemplate_id"] }}">{{ seqlane["seqtemplate_name"] }}</li>
          {% else %}
            <li class="tube placeholder"></li>
          {% endif %}
        {% endfor %}
      </ol>
      <div class="panel-footer clearfix">
        <button id="flowcell-clear-button" type="button" class="btn btn-default">Clear Flowcell Setup</button>
        <button id="flowcell-confirm-button" type="button" class="btn btn-primary pull-right">Confirm Flowcell
          Setup &raquo;</button>
      </div>
    </div>
  </div>
</div>
<hr>
<div class="panel panel-warning" id="seqtemplate-panel-control" name="PhiX">
  <div class="panel-heading">
    PhiX (Control)
  </div>
</div>
<div class="row">
  <div class="col-md-12">
    {% for seqtemplate in seqtemplates %}
      {% if loop.first %}
        <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-8">Sequence Template ID</div>
            <div class="col-md-1">
            </div>
            <div class="col-md-1">
            </div>
            <div class="col-md-2">
              <button type="button" class="btn btn-default btn-xs" id="show-inactive" data-toggle="collapse"
                      data-target=".panel-default" style="min-width: 87px">Show
                inactive
              </button>
            </div>
          </div>
        </div>
        <div class="panel-group">
      {% endif %}
      {% if seqtemplate.se.id != null and seqtemplate.se.status != 'Completed' %}
        <div class="panel panel-info" id="seqtemplate-panel-{{ seqtemplate.st.id }}" data-toggle="collapse"
             data-target="#seqtemplate-table-{{ seqtemplate.st.id }}" name="{{ seqtemplate.st.name }}">
          <div class="panel-heading" id="seqtemplate-header-{{ seqtemplate.st.id }}">
            {{ seqtemplate.st.name }}
          </div>
        </div>
      {% else %}
        <div class="panel panel-default collapse" id="seqtemplate-panel-{{ seqtemplate.st.id }}"
             data-toggle="collapse" data-target="#seqtemplate-table-{{ seqtemplate.st.id }}"
             name="{{ seqtemplate.st.name }}">
          <div class="panel-heading" id="seqtemplate-header-{{ seqtemplate.st.id }}">
            {{ seqtemplate.st.name }}
          </div>
        </div>
      {% endif %}
      {% if loop.last %}
        </div>
        </div>
      {% endif %}
      {% elsefor %} No Seqtemplates recorded
    {% endfor %}
  </div>
</div>
<script>
  function showTableSeqLibs(obj, seqtemplate_id) {
    var table = $(obj).find("#seqtemplate-table-" + seqtemplate_id);
    //console.log(table.attr("id"));
    // @TODO It should not be show table if the table is already exist. How is best way to recognize table exists?
    if (!table.attr("id")) {
      var target_id = '#seqtemplate-header-' + seqtemplate_id;
      $.ajax({
        url: '{{ url("trackerProjectSamples/showTableSeqLibs") }}',
        dataType: 'html',
        type: 'POST',
        data: {
          seqtemplate_id: seqtemplate_id
        }
      })
          .done(function (data) {
            $(target_id).after(data);
            //console.log(target_id);
          });
    }
  }

  $(document).ready(function () {
    $(".panel[id^=seqtemplate-panel-]").draggable({
      addClasses: "false",
      appendTo: "body",
      helper: "clone"
    })
        .each(function () {
          //Append click function to show seqlib table as detail information.
          $(this).click(function () {
            var seqtemplate_id = $(this).attr('id').replace('seqtemplate-panel-', '');
            showTableSeqLibs(this, seqtemplate_id);
            //console.log(seqtemplate_id);
          })
        });

    $("#flowcell-panel li").droppable({
      hoverClass: "tube-placeholder",
      accept: ":not(.ui-sortable-helper)",
      drop: function (event, ui) {
        //console.log(ui.draggable);
        $(this).removeClass("placeholder");

        var name = ui.draggable.context.getAttribute("name");
        $(this).text(name).addClass("tube-active");

        var newid = ui.draggable.context.id.replace('panel', 'tube');
        $(this).attr('id', newid);

        if (name == "PhiX") {
          $(this).append("<div class='pull-right clearfix'>Control Lane <input type='checkbox' name='control-lane' checked disabled></div>");
        } else {
          $(this).append("<div class='pull-right clearfix'>Control Lane <input type='checkbox' name='control-lane'></div>");
        }
      }
    });

    $("#flowcell-panel ol").sortable();

    $("#flowcell-confirm-button").click(function () {
      var parent_panel = $('#flowcell-panel');
      var flowcell_name = parent_panel.find('input#flowcell_name').val();
      console.log(flowcell_name);

      var seqlanes = [];
      parent_panel.find("ol").children("li").each(function () {
        var seqlane_number = $(this).index() + 1;
        if ($(this).attr("id")) {
          var seqtemplate_id = $(this).attr("id").replace("seqtemplate-tube-", "");
          var seqtemplate_name = $(this).html(); //text() with html() because seqtemplate_name is first child.
          var control_lane = 'N';
          if ($(this).find('input[name="control-lane"]').is(':checked')) {
            control_lane = 'Y';
          }
          seqlanes.push({seqlane_number: seqlane_number, seqtemplate_id: seqtemplate_id, seqtemplate_name: seqtemplate_name, control_lane: control_lane });
        }
      })
      //console.log(seqlanes);

      $.ajax({
        url: '{{ url("tracker/flowcellSetupSetSession/") ~ step.id }}',
        dataType: 'text',
        type: 'POST',
        data: {
          flowcell_name: flowcell_name, seqlanes: seqlanes, flowcell_clear: 'false'
        }
      })
          .done(function () {
            window.location = "{{ url("tracker/flowcellSetupConfirm/") ~ step.id }}"
          });

    });

    $("#flowcell-clear-button").click(function () {
      $.ajax({
        url: '{{ url("tracker/flowcellSetupSetSession/") ~ step.id }}',
        dataType: 'text',
        type: 'POST',
        data: {
          flowcell_clear: 'true'
        }
      })
          .done(function () {
            window.location = "{{ url("tracker/flowcellSetupCandidates/") ~ step.id }}"
          });
    });
  })
</script>
