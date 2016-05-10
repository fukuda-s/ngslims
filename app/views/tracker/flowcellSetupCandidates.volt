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
            {% if seqlane["seqtemplate_id"] is defined %}
              <li
                  class="tube tube-active"
                  id="seqtemplate-tube-control" seqtemplate_id="{{ seqlane["seqtemplate_id"] }}"
                  seqtemplate_name="{{ seqlane["seqtemplate_name"] }}">{{ seqlane["seqtemplate_name"] }}</li>
            {% elseif seqlane["control_id"] is defined %}
              <li
                  class="tube tube-warning"
                  id="seqtemplate-tube-control" control_id="{{ seqlane["control_id"] }}"
                  seqtemplate_name="{{ seqlane["seqtemplate_name"] }}">{{ seqlane["seqtemplate_name"] }}</li>
            {% endif %}
          {% else %}
            <li class="tube"></li>
          {% endif %}
        {% endfor %}
      </ol>
      <div class="panel-footer clearfix">
        <button id="flowcell-clear-button" type="button" class="btn btn-default">Clear Flowcell Setup</button>
        <button id="flowcell-setup-button" type="button" class="btn btn-primary pull-right">Flowcell
          Setup &raquo;</button>
      </div>
    </div>
  </div>
</div>
<hr>
{% for control in controls %}
  <div class="panel panel-warning" id="seqtemplate-panel-control" control_id="{{ control.id }}"
       seqtemplate_name="{{ control.name }}">
    <div class="panel-heading">
      {{ control.name }}
    </div>
  </div>
{% endfor %}
<div class="row">
  <div class="col-md-12">
    {% for seqtemplate in seqtemplates %}
      {% if loop.first %}
        <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-2" style="padding: 6px 12px;">Sequence Template ID</div>
            <div class="col-md-6">
              <button type="button" class="btn btn-default pull-left" id="fill-seqtemplate">
                <span>
                  <i class="fa fa-arrow-up" aria-hidden="true"></i>
                  Fill Seq-template to Flowcell
                </span>
              </button>
            </div>
            <div class="col-md-4" style="padding: 6px 12px;">
              <input id="panel-filter" type="search" class="form-control input-xs" placeholder="Filtering Search">
              <button type="button" class="btn btn-default btn-xs" id="show-inactive" data-toggle="collapse"
                      data-target=".panel-default" style="min-width: 87px">Show
                inactive
              </button>
            </div>
          </div>
        </div>
        <div class="panel-group"  style="overflow: auto; height: 400px;">
      {% endif %}
      {% if seqtemplate.se.id != null and seqtemplate.se.status != 'Completed' and seqtemplate.se.status != 'On Hold' %}
        <div class="panel panel-info" id="seqtemplate-panel-{{ seqtemplate.st.id }}" data-toggle="collapse"
             data-target="#seqtemplate-table-{{ seqtemplate.st.id }}" seqtemplate_id="{{ seqtemplate.st.id }}"
             seqtemplate_name="{{ seqtemplate.st.name }}" onclick="showTableSeqlibs(this, {{ seqtemplate.st.id }})">
          <div class="panel-heading" id="seqtemplate-header-{{ seqtemplate.st.id }}">
            {{ seqtemplate.st.name }}
          </div>
        </div>
      {% else %}
        <div class="panel panel-default collapse" id="seqtemplate-panel-{{ seqtemplate.st.id }}" data-toggle="collapse"
             data-target="#seqtemplate-table-{{ seqtemplate.st.id }}" seqtemplate_id="{{ seqtemplate.st.id }}"
             seqtemplate_name="{{ seqtemplate.st.name }}">
          <div class="panel-heading" id="seqtemplate-header-{{ seqtemplate.st.id }}"
               onclick="showTableSeqlibs(this, {{ seqtemplate.st.id }})">
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
  /*
   * Function: showTableSeqlibs
   *  To show table of seqlibs which contains with selected seqtemplates.
   */
  function showTableSeqlibs(obj, seqtemplate_id) {
    var table = $(obj).find("#seqtemplate-table-" + seqtemplate_id);
    //console.log(table.attr("id"));
    // @TODO It should not be show table if the table is already exist. How is best way to recognize table exists?
    if (!table.attr("id")) {
      var target_id = '#seqtemplate-header-' + seqtemplate_id;
      $.ajax({
            url: '{{ url("trackerdetails/showTableSeqlibs") }}',
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
    /*
     * Set draggable for seqtemplate panels
     */
    $(".panel[id^=seqtemplate-panel-]").draggable({
      addClasses: false,
      cursor: 'move',
      helper: "clone"
    });

    /*
     * Set droppable to flowcell panel (not for 'ol' list-group) from seqtemplate panels.
     */
    $("#flowcell-panel li").each(function () {
      $(this).droppable({
        addClasses: false,
        hoverClass: "tube tube-placeholder",
        accept: ":not(.ui-sortable-helper)",
        tolerance: "pointer",
        drop: function (event, ui) {
          var seqtemplate_name = ui.draggable.context.getAttribute("seqtemplate_name");
          var seqtemplate_id = ui.draggable.context.getAttribute("seqtemplate_id");
          var control_id = ui.draggable.context.getAttribute("control_id");
          if (seqtemplate_id) {
            $(this)
                .text(seqtemplate_name)
                .removeAttr('seqtemplate_id')
                .removeAttr('control_id')
                .removeClass()
                .attr('seqtemplate_name', seqtemplate_name)
                .attr('seqtemplate_id', seqtemplate_id)
                .addClass("tube tube-active")
                .removeAttr("id");
          } else if (control_id) {
            $(this)
                .text(seqtemplate_name)
                .removeAttr('seqtemplate_id')
                .removeAttr('control_id')
                .removeClass()
                .attr('seqtemplate_name', seqtemplate_name)
                .attr('control_id', control_id)
                .addClass("tube tube-warning")
                .removeAttr("id");
          }
        },
        out: function (event, ui) {
          $(this).addClass('tube');
        }
      });
    });

    $("#flowcell-panel ol").sortable({
      cursor: 'move',
      placeholder: "tube tube-placeholder"
    });

    /*
     * Build function for #flowcell-setup-button
     */
    $("#flowcell-setup-button").click(function () {
      var parent_panel = $('#flowcell-panel');
      var flowcell_name = parent_panel.find('input#flowcell_name').val();
      //console.log(flowcell_name);

      var seqlanes = {};
      parent_panel.find("ol").children("li").each(function () {
        var seqlane_number = $(this).index() + 1;
        var seqtemplate_id;
        var seqtemplate_name;
        var control_id;
        var is_control;
        if ($(this).attr("seqtemplate_id")) {
          seqtemplate_id = $(this).attr("seqtemplate_id");
          seqtemplate_name = $(this).attr("seqtemplate_name");
          is_control = 'N';
          seqlanes[seqlane_number] = {
            seqlane_number: seqlane_number,
            seqtemplate_id: seqtemplate_id,
            seqtemplate_name: seqtemplate_name,
            is_control: is_control
          };
        } else if ($(this).attr("control_id")) {
          control_id = $(this).attr("control_id");
          seqtemplate_name = $(this).attr("seqtemplate_name");
          is_control = 'Y';
          seqlanes[seqlane_number] = {
            seqlane_number: seqlane_number,
            seqtemplate_name: seqtemplate_name,
            is_control: is_control,
            control_id: control_id
          };
        }
      });
      //console.log(seqlanes);

      $.ajax({
            url: '{{ url("tracker/flowcellSetupSetSession/") }}',
            dataType: 'text',
            type: 'POST',
            data: {
              flowcell_name: flowcell_name, seqlanes: seqlanes, flowcell_clear: 'false'
            }
          })
          .done(function () {
            window.location = "{{ url("tracker/flowcellSetup/") ~ step.id }}"
          });

    });

    /*
     * Build function for #flowcell-clear-button
     */
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

    /*
     * Put function to 'Search' form on tube list header.
     */
    $('#panel-filter').on('keyup', function (event) {
      var queryStr = new RegExp(event.target.value);
      //console.log(queryStr);
      $(event.target)
          .parents('.panel')
          .children('.panel-group')
          .find('.panel.ui-draggable-handle')
          .filter(function (index) {
            var css_display = $(this).css('display');
            var tube_textStr = $(this).attr('seqtemplate_name').toString();
            //console.log(index + ":" + css_display != 'none' && ! queryStr.test(tube_textStr));
            return css_display != 'none' && !queryStr.test(tube_textStr);
          })
          .addClass('tube-hidden');

      $(event.target)
          .parents('.panel')
          .children('.panel-group')
          .find('.tube-hidden')
          .filter(function (index) {
            var tube_textStr = $(this).attr('seqtemplate_name').toString();
            return queryStr.test(tube_textStr);
          })
          .removeClass('tube-hidden');
    });

    /*
     * Fill Sequence Template to flowcell
     */
    $('#fill-seqtemplate').click(function(){
      var lane_array = $("#flowcell-panel li:not(.tube-active)");
      var num_of_lane = lane_array.length;
      $('.panel-group > div.panel[id^="seqtemplate-panel-"]:visible').each(function(index){
        if(index == num_of_lane) {
          return false;
        }
        var seqtemplate_id = $(this).attr("seqtemplate_id");
        var seqtemplate_name = $(this).attr("seqtemplate_name");

        console.log(index + ":" + seqtemplate_id + ":" + seqtemplate_name);

        $(lane_array[index])
            .addClass('tube-active')
            .attr('seqtemplate_id', seqtemplate_id)
            .attr('seqtemplate_name', seqtemplate_name)
            .text(seqtemplate_name)
      });
    });
  })
</script>
