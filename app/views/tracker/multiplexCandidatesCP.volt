<ul class="nav nav-tabs">
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=PI', 'PI') }}</li>
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=PJ', 'Project') }}</li>
  <li class="active"><a href="#">Cherry Picking</a></li>
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=SP', 'Search Picking') }}</li>
</ul>
<div class="panel-group" id="projectOverview">
  {% for cherry_picking in cherry_pickings %}
    {% if loop.first %}
      <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-7">Cherry Picking Name</div>
            <div class="col-md-2">User Name</div>
            <div class="col-md-1">
              <small>#seqlib</small>
            </div>
            <div class="col-md-2">
              <button type="button" class="btn btn-default btn-xs" id="show-inactive-panel">
                <div>Show Completed/On Hold</div>
                <div style="display: none">Hide Completed/On Hold</div>
              </button>
            </div>
          </div>
        </div>
      </div>
    {% endif %}

    {% if cherry_picking.seqlib_count_all !== cherry_picking.seqlib_count_used %}
      {% set active_status = 'active' %}
      {% set seqlib_count = cherry_picking.seqlib_count_all - cherry_picking.seqlib_count_used %}
    {% else %}
      {% set active_status = 'inactive' %}
      {% set seqlib_count = cherry_picking.seqlib_count_all %}
    {% endif %}

    <div {% if active_status is 'active' %} class="panel panel-info" id="cherry_picking_id_{{ cherry_picking.cp.id }}"
    {% else %} class="panel panel-default collapse" id="inactives-{{ cherry_picking.cp.id }}" {% endif %}>
      <div class="panel-heading" data-toggle="collapse"
           data-target="#seqlib-tube-list-target-id-0-{{ cherry_picking.cp.id }}" id="OwnerList" onclick="showTubeSeqlibs({{ step.id }}, 0, {{ cherry_picking.cp.id  }})">
        <h4 class="panel-title">
          <div class="row">
            <div class="col-md-7">
              <div class="">{{ cherry_picking.cp.name ~ ' -- ' ~ cherry_picking.cp.created_at }}</div>
            </div>
            <div class="col-md-2">
              <div class="">{{ cherry_picking.u.getFullname() }}</div>
            </div>
            <div class="col-md-2">
              <span class="badge">{{ seqlib_count }}</span>
            </div>
            <div class="col-md-1">
              <i class="indicator glyphicon glyphicon-chevron-right pull-right"></i>
            </div>
          </div>
        </h4>
      </div>
      <div class="collapse" id="seqlib-tube-list-target-id-0-{{ cherry_picking.cp.id }}">
      </div>
    </div>
    {% elsefor %} No cherry_pickings are recorded
  {% endfor %}
</div>

<script>

</script>