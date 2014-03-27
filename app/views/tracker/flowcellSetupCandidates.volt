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
  <div class="col-md-10">
  </div>
  <div class="col-md-2">
    <button id="mixup-seqlibs-button" type="button" class="btn btn-primary">Flowcell Setup &raquo;</button>
  </div>
</div>
<hr>
<div class="row">
  <div class="col-md-8">
    {% for seqtemplate in seqtemplates %}
      {% if loop.first %}
        <div class="panel-group">
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
      {% endif %}
      {% if seqtemplate.se.id != null and seqtemplate.se.status != 'Completed' %}
        <div class="panel panel-info" onclick="showTableSeqLibs({{ seqtemplate.st.id }})">
          <div class="panel-heading">
            {{ seqtemplate.st.name }}
          </div>
          <div id="seqlib-table-seqtemplate_id-{{ seqtemplate.st.id }}"></div>
        </div>
      {% else %}
        <div class="panel panel-default collapse" onclick="showTableSeqLibs({{ seqtemplate.st.id }})">
          <div class="panel-heading">
            {{ seqtemplate.st.name }}
          </div>
        </div>
        <div id="seqlib-table-seqtemplate_id-{{ seqtemplate.st.id }}"></div>
      {% endif %}
      {% if loop.last %}
        </div>
        </div>
      {% endif %}
      {% elsefor %} No Seqtemplates recorded
    {% endfor %}
  </div>
  <div class="col-md-4">

  </div>
</div>
<script>
  function showTableSeqLibs(seqtemplate_id) {
    target_id = '#seqlib-table-seqtemplate_id-' + seqtemplate_id;
    $.ajax({
      url: '{{ url("trackerProjectSamples/showTableSeqLibs") }}',
      dataType: 'html',
      type: 'POST',
      data: {
        seqtemplate_id: seqtemplate_id
      }
    })
        .done(function (data) {
          $(target_id).html(data);
          console.log(target_id);
        });
  }
</script>
