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
      <li class="active">Protocols</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="protocolEdit(-1, '', '', '', '', '', '', 'Y', '0', '0')"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Protocol
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Protocols</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Protocols</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="protocol-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Protocol Name</th>
        <th>Description</th>
        <th>Step Name</th>
        <th># of Min. Multiplex</th>
        <th># of Max. Multiplex</th>
        <th>Next Step Phase Code</th>
        <th>Created At</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for protocol in protocols %}
        {% set active = protocol.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ protocol.id }}</td>
          <td>{{ protocol.name }}</td>
          <td>{{ protocol.description }}</td>
          <td>{{ protocol.Steps.name }}</td>
          <td>{{ protocol.min_multiplex_number }}</td>
          <td>{{ protocol.max_multiplex_number }}</td>
          <td>{{ protocol.next_step_phase_code }}</td>
          <td>{{ protocol.created_at }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set protocol_seqlibs_count = protocol.Seqlibs|length %}
          {% set protocol_oligobarcode_scheme_allows_count = protocol.OligobarcodeSchemeAllows|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="protocolEdit('{{ protocol.id }}', '{{ protocol.name }}', '{{ protocol.description }}', '{{ protocol.step_id }}', '{{ protocol.min_multiplex_number }}', '{{ protocol.max_multiplex_number }}', '{{ protocol.next_step_phase_code }}', '{{ protocol.active }}', '{{ protocol_seqlibs_count }}', '{{ protocol_oligobarcode_scheme_allows_count }}' ); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {{ link_to('setting/protocolOligobarcodeSchemeAllows/' ~ protocol.id, "<i class='fa fa-user-plus'></i>&ensp;") }}
            {% if protocol_seqlibs_count == 0 and protocol_oligobarcode_scheme_allows_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="protocolRemove({{ protocol.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Protocol. This Protocol already has " ~ protocol_seqlibs_count ~ " seqlibs and " ~ protocol_oligobarcode_scheme_allows_count ~ " Oligobarcode Schemes" %}
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
<div class="modal fade form-horizontal" id="modal-protocol-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-protocol-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-protocol-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-protocol_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Protocol Name</label>
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
          <label for="modal-step_id" class="col-sm-3 control-label" style="font-size: 9pt">Step Name</label>
          <div class="col-sm-9">
            {{ select('modal-step_id', step_prep, 'using': ['id', 'name'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-min_multiplex_number" class="col-sm-3 control-label" style="font-size: 9pt"># of Min.
            Multiplex</label>
          <div class="col-sm-9">
            {{ numeric_field('modal-min_multiplex_number', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-max_multiplex_number" class="col-sm-3 control-label" style="font-size: 9pt"># of Max.
            Multiplex</label>
          <div class="col-sm-9">
            {{ numeric_field('modal-max_multiplex_number', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-next_step_phase_code" class="col-sm-3 control-label" style="font-size: 9pt">Next Step Phase
            Code</label>
          <div class="col-sm-9">
            {{ select_static('modal-next_step_phase_code', ['MULTIPLEX':'MULTIPLEX', 'DUALMULTIPLEX':'DUALMULTIPLEX'], 'class': 'form-control') }}
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
          <button type="button" id="modal-protocol-save" class="btn btn-primary pull-right disabled"
                  onclick="protocolSave()">
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
  function protocolEdit(protocol_id, name, description, step_id, min_multiplex_number, max_multiplex_number, next_step_phase_code, active, protocol_seqlibs_count, protocol_oligobarcode_scheme_allows_count) {

    $('#modal-protocol_id').val(protocol_id);
    $('#modal-name').val(name);
    $('#modal-description').val(description);
    $('#modal-step_id').val(step_id);
    $('#modal-min_multiplex_number').val(min_multiplex_number);
    $('#modal-max_multiplex_number').val(max_multiplex_number);
    $('#modal-next_step_phase_code').val(next_step_phase_code);
    $('#modal-active').val(active);

    if (protocol_seqlibs_count > 0 || protocol_oligobarcode_scheme_allows_count > 0) {
      $('#modal-active').prop('disabled', true);
    } else {
      $('#modal-active').prop('disabled', false);
    }


    $('#modal-protocol-save')
        .prop('disabled', true)
        .addClass('disabled');

    $('#modal-protocol-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function protocolSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Protocol name.');
      return false;
    }

    $('#modal-lab-edit').modal('hide');

    var protocol_id = $('#modal-protocol_id').val();
    var name = $('#modal-name').val();
    var description = $('#modal-description').val();
    var step_id = $('#modal-step_id').val();
    var min_multiplex_number = $('#modal-min_multiplex_number').val();
    var max_multiplex_number = $('#modal-max_multiplex_number').val();
    var next_step_phase_code = $('#modal-next_step_phase_code').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/protocols',
      data: {
        protocol_id: protocol_id,
        name: name,
        description: description,
        step_id: step_id,
        min_multiplex_number: min_multiplex_number,
        max_multiplex_number: max_multiplex_number,
        next_step_phase_code: next_step_phase_code,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete protocol record. (It will be soft-deleted (active=N).)
   * @param protocol_id
   * @returns {boolean}
   */
  function protocolRemove(protocol_id) {
    if (!protocol_id) {
      alert('Error: Could not found protocol_id value.');
      return false;
    }

    if (window.confirm("This Protocol will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/protocols',
        data: {
          protocol_id: protocol_id,
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
    $('#protocol-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-protocol-edit')
        .find('input, select')
        .change(function () {
          $('#modal-protocol-save')
              .prop('disabled', false)
              .removeClass('disabled');
        });

  });
</script>

