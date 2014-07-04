<ol class="breadcrumb">
  <li>
    {{ link_to('tracker', 'Tracker') }}
  </li>
  <li>
    {{ link_to('tracker/sequence/', 'Sequencing Run Setup View' ) }}
  </li>
  <li class="active">
    {{ instrument_type.name }}
  </li>
</ol>
{{ flashSession.output() }}
<div class="row">
  <div class="col-md-12">

  </div>
</div>
<hr>
<div class="row">
  <div class="col-md-12">
    {% for flowcell in flowcells %}
      {% if loop.first %}
        <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-4">Available Flowcells</div>
            <div class="col-md-8">Required Seq Run Type</div>
          </div>
        </div>
        <div class="panel-group">
      {% endif %}
      <div class="panel panel-info" id="flowcell-panel-{{ flowcell.fc.id }}">
        <div class="panel-heading" id="flowcell-header-{{ flowcell.fc.id }}" data-toggle="collapse"
             href="#seqtemplate-tube-list-flowcell-id-{{ flowcell.fc.id }}"
             onclick="showTubeSeqtemplates({{ flowcell.fc.id }})">
          <div class="row">
            <div class="col-md-4">
              {{ flowcell.fc.name }}
            </div>
            <div class="col-md-8">
              {{ flowcell.seqrun_prop_name }}
            </div>
          </div>
        </div>
        <div id="seqtemplate-tube-list-flowcell-id-{{ flowcell.fc.id }}" class="panel-collapse collapse"></div>
      </div>
      {% if loop.last %}
        </div>
        </div>
      {% endif %}
      {% elsefor %} No flowcells recorded
    {% endfor %}
  </div>
</div>
<script>
  function showTubeSeqtemplates(flowcell_id) {
    target_id = '#seqtemplate-tube-list-flowcell-id-' + flowcell_id;
    $.ajax({
      url: '{{ url("trackerdetails/showTubeSeqtemplates") }}',
      dataType: 'html',
      type: 'POST',
      data: {
        flowcell_id: flowcell_id
      }
    })
        .done(function (data) {
          $(target_id).html(data);
          //console.log(target_id);
        });
  }

  function showPopoverTableSeqlibs(obj, seqtemplate_id, seqtemplate_name, seqlane_id) {
    var target_id = '#seqlane-tube-seqlane-id-' + seqlane_id;
    $.ajax({
      url: '{{ url("trackerdetails/showTableSeqlibs") }}',
      dataType: 'html',
      type: 'POST',
      data: {
        seqtemplate_id: seqtemplate_id
      }
    })
        .done(function (data) {
          $(target_id).popover({
            title: "Seqlibs in "+seqtemplate_name,
            content: data,
            html: true,
            placement: "auto"
          });
          //console.log(target_id);
        });
  }

</script>
