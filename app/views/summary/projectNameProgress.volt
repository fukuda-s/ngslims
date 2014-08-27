{{ content() }}
<div class="progress-label">QC</div>
<div class="progress">
    {% set sample_progress = samples_progress[0] %}
    {% set completed_rate = sample_progress.completed_sum / sample_progress.all_sum * 100 %}
    {% set inprogress_rate = sample_progress.inprogress_sum / sample_progress.all_sum * 100 %}
    {% set onhold_rate = sample_progress.onhold_sum / sample_progress.all_sum * 100 %}
    <div class="progress-bar progress-bar-success" style="width: {{ completed_rate }}%">
      {{ sample_progress.completed_sum ~ '/' ~ sample_progress.all_sum ~ ' (%.1f%%)'|format(completed_rate) }}
      <span class="sr-only">{{ completed_rate }}% Completed</span>
    </div>
    <div class="progress-bar progress-bar-warning" style="width: {{ inprogress_rate }}%">
      {{ sample_progress.inprogress_sum ~ '/' ~ sample_progress.all_sum ~ ' (%.1f%%)'|format(inprogress_rate) }}
      <span class="sr-only">{{ inprogress_rate }}% In Progress</span>
    </div>
    <div class="progress-bar progress-bar-danger" style="width: {{ onhold_rate }}%">
      {{ sample_progress.onhold_sum ~ '/' ~ sample_progress.all_sum ~ ' (%.1f%%)'|format(onhold_rate) }}
      <span class="sr-only">{{ onhold_rate }}% On Hold</span>
    </div>
</div>
<div class="progress-label">SeqLib</div>
<div class="progress">
  {% set seqlib_progress = seqlibs_progress[0] %}
  {% set completed_rate = seqlib_progress.completed_sum / seqlib_progress.all_sum * 100 %}
  {% set inprogress_rate = seqlib_progress.inprogress_sum / seqlib_progress.all_sum * 100 %}
  {% set onhold_rate = seqlib_progress.onhold_sum / seqlib_progress.all_sum * 100 %}
  <div class="progress-bar progress-bar-success" style="width: {{ completed_rate }}%">
    {{ seqlib_progress.completed_sum ~ '/' ~ seqlib_progress.all_sum ~ ' (%.1f%%)'|format(completed_rate) }}
    <span class="sr-only">{{ completed_rate }}% Completed</span>
  </div>
  <div class="progress-bar progress-bar-warning" style="width: {{ inprogress_rate }}%">
    {{ seqlib_progress.inprogress_sum ~ '/' ~ seqlib_progress.all_sum ~ ' (%.1f%%)'|format(inprogress_rate) }}
    <span class="sr-only">{{ inprogress_rate }}% In Progress</span>
  </div>
  <div class="progress-bar progress-bar-danger" style="width: {{ onhold_rate }}%">
    {{ seqlib_progress.onhold_sum ~ '/' ~ seqlib_progress.all_sum ~ ' (%.1f%%)'|format(onhold_rate) }}
    <span class="sr-only">{{ onhold_rate }}% On Hold</span>
  </div>
</div>
<div class="progress-label">SeqLane (@seqlib count)</div>
<div class="progress">
  {% set completed_rate = seqlane_progress.completed_sum / seqlane_progress.all_sum * 100 %}
  {% set inprogress_rate = seqlane_progress.inprogress_sum / seqlane_progress.all_sum * 100 %}
  {% set onhold_rate = seqlane_progress.onhold_sum / seqlane_progress.all_sum * 100 %}
  <div class="progress-bar progress-bar-success" style="width: {{ completed_rate }}%">
    {{ seqlane_progress.completed_sum ~ '/' ~ seqlane_progress.all_sum ~ ' (%.1f%%)'|format(completed_rate) }}
    <span class="sr-only">{{ completed_rate }}% Completed</span>
  </div>
  <div class="progress-bar progress-bar-warning" style="width: {{ inprogress_rate }}%">
    {{ seqlane_progress.inprogress_sum ~ '/' ~ seqlane_progress.all_sum ~ ' (%.1f%%)'|format(inprogress_rate) }}
    <span class="sr-only">{{ inprogress_rate }}% In Progress</span>
  </div>
  <div class="progress-bar progress-bar-danger" style="width: {{ onhold_rate }}%">
    {{ seqlane_progress.onhold_sum ~ '/' ~ seqlane_progress.all_sum ~ ' (%.1f%%)'|format(onhold_rate) }}
    <span class="sr-only">{{ onhold_rate }}% On Hold</span>
  </div>
</div>
</div>