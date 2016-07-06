<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">SeqRunmodeTypes</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="seqRunmodeTypesEdit(-1, '', '', '', 'Y', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Seq Runmode Type
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Seq Runmode Type</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Seq Runmode Type</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="seq_runmode_type-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Seq Runmode Type Name</th>
        <th>Num. Of Lane Per Flowcell</th>
        <th>Sort Order</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for seq_runmode_type in seq_runmode_types %}
        {% set active = seq_runmode_type.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ seq_runmode_type.id }}</td>
          <td>{{ seq_runmode_type.name }}</td>
          <td>{{ seq_runmode_type.lane_per_flowcell}}</td>
          <td>{{ seq_runmode_type.sort_order }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set seq_runmode_type_seq_run_type_scheme_count = seq_runmode_type.SeqRunTypeSchemes|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="seqRunmodeTypesEdit('{{ seq_runmode_type.id }}', '{{ seq_runmode_type.name }}', '{{ seq_runmode_type.lane_per_flowcell }}', '{{ seq_runmode_type.sort_order }}', '{{ seq_runmode_type.active }}', '{{ seq_runmode_type_seq_run_type_scheme_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if seq_runmode_type_seq_run_type_scheme_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="seqRunmodeTypesRemove({{ seq_runmode_type.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Seq Runmode Type. This Seq Runmode Type is already used by " ~ seq_runmode_type_seq_run_type_scheme_count ~ " Seq Runtype Schemes." %}
              <a href="javascript:void(0)" data-toggle="tooltip" data-placement="bottom" title="{{ trash_message }}"
                 style="font-size: 9pt; color: #b9c4c8; cursor: not-allowed;" onclick="return false;">
                <span class="fa fa-trash"></span></a>
            {% endif %}
          </td>
        </tr>
      {% endfor %}
      </tbody>
    </table>
  </div>
</div>

<!-- Modal Confirm Copy-->
<div class="modal fade form-horizontal" id="modal-seq_runmode_type-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-seq_runmode_type-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-seq_runmode_type-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-seq_runmode_type_id', 'class': 'form-control') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Seq Runmode Type Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-lane_per_flowcell" class="col-sm-3 control-label" style="font-size: 9pt">Num. Of Lane Per Flowcell</label>
          <div class="col-sm-9">
            {{ numeric_field('modal-lane_per_flowcell', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-sort_order" class="col-sm-3 control-label" style="font-size: 9pt">Sort Order</label>
          <div class="col-sm-9">
            {{ numeric_field('modal-sort_order', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-active" class="col-sm-3 control-label" style="font-size: 9pt">Active/In-active</label>
          <div class="col-sm-2">
            {{ select_static('modal-active', ['Y':'Y', 'N':'N'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="button" id="modal-seq_runmode_type-save" class="btn btn-primary pull-right disabled"
                  onclick="seqRunmodeTypesSave()">
            Save
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  /**
   * Open modal window with filling values.
   */
  function seqRunmodeTypesEdit(seq_runmode_type_id, name, lane_per_flowcell, sort_order, active, seq_runmode_type_seq_run_type_scheme_count) {

    $('#modal-seq_runmode_type_id').val(seq_runmode_type_id);
    $('#modal-name').val(name);
    $('#modal-lane_per_flowcell').val(lane_per_flowcell);
    $('#modal-sort_order').val(sort_order);
    $('#modal-active').val(active);


    // @TODO should be consider details condition of details
    if (seq_runmode_type_seq_run_type_scheme_count > 0) {
      $('#modal-name').prop('disabled', true);
      $('#modal-active').prop('disabled', true);
    } else {
      $('#modal-name').prop('disabled', false);
      $('#modal-active').prop('disabled', false);
    }

    $('#modal-seq_runmode_type-save').addClass('disabled');

    $('#modal-seq_runmode_type-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function seqRunmodeTypesSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input SeqRunmodeType name.');
      return false;
    }

    $('#modal-seq_runmode_type-edit').modal('hide');

    var seq_runmode_type_id = $('#modal-seq_runmode_type_id').val();
    var name = $('#modal-name').val();
    var lane_per_flowcell = $('#modal-lane_per_flowcell').val();
    var sort_order = $('#modal-sort_order').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/seqRunmodeTypes',
      data: {
        seq_runmode_type_id: seq_runmode_type_id,
        name: name,
        lane_per_flowcell: lane_per_flowcell,
        sort_order: sort_order,
        active: active
      }
    })
        .done(function (data) {
          console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete seq_runmode_type record. (It will be soft-deleted (active=N).)
   * @param seq_runmode_type_id
   * @returns {boolean}
   */
  function seqRunmodeTypesRemove(seq_runmode_type_id) {
    if (!seq_runmode_type_id) {
      alert('Error: Could not found seq_runmode_type_id value.');
      return false;
    }

    if (window.confirm("This SeqRunmodeType will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/seqRunmodeTypes',
        data: {
          seq_runmode_type_id: seq_runmode_type_id,
          active: 'N'
        }
      })
          .done(function (data) {
            console.log(data);
            window.location.reload(); // @TODO It should not be re-loaded.
          });
    }


  }

  /**
   * Show active=N rows function on button.
   */
  function showInactive(target) {
    $('.inactive').toggle();
    $(target).children('div').toggle();
  }

  /**
   * DataTables
   */
  $(document).ready(function () {
    $('#seq_runmode_type-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-seq_runmode_type-edit')
        .find('input, select')
        .change(function () {
          $('#modal-seq_runmode_type-save')
              .prop('disabled', true)
              .removeClass('disabled');
        });

  });
</script>