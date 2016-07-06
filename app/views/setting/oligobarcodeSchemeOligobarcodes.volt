<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li>{{ link_to('setting/oligobarcodeSchemes', 'Oligobarcode Schemes') }}</li>
      <li>{{ oligobarcode_scheme.name }}</li>
      <li class="active">Oligobarcodes</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}
  </div>
</div>

{{ hidden_field('oligobarcode_scheme_id', 'value': oligobarcode_scheme.id) }}

<div class="row">
  <div class="col-md-5">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Candidate Oligobarcode List</h3>
      </div>
      <div class="panel-body">
        <form id="pick_form" method="post">
          <div class="form-group">
            {{ text_field('oligobarcode_candidate_filter', 'class': "form-control", 'placeholder': 'Search Oligobarcode') }}
          </div>
        </form>
        <div class="tube-group">
          <div class="tube-list" id="oligobarcode_candidate_holder" style="font-family: Consolas, 'Courier New', Courier, Monaco, monospace;">
            {% for oligobarcode in oligobarcodes_candidate %}
              <div class="tube tube-active" id="oligobarcode_id-{{ oligobarcode.id }}">
                {{ oligobarcode.name ~ ' (' ~ oligobarcode.barcode_seq ~ ')'}}
              </div>
              {% elsefor %} No Oligobarcodes are recorded.
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
            <h3 class="panel-title col-sm-10">Oligobarcode Scheme Oligobarcodes List</h3>
          </div>
          <div class="col-sm-2">
            <button type="button" id="oligobarcode_scheme_oligobarcodes_save" class="btn btn-primary pull-right"
                    disabled="disabled">Save
            </button>
          </div>
        </div>
      </div>
      <div class="panel-body">
        <form id="pick_form" method="post">
          <div class="form-group">
            {{ text_field('oligobarcode_scheme_oligobarcodes_filter', 'class': "form-control", 'placeholder': 'Search Oligobarcodes') }}
          </div>
        </form>
        <div class="tube-group">
          <div class="tube-list" id="oligobarcode_scheme_oligobarcodes_holder" style="font-family: Consolas, 'Courier New', Courier, Monaco, monospace;">
            {% for oligobarcode_scheme_oligobarcode in oligobarcode_scheme_oligobarcodes %}
              <div class="tube" id="oligobarcode_id-{{ oligobarcode_scheme_oligobarcode.id }}">
                {{ oligobarcode_scheme_oligobarcode.name ~ ' (' ~ oligobarcode_scheme_oligobarcode.barcode_seq ~ ')' }}
                <a href="javascript:void(0)" class="tube-close pull-right" onclick="tubeCloseToggle(this)">
                  <i class="fa fa-times" aria-hidden="true"></i>
                  <i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>
                </a>
              </div>
              {% elsefor %} No Oligobarcodes are recorded
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
    $(target)
        .parent('.tube')
        .toggleClass('tube-inactive');
    $(target)
        .find('i')
        .toggle();

    var oligobarcode_scheme_oligobarcodes_holder = $('#oligobarcode_scheme_oligobarcodes_holder');
    var oligobarcode_scheme_oligobarcodes_save = $('#oligobarcode_scheme_oligobarcodes_save');
    if (oligobarcode_scheme_oligobarcodes_holder.find('div.tube-active:not(.tube-inactive)').length //For dragged oligobarcode_schemes
        || oligobarcode_scheme_oligobarcodes_holder.find('div.tube-inactive:not(.tube-active)').length) { //For original oligobarcode_schemes
      oligobarcode_scheme_oligobarcodes_save.prop('disabled', false);
    } else {
      oligobarcode_scheme_oligobarcodes_save.prop('disabled', true);
    }
  }

  $(document).ready(function () {
    $('#oligobarcode_candidate_holder').sortable({
      connectWith: "#oligobarcode_scheme_oligobarcodes_holder",
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

    $('#oligobarcode_scheme_oligobarcodes_holder').sortable({
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

        $('#oligobarcode_scheme_oligobarcodes_save').prop('disabled', false);
      }
    });

    $('#oligobarcode_scheme_candidate_filter').on('keyup', function (event) {
      var queryStr = new RegExp(event.target.value, 'i');
      //console.log(queryStr);
      tubeFilter(queryStr, '#oligobarcode_scheme_candidate_holder');
    });
    $('#oligobarcode_scheme_oligobarcodes_filter').on('keyup', function (event) {
      var queryStr = new RegExp(event.target.value, 'i');
      //console.log(queryStr);
      tubeFilter(queryStr, '#oligobarcode_scheme_oligobarcodes_holder');
    });


    $('#oligobarcode_scheme_oligobarcodes_save').click(function () {
      var oligobarcode_scheme_oligobarcodes_holder = $('#oligobarcode_scheme_oligobarcodes_holder');
      var new_oligobarcode_id_array = oligobarcode_scheme_oligobarcodes_holder
          .find('.tube-active:not(.tube-inactive)')
          .map(function () {
            return $(this).attr('id').replace('oligobarcode_id-', '');
          }).get();
      var del_oligobarcode_id_array = oligobarcode_scheme_oligobarcodes_holder
          .find('.tube-inactive:not(.tube-active)')
          .map(function () {
            return $(this).attr('id').replace('oligobarcode_id-', '');
          }).get();

      var oligobarcode_scheme_id = $('#oligobarcode_scheme_id').val();
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/oligobarcodeSchemeOligobarcodes/' + oligobarcode_scheme_id,
        data: {
          new_oligobarcode_id_array: new_oligobarcode_id_array,
          del_oligobarcode_id_array: del_oligobarcode_id_array
        }
      })
          .done(function (data) {
            //console.log(data);
            window.location.reload();  // @TODO It should not be re-loaded.
          });

    });
  });

</script>
