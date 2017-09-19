<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      {% if query is empty %}
        <li class="active">Sequence Templates</li>
      {% else %}
        <li>{{ link_to('setting/seqtemplates', 'Sequence Templates') }}</li>
        <li class="active">Filter: {{ query }}</li>
      {% endif %}
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <!--
    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="seqtemplateEdit(-1, '', '', '', '', '', '', '', '', '', '', '', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Sequence Template
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Sequence Templates</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Sequence Templates
      </div>
    </button>
    -->
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="seqtemplate-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Sequence Template Name</th>
        <th>Target Conc. (nM)</th>
        <th>Target Vol. (&micro;L)</th>
        <th>Target DW Vol. (&micro;L)</th>
        <th>Initial Conc. (nM)</th>
        <th>Initial Vol. (&micro;L)</th>
        <th>Final Conc. (nM)</th>
        <th>Final Vol. (&micro;L)</th>
        <th>Final DW Vol. (&micro;L)</th>
        <th>Started At</th>
        <th>Finished At</th>
        <th>Created At</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for seqtemplate in seqtemplates %}
        <tr>
          <td>{{ seqtemplate.id }}</td>
          <td>{{ seqtemplate.name }}</td>
          <td>{{ seqtemplate.target_conc }}</td>
          <td>{{ seqtemplate.target_vol }}</td>
          <td>{{ seqtemplate.target_dw_vol }}</td>
          <td>{{ seqtemplate.initial_conc }}</td>
          <td>{{ seqtemplate.initial_vol }}</td>
          <td>{{ seqtemplate.final_conc }}</td>
          <td>{{ seqtemplate.final_vol }}</td>
          <td>{{ seqtemplate.final_dw_vol }}</td>
          {% if seqtemplate.started_at is empty %}
            <td></td>
          {% else %}
            <td>{{ date('Y-m-d', strtotime(seqtemplate.started_at)) }}</td>
          {% endif %}
          {% if seqtemplate.finished_at is empty %}
            <td></td>
          {% else %}
            <td>{{ date('Y-m-d', strtotime(seqtemplate.finished_at)) }}</td>
          {% endif %}
          <td>{{ seqtemplate.created_at }}</td>
          {% set seqtemplate_seqlane_count = seqtemplate.Seqlanes|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="seqtemplateEdit('{{ seqtemplate.id }}', '{{ seqtemplate.name }}', '{{ seqtemplate.target_conc }}', '{{ seqtemplate.target_vol }}', '{{ seqtemplate.target_dw_vol }}', '{{ seqtemplate.initial_conc }}', '{{ seqtemplate.initial_vol }}', '{{ seqtemplate.final_conc }}', '{{ seqtemplate.final_vol }}', '{{ seqtemplate.final_dw_vol }}', '{{ date('Y-m-d', strtotime(seqtemplate.started_at)) }}', '{{ date('Y-m-d', strtotime(seqtemplate.finished_at)) }}', '{{ seqtemplate_seqlane_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {{ link_to('setting/seqtemplateAssocs/' ~ seqtemplate.id, "<i class='fa fa-user-plus'></i>&ensp;") }}
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="seqtemplateCopy('{{ seqtemplate.id }}', '{{ seqtemplate.name }}'); return false;"><span
                  class="fa fa-copy"></span></a>
            {% if seqtemplate_seqlane_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="seqtemplateRemove({{ seqtemplate.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Sequence Template. This Sequence Template already has " ~ seqtemplate_seqlane_count ~ " seqlanes." %}
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
<div class="modal fade form-horizontal" id="modal-seqtemplate-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-seqtemplate-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-seqtemplate-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-seqtemplate_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Sequence Template Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-target_conc" class="col-sm-3 control-label" style="font-size: 9pt">Target Conc. (nM)</label>
          <div class="col-sm-9">
            {{ text_field('modal-target_conc', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-target_vol" class="col-sm-3 control-label" style="font-size: 9pt">Target Vol.
            (&micro;L)</label>
          <div class="col-sm-9">
            {{ text_field('modal-target_vol', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-target_dw_vol" class="col-sm-3 control-label" style="font-size: 9pt">Target DW Vol. (&micro;L)</label>
          <div class="col-sm-9">
            {{ text_field('modal-target_dw_vol', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-initial_conc" class="col-sm-3 control-label" style="font-size: 9pt">Initial Conc.
            (nM)</label>
          <div class="col-sm-9">
            {{ text_field('modal-initial_conc', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-initial_vol" class="col-sm-3 control-label" style="font-size: 9pt">Initial Vol.
            (&micro;L)</label>
          <div class="col-sm-9">
            {{ text_field('modal-initial_vol', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-final_conc" class="col-sm-3 control-label" style="font-size: 9pt">Final Conc. (nM)</label>
          <div class="col-sm-9">
            {{ text_field('modal-final_conc', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-final_vol" class="col-sm-3 control-label" style="font-size: 9pt">Final Vol.
            (&micro;L)</label>
          <div class="col-sm-9">
            {{ text_field('modal-final_vol', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-final_dw_vol" class="col-sm-3 control-label" style="font-size: 9pt">Final DW Vol.
            (&micro;L)</label>
          <div class="col-sm-9">
            {{ text_field('modal-final_dw_vol', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-started_at" class="col-sm-3 control-label" style="font-size: 9pt">Started At</label>
          <div class="col-sm-9">
            {{ date_field('modal-started_at', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-finished_at" class="col-sm-3 control-label" style="font-size: 9pt">Finished At</label>
          <div class="col-sm-9">
            {{ date_field('modal-finished_at', 'class': 'form-control') }}
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="button" id="modal-seqtemplate-save" class="btn btn-primary pull-right disabled"
                  onclick="seqtemplateSave()">
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
    function seqtemplateEdit(seqtemplate_id, name, target_conc, target_vol, target_dw_vol, initial_conc, initial_vol, final_conc, final_vol, final_dw_vol, started_at, finished_at, seqtemplate_seqlane_count) {

        $('#modal-seqtemplate_id').val(seqtemplate_id);
        $('#modal-name').val(name);
        $('#modal-target_conc').val(target_conc);
        $('#modal-target_vol').val(target_vol);
        $('#modal-target_dw_vol').val(target_dw_vol);
        $('#modal-initial_conc').val(initial_conc);
        $('#modal-initial_vol').val(initial_vol);
        $('#modal-final_conc').val(final_conc);
        $('#modal-final_vol').val(final_vol);
        $('#modal-final_dw_vol').val(final_dw_vol);
        $('#modal-started_at').val(started_at);
        $('#modal-finished_at').val(finished_at);

        if (seqtemplate_seqlane_count > 0) {
            $('#modal-name').prop('disabled', true);
        } else {
            $('#modal-name').prop('disabled', false);
        }


        $('#modal-seqtemplate-save')
            .prop('disabled', true)
            .addClass('disabled');

        $('#modal-seqtemplate-edit').modal('show');

    }

    /**
     * Save edit results on modal window.
     * @returns {boolean}
     */
    function seqtemplateSave() {
        if (!$('#modal-name').val().length) {
            alert('Please input Sequence Template name.');
            return false;
        }

        $('#modal-lab-edit').modal('hide');

        var seqtemplate_id = $('#modal-seqtemplate_id').val();
        var name = $('#modal-name').val();
        var target_conc = $('#modal-target_conc').val();
        var target_vol = $('#modal-target_vol').val();
        var target_dw_vol = $('#modal-target_dw_vol').val();
        var initial_conc = $('#modal-initial_conc').val();
        var initial_vol = $('#modal-initial_vol').val();
        var final_conc = $('#modal-final_conc').val();
        var final_vol = $('#modal-final_vol').val();
        var final_dw_vol = $('#modal-final_dw_vol').val();
        var started_at = $('#modal-started_at').val();
        var finished_at = $('#modal-finished_at').val();
        $.ajax({
            type: 'POST',
            url: '/ngsLIMS/setting/seqtemplates',
            data: {
                seqtemplate_id: seqtemplate_id,
                name: name,
                target_conc: target_conc,
                target_vol: target_vol,
                target_dw_vol: target_dw_vol,
                initial_conc: initial_conc,
                initial_vol: initial_vol,
                final_conc: final_conc,
                final_vol: final_vol,
                final_dw_vol: final_dw_vol,
                started_at: started_at,
                finished_at: finished_at
            }
        })
            .done(function (data) {
                console.log(data);
                window.location.reload();  // @TODO It should not be re-loaded.
            });
    }


    /**
     * Copy seqtemplate record.
     * @param seqtemplate_id
     * @param seqtemplate_name
     * @returns {boolean}
     */
    function seqtemplateCopy(seqtemplate_id, seqtemplate_name) {
        if (!seqtemplate_id) {
            alert('Error: Could not found seqtemplate_id value.');
            return false;
        }

        if (window.confirm("This Sequence Template will be copy.\n\nAre You Sure?")) {
            $.ajax({
                type: 'POST',
                url: '/ngsLIMS/setting/seqtemplateCopy',
                data: {
                    seqtemplate_id: seqtemplate_id,
                }
            })
                .done(function (data) {
                    window.location.replace(window.location + '?q=' + seqtemplate_name);
                    //window.location.reload(); // @TODO It should not be re-loaded.
                });
        }

    }

    /**
     * Delete seqtemplate record. (It will be soft-deleted (active=N).)
     * @param seqtemplate_id
     * @returns {boolean}
     */
    function seqtemplateRemove(seqtemplate_id) {
        if (!seqtemplate_id) {
            alert('Error: Could not found seqtemplate_id value.');
            return false;
        }

        if (window.confirm("This Sequence Template will be in-active.\n\nAre You Sure?")) {
            $.ajax({
                type: 'POST',
                url: '/ngsLIMS/setting/seqtemplates',
                data: {
                    seqtemplate_id: seqtemplate_id,
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
        $('#seqtemplate-table').DataTable({
            order: []
        });

        $('#modal-seqtemplate-edit')
            .find('input, select')
            .change(function () {
                $('#modal-seqtemplate-save')
                    .prop('disabled', false)
                    .removeClass('disabled');
            });

    });
</script>