{{ content() }}
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