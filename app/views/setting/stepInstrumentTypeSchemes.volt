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
      <li class="active">Step - Instrument Type Schemes</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}
  </div>
</div>

{{ hidden_field('instrument_type_id', 'value': instrument_type.id) }}

<div class="row">
  <div class="col-md-5">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">All Steps List</h3>
      </div>
      <div class="panel-body">
        <div class="form-group">
          {{ text_field('step_candidate_filter', 'class': "form-control", 'placeholder': 'Search Steps') }}
        </div>
        <div class="tube-group">
          <div class="tube-list" id="step_instrument_type_scheme_candidate_holder">
            {% for step in step_instrument_type_scheme_candidate %}
              <div class="tube tube-active" id="step_id-{{ step.id }}">
                {{ step.name }}
              </div>
              {% elsefor %} No Steps are recorded.
            {% endfor %}
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="col-md-7">
    <div class="panel panel-default">
      <div class="panel-heading">
        <div class="row">
          <div class="col-sm-10">
            <h3 class="panel-title col-sm-10">Steps List</h3>
          </div>
          <div class="col-sm-2">
            <button type="button" id="step_instrument_type_schemes_save" class="btn btn-primary pull-right"
                    disabled="disabled">Save
            </button>
          </div>
        </div>
      </div>
      <div class="panel-body">
        <div class="form-group">
          {{ text_field('step_instrument_type_schemes_filter', 'class': "form-control", 'placeholder': 'Search Steps') }}
        </div>
        <div class="tube-group">
          <div class="tube-list" id="step_instrument_type_schemes_holder">
            {% for step_instrument_type_scheme in step_instrument_type_schemes %}
              <div class="tube"
                   id="step_id-{{ step_instrument_type_scheme.Steps.id }}">{{ step_instrument_type_scheme.Steps.name }}
                <a href="javascript:void(0)" class="tube-close pull-right" onclick="tubeCloseToggle(this)">
                  <i class="fa fa-times" aria-hidden="true"></i>
                  <i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>
                </a>
              </div>
              {% elsefor %} No Step Members are recorded
            {% endfor %}
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  /**
   * Filter tube from 'queryStr' which placed in 'target'.
   * @param queryStr
   * @param target
   */
  function tubeFilter(queryStr, target) {
    $(target)
        .find('.tube')
        .filter(function () {
          var css_display = $(this).css('display');
          var tube_textStr = $(this).text().toString();
          //console.log(index + ":" + css_display != 'none' && ! queryStr.test(tube_textStr));
          return css_display != 'none' && !queryStr.test(tube_textStr);
        })
        .addClass('tube-hidden');

    $(target)
        .find('.tube-hidden')
        .filter(function () {
          var tube_textStr = $(this).text().toString();
          return queryStr.test(tube_textStr);
        })
        .removeClass('tube-hidden');
  }

  /**
   * Toggle button icon and tube class
   */
  function tubeCloseToggle(target) {
    //console.log('clicked');
    $(target)
        .parent('.tube')
        .toggleClass('tube-inactive');
    $(target)
        .find('i')
        .toggle();

    var step_instrument_type_schemes_holder = $('#step_instrument_type_schemes_holder');
    var step_instrument_type_schemes_save = $('#step_instrument_type_schemes_save');
    if (step_instrument_type_schemes_holder.find('div.tube-active:not(.tube-inactive)').length //For dragged steps
        || step_instrument_type_schemes_holder.find('div.tube-inactive:not(.tube-active)').length) { //For original steps
        step_instrument_type_schemes_save.prop('disabled', false);
    } else {
        step_instrument_type_schemes_save.prop('disabled', true);
    }
  }

  $(document).ready(function () {
    $('#step_instrument_type_scheme_candidate_holder').sortable({
      connectWith: "#step_instrument_type_schemes_holder",
      placeholder: "tube tube-placeholder",
      revert: true,
      pointer: "move",
      opacity: 0.5,
      helper: "clone",
      remove: function (event, ui) {
        // Append close button on sorted seqlib tube
        //console.log(ui.item.find('button').length);
        if (!ui.item.find('button').length) {
          ui.item
              .append('<button type="button" class="tube-close pull-right">' +
                  '<i class="fa fa-times" aria-hidden="true"></i>' +
                  '<i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>' +
                  '</button>')
              .find('button.tube-close').click(tubeCloseToggle);
        }
      }

    });

    $('#step_instrument_type_schemes_holder').sortable({
      update: function (event, ui) {
        var item = ui.item.parent();
        var funcSort = function (a, b) {
          var compA = $(a).text().trim();
          var compB = $(b).text().trim();
          return (compA < compB) ? -1 : (compA > compB) ? 1 : 0;
        };
        var listItems = item.children('div').get();
        listItems.sort(funcSort);
        $.each(listItems, function (i, itm) {
          item.append(itm);
        });

        $('#step_instrument_type_schemes_save').prop('disabled', false);
      }
    });

    $('#step_candidate_filter').on('keyup', function (event) {
      var queryStr = new RegExp(event.target.value, 'i');
      //console.log(queryStr);
      tubeFilter(queryStr, '#step_candidate_filter');
    });
    $('#step_instrument_type_schemes_filter').on('keyup', function (event) {
      var queryStr = new RegExp(event.target.value, 'i');
      //console.log(queryStr);
      tubeFilter(queryStr, '#step_instrument_type_schemes_filter');
    });


    $('#step_instrument_type_schemes_save').click(function () {
      var step_instrument_type_schemes_holder = $('#step_instrument_type_schemes_holder');
      var new_step_id_array = step_instrument_type_schemes_holder
          .find('.tube-active:not(.tube-inactive)')
          .map(function () {
            return $(this).attr('id').replace('step_id-', '');
          }).get();
      var del_step_id_array = step_instrument_type_schemes_holder.find('.tube-inactive:not(.tube-active)')
          .map(function () {
            return $(this).attr('id').replace('step_id-', '');
          }).get();

      var instrument_type_id = $('#instrument_type_id').val();
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/stepInstrumentTypeSchemes/' + instrument_type_id,
        data: {
            new_step_id_array: new_step_id_array,
            del_step_id_array: del_step_id_array
        }
      })
          .done(function (data) {
            //console.log(data);
            window.location.reload();  // @TODO It should not be re-loaded.
          });

    });
  });

</script>
