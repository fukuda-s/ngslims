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

<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li>{{ link_to('setting/instrumentTypes', 'Instrument Types') }}</li>
      <li>{{ instrument_type.name }}</li>
      <li class="active">Sequence Run Type Scheme</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    {% for seq_runmode_type in seq_runmode_types %}
      {% set checkbox_seq_runmode_type_id = "seq_runmode_type-" ~ seq_runmode_type.id %}
      <div class="jumbotron">
        <div class="row">
          <div class="col-md-4">
            <div class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">Run Mode</h3>
              </div>
              <div class="panel-body">
                {{ check_field(checkbox_seq_runmode_type_id, "data-toggle": "checkbox") }}
                {{ seq_runmode_type.name }}
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">Run Read Type</h3>
              </div>
              <div class="panel-body">
                {% for seq_runread_type in seq_runread_types %}
                  {% set checkbox_seq_runread_type_id = "seq_runread_type-" ~ seq_runmode_type.id ~ '-' ~ seq_runread_type.id %}
                  <div class="checkbox">
                    <label class="checkbox">
                      {% if checkbox_seq_runmode_type_id_checked[checkbox_seq_runmode_type_id] is defined %}
                        {{ check_field(checkbox_seq_runread_type_id, "data-toggle": "checkbox") }}
                      {% else %}
                        {{ check_field(checkbox_seq_runread_type_id, "data-toggle": "checkbox", "class": "disabled", "disabled": "disabled") }}
                      {% endif %}
                      {{ seq_runread_type.name }}
                    </label>
                  </div>
                {% endfor %}
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="panel panel-default">
              <div class="panel-heading">
                <h3 class="panel-title">Run Cycle Type</h3>
              </div>
              <div class="panel-body">
                <ul class="nav nav-tabs" role="tablist">
                  {% set presentation_actived = 0 %}
                  {% for seq_runread_type in seq_runread_types %}
                    {% set checkbox_seq_runread_type_id = "seq_runread_type-" ~ seq_runmode_type.id ~ '-' ~ seq_runread_type.id %}
                    {% if checkbox_seq_runread_type_id_checked[checkbox_seq_runread_type_id] is defined %}
                      {% set presentation_disabled_class = '' %}
                    {% else %}
                      {% set presentation_disabled_class = 'disabled' %}
                    {% endif %}
                    {% if presentation_actived == 0 %}
                      {% set presentation_active_class = 'active' %}
                    {% else %}
                      {% set presentation_active_class = '' %}
                    {% endif %}
                    {% set presentation_actived = 1 %}
                    <li role="presentation"
                        class="{{ presentation_active_class }} {{ presentation_disabled_class }}"><a
                          href="#{{ checkbox_seq_runread_type_id ~ '_tab' }}"
                          aria-controls="{{ checkbox_seq_runread_type_id ~ '_tab' }}"
                          role="tab"
                          data-toggle="tab">{{ seq_runread_type.name }}</a></li>
                  {% endfor %}
                </ul>
                <div class="tab-content">
                  {% set tabpanel_actived = 0 %}
                  {% for seq_runread_type in seq_runread_types %}
                    {% set checkbox_seq_runread_type_id = "seq_runread_type-" ~ seq_runmode_type.id ~ '-' ~ seq_runread_type.id %}
                    {% if tabpanel_actived == 0 %}
                      {% set tabpanel_active_class = 'active' %}
                    {% else %}
                      {% set tabpanel_active_class = '' %}
                    {% endif %}
                    {% set tabpanel_actived = 1 %}
                    <div role="tabpanel" class="tab-pane {{ tabpanel_active_class }}"
                         id="{{ checkbox_seq_runread_type_id ~ '_tab' }}">
                      {% for seq_runcycle_type in seq_runcycle_types %}
                        {% set checkbox_seq_runcycle_type_id = "seq_runcycle_type-" ~ seq_runmode_type.id ~ '-' ~ seq_runread_type.id ~ '-' ~ seq_runcycle_type.id %}
                        <div class="checkbox">
                          <label class="checkbox">
                            {% if checkbox_seq_runread_type_id_checked[checkbox_seq_runread_type_id] is defined %}
                              {{ check_field(checkbox_seq_runcycle_type_id, "data-toggle": "checkbox") }}
                            {% else %}
                              {{ check_field(checkbox_seq_runcycle_type_id, "data-toggle": "checkbox", "class": "disabled", "disabled": "disabled") }}
                            {% endif %}
                            {{ seq_runcycle_type.name }}
                          </label>
                        </div>
                      {% endfor %}
                    </div>
                  {% endfor %}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    {% endfor %}
    <button type="button" id="button_save" class="btn btn-lg btn-primary pull-right disabled"
            onclick="seqRunTypeSchemesSave({{ instrument_type.id }})" disabled>Save</span>
    </button>
  </div>
</div>

<script>
  /**
   * Save SeqRunTypeSchemes values from 'input[id^=seq_runcycle_type-]')
   * @param instrument_type_id
   */
  function seqRunTypeSchemesSave(instrument_type_id) {
    var seq_run_type_scheme_arrays = [];
    $('input[id^=seq_runcycle_type-]')
        .each(function (index) {
          var seq_runmode_runread_runcycle_type_id_arr = $(this).attr('id').replace('seq_runcycle_type-', '').split('-');
          if ($(this).is(':checked')) {
            if ($(this).is(':disabled')) { //Case disabled by upstream checkbox (seq_runmode and seq_runcycle).
              seq_runmode_runread_runcycle_type_id_arr.push('N');
              seq_run_type_scheme_arrays[index] = seq_runmode_runread_runcycle_type_id_arr;
            } else { //Case checkbox is checked and not disabled.
              seq_runmode_runread_runcycle_type_id_arr.push('Y');
              seq_run_type_scheme_arrays[index] = seq_runmode_runread_runcycle_type_id_arr;
            }
          } else { //Case checkbox is not checked.
            seq_runmode_runread_runcycle_type_id_arr.push('N');
            seq_run_type_scheme_arrays[index] = seq_runmode_runread_runcycle_type_id_arr;
          }
        });
    //console.log(JSON.stringify(seq_run_type_schemes));
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/seqRunTypeSchemes/' + instrument_type_id,
      data: {
        seq_run_type_scheme_arrays: seq_run_type_scheme_arrays
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload(); // @TODO It should not be re-loaded.
        });
  }

  $(document).ready(function () {
    $('input[type="checkbox"]').change(function(){
      $('#button_save')
          .prop('disabled', false)
          .removeClass('disabled');
    });

    $('input[id^=seq_runmode_type-]')
        .change(function () {
          var seq_runmode_type_id = $(this).attr('id').replace('seq_runmode_type-', '');
          if ($(this).is(':checked')) {
            $('input[id^=seq_runread_type-' + seq_runmode_type_id + '-]')
                .each(function () {
                  $(this)
                      .prop('disabled', false)
                      .removeClass('disabled');
                });
            $('input[id^=seq_runcycle_type-' + seq_runmode_type_id + '-]')
                .each(function () {
                  $(this)
                      .prop('disabled', false)
                      .removeClass('disabled');
                });
          } else {
            $('input[id^=seq_runread_type-' + seq_runmode_type_id + '-]')
                .each(function () {
                  $(this)
                      .prop('disabled', true)
                      .addClass('disabled');
                });
            $('input[id^=seq_runcycle_type-' + seq_runmode_type_id + '-]')
                .each(function () {
                  $(this)
                      .prop('disabled', true)
                      .addClass('disabled');
                });
          }
        });

    $('input[id^=seq_runread_type-]')
        .change(function () {
          var seq_runmode_runread_type_id_str = $(this).attr('id').replace('seq_runread_type-', '');
          var seq_runmode_type_id = seq_runmode_runread_type_id_str.split('-')[0];
          var seq_runread_type_id = seq_runmode_runread_type_id_str.split('-')[1];

          if ($(this).is(':checked')) {
            $('input[id^=seq_runcycle_type-' + seq_runmode_type_id + '-' + seq_runread_type_id + ']')
                .each(function () {
                  $(this)
                      .prop('disabled', false)
                      .removeClass('disabled');
                });
          } else {
            $('input[id^=seq_runcycle_type-' + seq_runmode_type_id + '-' + seq_runread_type_id + ']')
                .each(function () {
                  $(this)
                      .prop('disabled', true)
                      .addClass('disabled');
                });
          }
        });

  });
</script>