<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Oligobarcode Schemes</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="oligobarcodeSchemeEdit(-1, '', '', 'Y', '0', '0')"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Oligobarcode Scheme
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Oligobarcode Schemes</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Oligobarcode Schemes
      </div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="oligobarcode_scheme-table"
           style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Oligobarcode Scheme Name</th>
        <th>Description</th>
        <th>Is Oligobarcode B</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for oligobarcode_scheme in oligobarcode_schemes %}
        {% set active = oligobarcode_scheme.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ oligobarcode_scheme.id }}</td>
          <td>{{ oligobarcode_scheme.name }}</td>
          <td>{{ oligobarcode_scheme.description }}</td>
          <td>{{ oligobarcode_scheme.is_oligobarcodeB }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set oligobarcode_scheme_oligobarcodes_count = oligobarcode_scheme.Oligobarcodes|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="oligobarcodeSchemeEdit('{{ oligobarcode_scheme.id }}', '{{ oligobarcode_scheme.name }}', '{{ oligobarcode_scheme.description }}', '{{ oligobarcode_scheme.is_oligobarcodeB }}', '{{ oligobarcode_scheme.active }}', '{{ oligobarcode_scheme_oligobarcodes_count }}' ); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {{ link_to('setting/oligobarcodeSchemeOligobarcodes/' ~ oligobarcode_scheme.id, "<i class='fa fa-user-plus'></i>&ensp;") }}
            {% if oligobarcode_scheme_oligobarcodes_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="oligobarcodeSchemeRemove({{ oligobarcode_scheme.id }}); return false;"><span
                    class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Oligobarcode Scheme. This Oligobarcode Scheme already has " ~ oligobarcode_scheme_oligobarcodes_count ~ " oligobarcodes." %}
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
<div class="modal fade form-horizontal" id="modal-oligobarcode_scheme-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-oligobarcode_scheme-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-oligobarcode_scheme-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-oligobarcode_scheme_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Oligobarcode Scheme Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-description" class="col-sm-3 control-label" style="font-size: 9pt">Description</label>
          <div class="col-sm-9">
            {{ text_field('modal-description', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-is_oligobarcodeB" class="col-sm-3 control-label" style="font-size: 9pt">Is Oligobarcode
            B</label>
          <div class="col-sm-9">
            {{ select_static('modal-is_oligobarcodeB', ['N':'N', 'Y':'Y'], 'class': 'form-control') }}
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
          <button type="button" id="modal-oligobarcode_scheme-save" class="btn btn-primary pull-right disabled"
                  onclick="oligobarcodeSchemeSave()">
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
  function oligobarcodeSchemeEdit(oligobarcode_scheme_id, name, description, is_oligobarcodeB, active, oligobarcode_scheme_oligobarcodes_count) {

    $('#modal-oligobarcode_scheme_id').val(oligobarcode_scheme_id);
    $('#modal-name').val(name);
    $('#modal-description').val(description);
    $('#modal-is_oligobarcodeB').val(is_oligobarcodeB);
    $('#modal-active').val(active);

    if (oligobarcode_scheme_oligobarcodes_count > 0) {
      $('#modal-active').attr('disabled', 'disabled');
    } else {
      $('#modal-active').removeAttr('disabled');
    }


    $('#modal-oligobarcode_scheme-save').addClass('disabled');

    $('#modal-oligobarcode_scheme-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function oligobarcodeSchemeSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Oligobarcode Scheme name.');
      return false;
    }

    $('#modal-lab-edit').modal('hide');

    var oligobarcode_scheme_id = $('#modal-oligobarcode_scheme_id').val();
    var name = $('#modal-name').val();
    var description = $('#modal-description').val();
    var is_oligobarcodeB = $('#modal-is_oligobarcodeB').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/oligobarcodeSchemes',
      data: {
        oligobarcode_scheme_id: oligobarcode_scheme_id,
        name: name,
        description: description,
        is_oligobarcodeB: is_oligobarcodeB,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete oligobarcode_scheme record. (It will be soft-deleted (active=N).)
   * @param oligobarcode_scheme_id
   * @returns {boolean}
   */
  function oligobarcodeSchemeRemove(oligobarcode_scheme_id) {
    if (!oligobarcode_scheme_id) {
      alert('Error: Could not found oligobarcode_scheme_id value.');
      return false;
    }

    if (window.confirm("This Oligobarcode Scheme will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/oligobarcodeSchemes',
        data: {
          oligobarcode_scheme_id: oligobarcode_scheme_id,
          active: 'N'
        }
      })
          .done(function () {
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
    $('#oligobarcode_scheme-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-oligobarcode_scheme-edit')
        .find('input, select')
        .change(function () {
          $('#modal-oligobarcode_scheme-save').removeClass('disabled');
        });

  });
</script>

