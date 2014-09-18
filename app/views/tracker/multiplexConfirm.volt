{{ content() }}

<form class="form-horizontal" role="form" action="{{ url("tracker/multiplexSave/" ~ step_id ) }}" method="POST">
  {% for selected_seqtemplate_index in selected_seqtemplates %}
    {% if selected_seqlibs[selected_seqtemplate_index] is defined %}
      <div class="panel panel-success">
      <div class="panel-heading">
        <div class="form-inline">
          <div class="input-group">
            <div class="input-group-addon">#{{ selected_seqtemplate_index }}</div>
            {{ text_field('seqtemplate_name-' ~ selected_seqtemplate_index, 'class': "form-control") }}
          </div>
          {% if loop.first and selected_seqtemplates|length > 1 %}
            <button type="button" id="increment-copy-name-button" class="btn btn-primary btn-xs"><i
                  class="glyphicon glyphicon-plus"></i></button>
          {% endif %}
          <div class="pull-right">
            <label>Calculator&nbsp;<i class="fa fa-calculator"></i></label>
            <div class="btn-group btn-toggle">
              <button type="button" class="btn btn-default btn-sm" data-toggle="collapse"
                      data-target="#calculator-{{ selected_seqtemplate_index }}">ON
              </button>
              <button type="button" class="btn btn-success btn-sm active" data-toggle="collapse"
                      data-target="#calculator-{{ selected_seqtemplate_index }}">OFF
              </button>
            </div>
            <input type="hidden" id="calculator_used-{{ selected_seqtemplate_index }}"
                   name="calculator_used-{{ selected_seqtemplate_index }}" value="0">
          </div>
        </div>
      </div>
      {% for selected_seqlib in selected_seqlibs[selected_seqtemplate_index] %}
        {% if loop.first %}
          <div class="panel-body collapse" id="calculator-{{ selected_seqtemplate_index }}">
            <!--
              <div class="form-group">
                <label for="multiplex-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">Multiplex</label>
                <div class="col-sm-10">
                  <p class="form-control-static" id="multiplex-{{ selected_seqtemplate_index }}">{{ loop.length }}</p>
                </div>
              </div>
              -->
            <div class="form-group">
              <label for="target_conc-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">Target Conc.
                (nM)</label>
              <div class="col-sm-2">
                <input type="text" class="form-control" id="target_conc-{{ selected_seqtemplate_index }}"
                       name="target_conc-{{ selected_seqtemplate_index }}" value="1.052">
              </div>

              <label for="target_vol-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">Target Vol.
                (uL)</label>
              <div class="col-sm-2">
                <input type="text" class="form-control" id="target_vol-{{ selected_seqtemplate_index }}"
                       name="target_vol-{{ selected_seqtemplate_index }}" value="19.00">
              </div>

              <label for="target_total_mol-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">(total
                mol)</label>
              <div class="col-sm-2">
                <p class="form-control-static" id="target_total_mol-{{ selected_seqtemplate_index }}"></p>
              </div>
            </div>
            <div class="form-group">
              <label for="target_each_mol-{{ selected_seqtemplate_index }}"
                     class="col-sm-2 col-sm-offset-8 control-label">(each mol)</label>
              <div class="col-sm-2">
                <p class="form-control-static" id="target_each_mol-{{ selected_seqtemplate_index }}"></p>
              </div>
            </div>
            <div class="form-group">
              <label for="dw_for_dilution_vol-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">Calculated
                DW For
                Dilution (uL)</label>
              <div class="col-sm-2">
                <p class="form-control-static" id="dw_for_dilution_vol-{{ selected_seqtemplate_index }}"></p>
                <input type="hidden" id="dw_for_dilution_vol_hidden-{{ selected_seqtemplate_index }}"
                       name="dw_for_dilution_vol-{{ selected_seqtemplate_index }}">
              </div>

              <label for="added_dw_vol-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">Actual Added
                DW
                (uL)</label>
              <div class="col-sm-2">
                <input type="text" class="form-control" id="added_dw_vol-{{ selected_seqtemplate_index }}"
                       name="added_dw_vol-{{ selected_seqtemplate_index }}">
              </div>

              <label for="library_vol_total-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">Library
                Vol. Total (uL)</label>
              <div class="col-sm-2">
                <p class="form-control-static" id="library_vol_total-{{ selected_seqtemplate_index }}"></p>
                <input type="hidden" id="library_vol_total_hidden-{{ selected_seqtemplate_index }}"
                       name="library_vol_total-{{ selected_seqtemplate_index }}">
              </div>
            </div>
            <div class="form-group">
              <label for="seqtemplate_initial_conc-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">Initial
                Conc. (nM)</label>
              <div class="col-sm-2">
                <p class="form-control-static" id="seqtemplate_initial_conc-{{ selected_seqtemplate_index }}"></p>
                <input type="hidden" id="seqtemplate_initial_conc_hidden-{{ selected_seqtemplate_index }}"
                       name="seqtemplate_initial_conc-{{ selected_seqtemplate_index }}">
              </div>

              <label for="seqtemplate_final_vol-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">Final
                Vol. (uL)</label>
              <div class="col-sm-2">
                <p class="form-control-static" id="seqtemplate_final_vol-{{ selected_seqtemplate_index }}"></p>
                <input type="hidden" id="seqtemplate_final_vol_hidden-{{ selected_seqtemplate_index }}"
                       name="seqtemplate_final_vol-{{ selected_seqtemplate_index }}">
              </div>

              <label for="seqtemplate_final_conc-{{ selected_seqtemplate_index }}" class="col-sm-2 control-label">Final
                Conc. (nM)</label>
              <div class="col-sm-2">
                <p class="form-control-static" id="seqtemplate_final_conc-{{ selected_seqtemplate_index }}"></p>
                <input type="hidden" id="seqtemplate_final_conc_hidden-{{ selected_seqtemplate_index }}"
                       name="seqtemplate_final_conc-{{ selected_seqtemplate_index }}">
              </div>
            </div>
          </div>
          <table id="seqtemplate-{{ selected_seqtemplate_index }}" class="table table-condensed">
          <thead>
          <tr>
            <th>SeqLib Name</th>
            <th>Oligobarcode Name</th>
            <th>Oligobarcode Seq</th>
            <th>Conc. (nmol/L)</th>
            <th>Conc. Factor</th>
            <th>Stocked Vol. (uL)</th>
            <th>Calculated Input Vol. (uL)</th>
            <th>Fragment Size (bp)</th>
          </tr>
          </thead>
          <tbody>
        {% endif %}
        {% set seqlib = seqlibs[selected_seqlib['seqlib_id']] %}
        {% if selected_seqlib['oligobarcodeA_id'] === 'null' %}
          {% set oligobarcodeName = 'No Barcode' %}
          {% set oligobarcodeSeq = '' %}
        {% else %}
          {% set oligobarcodeA = oligobarcodes[selected_seqlib['oligobarcodeA_id']] %}
          {% set oligobarcodeName = oligobarcodeA.name %}
          {% set oligobarcodeSeq = oligobarcodeA.barcode_seq %}
        {% endif %}
        {% if selected_seqlib['oligobarcodeB_id'] is defined %}
          {% set oligobarcodeB = oligobarcodes[selected_seqlib['oligobarcodeB_id']] %}
          {% set oligobarcodeName = oligobarcodeName ~ '-' ~ oligobarcodeB.name %}
          {% set oligobarcodeSeq = oligobarcodeSeq ~ '-' ~ oligobarcodeB.barcode_seq %}
        {% endif %}
        <tr id="seqlib-{{ seqlib.id }}">
          <td>{{ seqlib.name }}</td>
          <td>{{ oligobarcodeName }}</td>
          <td style="font-family: Consolas, 'Courier New', Courier, Monaco, monospace;">{{ oligobarcodeSeq }}</td>
          <td id="seqlib_conc-{{ seqlib.id }}">{{ seqlib.concentration }}</td>
          <td><input type="text" id="seqlib_conc_factor-{{ seqlib.id }}" name="seqlib_conc_factor-{{ seqlib.id }}"
                     value="1.000">
          </td>
          <td id="seqlib_stock_vol-{{ seqlib.id }}">{{ seqlib.stock_seqlib_volume }}</td>
          <td id="seqlib_input_vol-{{ seqlib.id }}"></td>
          <td style="display: none"><input type="hidden" id="seqlib_input_vol_hidden-{{ seqlib.id }}"
                                           name="seqlib_input_vol-{{ seqlib.id }}"></td>
          <td>{{ seqlib.fragment_size }}</td>
          <td></td>
        </tr>
        {% if loop.last %}
          </tbody>
          </table>
        {% endif %}
      {% endfor %}
    {% endif %}
    </div>
  {% endfor %}
  <div class="row">
    <!-- Button trigger modal -->
    <button type="button" class="btn btn-primary pull-right" data-toggle="modal" data-target="#saveConfirmModal">
      Save Changes
    </button>
  </div>
  <!-- Modal -->
  <div class="modal fade" id="saveConfirmModal" tabindex="-1" role="dialog" aria-labelledby="saveConfirmModalLabel"
       aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span
                class="sr-only">Close</span></button>
          <h4 class="modal-title" id="saveConfirmModalLabel">Confirm</h4>
        </div>
        <div class="modal-body" id="saveConfirmModalBody">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-success" id="saveConfirmModalSubmitButton">Save</button>
        </div>
      </div>
    </div>
  </div>
</form>
<script>
/*
 * Functions for the calculator.
 */
function calcTargetTotalMol(selected_seqtemplate_index) {
  var target_conc = parseFloat($('input#target_conc-' + selected_seqtemplate_index).val());
  var target_vol = parseFloat($('input#target_vol-' + selected_seqtemplate_index).val());
  var target_total_mol = target_conc * target_vol;
  $('p#target_total_mol-' + selected_seqtemplate_index).text(target_total_mol.toFixed(4));
  return target_total_mol
}

function calcTargetEachMol(selected_seqtemplate_index, target_total_mol) {
  var multiplex = $('p#multiplex-' + selected_seqtemplate_index).text();
  var target_each_mol = target_total_mol / multiplex;
  //console.log(target_total_mol + " / " + multiplex + " = " + target_each_mol);
  $('p#target_each_mol-' + selected_seqtemplate_index).text(target_each_mol.toFixed(4));
  return target_each_mol;
}

function calcLibraryTotalVol(selected_seqtemplate_index, target_each_mol) {
  var seqtemplate_table = $('table#seqtemplate-' + selected_seqtemplate_index);
  var library_vol_total = 0;
  seqtemplate_table.children('tbody').children('tr').each(function () {
    var seqlib_id = $(this).attr('id').split('-').pop();
    var seqlib_conc = $(this).children('td#seqlib_conc-' + seqlib_id).text();
    var seqlib_conc_factor = parseFloat($(this).children('td').children('input#seqlib_conc_factor-' + seqlib_id).val());
    var seqlib_actual_conc = seqlib_conc * seqlib_conc_factor;
    var seqlib_input_vol = target_each_mol / seqlib_actual_conc;
    //console.log(seqlib_input_vol+" = "+target_each_mol+" / "+seqlib_actual_conc);
    library_vol_total += seqlib_input_vol;
    //console.log(library_vol_total+" : "+seqlib_input_vol);
    $('td#seqlib_input_vol-' + seqlib_id).text(seqlib_input_vol.toFixed(3));
    $('input#seqlib_input_vol_hidden-' + seqlib_id).val(seqlib_input_vol.toFixed(3));
  });
  $('p#library_vol_total-' + selected_seqtemplate_index).text(library_vol_total.toFixed(3));
  $('input#library_vol_total_hidden-' + selected_seqtemplate_index).val(library_vol_total.toFixed(3));
  return library_vol_total;
}

function calcDwForDilutionVol(selected_seqtemplate_index, library_vol_total) {
  var target_vol = parseFloat($('#target_vol-' + selected_seqtemplate_index).val());
  var dw_for_dilution_vol = target_vol - library_vol_total;
  $('p#dw_for_dilution_vol-' + selected_seqtemplate_index).text(dw_for_dilution_vol.toFixed(3));
  $('input#dw_for_dilution_vol_hidden-' + selected_seqtemplate_index).val(dw_for_dilution_vol.toFixed(3));
  $('#added_dw_vol-' + selected_seqtemplate_index).val(dw_for_dilution_vol.toFixed(3));
  return dw_for_dilution_vol;
}

function calcInitialConc(selected_seqtemplate_index, target_total_mol, library_vol_total) {
  var seqtemplate_initial_conc = target_total_mol / library_vol_total;
  $('p#seqtemplate_initial_conc-' + selected_seqtemplate_index).text(seqtemplate_initial_conc.toFixed(4));
  $('input#seqtemplate_initial_conc_hidden-' + selected_seqtemplate_index).val(seqtemplate_initial_conc.toFixed(4));
  //console.log(seqtemplate_initial_conc + " = " + target_total_mol + " / " + library_vol_total);
  return seqtemplate_initial_conc;
}

function calcFinalVol(selected_seqtemplate_index, library_vol_total) {
  var added_dw_vol = parseFloat($('#added_dw_vol-' + selected_seqtemplate_index).val());
  var seqtemplate_final_vol = library_vol_total + added_dw_vol;
  $('p#seqtemplate_final_vol-' + selected_seqtemplate_index).text(seqtemplate_final_vol.toFixed(3));
  $('input#seqtemplate_final_vol_hidden-' + selected_seqtemplate_index).val(seqtemplate_final_vol.toFixed(3));
  return seqtemplate_final_vol;
}

function calcFinalConc(selected_seqtemplate_index, target_total_mol, seqtemplate_final_vol) {
  var seqtemplate_final_conc = target_total_mol / seqtemplate_final_vol;
  //console.log(seqtemplate_final_conc+" = "+target_total_mol+" / "+seqtemplate_final_vol);
  $('p#seqtemplate_final_conc-' + selected_seqtemplate_index).text(seqtemplate_final_conc.toFixed(3));
  $('input#seqtemplate_final_conc_hidden-' + selected_seqtemplate_index).val(seqtemplate_final_conc.toFixed(3));
  return seqtemplate_final_conc;
}

$(document).ready(function () {

  /*
   * Function for the calculator on/off button.
   */
  $('.btn-toggle').click(function () {
    $(this).find('.btn').toggleClass('active');

    if ($(this).find('.btn-primary').size() > 0) {
      $(this).find('.btn').toggleClass('btn-primary');
    }
    if ($(this).find('.btn-danger').size() > 0) {
      $(this).find('.btn').toggleClass('btn-danger');
    }
    if ($(this).find('.btn-success').size() > 0) {
      $(this).find('.btn').toggleClass('btn-success');
    }
    if ($(this).find('.btn-info').size() > 0) {
      $(this).find('.btn').toggleClass('btn-info');
    }

    $(this).find('.btn').toggleClass('btn-default');

  });

  $('[id^=calculator-]').each(function () {
    var selected_seqtemplate_index = $(this).attr('id').split('-').pop();
    $(this).on('hidden.bs.collapse', function () {
      $("#calculator_used-" + selected_seqtemplate_index).val("0")
    });
    $(this).on('shown.bs.collapse', function () {
      $("#calculator_used-" + selected_seqtemplate_index).val("1")
    });
  });

  /*
   * Calculator
   */
  $('[id^=multiplex-]').each(function () {
    var selected_seqtemplate_index = $(this).attr('id').split('-').pop();
    var target_total_mol = calcTargetTotalMol(selected_seqtemplate_index);
    var target_each_mol = calcTargetEachMol(selected_seqtemplate_index, target_total_mol);
    var library_vol_total = calcLibraryTotalVol(selected_seqtemplate_index, target_each_mol);
    var dw_for_dilution_vol = calcDwForDilutionVol(selected_seqtemplate_index, library_vol_total);
    var seqtemplate_initial_conc = calcInitialConc(selected_seqtemplate_index, target_total_mol, library_vol_total);
    var seqtemplate_final_vol = calcFinalVol(selected_seqtemplate_index, library_vol_total);
    var seqtemplate_final_conc = calcFinalConc(selected_seqtemplate_index, target_total_mol, seqtemplate_final_vol);
  });

  $('input[id^=target_conc-], input[id^=target_vol-]').change(function () {
    var selected_seqtemplate_index = $(this).attr('id').split('-').pop();
    var target_total_mol = calcTargetTotalMol(selected_seqtemplate_index);
    var target_each_mol = calcTargetEachMol(selected_seqtemplate_index, target_total_mol);
    var library_vol_total = calcLibraryTotalVol(selected_seqtemplate_index, target_each_mol);
    var dw_for_dilution_vol = calcDwForDilutionVol(selected_seqtemplate_index, library_vol_total);
    var seqtemplate_initial_conc = calcInitialConc(selected_seqtemplate_index, target_total_mol, library_vol_total);
    var seqtemplate_final_vol = calcFinalVol(selected_seqtemplate_index, library_vol_total);
    var seqtemplate_final_conc = calcFinalConc(selected_seqtemplate_index, target_total_mol, seqtemplate_final_vol);
  });

  $('input[id^=added_dw_vol-]').change(function () {
    var selected_seqtemplate_index = $(this).attr('id').split('-').pop();
    var target_total_mol = $('#target_total_mol-' + selected_seqtemplate_index).text();
    var library_vol_total = $('#library_vol_total-' + selected_seqtemplate_index).text();
    var seqtemplate_initial_conc = calcInitialConc(selected_seqtemplate_index, target_total_mol, library_vol_total);
    var seqtemplate_final_vol = calcFinalVol(selected_seqtemplate_index, library_vol_total);
    var seqtemplate_final_conc = calcFinalConc(selected_seqtemplate_index, target_total_mol, seqtemplate_final_vol);
  });

  $('input[id^=seqlib_conc_factor-]').change(function () {
    var selected_seqtemplate_index = $(this).parents('table[id^=seqtemplate-]').attr('id').split('-').pop();
    var target_each_mol = $('#target_each_mol-' + selected_seqtemplate_index).text();
    var target_total_mol = $('#target_total_mol-' + selected_seqtemplate_index).text();
    var library_vol_total = calcLibraryTotalVol(selected_seqtemplate_index, target_each_mol);
    var dw_for_dilution_vol = calcDwForDilutionVol(selected_seqtemplate_index, library_vol_total);
    var seqtemplate_initial_conc = calcInitialConc(selected_seqtemplate_index, target_total_mol, library_vol_total);
    var seqtemplate_final_vol = calcFinalVol(selected_seqtemplate_index, library_vol_total);
    var seqtemplate_final_conc = calcFinalConc(selected_seqtemplate_index, target_total_mol, seqtemplate_final_vol);
  });

  $('#saveConfirmModal').on('show.bs.modal', function () {
    var seqtemplate_names = [];
    $('[id^=seqtemplate_name-]').each(function () {
      seqtemplate_names.push($(this).val());
    });

    var saveConfirmModalBody = $('#saveConfirmModalBody');
    /*
     * Find duplicated seqtemplate_names on this view of inputs.
     * And show alert on modal when found duplicates
     */
    var duplicatesInView = seqtemplate_names.filter(function (x, i, self) {
      return self.indexOf(x) === i && i !== self.lastIndexOf(x);
    });
    if (duplicatesInView.length) {
      saveConfirmModalBody
          .append('<h5>Following seqtemplate(s) name were duplicated.<br>Please press \'Cancel\' and non-duplicate seqtemplate name.</h5>')
          .append('<ul>');
      $.each(duplicatesInView, function (index, value) {
        saveConfirmModalBody.append('<li>' + value + '</li>');
      });
      saveConfirmModalBody.append('</ul>');
      console.log(duplicatesInView);
      $('#saveConfirmModalSubmitButton').addClass('disabled')
    }

    /*
     * Find duplicated seqtemplate_names on this view of inputs.
     * And show alert on modal when found duplicates
     */
    var uniqueInView = seqtemplate_names.filter(function (x, i, self) {
      return self.indexOf(x) === i;
    });
    $.ajax({
      url: '{{ url("seqtemplates/loadjson/") }}',
      dataType: "json",
      type: "POST",
      data: {query: uniqueInView}
    })
        .done(function (data) {
          if (data.length) {
            console.log(data);
            saveConfirmModalBody
                .append('<h5>Following seqtemplate(s) name were already used.<br>Please press \'Cancel\' and non-duplicate seqtemplate name.</h5>')
                .append('<ul>');
            $.each(data, function (index, value) {
              saveConfirmModalBody.append('<li>' + value['name'] + '</li>');
            });
            saveConfirmModalBody.append('</ul>');
            $('#saveConfirmModalSubmitButton').addClass('disabled')
          } else if (!duplicatesInView.length) {
            saveConfirmModalBody.append('<h5>Please press \'Save\' to record seqtemplates.</h5>')
          }
        })

  }).on('hide.bs.modal', function () {
    $('#saveConfirmModalBody').html('');
    $('#saveConfirmModalSubmitButton').removeClass('disabled')
  });

  /*
   * Function for #increment-copy-name-button
   *  Copy seqtemplate name with incrementation of serial number
   */
  $('#increment-copy-name-button').click(function () {
    var first_seqtemplate_name = $(this).parent().find('input').val();
    var this_panel = $(this).parents('.panel');
    var incremented_seqtemplate_name = first_seqtemplate_name;
    this_panel.nextAll('.panel').each(function () {
      incremented_seqtemplate_name = incremented_seqtemplate_name.replace(/\d+$/, function (n) {
        var length = n.length;
        ++n;
        //Increment last number with zerofill.
        return n.toLocaleString("ja-JP", {useGrouping: false, minimumIntegerDigits: length});
      });
      $(this).children('.panel-heading').find('input').val(incremented_seqtemplate_name);
    });
  });

});

</script>