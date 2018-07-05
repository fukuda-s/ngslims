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

<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">SeqRuncycleTypes</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="seqRuncycleTypesEdit(-1, '', '', 'Y', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Seq Runcycle Type
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Seq Runcycle Type</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Seq Runcycle Type</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="seq_runcycle_type-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Seq Runcycle Type Name</th>
        <th>Sort Order</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for seq_runcycle_type in seq_runcycle_types %}
        {% set active = seq_runcycle_type.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ seq_runcycle_type.id }}</td>
          <td>{{ seq_runcycle_type.name }}</td>
          <td>{{ seq_runcycle_type.sort_order }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set seq_runcycle_type_seq_run_type_scheme_count = seq_runcycle_type.SeqRunTypeSchemes|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="seqRuncycleTypesEdit('{{ seq_runcycle_type.id }}', '{{ seq_runcycle_type.name }}', '{{ seq_runcycle_type.sort_order }}', '{{ seq_runcycle_type.active }}', '{{ seq_runcycle_type_seq_run_type_scheme_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if seq_runcycle_type_seq_run_type_scheme_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="seqRuncycleTypesRemove({{ seq_runcycle_type.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Seq Runcycle Type. This Seq Runcycle Type is already used by " ~ seq_runcycle_type_seq_run_type_scheme_count ~ " Seq Runtype Schemes." %}
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
<div class="modal fade form-horizontal" id="modal-seq_runcycle_type-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-seq_runcycle_type-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-seq_runcycle_type-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-seq_runcycle_type_id', 'class': 'form-control') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Seq Runcycle Type Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
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
          <button type="button" id="modal-seq_runcycle_type-save" class="btn btn-primary pull-right disabled"
                  onclick="seqRuncycleTypesSave()" disabled>
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
  function seqRuncycleTypesEdit(seq_runcycle_type_id, name, sort_order, active, seq_runcycle_type_seq_run_type_scheme_count) {

    $('#modal-seq_runcycle_type_id').val(seq_runcycle_type_id);
    $('#modal-name').val(name);
    $('#modal-sort_order').val(sort_order);
    $('#modal-active').val(active);


    // @TODO should be consider details condition of details
    if (seq_runcycle_type_seq_run_type_scheme_count > 0) {
      $('#modal-name').prop('disabled', true);
      $('#modal-active').prop('disabled', true);
    } else {
      $('#modal-name').prop('disabled', false);
      $('#modal-active').prop('disabled', false);
    }

    $('#modal-seq_runcycle_type-save').addClass('disabled');

    $('#modal-seq_runcycle_type-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function seqRuncycleTypesSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input SeqRuncycleType name.');
      return false;
    }

    $('#modal-seq_runcycle_type-edit').modal('hide');

    var seq_runcycle_type_id = $('#modal-seq_runcycle_type_id').val();
    var name = $('#modal-name').val();
    var sort_order = $('#modal-sort_order').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/seqRuncycleTypes',
      data: {
        seq_runcycle_type_id: seq_runcycle_type_id,
        name: name,
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
   * Delete seq_runcycle_type record. (It will be soft-deleted (active=N).)
   * @param seq_runcycle_type_id
   * @returns {boolean}
   */
  function seqRuncycleTypesRemove(seq_runcycle_type_id) {
    if (!seq_runcycle_type_id) {
      alert('Error: Could not found seq_runcycle_type_id value.');
      return false;
    }

    if (window.confirm("This SeqRuncycleType will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/seqRuncycleTypes',
        data: {
          seq_runcycle_type_id: seq_runcycle_type_id,
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
    $('#seq_runcycle_type-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-seq_runcycle_type-edit')
        .find('input, select')
        .change(function () {
          $('#modal-seq_runcycle_type-save')
              .prop('disabled', false)
              .removeClass('disabled');
        });

  });
</script>