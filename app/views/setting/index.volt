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

<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li class="active">Setting</li>
    </ol>
    <ul>
      <li>{{ link_to('setting/labs', 'Labs') }}</li>
      <ul>
        <li>{{ link_to('setting/users', 'Users') }}</li>
        <li>{{ link_to('setting/projects', 'Projects') }} -- {{ link_to('setting/projectTypes', 'Project Types') }}</li>
      </ul>
      <li>{{ link_to('setting/seqtemplates', 'Sequence Templates') }}</li>
      <li>{{ link_to('setting/flowcells', 'Flowcells') }}</li>
      <li>{{ link_to('setting/steps', 'Steps') }}</li>
      <ul>
        <li>{{ link_to('setting/protocols', 'Protocols') }}</li>
        <li>{{ link_to('setting/oligobarcodeSchemes', 'Oligobarcode Schemes') }}</li>
        <li>{{ link_to('setting/oligobarcodes', 'Oligobarcodes') }}</li>
      </ul>
      <li>Samples</li>
      <ul>
        <li>{{ link_to('setting/sampleTypes', 'Sample Types') }}</li>
        <li>{{ link_to('setting/samplePropertyTypes', 'Sample Property Types') }}</li>
        <li>{{ link_to('setting/sampleLocations', 'Sample Locations') }}</li>
      </ul>
      <li>{{ link_to('setting/organisms', 'Organisms') }}</li>
      <li>{{ link_to('setting/instrumentTypes', 'Instrument Types') }}</li>
      <ul>
        <li>{{ link_to('setting/instruments', 'Instruments') }}</li>
        <li>{{ link_to('setting/seqRunmodeTypes', 'Sequence Run Mode Types') }}</li>
        <li>{{ link_to('setting/seqRunreadTypes', 'Sequence Run Read Types') }}</li>
        <li>{{ link_to('setting/seqRuncycleTypes', 'Sequence Run Cycle Types') }}</li>
      </ul>
    </ul>
  </div>
</div>
