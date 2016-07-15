<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Sample Types</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="sampleTypesEdit(-1, '', '', '', '', 'Y', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Sample Type
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Sample Type</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Sample Type</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="sample_type-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Sample Type Name</th>
        <th>Nucleotide Type</th>
        <th>Sample Type Code</th>
        <th>Sort Order</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for sample_type in sample_types %}
        {% set active = sample_type.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ sample_type.id }}</td>
          <td>{{ sample_type.name }}</td>
          <td>{{ sample_type.nucleotide_type }}</td>
          <td>{{ sample_type.sample_type_code }}</td>
          <td>{{ sample_type.sort_order }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set sample_type_sample_count = sample_type.Samples|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="sampleTypesEdit('{{ sample_type.id }}', '{{ sample_type.name }}', '{{ sample_type.nucleotide_type }}', '{{ sample_type.sample_type_code }}' , '{{ sample_type.sort_order }}', '{{ sample_type.active }}', '{{ sample_type_sample_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if sample_type_sample_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="sampleTypesRemove({{ sample_type.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Sample Type. This Sample Type is already used by " ~ sample_type_sample_count ~ " Samples." %}
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
<div class="modal fade form-horizontal" id="modal-sample_type-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-sample_type-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-sample_type-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-sample_type_id', 'class': 'form-control') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Sample Type Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-nucleotide_type" class="col-sm-3 control-label" style="font-size: 9pt">Nucleotide Type</label>
          <div class="col-sm-9">
            {{ select_static('modal-nucleotide_type', ['DNA':'DNA', 'RNA':'RNA'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-sample_type_code" class="col-sm-3 control-label" style="font-size: 9pt">Sample Type Code</label>
          <div class="col-sm-9">
            {{ text_field('modal-sample_type_code', 'class': 'form-control') }}
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
          <button type="button" id="modal-sample_type-save" class="btn btn-primary pull-right disabled"
                  onclick="sampleTypesSave()">
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
  function sampleTypesEdit(sample_type_id, name, nucleotide_type, sample_type_code, sort_order, active, sample_type_sample_count) {

    $('#modal-sample_type_id').val(sample_type_id);
    $('#modal-name').val(name);
    $('#modal-nucleotide_type').val(nucleotide_type);
    $('#modal-sample_type_code').val(sample_type_code);
    $('#modal-sort_order').val(sort_order);
    $('#modal-active').val(active);


    // @TODO should be consider details condition of details
    if (sample_type_sample_count > 0) {
      $('#modal-name').prop('disabled', true);
      $('#modal-active').prop('disabled', true);
    } else {
      $('#modal-name').prop('disabled', false);
      $('#modal-active').prop('disabled', false);
    }

    $('#modal-sample_type-save').addClass('disabled');

    $('#modal-sample_type-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function sampleTypesSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input SeqRunmodeType name.');
      return false;
    }

    $('#modal-sample_type-edit').modal('hide');

    var sample_type_id = $('#modal-sample_type_id').val();
    var name = $('#modal-name').val();
    var nucleotide_type = $('#modal-nucleotide_type').val();
    var sample_type_code = $('#modal-sample_type_code').val();
    var sort_order = $('#modal-sort_order').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/sampleTypes',
      data: {
        sample_type_id: sample_type_id,
        name: name,
        nucleotide_type: nucleotide_type,
        sample_type_code: sample_type_code,
        sort_order: sort_order,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete sample_type record. (It will be soft-deleted (active=N).)
   * @param sample_type_id
   * @returns {boolean}
   */
  function sampleTypesRemove(sample_type_id) {
    if (!sample_type_id) {
      alert('Error: Could not found sample_type_id value.');
      return false;
    }

    if (window.confirm("This Sample Type will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/sampleTypes',
        data: {
          sample_type_id: sample_type_id,
          active: 'N'
        }
      })
          .done(function (data) {
            //console.log(data);
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
    $('#sample_type-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-sample_type-edit')
        .find('input, select')
        .change(function () {
          $('#modal-sample_type-save')
              .prop('disabled', false)
              .removeClass('disabled');
        });

  });
</script>