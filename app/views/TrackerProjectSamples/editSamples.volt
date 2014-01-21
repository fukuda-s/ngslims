<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li><a href="">{{ project.users.name }} </a></li>
      <li><a href="">{{ project.name }} </a></li>
      <li class="active">Samples</li>
    </ol>
    {{ content() }}
    <div align="left">{{ link_to("trackerProjectSamples/index/" ~ project.id, "<< Back to Sample Info", "class": "btn btn-primary") }}</div>
    <hr>
    <div class="alert alert-info" id="handsontable-console">Click "Save" to save data to server</div>
    <nav class="navbar navbar-default" role="navigation">
      <!-- Brand and toggle get grouped for better mobile display -->
      <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#handsontable-toolbar">
          <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span
            class="icon-bar"></span>
        </button>
      </div>
      <!-- Collect the nav links, forms, and other content for toggling -->
      <div class="collapse navbar-collapse" id="handsontable-toolbar">
        <ul class="nav navbar-nav">
          <li class="disabled" id="save"><a href="#"><i class="fa fa-save"></i> Save</a></li>
          <li class="disabled" id="undo"><a href="#"><i class="fa fa-undo"></i> Undo</a></li>
          <li class="disabled" id="redo"><a href="#">Redo <i class="fa fa-repeat"></i></a></li>
        </ul>
        <form class="navbar-form navbar-right" role="search">
          <div class="form-group">
            <input type="text" class="form-control" placeholder="Search">
          </div>
        </form>
        <ul class="nav navbar-nav navbar-right">
          <li class="disabled" id="clear"><a href="#">Clear edit <i class="fa fa-refresh"></i></a></li>
        </ul>
      </div>
      <!-- /.navbar-collapse -->
    </nav>
    <div class="checkbox" id="handsontable-autosave">
      <label> <input class="checkbox" type="checkbox" autocomplete="off"> Autosave
      </label>
    </div>
    <div id="handsontable-body"></div>
  </div>
</div>
<script>
/*
 * Construct Handsontable
 */
// Make handsontable renderer and dropdown lists
var sampleTypeAr = new Array();
var organismAr = new Array();

$(document).ready(function() {

 	function getSampleTypeAr (data) {
 		//console.log("stringified:"+JSON.stringify(data));
 		var parseAr = JSON.parse(JSON.stringify(data));
 		//alert(parseAr);
 		$.each( parseAr, function(key, value) {
 			//alert(value["id"]+" : "+value["name"]);
 			var sample_type_id = value["id"];
 			var sample_type_name   = value["name"];
 			sampleTypeAr[sample_type_id] = sample_type_name;
 		});
 	}

 	$.getJSON(
 	  '/ngsLIMS/sampletypes/loadjson',
 	  {},
       function (data, status, xhr) {
         getSampleTypeAr(data);
 	  }
 	);

 	function getOrganismAr (data) {
 		//console.log("stringified:"+JSON.stringify(data));
 		var parseAr = JSON.parse(JSON.stringify(data));
 		//alert(parseAr);
 		$.each( parseAr, function(key, value) {
 			//alert(value["id"]+" : "+value["name"]);
 			var organism_id = value["id"];
 			var organism_name   = value["name"];
 			organismAr[organism_id] = organism_name;
 		});
 	}

 	$.getJSON(
 	  '/ngsLIMS/organisms/loadjson',
 	  {},
       function (data, status, xhr) {
         getOrganismAr(data);
 	  }
 	);

});

$(document).ready(function() {

	var sampleTypeRenderer = function (instance, td, row, col, prop, value, cellProperties) {
		Handsontable.TextCell.renderer.apply(this, arguments);
		//alert("renderer: "+sampleTypeAr[value]);
		$(td).text(sampleTypeAr[value]);
	};

	var organismRenderer = function (instance, td, row, col, prop, value, cellProperties) {
		Handsontable.TextCell.renderer.apply(this, arguments);
		//alert("renderer: "+sampleTypeAr[value]);
		$(td).text(organismAr[value]);
	};

	// Construct handsontable
	var $container = $("#handsontable-body");
	var $console = $("#handsontable-console");
	var $toolbar = $("#handsontable-toolbar");
	var autosaveNotification = new String();
	var isDirtyAr = new Array();
	$container.handsontable({
		stretchH: 'all',
		rowHeaders: true,
		columns: [
		          	{ data : "name", title: "Sample Name", readOnly: true },
		          	{ data : "sample_type_id", title: "Sample Type", readOnly: true, renderer: sampleTypeRenderer },
		          	{ data : "organism_id", title: "Organism", readOnly: true, renderer: organismRenderer, source: organismRenderer },
		          	{ data : "qual_concentration", title: "Conc. (ng/uL)", type: 'numeric', format: '0.000' },
		          	{ data : "qual_od260280", title: "A260/A280", type: 'numeric', format: '0.00' },
		          	{ data : "qual_od260230", title: "A260/A230", type: 'numeric', format: '0.00' },
		          	{ data : "qual_RIN", title: "RIN", type: 'numeric', format: '0.00' },
		          	{ data : "qual_fragmentsize", title: "Fragment Size (From)", type: 'numeric' },
		          	{ data : "qual_nanodrop_conc", title: "Conc. (ng/uL) (NanoDrop)", type: 'numeric', format: '0.000' },
		          	{ data : "qual_volume", title: "Volume (uL)", type: 'numeric', format: '0.00' },
		          	{ data : "qual_amount", data : 0, title: "Total (ng)", type: 'numeric', format: '0.00' },
		          	{ data : "qual_date", title: "QC Date", type: 'date', dateFormat: 'yy-mm-dd' }
		          ],
		          minSpareCols: 0,
		          minSpareRows: 0,
		          contextMenu: true,
		          columnSorting: true,
		          manualColumnResize: true,
		          afterChange: function (changes, source) {
		        	  if (source === 'loadData') {
		        		  return; // don't save this change
		        	  }
		        	  else {
		        		  // Enable "Save", "Undo" link on toolbar above of table
		        		  // after editting.
		        		  // alert("afterEdit");
		        		  $toolbar.find("#save, #undo, #clear").removeClass("disabled");
		        		  $console.text('Click "Save" to save data to server').removeClass().addClass("alert alert-info");
		        		  $.each( changes, function(key, value) {
			        		  isDirtyAr.push(value);
		        		  });
		        	  }

		        	  if ($('#handsontable-autosave').find('input').is(':checked')) {
		        		  clearTimeout(autosaveNotification);
		        		  $.ajax({
		        			  url: "/ngsLIMS/trackerProjectSamples/saveSamples",
		        			  dataType: "json",
		        			  type: "POST",
		        			  data: {data: handsontable.getData(), changes: changes} // returns "data" as all data and "changes" as changed data
		        		  })
		        		  .done( function () {
		        			  $console.text('Autosaved (' + changes.length + ' cell' + (changes.length > 1 ? 's' : '') + ')')
		        			  .removeClass().addClass("alert alert-success");
		        			  autosaveNotification = setTimeout(function () {
		        				  $console.text('Changes will be autosaved').removeClass().addClass("alert alert-success");
		        			  }, 1000);
		        		  })
		        		  .fail( function () {
		        			  $console.text('Autosaved (' + changes.length + ' cell' + (changes.length > 1 ? 's' : '') + ') is Failed')
		        			  .removeClass().addClass("alert alert-danger");
		        		  });
		        	  }

		          }
	});
	var handsontable = $container.data('handsontable');

	function loadData() {
		$.ajax({
			url: "/ngsLIMS/samples/loadjson/{{ project.id }}",
			dataType: 'json',
			type: 'POST',
			data: {
			}
		})
		.done( function (data) {
			//alert(data);
			//alert(location.href);
			$container.handsontable("loadData", data);
		});
	}

	loadData(); // loading data at first.

	$toolbar.find('#save').click(function () {
		//alert("save! "+handsontable.getData());
		$.ajax({
			url: "/ngsLIMS/trackerProjectSamples/saveSamples",
			data: {data: handsontable.getData(), changes: isDirtyAr }, // returns all cells
			dataType: 'json',
			type: 'POST'
		})
		.done( function (data, status, xhr) {
			//alert(status.toString());
			$console.text('Save success').removeClass().addClass("alert alert-success");
			$toolbar.find("#save").addClass("disabled");
			isDirtyAr.length = 0;
		})
		.fail( function (xhr, status, error) {
			//alert(status.toString());
			$console.text('Save error').removeClass().addClass("alert alert-danger");
		});
	});

	$toolbar.find('#undo').click(function () {
		// alert("undo! "+handsontable.isUndoAvailable()+"
		// "+handsontable.isRedoAvailable())
		handsontable.undo();
		// $console.text('Undo!');
		if( handsontable.isUndoAvailable() ) {
			$toolbar.find("#undo").removeClass("disabled");
		} else {
			$toolbar.find("#undo").addClass("disabled");
		}

		if( handsontable.isRedoAvailable() ) {
			$toolbar.find("#redo").removeClass("disabled");
		} else {
			$toolbar.find("#redo").addClass("disabled");
		}
	});

	$toolbar.find('#redo').click(function () {
		// alert("redo! "+handsontable.isUndoAvailable()+"
		// "+handsontable.isRedoAvailable());
		handsontable.redo();
						// $console.text('Redo!');
						if (handsontable.isUndoAvailable()) {
			$toolbar.find("#undo").removeClass("disabled");
		} else {
			$toolbar.find("#undo").addClass("disabled");
		}

		if( handsontable.isRedoAvailable() ) {
			$toolbar.find("#redo").removeClass("disabled");
		} else {
			$toolbar.find("#redo").addClass("disabled");
		}
	});

	$toolbar.find('#clear').click(function () {
		loadData();
		$toolbar.find("#save, #undo, #redo, #clear").addClass("disabled");
		$console.text('All changes is discarded').removeClass().addClass("alert alert-success");
	});


	$('#handsontable-autosave').find('input').click(function () {
		if ($(this).is(':checked')) {
			$console.text('Changes will be autosaved').removeClass().addClass("alert alert-success");
		}
		else {
			$console.text('Changes will not be autosaved').removeClass().addClass("alert alert-warning");
		}
	});

});
</script>