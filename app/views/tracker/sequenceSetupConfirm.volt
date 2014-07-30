<ol class="breadcrumb" xmlns="http://www.w3.org/1999/html">
  <li>
    {{ link_to('tracker', 'Tracker') }}
  </li>
  <li>
    {{ link_to('tracker/sequence/', 'Sequencing Run Setup View' ) }}
  </li>
  <li class="active">
    {{ link_to('tracker/sequenceSetupCandidates/' ~ instrument_type.id, instrument_type.name) }}
  </li>
  <li class="active">
    Confirm
  </li>
</ol>
{{ flashSession.output() }}
{{ form('tracker/sequenceSetupSave', 'id': 'sequenceSetupForm', 'onbeforesubmit': 'return false') }}
<div class="row">
  <div class="col-md-12">
    <h3>Confrim Sequence Run Setup</h3>
    <br>
    <h4>{{ instrument_type.name }}</h4>
    {{ hidden_field('instrument_type_id', 'value' : instrument_type.id) }}
    <h5>{{ instrument.fullname }}</h5>
    {{ hidden_field('instrument_id', 'value' : instrument.id) }}
    <h5>{{ run_started_date }}</h5>
    {{ hidden_field('run_started_date', 'value' : run_started_date) }}
    <h5>{{ seq_runmode_type.name }}</h5>
    {{ hidden_field('seq_runmode_type_id', 'value' : seq_runmode_type.id) }}

    {% for slot in slots_per_run %}
      {% set slot_data = slots_data[slot] %}
      <div id="{{ 'slot_' ~ slot }}" class="panel panel-info">
        <div class="panel-heading">
          <div class="panel-title">Slot{{ instrument_type.getSlotStr(slot) }}</div>
        </div>
        <div id={{ 'slot_body_' ~ slot }} class="panel-body">
          {% if slot_data['slot_unused'] == "on" %}
            <p>Slot{{ instrument_type.getSlotStr(slot) }} is unused</p>
            {{ hidden_field('slot_unused_' ~ slot , 'value': 'on') }}
          {% else %}
            <ul>
              <li>Run Number: {{ slot_data['run_number'] }}</li>
              {{ hidden_field('run_number_' ~ slot , 'value': slot_data['run_number']) }}
              <li>Read Type: {{ slot_data['seq_runread_type']['name'] }}</li>
              {{ hidden_field('seq_runread_type_id_' ~ slot , 'value': slot_data['seq_runread_type']['id']) }}
              <li>Read Cycle: {{ slot_data['seq_runcycle_type']['name'] }}</li>
              {{ hidden_field('seq_runcycle_type_id_' ~ slot , 'value': slot_data['seq_runcycle_type']['id']) }}
              <li>Flowcell: {{ slot_data['flowcell']['name'] }}</li>
              {{ hidden_field('flowcell_id_' ~ slot , 'value': slot_data['flowcell']['id']) }}
            </ul>
          {% endif %}
        </div>
      </div>
    {% endfor %}

    <div class="form-actions">
      {{ submit_button('Save', 'class': 'btn btn-primary') }}
      &nbsp;
      {{ link_to('tracker/sequenceSetupCandidates/' ~ instrument_type.id, 'Cancel') }}
    </div>
  </div>
  <!--col-md-12-->
</div><!--row-->
</form>
